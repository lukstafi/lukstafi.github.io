"""Replay finite menu-cover proofs and check the two InvarGenT examples."""
import argparse
from dataclasses import dataclass
from itertools import combinations, product
from pathlib import Path
from random import Random
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent


@dataclass(frozen=True)
class Rule:
    source: int
    value: int
    calls: tuple = ()


def covers(menus, target, sources):
    return menus[target] <= frozenset().union(*(menus[x] for x in sources))


def derive(menus, values, rules):
    """Record one finite support per opening. Each (target, sources) is an inclusion."""
    opened = {}
    while True:
        size = len(opened)
        producers = {}
        for rule in rules:
            if all(call in opened for call in rule.calls):
                support = frozenset().union(*(opened[call] for call in rule.calls))
                producers.setdefault((rule.source, rule.value), support)
        for target, menu in enumerate(menus):
            for value in values:
                if (target, value) in opened:
                    continue
                missing = set(menu)
                sources, support = [], set()
                for (source, result), evidence in producers.items():
                    if result == value and missing.intersection(menus[source]):
                        sources.append(source)
                        support.update(evidence)
                        missing.difference_update(menus[source])
                if not missing:
                    # If a target supplies itself the inclusion is tautological.
                    if target not in sources:
                        support.add((target, frozenset(sources)))
                    opened[target, value] = frozenset(support)
        if len(opened) == size:
            return opened


def legal_packages(menus, values, rules, keys):
    for bits in product((False, True), repeat=len(keys)*len(values)):
        stored = {(k, r) for (k, r), bit in zip(product(keys, values), bits) if bit}
        opened = {(x, r) for x, menu in enumerate(menus) for r in values
                  if all((k, r) in stored for k in menu)}
        if all(not set(rule.calls) <= opened or (rule.source, rule.value) in opened for rule in rules):
            yield opened


def split_search(menus, values, rules, bad):
    menus = list(menus)
    fresh = 1 + max((k for menu in menus for k in menu), default=-1)
    isolated = []
    while True:
        opened = derive(menus, values, rules)
        hit = next((q for q in bad if q in opened), None)
        if hit is None:
            return True, isolated, opened
        if not opened[hit]:
            return False, isolated, opened
        target, src = min(opened[hit], key=lambda c: (c[0], sorted(c[1])))
        assert target not in src and target not in isolated and covers(menus, target, src)
        menus[target] = menus[target] | {fresh}
        fresh += 1
        isolated.append(target)


def extend(menus, columns, chosen):
    fresh = 1 + max((k for menu in menus for k in menu), default=-1)
    return [menu | {fresh+j for j in chosen if x in columns[j]} for x, menu in enumerate(menus)]


def bounded_search(base, values, rules, bad, columns, budget):
    """Branch on separators of a failed proof. Keep learned clauses across branches."""
    tried, cuts = set(), []

    def visit(chosen):
        if chosen in tried:
            return None
        tried.add(chosen)
        missing = next((cut for cut in cuts if not (chosen & cut)), None)
        if missing is None:
            opened = derive(extend(base, columns, chosen), values, rules)
            hit = next((q for q in bad if q in opened), None)
            if hit is None:
                return chosen
            missing = frozenset(j for j, col in enumerate(columns)
                                if any(x in col and col.isdisjoint(src) for x, src in opened[hit]))
            assert not (missing & chosen)
            cuts.append(missing)
        if len(chosen) < budget:
            for j in sorted(missing):
                result = visit(chosen | {j})
                if result is not None:
                    return result
        return None

    return visit(frozenset()), cuts


def bounded_checks():
    # One separator shared by two callers fits the budget. A private key for
    # just the first counterexample would spend the only slot too early.
    base, columns = [{0}]*3, [{1}, {1, 2}, {2}]
    picked, cuts = bounded_search(base, (0,), [Rule(0, 0)], [(1, 0), (2, 0)], columns, 1)
    assert picked == {1} and cuts == [{0, 1}, {1, 2}]
    rng = Random(471)
    inputs, values = range(3), (0, 1)
    pairs = list(product(inputs, values))
    for _ in range(64):
        rules = [Rule(*rng.choice(pairs), tuple(rng.choices(pairs, k=rng.randrange(3))))
                 for _ in range(7)]
        bad = rng.sample(pairs, rng.randint(1, 3))
        columns = [set(rng.sample(list(inputs), rng.randint(1, 3))) for _ in range(3)]
        good = []
        for n in range(4):
            for picked in combinations(range(3), n):
                menus = extend(base, columns, picked)
                keys = sorted(set.union(*menus))
                if any(not opened.intersection(bad) for opened in legal_packages(menus, values, rules, keys)):
                    good.append(set(picked))
        for budget in range(4):
            result, cuts = bounded_search(base, values, rules, bad, columns, budget)
            assert (result is not None) == any(len(s) <= budget for s in good)
            assert all(s & cut for s in good for cut in cuts)
            if result is not None:
                assert result in good and len(result) <= budget
    print("256 bounded searches match exhaustive admission and package synthesis.")


