"""Check the depth-indexed maximal answers and all their immediate relaxations."""
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location("maximal", Path(__file__).with_name("round-42-maximal.py"))
maximal = module_from_spec(spec)
spec.loader.exec_module(maximal)
inp, V, a, f = maximal.inp, maximal.V, maximal.a, maximal.f
names = ("x", "y", "z")


def chain(depth, name, tail):
    for i in reversed(range(depth)):
        tail = f(V((name, i)), tail)
    return tail


def family(depth):
    p, q, s = map(V, ("p", "q", "s"))
    return {
        "x": chain(depth, "u", f(q, q)),
        "y": f(p, chain(depth, "v", f(s, p))),
        "z": s,
    }


def positions(t, path=()):
    yield path, t
    if not inp.trees.is_var(t):
        for i, child in enumerate(t[1:], 1):
            yield from positions(child, (*path, i))


def replace_at(t, path, value):
    if not path:
        return value
    i, *rest = path
    return (*t[:i], replace_at(t[i], rest, value), *t[i+1:])


def relaxations(pattern):
    locations = {}
    for x, t in pattern.items():
        for path, subtree in positions(t):
            locations.setdefault(subtree, []).append((x, path))
    for subtree, uses in locations.items():
        if inp.trees.is_var(subtree):
            assert len(uses) <= 2
            if len(uses) == 1:
                continue
        else:
            assert len(uses) == 1
        x, path = uses[0]
        yield {**pattern, x: replace_at(pattern[x], path, V("new"))}


def least_general_generalization(first, second):
    disagreements = {}
    def visit(left, right):
        if (not inp.trees.is_var(left) and not inp.trees.is_var(right)
                and left[0] == right[0]):
            return inp.F(left[0], *(visit(l, r) for l, r in zip(left[1:], right[1:])))
        pair = (left, right)
        if pair not in disagreements:
            disagreements[pair] = V(len(disagreements))
        return disagreements[pair]
    return {name: visit(first[name], second[name]) for name in names}


def uniform_seed(depth):
    # These answers use only the three public names.
    x, tail = a, V("z")
    for _ in range(depth):
        x, tail = f(a, x), f(a, tail)
    return {"x": x, "y": f(a, tail), "z": V("z")}


def check_uniform_consistency():
    x, y, z = map(V, names)
    b = inp.F("b")
    branches = [([(y, f(c, x))], [(z, c)]) for c in (a, b)]
    prefix = [("some", v) for v in names]
    gamma = V("g")
    for answer in ([(y, f(z, gamma))], [(y, f(x, z))]):
        assert inp.trees.answer(answer, branches)
        assert all(maximal.weak.game(answer+d, [("all","g"), *prefix]) for d,_ in branches)
    for depth in range(13):
        seed = uniform_seed(depth)
        eqs = [(V(n), t) for n,t in seed.items()]
        assert inp.trees.answer(eqs, branches[:1])
        assert maximal.weak.game(eqs+branches[0][0], prefix)
        for smaller in range(depth):
            general = least_general_generalization(uniform_seed(smaller), seed)
            for specific in (uniform_seed(smaller), seed):
                assert maximal.contains(general, specific, names)
            assert inp.unify([(general["y"], f(a,general["x"])), (general["z"], b)]) is not None
    pattern = family(1)
    eqs = [(V(n),t) for n,t in pattern.items()]
    fresh = set().union(*(inp.vars_in(t) for t in pattern.values()))
    assert not maximal.weak.game(eqs+branches[0][0], [*(("all",v) for v in fresh), *prefix])


def check():
    total = 0
    x, y, z = map(V, names)
    for depth in range(13):
        pattern = family(depth)
        equations = [(V(name), pattern[name]) for name in names]
        for b in (inp.F("b"), f(a, a)):
            branches = [([(y, f(c, x))], [(z, c)]) for c in (a, b)]
            assert inp.trees.answer(equations, branches)
            for relaxed in relaxations(pattern):
                assert maximal.contains(relaxed, pattern, names)
                assert not maximal.contains(pattern, relaxed, names)
                # Ground the unifier and check the concrete false row.
                mu = inp.unify([(relaxed["y"], f(a, relaxed["x"])), (relaxed["z"], b)])
                assert mu is not None
                row = {name: inp.apply(t, mu) for name, t in relaxed.items()}
                rest = set().union(*(inp.vars_in(t) for t in row.values()))
                row = {name: inp.once(t, dict.fromkeys(rest, a)) for name, t in row.items()}
                assert row["y"] == f(a, row["x"]) and row["z"] == b != a
                assert maximal.contains(relaxed, row, names)
                total += 1
        for prev in range(depth):
            other = family(prev)
            assert not maximal.contains(pattern, other, names)
            assert not maximal.contains(other, pattern, names)
    check_uniform_consistency()
    print(f"Verified both consistency conventions, depths 0–12, all {total} relaxation counterexamples and pairwise incomparability.")


if __name__ == "__main__":
    check()
