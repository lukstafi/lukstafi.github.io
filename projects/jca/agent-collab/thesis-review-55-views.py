"""Eliminate unsupported constructor invariants and replay guard and datatype examples."""
import argparse
from dataclasses import dataclass
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory
import z3 as z

HERE = Path(__file__).resolve().parent
INDEX = z.Real("index")


@dataclass(frozen=True)
class Constructor:
    datatype: str
    result: object
    guard: tuple = ()
    fields: tuple = ()  # Immediate inductive fields with their index expressions.


def at(pred, term):
    return z.substitute(pred, (INDEX, term))


def inductive_subset(constructors, candidates):
    current = {name: list(options) for name, options in candidates.items()}
    while True:
        failing = {name: set() for name in current}
        for ctor in constructors:
            s = z.SolverFor("QF_LRA")
            s.add(*ctor.guard)
            for child, term in ctor.fields:
                s.add(*(at(p, term) for p in current[child]))
            for j, pred in enumerate(current[ctor.datatype]):
                s.push()
                s.add(z.Not(at(pred, ctor.result)))
                result = s.check()
                if result == z.sat:
                    failing[ctor.datatype].add(j)
                elif result != z.unsat:
                    raise RuntimeError(s.reason_unknown())
                s.pop()
        if not any(failing.values()):
            return current
        current = {name: [p for j,p in enumerate(opts) if j not in failing[name]]
                   for name,opts in current.items()}


def synthesis_checks():
    n = z.Real("n")
    zero = z.RealVal(0)
    candidates = {"List": [INDEX >= 0, INDEX >= 1, INDEX <= 0, INDEX <= 1]}
    cons = Constructor("List", n+1, fields=(("List",n),))
    cs = [Constructor("List", zero), cons]
    result = inductive_subset(cs, candidates)
    assert list(map(str, result["List"])) == [str(INDEX >= 0)]
    assert inductive_subset(cs+[Constructor("List", z.RealVal(-1))], candidates)["List"] == []
    pool = {"Even":[INDEX >= 0, INDEX >= 2], "Odd":[INDEX >= 1, INDEX >= 3]}
    mutual = [Constructor("Even", zero), Constructor("Odd", n+1, fields=(("Even",n),)),
              Constructor("Even", n+1, fields=(("Odd",n),))]
    kept = inductive_subset(mutual, pool)
    assert all(list(map(str, kept[t])) == [str(pool[t][0])] for t in pool)
    print("Constructor checks kept list nonnegativity and the mutual even/odd lower bounds.")


def list_view(explicit_tail_bound):
    """Elaborate the surviving nonnegative template into a checked identity view."""
    n = z.Real("n")
    invariant = INDEX >= 0
    nil = Constructor("List", z.RealVal(0))
    cons = Constructor("List", n+1, (n >= 0,) if explicit_tail_bound else (), (("List",n),))
    if not inductive_subset([nil,cons], {"List":[invariant]})["List"]:
        raise ValueError("length invariant does not survive its constructors")
    # Use a recursive call only for a field whose facts the branch proof needs.
    bodies = []
    recursive = False
    for pattern, ctor, bindings in [("LNil", nil, []), ("LCons (_,xs)", cons, ["xs"])]:
        def suffices(indices):
            s = z.SolverFor("QF_LRA")
            s.add(*ctor.guard, *(at(invariant,ctor.fields[i][1]) for i in indices),
                  z.Not(at(invariant,ctor.result)))
            return s.check() == z.unsat
        needed = list(range(len(bindings)))
        for i in needed.copy():
            rest = [j for j in needed if j != i]
            if suffices(rest):
                needed = rest
        assert suffices(needed)
        recursive |= bool(needed)
        calls = "".join(f"let witness = view {bindings[i]} in " for i in needed)
        bodies.append(f"{pattern} as v -> {calls}v")
    rec = "rec " if recursive else ""
    return f"let {rec}view : ∀a,n. List (a,n) → ∃k[k=n ∧ 0≤k]. List (a,k) = efunction " + " | ".join(bodies)


