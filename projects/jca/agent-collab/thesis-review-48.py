"""Construct key supports, compare finite solutions and replay negative numeric guards."""
import argparse
from itertools import product
from pathlib import Path
from random import Random
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE/"thesis-review-47.py"))
derive, extend = previous["derive"], previous["extend"]
Rule, legal_packages = previous["Rule"], previous["legal_packages"]


def fit(traces, hulls, lower, upper):
    """Assign each trace to a node and a label, remembering sources from past choices."""
    start = tuple((h(lo), frozenset()) for h, lo in zip(hulls, lower))
    if any(not pos <= hi for (pos, _), hi in zip(start, upper)):
        return None

    def visit(n, labels):
        if n == len(traces):
            return tuple(pos for pos, _ in labels)
        for x, sources in sorted(traces[n], key=lambda c: (c[0], sorted(c[1]))):
            for j, (pos, neg) in enumerate(labels):
                support, excluded = hulls[j](pos | {x}), neg | sources
                if support <= upper[j] and support.isdisjoint(excluded):
                    updated = labels[:j] + ((support, excluded),) + labels[j+1:]
                    found = visit(n+1, updated)
                    if found is not None:
                        return found
        return None

    return visit(0, start)


def learn(base, values, rules, forbidden, hulls, lower, upper):
    traces, tried = [], set()
    while True:
        columns = fit(traces, hulls, lower, upper)
        if columns is None:
            return None, traces
        assert columns not in tried
        tried.add(columns)
        opened = derive(extend(base, columns, range(len(columns))), values, rules)
        hit = next((q for q in forbidden if q in opened), None)
        if hit is None:
            return columns, traces
        traces.append(opened[hit])


def interval(points):
    return frozenset(range(min(points), max(points)+1)) if points else frozenset()


def finite():
    # All clients forbid the same marker. Two exterior inputs need a key
    # excluding the middle input, which is where that marker is supplied.
    base = [{0}]*3
    bad = [(0, 0), (2, 0)]
    all_x = frozenset(range(3))
    def middle(hulls):
        return learn(base, (0,), [Rule(1, 0)], bad, hulls,
                     [frozenset()]*len(hulls), [all_x]*len(hulls))[0]
    assert middle([frozenset]) == (frozenset([0, 2]),)
    assert middle([interval]) is None
    assert set(middle([interval, interval])) == {frozenset([0]), frozenset([2])}

    # A ray of clients. The least fit to each finite prefix admits one more
    # forced counterexample, despite the solution x >= 1 using a single key.
    for n in range(1, 12):
        rows = list(range(n+1))
        cols, traces = learn([{0}]*len(rows), (0,), [Rule(0, 0)], [(x, 0) for x in rows[1:]],
                             [interval], [frozenset()], [frozenset(rows)])
        assert cols == (frozenset(rows[1:]),) and len(traces) == n

    rng = Random(480)
    subsets = [frozenset(x for x in range(3) if bits & (1 << x)) for bits in range(8)]
    pairs = list(product(range(3), (0, 1)))
    trials = 0
    for _ in range(80):
        rules = [Rule(*rng.choice(pairs), tuple(rng.choices(pairs, k=rng.randrange(3)))) for _ in range(6)]
        forbidden = rng.sample(pairs, rng.randint(1, 3))
        for m in (0, 1, 2):
            hulls = rng.choices([frozenset, interval], k=m)
            upper = rng.choices(subsets, k=m)
            lower = [rng.choice([s for s in subsets if s <= hi]) for hi in upper]
            def safe(columns):
                menus = extend(base, columns, range(m))
                return any(not opened.intersection(forbidden) for opened in legal_packages(
                    menus, (0, 1), rules, sorted(set.union(*menus))))
            legal = [[s for s in subsets if lo <= s <= hi and h(s) == s]
                     for lo, hi, h in zip(lower, upper, hulls)]
            exists = any(safe(cols) for cols in product(*legal))
            cols, _ = learn(base, (0, 1), rules, forbidden, hulls, lower, upper)
            assert (cols is not None) == exists and (cols is None or safe(cols))
            trials += 1
    print(f"{trials} searches agree with direct joint admission and package enumeration.")


