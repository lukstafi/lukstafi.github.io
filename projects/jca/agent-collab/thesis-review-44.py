"""Reproduce the projection, finite decision procedure, and round lower bound."""
import argparse
from fractions import Fraction as Q
from heapq import heappop, heappush
from itertools import combinations, product
from pathlib import Path
import subprocess

import z3


def prove(formula):
    solver = z3.Solver()
    solver.add(z3.Tactic("qe")(z3.Not(formula)).as_expr())
    assert solver.check() == z3.unsat, formula


def projection():
    x, y, k, r = z3.Reals("x y k r")
    unit = lambda t: z3.And(0 <= t, t <= 1)

    def admits(x, k):
        return z3.And(unit(x), unit(k), z3.Or(x + k <= 1, z3.And(x == 1, k == 1)))

    cap = z3.And(unit(k), r <= 1, z3.Or(k + r <= 1, k == 1))
    prove(z3.Exists(y, z3.And(admits(y, k), r <= y)) == cap)
    opened = z3.ForAll(k, z3.Implies(admits(x, k), cap))
    prove(z3.Implies(unit(x), opened == (r <= x)))


def descending(menus, centres, branches, caps):
    """Visit a value once, after every larger value that can introduce it."""
    if any(c > d for c, d in zip(centres, caps)):
        return None
    floor = min(centres)
    rows = {}
    pending = []

    def store(t, keys):
        if t <= floor:
            return
        if t not in rows:
            rows[t] = set()
            heappush(pending, -t)
        rows[t].update(keys)

    for keys, c in zip(menus, centres):
        store(c, keys)
    while pending:
        t = -heappop(pending)
        stored = rows[t]
        for keys, c, local in zip(menus, centres, branches):
            if not keys <= stored:
                continue
            if t > c:
                return None
            for a in local:
                v = c + a * (t - c)
                if v < t:
                    store(v, keys)
    return {(k, t) for t, keys in rows.items() for k in keys}


def simultaneous(menus, centres, branches, caps):
    """Iterate whole producer rounds without precomputing any value or edge."""
    floor = min(centres)
    base = {(k, c) for keys, c in zip(menus, centres) for k in keys if c > floor}
    relation = base.copy()
    rounds = 0
    while True:
        if any(c > d for c, d in zip(centres, caps)):
            return None, rounds
        following = base.copy()
        for keys, c, local in zip(menus, centres, branches):
            opened = set.intersection(*({t for j, t in relation if j == k} for k in keys))
            if any(t > c for t in opened):
                return None, rounds
            following.update((k, v) for t, a in product(opened, local)
                             for v in [c + a * (t - c)] if v > floor for k in keys)
        if following == relation:
            return relation, rounds
        assert relation < following
        relation = following
        rounds += 1


def compare_menus():
    keys = "abc"
    choices = [set(s) for n in range(1, 4) for s in combinations(keys, n)]
    centres = (Q(0), Q(2), Q(3))
    good = bad = 0
    for menus in product(choices, repeat=3):
        for branches in (((Q(2),),) * 3, ((Q(3, 2), Q(2)), (Q(3),), (Q(3, 2), Q(2)))):
            for caps in (centres, (10, 11, 12)):
                answer = descending(menus, centres, branches, caps)
                replay, _ = simultaneous(menus, centres, branches, caps)
                assert answer == replay, (menus, branches, answer, replay)
                if answer is None:
                    bad += 1
                else:
                    good += 1
                    # Every upper cap with convex key sections exists exactly
                    # when each input can exclude every larger centre.
                    heights = {k: max(c for m, c in zip(menus, centres) if k in m)
                               for k in set.union(*menus)}
                    separates = all(min(heights[k] for k in m) == c
                                    for m, c in zip(menus, centres))
                    if separates:
                        assert all(t <= heights[k] for k, t in answer)
    print(f"{good + bad} comparisons with simultaneous iteration ({good} feasible, {bad} infeasible)")

    menus = (set("ab"), {"a"}, {"b"})
    centres = (Q(0), Q(1), Q(2))
    doubles = ((Q(2),),) * 3
    assert descending(menus, centres, doubles, centres) == {("a", 1), ("b", 2)}
    assert descending(menus, centres, doubles, (0, 1, 1)) is None

    # The smaller centre's common unsafe value appears after a successor.
    # Centre three puts its new one at b. The private key d keeps three
    # out of the centre-two opening.
    menus = (set("ab"), {"a"}, set("bcd"), set("bc"))
    centres = (Q(0), Q(1), Q(2), Q(3))
    answer, rounds = simultaneous(menus, centres, ((Q(2),),) * 4, (20,) * 4)
    assert answer is None and rounds == 1
    assert descending(menus, centres, ((Q(2),),) * 4, (20,) * 4) is None