def proof_checks():
    rng = Random(47)
    values = keys = (0, 1)
    all_menus = list(product((frozenset(), frozenset([0]), frozenset([1]), frozenset(keys)), repeat=2))
    pairs = list(product(range(2), values))
    for _ in range(80):
        rules = [Rule(*rng.choice(pairs), tuple(rng.choices(pairs, k=rng.randrange(3))))
                 for _ in range(5)]
        results = [derive(a, values, rules) for a in all_menus]
        for menus, opened in zip(all_menus, results):
            assert opened.keys() == set.intersection(*legal_packages(menus, values, rules, keys))
            for q, trace in opened.items():
                for other, replay in zip(all_menus, results):
                    if all(covers(other, x, src) for x, src in trace):
                        assert q in replay
        bad = rng.sample(pairs, rng.randrange(1, 4))
        expected = not set(bad).intersection(derive([{0}, {1}], values, rules))
        ok, isolated, _ = split_search([{0}, {0}], values, rules, bad)
        assert ok == expected and len(isolated) <= 2

    rules = [Rule(0, 0), Rule(1, 0)]
    proof = derive([{0}, {1}, {0, 1}], (0,), rules)[2, 0]
    assert proof == {(2, frozenset([0, 1]))}
    assert split_search([{0}, {1}, {0, 1}], (0,), rules, [(2, 0)])[:2] == (True, [2])

    for n in range(1, 9):
        rules = [Rule(0, 0)] + [Rule(2*i, i, ((2*i-1, i-1),)) for i in range(1, n)]
        bad = (2*n-1, n-1)
        menus = [{0}] * (2*n)
        support = frozenset((2*i+1, frozenset([2*i])) for i in range(n))
        assert derive(menus, range(n), rules)[bad] == support
        for separate in range(n):
            changed = menus.copy()
            changed[2*separate+1] = {0, 1}
            assert bad not in derive(changed, range(n), rules)
        assert split_search(menus, range(n), rules, [bad])[:2] == (True, [1])
    print("1,280 finite closures match direct package enumeration. Cross-policy replays and splits passed.")


def rational_covers(driver):
    import z3
    rng = Random(472)
    k, i = z3.Reals("k i")
    cases = [
        (["0≤k ∧ k≤1", "0≤k ∧ 2 k≤1", "1≤2 k ∧ k≤1"], True),
        (["0≤k ∧ k≤1", "0≤k ∧ 2 k≤1", "2≤3 k ∧ k≤1"], False),
        (["0≤k ∧ k≤1", "k=0", "k=1"], False),
        (["2 k=1", "m=k ∧ 2 m=1"], True),
        (["0≤k ∧ k≤i", "k=m ∧ 2 m≤i", "i≤2 k"], True),
        (["1≤0"], True), (["k=0"], False),
    ]
    # Each ground input supplies a rational key interval. i stays public
    # through the disjunction and each local witness has its own scope.
    for _ in range(120):
        text, denotations = [], []
        for _ in range(rng.randint(1, 5)):
            lo, hi = sorted(rng.choices(range(-4, 5), k=2))
            slope = rng.randint(-2, 2)
            text.append(f"m=2 k + {slope} i ∧ {lo}≤m ∧ m≤{hi}")
            denotations.append(z3.And(lo <= 2*k+slope*i, 2*k+slope*i <= hi))
        solver = z3.Solver()
        solver.add(denotations[0], z3.Not(z3.Or(*denotations[1:])))
        cases.append((text, solver.check() == z3.unsat))
    data = "".join("\t".join(query)+"\n" for query, _ in cases)
    run = subprocess.run([driver], input=data, capture_output=True, text=True, check=True)
    assert run.stdout.splitlines() == ["covered" if covered else "gap" for _, covered in cases]
    print("127 rational cover tests passed, including unions and private menu witnesses.")