def polyhedra():
    """Compare rational separating certificates to the closed hull's lifted formulation."""
    from z3 import FreshReal, SolverFor, Sum, sat, unsat

    def dot(a, x):
        return Sum([c*t for c, t in zip(a, x)])

    def solve(*conditions):
        solver = SolverFor("QF_LRA")
        solver.add(*conditions)
        result = solver.check()
        assert result in (sat, unsat)
        return solver.model() if result == sat else None

    def variables(count):
        return [FreshReal() for _ in range(count)]

    def rows(cell, x, weight=1):
        return [dot(row[:-1], x) <= row[-1]*weight for row in cell]

    def separator(live, bad, dim):
        a, c = variables(dim), FreshReal()
        conditions = []
        regions = [(h, 1) for h in live] + [(bad, -1)]
        for cell, side in regions:
            multipliers = variables(len(cell))
            conditions.extend(v >= 0 for v in multipliers)
            for k in range(dim):
                conditions.append(dot([r[k] for r in cell], multipliers) == side*a[k])
            conditions.append(dot([r[-1] for r in cell], multipliers) <=
                              (c if side == 1 else -c-1))
        model = solve(*conditions)
        if model is None:
            return None
        return [model.eval(v, model_completion=True) for v in a], model.eval(c, model_completion=True)

    def intersects(live, bad, dim):
        weights = variables(len(live))
        parts = [variables(dim) for _ in live]
        constraints = [Sum(weights) == 1, *(w >= 0 for w in weights)]
        for cell, part, w in zip(live, parts, weights):
            constraints.extend(rows(cell, part, w))
        x = [Sum([part[k] for part in parts]) for k in range(dim)]
        return solve(*constraints, *rows(bad, x)) is not None

    def point(x, y):
        return [(1,0,x), (-1,0,-x), (0,1,y), (0,-1,-y)]

    def check(live, forbidden, expected=None):
        # Discard empty cells before homogenizing. Every test uses dimension two.
        x = variables(2)
        live = [p for p in live if solve(*rows(p, x)) is not None]
        forbidden = [p for p in forbidden if solve(*rows(p, x)) is not None]
        if not live:
            return  # Empty support suffices.
        answer = []
        for bad in forbidden:
            face = separator(live, bad, 2)
            assert (face is None) == intersects(live, bad, 2)
            if face is not None:
                a, c = face
                assert all(solve(*rows(h, x), dot(a, x) > c) is None for h in live)
                assert solve(*rows(bad, x), dot(a, x) < c+1) is None
                answer.append(face)
        if expected is not None:
            assert (len(answer) == len(forbidden)) == expected

    ray = [(-1,0,0), (0,1,1), (0,-1,-1)]
    check([point(0,0), ray], [point(1,0)], False)
    check([point(0,0), [*ray, (1,0,1000)]], [point(1,0)], True)
    check([[(0,-1,-1)]], [point(0,0), point(100,0)], True)
    check([point(1,0), point(0,1)], [[(1,0,0), (0,1,0)]], True)
    rng = Random(482)
    def cell():
        # The anchor witnesses nonemptiness. Cells may be unbounded or lower dimensional.
        x, y = rng.choices(range(-4, 5), k=2)
        normals = [(a,b) for a,b in product(range(-1,2), repeat=2) if a or b]
        return [(a,b,a*x+b*y+rng.randrange(3)) for a,b in rng.sample(normals, rng.randint(1,6))]
    for _ in range(100):
        check([cell() for _ in range(rng.randint(1,4))], [cell() for _ in range(rng.randint(1,3))])
    print("104 symbolic region problems agree with independent closed-hull intersection checks.")


def numeric(driver):
    rng = Random(481)
    problems = []
    for _ in range(360):
        # Coordinates below are in quarters. A convex precondition can keep
        # a witness in each closed interval iff one open gap hits all of them.
        intervals = [sorted(rng.choices(range(-6, 7), k=2)) for _ in range(rng.randint(1, 4))]
        points = sorted(rng.sample(range(-6, 7), rng.randint(1, 4)))
        ends = [float("-inf"), *points, float("inf")]
        feasible = any(all(lo < b and hi > a for lo, hi in intervals)
                       for a, b in zip(ends, ends[1:]))
        fields = [f"{lo}≤4 i ∧ 4 i≤{hi}" for lo, hi in intervals]
        fields += ["--", *(f"4 i={bad}" for bad in points)]
        problems.append((fields, len(intervals), len(points), feasible))
    problems.extend([
        (["i+j=0", "--", "i≤0 ∧ j≤0", "i≤0"], 1, 2, True),
        (["2 i= -1 ∧ 3 j= -1", "--", "min|max(i,j)"], 1, 1, True),
        (["3 i=1 ∧ 4 j=1", "--", "min||max(i,j)"], 1, 1, True),
    ])
    data = "".join("\t".join(row)+"\n" for row, *_ in problems)
    run = subprocess.run([driver], input=data, text=True, capture_output=True, check=True)
    answers = run.stdout.splitlines()
    assert len(answers) == len(problems)
    for (row, n, k, feasible), line in zip(problems, answers):
        kept, excluded = map(int, line.split())
        assert excluded == k and (kept == n) == feasible, (row, line, feasible)
    print("363 numeric guard problems agree with the expected joint feasibility.")


