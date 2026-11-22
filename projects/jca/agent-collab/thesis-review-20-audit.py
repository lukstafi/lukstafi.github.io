"""Compare Guard_probe.native with independent quantified rational queries in Z3."""
import argparse
from collections import Counter
from itertools import combinations_with_replacement, permutations, product
from pathlib import Path
import subprocess

import z3


def responses(exe, rows):
    request = "".join("\t".join(row) + "\n" for row in rows)
    result = subprocess.run([exe], input=request, text=True, capture_output=True, check=True)
    answers = result.stdout.splitlines()
    assert len(answers) == len(rows) and set(answers) <= {"true", "false"}, result.stderr
    return [answer == "true" for answer in answers]


def possible(prefix, variables, matrix):
    for name, quantifier in reversed(prefix):
        bind = z3.Exists if quantifier == "E" else z3.ForAll
        matrix = bind([variables[name]], matrix)
    solver = z3.Solver()
    solver.add(matrix)
    answer = solver.check()
    assert answer != z3.unknown, solver.reason_unknown()
    return answer == z3.sat


def numeric(exe):
    x, y = z3.Reals("n1 n2")
    variables = {"n1": x, "n2": y}
    atoms = [("n1<=0", x <= 0), ("0<=n1", 0 <= x), ("n2<=1", y <= 1), ("1<=n2", 1 <= y),
             ("n1=n2", x == y), ("n1<=n2", x <= y), ("n2<=n1", y <= x), ("n1+n2<=0", x+y <= 0),
             ("n1+1<=n2", x+1 <= y), ("n2+1<=n1", y+1 <= x), ("2 n1=n2+1", 2*x == y+1)]
    linear_count = len(atoms)
    atoms.extend([("n1<=max(n2,0)", z3.Or(x <= y, x <= 0)), ("n1=min(n2,0)", x == z3.If(y <= 0, y, 0))])
    empty = "-", z3.BoolVal(True)
    rows, expected = [], []
    cache = {}
    for quantifiers in product("EA", repeat=2):
        prefix = tuple(zip(variables, quantifiers))
        encoded = ",".join(q+name for name, q in prefix)

        def truth(matrix):
            key = prefix, matrix.sexpr()
            if key not in cache:
                cache[key] = possible(prefix, variables, matrix)
            return cache[key]

        def add(group, f, h, c, g):
            rows.append((encoded, f[0], h[0], c[0], g[0]))
            facts = z3.And(f[1], z3.Implies(h[1], c[1]))
            needed = not truth(z3.And(facts, z3.Not(g[1]))) if truth(facts) else None
            expected.append((group, needed))

        for i, j in combinations_with_replacement(range(len(atoms)), 2):
            a, b = atoms[i], atoms[j]
            guard = a[0] + " ∧ " + b[0], z3.And(a[1], b[1])
            add("linear" if j < linear_count else "extrema", empty, empty, empty, guard)
            for c in atoms:
                add("conditional", empty, a, c, guard)
                add("unconditional", c, empty, empty, guard)

    counts = Counter()
    for row, (group, needed), actual in zip(rows, expected, responses(exe, rows)):
        if needed is None:
            continue
        assert not actual or needed, row
        counts[group, "agreed" if actual == needed else "missed"] += 1
    assert not counts["linear", "missed"]
    print(len(rows), "queries,", sum(counts.values()), "with feasible facts,", dict(sorted(counts.items())))


def mixed(exe):
    # In the dual game a choice of the type a that can force a=Num(n2)
    # has exactly the freedom to choose its index. An opposing type move
    # can always choose Marker instead.
    variables = dict(zip(("a", "n1", "n2"), z3.Reals("z x y")))
    z, x, y = variables.values()
    rows, expected = [], []
    for names in permutations(variables):
        for quantifiers in product("AE", repeat=3):
            prefix = tuple(zip(names, quantifiers))
            dual = tuple((name, "E" if q == "A" else "A") for name, q in prefix)
            for atom, comparison in (("n2=n1", y == x), ("n1<=n2", x <= y), ("n1+n2<=0", x+y <= 0)):
                guard = "a=Num n2 ∧ " + atom
                rows.append((",".join(q+name for name, q in prefix), "-", "-", "-", guard))
                expected.append(dict(dual)["a"] == "E" and possible(dual, variables, z3.And(z == y, comparison)))
    answers = responses(exe, rows)
    assert all(not a or e for a, e in zip(answers, expected))
    print(len(rows), "mixed queries,", sum(a != e for a, e in zip(answers, expected)), "missed")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("probe", type=Path)
    probe = parser.parse_args().probe.resolve(strict=True)
    numeric(probe)
    mixed(probe)
