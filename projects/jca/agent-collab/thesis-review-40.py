"""Replay the joint-abduction example and the finite rational sampling obstruction."""
import argparse
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
SOURCE = (HERE / "interior_result_key.gadt").read_text()


def check_signature(signature):
    previous = runpy.run_path(str(HERE / "thesis-review-36.py"))
    arrow = " ".join(signature.split()).split("val run : ")[1].split(" val ")[0]
    pattern = r"∀([\w, ]+)\[(.*?)\]\. Num (\w+) → Num (\w+) → Nat → ∃(\w+)\[(.*?)\]\.\s*Num (\w+)"
    names, pre, flag, width, payload, post, result = re.fullmatch(pattern, arrow).groups()
    assert payload == result
    key, = set(names.split(", ")) - {flag, width}
    post = re.sub(r"\b" + re.escape(payload) + r"\b", "payload", post)
    for sort in (z3.Int, z3.Real):
        f, n, k, r = map(sort, (flag, width, key, "payload"))

        def read(atoms):
            return z3.And(*previous["read_atoms"](atoms.split(" ∧ "), z3, sort))

        domain = z3.And(0 <= f, f <= 1, 2 <= n, 0 <= k, k <= n, z3.Or(k <= 0, 1 <= f))
        package = z3.And(0 <= r, r <= f, z3.Or(k+r <= n, n <= k))
        previous["equivalent"](read(pre), domain)
        previous["equivalent"](z3.And(domain, read(post)), z3.And(domain, package))


def swap_flags(clients):
    return clients.replace("run 0 4", "SWAP").replace("run 1 4", "run 0 4").replace("SWAP", "run 1 4")


def client_chain(flags):
    bindings = []
    for i, flag in enumerate(flags):
        bindings.append(f"let p{i} = run {flag} 4 (S Z) in ")
        if i+1 < len(flags):
            bindings.append(f"let b{i} = observe p{i} in ")
    return "test (" + "".join(bindings) + f"observe p{len(flags)-1})\n"


def programs(compiler, before, unconditional, chains):
    definition, clients = SOURCE.split("test ", 1)
    constant = definition.split("  | S d ->", 1)[0] + "  | S d -> 0\n"
    reversed_clients = swap_flags(clients)
    live = (HERE / "fixed_result_input.gadt").read_text().split("test (let", 1)[0]
    live = live.replace("v = 0", "v >= 0")
    live += "test (let p = run 0 (S Z) in let ok = observe p in let q = run 1 (S Z) in observe q)\n"

    with TemporaryDirectory() as temp:
        def check(exe, name, source, *, error=None, output=None, signature=False):
            path = Path(temp) / (name + ".gadt")
            path.write_text(source)
            proc = subprocess.run([exe, "-iterations_timeout", "2", "-no_verif", "-full_annot",
                                   "-overwrite_ml", path], capture_output=True, text=True, check=False)
            report = proc.stdout + proc.stderr
            if error:
                assert proc.returncode and error in report, (name, report)
            else:
                assert proc.returncode == 0, (name, report)
                if signature:
                    check_signature(path.with_suffix(".gadti").read_text())
                run = subprocess.run(["ocaml", path.with_suffix(".ml")], check=True,
                                     text=True, capture_output=True)
                assert run.stdout == output, (name, run.stdout)
            print(name, "rejected" if error else "passed", flush=True)

        check(compiler, "attached", SOURCE, output="0\n0\n", signature=True)
        check(compiler, "constant", constant + "test " + clients, output="0\n0\n", signature=True)
        check(compiler, "live", live, error="Type mismatch")
        check(compiler, "numeric", live.replace("-> True", "-> r"), output="0\n1\n")
        check(compiler, "reverse_constant", constant + "test " + reversed_clients,
              output="0\n0\n", signature=True)
        check(compiler, "reverse_attached", definition + "test " + reversed_clients,
              output="0\n0\n", signature=True)
        if chains:
            for flags in ("101", "000"):
                check(compiler, "chain_"+flags, definition + client_chain(flags),
                      output="0\n"*len(flags), signature=True)
        if unconditional:
            check(unconditional, "first_repair_reverse_constant", constant + "test " + reversed_clients,
                  error="numerical abduction failed")
        if before:
            check(before, "old_attached", SOURCE, error="Type mismatch")
            check(before, "old_constant", constant + "test " + clients, error="numerical abduction failed")
            check(before, "old_definition", definition, output="", signature=True)
            check(before, "old_separate", definition + "let client = " + clients,
                  output="0\n0\n", signature=True)
            check(before, "old_one", definition + "test (let p = run 1 4 Z in observe p)\n",
                  output="0\n", signature=True)
            check(before, "old_zero", definition + "test (let p = run 0 4 Z in observe p)\n",
                  error="Type mismatch")