def programs(compiler, before):
    pair = (HERE/"coherent_negative_guards.gadt").read_text()
    maximum = (HERE/"negative_max_face.gadt").read_text()
    with TemporaryDirectory() as temp:
        def run(exe, name, source, succeeds, error="No answer in num", runtime_failure=False):
            path = Path(temp)/(name+".gadt")
            path.write_text(source)
            r = subprocess.run([exe, "-no_verif", "-full_annot", "-overwrite_ml", path], capture_output=True, text=True)
            if not succeeds:
                assert r.returncode and error in r.stdout+r.stderr, (name, r)
                return
            assert r.returncode == 0, (name, r)
            ml = path.with_suffix(".ml")
            if runtime_failure:
                executed = subprocess.run(["ocaml", ml], capture_output=True, text=True)
                assert executed.returncode and "Exception: Match_failure" in " ".join(executed.stderr.split())
                return
            binding = "half && pair" if "PairGate" in source else "sample"
            with ml.open("a") as out:
                out.write(f'\nlet () = print_endline (string_of_bool ({binding}))\n')
            assert subprocess.run(["ocaml", ml], check=True, text=True, capture_output=True).stdout == "true\n"
            return " ".join(path.with_suffix(".gadti").read_text().split())
        if before:
            run(before, "before_half", pair.split("datatype PairGate")[0], False)
            run(before, "before_pair", "datatype PairGate"+pair.split("datatype PairGate")[1], False)
            run(before, "before_max", maximum, False)
        signature = run(compiler, "pair", pair, True)
        assert "val accept : Gate (1/2) → Bool" in signature
        assert "val keep : ∀k, n[1 ≤ n]. PairGate (n, k) → Bool" in signature
        sig = run(compiler, "maximum", maximum, True)
        assert "k + (1/4) ≤ 0 ∧ n + (1/4) ≤ 0" in sig
        for n, call in enumerate(["accept Zero", "accept Unit", "keep Low", "keep Edge"]):
            run(compiler, f"bad{n}", pair+"\nlet bad = "+call+"\n", False)
        incompatible = "Contradiction in num: Incompatible numeric alternatives"
        run(compiler, "bad_max", maximum+"\nlet bad = accept Bad\n", False, incompatible)
        def declared(bound):
            return ('datatype Gate : num * num\n'
                    'datacons Bad : ∀i,j[min|max(i,j)]. Gate (i,j)\n'
                    f'external let require : ∀i,j[i≤-1 ∧ j≤{bound}]. Gate (i,j) → Bool = "fun _ -> true"\n'
                    'let sample = require Bad\n')
        annotated = maximum.replace(
            "let accept = function Live -> True | Bad -> assert false",
            "let accept : ∀i,j[i≤-1/4 ∧ j≤-1/4]. Gate (i,j) → Bool = function Live -> True")
        unsafe = annotated+"\nlet bad = accept Bad\n"
        run(compiler, "annotated_live", annotated, True)
        run(compiler, "annotated_bad", unsafe, False, incompatible)
        if before:
            run(before, "previous_match_failure", unsafe, True, runtime_failure=True)
            run(before, "previous_empty_residual", declared(-1), True)
        run(compiler, "empty_residual", declared(-1), False, incompatible)
        run(compiler, "feasible_alternative", declared(0), True)
        diagonal = ("datatype Gate : num * num\n"
                    "datacons East : Gate (1,0)\ndatacons North : Gate (0,1)\n"
                    "datacons Bad : ∀i,j[i≤0 ∧ j≤0]. Gate (i,j)\n"
                    "let accept : ∀i,j[1≤i+j]. Gate (i,j) → Bool = "
                    "function East -> True | North -> True | Bad -> assert false\n"
                    "let east = accept East\nlet sample = accept North\n")
        run(compiler, "written_oblique", diagonal, True)
    print("Three inferred domains accept their live examples and reject five forbidden calls.")
    print("Calls through a declared domain succeed exactly on the feasible control.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    for name in ["driver", "compiler", "before"]:
        parser.add_argument("--"+name, type=Path)
    parser.add_argument("--polyhedra", action="store_true", help="also run exact symbolic checks (requires z3-solver)")
    args = parser.parse_args()
    finite()
    if args.polyhedra:
        polyhedra()
    if args.driver:
        numeric(args.driver.resolve())
    if args.compiler:
        programs(args.compiler.resolve(), args.before.resolve() if args.before else None)
