"""Compute exact unary caller domains and check explicit indexed evidence in InvarGenT."""
import argparse
from itertools import product
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent


def orbit(next_state, accepting, start):
    history = {}
    states = []
    q = start
    while q not in history:
        history[q] = len(states)
        states.append(q)
        q = next_state[q]
    cut = history[q]
    verdict = [accepting[q] for q in states]
    return verdict[:cut], verdict[cut:]


def check():
    count = finite = 0
    for size in range(1, 5):
        for nxt in product(range(size), repeat=size):
            for ok in product((False, True), repeat=size):
                for start in range(size):
                    prefix, cycle = orbit(nxt, ok, start)
                    flat = all(b == cycle[0] for b in cycle)
                    finite += flat
                    q = start
                    for n in range(len(prefix) + 3*len(cycle)):
                        b = (prefix[n] if n < len(prefix) else cycle[(n-len(prefix)) % len(cycle)])
                        assert ok[q] == b
                        if flat:
                            assert (prefix[n] if n < len(prefix) else cycle[0]) == b
                        q = nxt[q]
                    count += 1
    assert orbit((1,0), (True,False), 0) == ([], [True,False])
    print(f"Checked {count} finite-control start states, {finite} with an equational Boolean guard.")


def machine_source(nxt, ok, start, depths):
    states = "ABCD"[:len(nxt)]
    head = (HERE / "even_index_proof.gadt").read_text().split("datatype Even")[0]
    lines = [head, *("datatype State"+s for s in states), "datatype OK : type * type"]
    for i, s in enumerate(states):
        if ok[i]:
            lines.append(f"datacons Stop{s} : OK (State{s},Base)")
        lines.append(f"datacons More{s} : ∀a. OK (State{states[nxt[i]]},a) ⟶ OK (State{s},Step a)")
    lines.append("let rec validate : ∀a,b. OK (a,b) → Rep b → Bool = function")
    for i,s in enumerate(states):
        if ok[i]:
            lines.append(f"| Stop{s} -> (function Root -> True)")
        lines.append(f"| More{s} p -> (function Next x -> validate p x)")
    lines.append(f"let consume : ∀a. OK (State{states[start]},a) → Rep a → Bool = fun p x -> validate p x")
    lines.append('external let check : Bool → Bool = "fun x -> assert x; x"')
    for n in depths:
        q, trace, represented = start, [], "Root"
        for _ in range(n):
            trace.append(q)
            q = nxt[q]
            represented = f"(Next {represented})"
        assert ok[q]
        proof = "Stop" + states[q]
        for k in reversed(trace):
            proof = f"(More{states[k]} {proof})"
        lines.append(f"let result{n} = check (consume {proof} {represented})")
    return "\n".join(lines) + "\n"


def compiler(exe):
    with TemporaryDirectory() as temp:
        root = Path(temp)
        def run(name, source, accept, options=()):
            p = root / (name + ".gadt")
            p.write_text(source)
            c = subprocess.run([exe, "-full_annot", "-overwrite_ml", *options, p], capture_output=True, text=True)
            if accept:
                assert c.returncode == 0 and "exited with code 0" in c.stdout, c
                subprocess.run(["ocaml", "-noinit", p.with_suffix(".ml")], check=True, capture_output=True)
            else:
                assert c.returncode != 0 and any(s in c.stdout+c.stderr for s in
                       ["term abduction failed", "Type mismatch", "Constructor mismatch"]), c

        source = (HERE / "even_index_proof.gadt").read_text()
        head = source.split("datatype Even")[0]
        run("certified", source, True)
        run("badproof", source + "\nlet bad = certified ERoot (Next Root)\n", False)
        arms = " = function Root -> True | Next Root -> False | Next (Next x) -> even x\n"
        run("parity", head + "let rec even" + arms +
            'external let check : Bool → Bool → Bool = "fun a b -> assert (a = b); true"\n'
            'let ok = (check (even Root) True, check (even (Next Root)) False, '
            'check (even (Next (Next Root))) True)\n', True)
        for i, ty in enumerate(["", " : ∀a. Rep a → Bool", " : Rep (Step (Step Base)) → Bool"]):
            run("unsafe"+str(i), head + "let rec even" + ty + arms.replace("-> False","-> assert false"), False)
        base_only = "let rec even : Rep Base → Bool" + arms.replace("-> False", "-> assert false")
        run("base", head + base_only, False)
        run("base_dead", head + base_only, False, ("-allow_dead_code",))
        machine = machine_source((1, 2, 3, 1), (False, True, False, True), 0, [1,3,4,6,7])
        run("cycle", machine, True)
        run("wrongstate", machine + "let bad = consume StopB Root\n", False)
        print("Checked the recursive parity program, the indexed version, and a generated four-state evidence datatype.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--compiler", type=Path)
    args = parser.parse_args()
    check()
    if args.compiler:
        compiler(args.compiler.resolve())