def compile_case(compiler, source, accept=True):
    with TemporaryDirectory() as d:
        path = Path(d)/"case.gadt"
        path.write_text(source)
        c = subprocess.run([compiler, "-full_annot", path], capture_output=True, text=True)
        if not accept:
            assert c.returncode and ("No answer" in c.stderr+c.stdout or
                                     "Contradiction" in c.stderr+c.stdout), c
            return ""
        assert c.returncode == 0 and "exited with code 0" in c.stdout,c
        subprocess.run(["ocaml","-noinit",path.with_suffix(".ml")],check=True,capture_output=True)
        return " ".join(path.with_suffix(".gadti").read_text().split())


def scheme(signature, name):
    return signature.split("val "+name+" : ",1)[1].split(" val ")[0].split(" external ")[0]


def list_argument(name, body, expose):
    # Rebind the original argument so its occurrences and any inner shadows
    # keep their scope. The generated helper name is fresh in this example.
    opening = f"let {name} = view {name} in " if expose else ""
    return f"(fun {name} -> {opening}{body})"


def short_append(expose):
    nil = list_argument("l", "l", expose)
    cons = list_argument("l", "LCons (x, append xs l)", expose)
    return f"let rec append = function LNil -> {nil} | LCons (x, xs) -> {cons}\n"


def compiler_checks(compiler, before):
    guards = (HERE/"broader_guard.gadt").read_text()
    assert "min (" in scheme(compile_case(compiler, guards), "check")
    compile_case(compiler, guards+'\nlet bad = check (Bounded 3) 2\n',False)
    if before:
        compile_case(before, guards, False)
    body = guards.split("external let left")[0]
    tagged = body.replace('within x cap','let tested = within x cap in cap')
    tagged += "let exported : ∀i,j,n[min(i,j)≤n]. Bounds (i,j) → Num n → Num n = check\n"
    compile_case(compiler,tagged)
    # A separate use of the second bound must still be proved on every input.
    needs_j = body.replace('Num k ⟶', 'Num k * Num j ⟶').replace('Bounded x','Bounded (x,y)')
    needs_j = needs_j.replace('within x cap','(within x cap, within y cap)')
    compile_case(compiler,needs_j+'let ok = check (Bounded (0,4)) 4\n')
    compile_case(compiler,needs_j+'let bad = check (Bounded (0,4)) 0\n', False)

    source = (HERE/"constructor_value_view.gadt").read_text()
    header, rest = source.split("let view :", 1)
    clients = "let empty :" + rest.split("let empty :", 1)[1]
    compile_case(compiler, header + short_append(False) + clients, False)
    append = short_append(True) + clients
    source = header + list_view(True) + "\n" + append
    shallow_sig = compile_case(compiler,source)
    for name in ("view","append"):
        assert "[" not in scheme(shallow_sig,name).split(".")[0]
    bad = source.replace('let view :','datacons Debt : ∀a. List (a,-1)\nlet view :')
    bad = bad.replace('LCons (_,xs) as v -> v','LCons (_,xs) as v -> v | Debt as v -> v')
    compile_case(compiler,bad, False)
    no_guard = source.replace('[0 ≤ n]', '')
    shallow = scheme(compile_case(compiler,no_guard), "view")
    assert "[" in shallow.split(".")[0], shallow
    plain_header = header.replace('[0 ≤ n]', '')
    plain = compile_case(compiler,plain_header + short_append(False) + clients)
    assert "[" not in scheme(plain,"append").split(".")[0]
    recursive = plain_header + list_view(False) + "\n" + append
    deep = compile_case(compiler,recursive)
    for name in ("view","append"):
        assert "[" not in scheme(deep,name).split(".")[0]
    print("Broader guards, dependent result, independent obligation, checked views and rejection controls passed.")


if __name__ == "__main__":
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler",type=Path)
    parser.add_argument("--before",type=Path)
    args=parser.parse_args()
    synthesis_checks()
    if args.compiler:
        compiler_checks(args.compiler.resolve(), args.before.resolve() if args.before else None)