def arithmetic(driver):
    import z3
    rng = Random(470)
    names = ["l", "i", "i1", "i2"]
    z = [z3.Real(name) for name in names]
    cases = []
    for _ in range(220):
        d = rng.randint(2, 4)
        equations, facts = [], []
        point = [rng.randint(-3, 3) for _ in range(d)]
        for _ in range(rng.randint(1, d+2)):
            coeff = [rng.randint(-4, 4) for _ in range(d)]
            target = sum(a*b for a, b in zip(coeff, point)) + rng.choice([0, 0, 0, 1])
            terms = " + ".join(f"{a} {v}" for a, v in zip(coeff, names) if a) or "0"
            equations.append(f"{terms}={target}")
            facts.append(sum(a*b for a, b in zip(coeff, z)) == target)
        expected = []
        for native in [[], z[:1], z[:d]]:
            solver = z3.Solver()
            solver.add(*facts, *(z3.IsInt(v) for v in native))
            result = solver.check()
            assert result != z3.unknown
            expected.append(str(result))
        cases.append(([";".join(names[:d]), " ∧ ".join(equations), "2 m=k+l", "2 k=1"], expected))
    # Both rounded rows are primitive, and each coordinate can take every
    # integer value on the rational plane. The two congruences disagree.
    row1 = "10 l + -5 i1 + -5 i2"
    row2 = "10 i + -5 i1 + 5 i2"
    for lower, upper, verdict in [(1, 9, "unsat"), (6, 14, "sat")]:
        pre = f"-4≤{row1} ∧ {row1}≤4 ∧ {lower}≤{row2} ∧ {row2}≤{upper}"
        cases.append((["l;i;i1;i2", pre, "0=0", "0=0"], ["sat", "sat", verdict]))
    # The rational relaxation can still include a full-dimensional cell without integer points.
    gap = "0≤8 i+7 l ∧ 8 i+7 l≤1 ∧ 2≤12 i+11 l ∧ 12 i+11 l≤3"
    cases.append((["l;i", gap, "0=0", "0=0"], ["sat", "sat", "sat"]))
    x, y = z3.Ints("x y")
    solver = z3.Solver()
    solver.add(0 <= 8*x+7*y, 8*x+7*y <= 1, 2 <= 12*x+11*y, 12*x+11*y <= 3)
    assert solver.check() == z3.unsat
    data = "".join("\t".join(query)+"\n" for query, _ in cases)
    run = subprocess.run([driver], input=data, text=True, capture_output=True, check=True)
    answers = run.stdout.splitlines()
    assert len(answers) == len(cases)
    for (query, expected), answer in zip(cases, answers):
        assert answer.split() == expected, (query, expected, answer)
    print("220 equality systems agree with Z3 in three native modes. Both unbounded plane controls and the inequality gap passed.")


def programs(compiler, before):
    with TemporaryDirectory() as temp:
        def check(exe, name, source, budget, output=None, error=None):
            path = Path(temp)/(name+".gadt")
            path.write_text(source)
            run = subprocess.run([exe, "-iterations_timeout", str(budget), "-num_abduction_timeout", "40",
                                  "-no_verif", "-full_annot", "-overwrite_ml", path], capture_output=True, text=True)
            if error:
                assert run.returncode != 0 and error in run.stdout+run.stderr, (name, run)
                return
            assert run.returncode == 0, (name, run)
            actual = subprocess.run(["ocaml", path.with_suffix(".ml")], text=True, capture_output=True, check=True)
            assert actual.stdout == output, (name, actual)
            return " ".join(path.with_suffix(".gadti").read_text().split("val run :")[1].split())

        bit = (HERE/"caller_bit_flip.gadt").read_text()
        schema = bit[bit.index("let rec run :"):bit.index(" =\n  fun bit")]
        written = check(compiler, "flip", bit, 2, "0\n1\n")
        inferred = check(compiler, "inferred", bit.replace(schema, "let rec run"), 3, "0\n1\n")
        assert "∃l[0 ≤ l ∧ l ≤ 1].Num l" in written and "∃.Num n" in inferred
        lattice = (HERE/"lattice_guard.gadt").read_text()
        if before:
            check(before, "before", lattice, 4, error="Type mismatch")
        check(compiler, "lattice", lattice, 2, "0\n")
        even = lattice.replace("11 + -5 i", "10 + -5 i").replace("fun _ -> 0", "fun v -> if v = 1 then 1 else 0")
        scaled = lattice.replace("Num i →\n  ∃", "Num (2 i) →\n  ∃").replace("(Num i, Num j)", "(Num (2 i), Num j)")
        scaled = scaled.replace("fun _ -> 0", "fun v -> if v = 3 then 2 else 0")
        for name, source, value in [("even", even.replace("run (2,2)", "run (1,2)"), 1),
                                    ("scaled", scaled.replace("run (2,2)", "run (3,2)"), 2)]:
            check(compiler, name, source, 4, error="Type mismatch")
            live = source.replace("-> True | _ -> 0", "-> let _ = observe r in 0 | _ -> 0")
            check(compiler, name+"_live", live.replace("(S (S Z))", "(S Z)"), 2, f"{value}\n0\n")
        print("Written and inferred flip schemes, native guard and two live controls passed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--driver", type=Path)
    parser.add_argument("--covers", type=Path)
    parser.add_argument("--compiler", type=Path)
    parser.add_argument("--before", type=Path)
    args = parser.parse_args()
    proof_checks()
    bounded_checks()
    if args.covers:
        rational_covers(args.covers.resolve())
    if args.driver:
        arithmetic(args.driver.resolve())
    if args.compiler:
        programs(args.compiler.resolve(), args.before.resolve() if args.before else None)