def changing_menus():
    # With only two centres, opening the larger base at the smaller input
    # is the only possible obstruction, even for nonconvex packages.
    menus = [set(s) for n in range(1, 4) for s in combinations("abc", n)]
    nested = [(small, large) for small, large in product(menus, repeat=2) if small <= large]
    centres = (Q(0), Q(1), Q(0), Q(1))
    independent_only = 0
    for (lo0, hi0), (lo1, hi1) in product(nested, repeat=2):
        endpoints = (lo0, lo1, hi0, hi1)
        shared = descending(endpoints, centres, ((Q(2),),) * 4, centres)
        passes = not lo0 <= hi1
        assert (shared is not None) == passes
        if not passes and not lo0 <= lo1 and not hi0 <= hi1:
            independent_only += 1
    assert independent_only > 0
    print(f"{len(nested)**2} admission intervals ({independent_only} with separate solutions only)")


def slow_family():
    menus = ({"c"}, set("ab"), {"b"})
    centres = (Q(0), Q(1), Q(2))
    for n in range(1, 10):
        q = 2**n
        gain = 1 + Q(1, q)
        branches = ((gain,),) * 3
        relation = descending(menus, centres, branches, centres)
        assert relation is not None
        # At b, the one generated value at each stage has this closed form.
        threshold = 1
        while gain**threshold < 2:
            threshold += 1
        expected = {("a", 1), ("b", 2)} | {("b", 2 - gain**j) for j in range(threshold)}
        assert relation == expected and q // 3 < threshold <= q
        if n <= 7:
            direct, rounds = simultaneous(menus, centres, branches, centres)
            assert direct == relation and rounds == threshold - 1
    print("Three fixed centres, denominator through 512, exact rational round bound verified")


def compiler_openings(driver):
    cases = []
    for keys in ((0, 1), (0,), (1,)):
        for convex in (False, True):
            post = "l≤1+k" if convex else "l≤1+k ∧ min(l,1+k + -l)≤0"
            for t in map(Q, ("-3/2", "-1", "0", "1/2", "1", "3/2", "2", "3")):
                possible = all(t <= k+1 if convex else t <= 0 or t == k+1 for k in keys)
                fields = ["l", f"{t.denominator} l={t.numerator}", post, *(f"k={k}" for k in keys)]
                verdicts = (possible, possible and t.denominator == 1)
                cases.append(("\t".join(fields), ["sat" if b else "unsat" for b in verdicts]))
    result = subprocess.run([driver], input="".join(line+"\n" for line, _ in cases),
                            check=True, capture_output=True, text=True)
    assert [row.split() for row in result.stdout.splitlines()] == [v for _, v in cases]
    print(f"InvarGenT agreed on both rational and native openings for {len(cases)} guards")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--driver", type=Path, help="executable from thesis-review-41-numeric.ml")
    args = parser.parse_args()
    projection()
    compare_menus()
    changing_menus()
    slow_family()
    if args.driver:
        compiler_openings(args.driver.resolve(strict=True))