def check_grids(driver):
    post = "0≤l ∧ l≤1 ∧ min(k+l + -i,i + -k)≤0"
    problems, expected = [], []

    def case(pre, domains, answer):
        problems.append("\t".join(["i=2 ∧ " + pre, post, *domains]))
        expected.append(answer)

    interval = ["0≤k ∧ k≤i"]
    adaptive = ["2 k+l=2 i ∧ 0≤k ∧ k≤i"]
    for d in (1, 2, 3, 4, 8, 16):
        grid = [f"{d} k={p}" for p in range(2*d+1)]
        case(f"{d} l=1", grid, "sat")
        case(f"{d} l=2", grid, "unsat")
        case(f"{d} l=1", interval, "unsat")
        case(f"{d} l=1", adaptive, "unsat")
    case("l=0", interval, "sat")
    case("l=1", ["2 k+1=2 i"], "unsat")
    case("l=0", adaptive, "sat")
    # Check admission and refutation for arbitrary positive rational payloads.
    n, r = z3.Reals("width result")
    k = n-r/2
    s = z3.Solver()
    s.add(n >= 2, r > 0, r <= 1, z3.Or(k < 0, n < k, k+r <= n, n <= k))
    assert s.check() == z3.unsat
    # A closed guard can need arbitrarily many input-only probes as width grows.
    separated = "-1≤l ∧ l≤i ∧ min(l+1 + -k,k+1 + -l)≤0"
    for width in (1, 2, 3, 4, 7, 8, 9):
        count = width // 2 + 1
        midpoints = [f"{2*count} k={(2*j+1)*width}" for j in range(count)]
        for guard, keys, answer in [
            ("0≤l ∧ l≤i", midpoints, "unsat"),
            ("0≤l ∧ l≤i", midpoints[:-1], "sat"),
            ("0≤l ∧ l≤i", ["k=l ∧ 0≤k ∧ k≤i"], "unsat"),
            ("l= -1", ["0≤k ∧ k≤i"], "sat"),
        ]:
            problems.append("\t".join([f"i={width} ∧ "+guard, separated, *keys]))
            expected.append(answer)
    result = subprocess.run([driver, "--keys", "k", "--witnesses", ""],
                            input="\n".join(problems)+"\n", text=True, capture_output=True, check=True)
    answers = result.stdout.splitlines()
    assert len(answers) == len(expected)
    for query, actual, want in zip(problems, answers, expected):
        assert actual == want, (query, actual, want)
    print(f"{len(answers)} numeric checks passed, including six rational grids and seven closed guard widths.")


def client_rows(compiler):
    definition, clients = SOURCE.split("test ", 1)
    constant = definition.split("  | S d ->", 1)[0] + "  | S d -> 0\n"
    with TemporaryDirectory() as temp:
        for flags, uses in (("01", clients), ("10", swap_flags(clients))):
            src = Path(temp) / ("rows"+flags+".gadt")
            src.write_text(constant + "test " + uses)
            run = subprocess.run([compiler, "-iterations_timeout", "2", "-no_verif", "-no_ml",
                                  "-no_sig", src], text=True, capture_output=True)
            block = re.search(r"^NUMROWS\n(.*?)\nENDROWS$", run.stderr+run.stdout, re.M | re.S)
            assert block, (flags, run.stderr)
            guards, clients_seen = [], []
            for row in block[1].split("\n| "):
                premise, goal = (" ".join(s.split()) for s in row.split("⟹"))
                atoms = set(premise.split(" ∧ ")) if premise else set()
                guards.append(atoms)
                match = re.search(r"(n\d+) = 4 ∧ (n\d+) = ([01]) ∧ min\|\|max "
                                  r"\((n\d+) \+ 0, 0 \+ 1 \+ -\2\)", goal)
                if match:
                    width, _, flag, key = match.groups()
                    assert f"0 ≤ {key}" in goal and f"{key} ≤ {width}" in goal
                    clients_seen.append((flag, atoms))
            assert "".join(f for f, _ in clients_seen) == flags
            first, second = [g for _, g in clients_seen]
            assert not first and second and any(second < g for g in guards)
    print("Verified the unconditional and guarded admissions in both client orders.")


def trace(compiler, old):
    def events(path, budget):
        r = subprocess.run([compiler, "-no_verif", "-no_ml", "-no_sig", "-iterations_timeout",
                            str(budget), path], text=True, capture_output=True)
        report = r.stderr + r.stdout
        return r.returncode, re.findall(r"^TRACE (enter|update|fail) (\d+)", report, re.M), report

    with TemporaryDirectory() as temp:
        ordinary = HERE / "interior_result_key.gadt"
        if old:
            expected = [("enter","0"), ("update","0"), ("enter","1"), ("fail","1")]*14
            for limit in (2, 10000):
                code, sequence, report = events(ordinary, limit)
                assert code and sequence == expected and "TUPLE " not in report, report
        else:
            reverse = Path(temp) / "reverse.gadt"
            reverse.write_text(swap_flags(SOURCE))
            for src in (ordinary, reverse):
                code, sequence, report = events(src, 2)
                assert code == 0 and ("update", "2") in sequence, report
                assert re.search(r"^TUPLE \d+ true$", report, re.M), report
    print("Verified the old pass-one failure." if old else "Verified both pass-two guard checks.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("compiler", "before", "unconditional", "numeric-driver", "trace", "old-trace", "rows"):
        parser.add_argument("--" + name, type=Path)
    parser.add_argument("--chains", action="store_true", help="check the three-client cases")
    args = parser.parse_args()
    if not any(vars(args).values()) or ((args.before or args.unconditional or args.chains) and not args.compiler):
        parser.error("supply a compiler, numeric driver or trace executable; compiler comparisons need --compiler")
    if args.numeric_driver:
        check_grids(args.numeric_driver.resolve(strict=True))
    if args.compiler:
        programs(args.compiler.resolve(strict=True), args.before and args.before.resolve(strict=True),
                 args.unconditional and args.unconditional.resolve(strict=True), args.chains)
    if args.rows:
        client_rows(args.rows.resolve(strict=True))
    if args.trace:
        trace(args.trace.resolve(strict=True), False)
    if args.old_trace:
        trace(args.old_trace.resolve(strict=True), True)
