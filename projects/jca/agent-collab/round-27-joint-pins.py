"""One implication whose joint witness bounds all possible output markings."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location("pins", Path(__file__).with_name("round-22-ground-tests.py"))
pins = module_from_spec(spec)
spec.loader.exec_module(pins)
inp = pins.inp
V, F = inp.V, inp.F


def bodies(tree, available):
    # Each marked position consumes the entire subtree. The same public input
    # can occupy several disjoint positions, including equal DAG subterms.
    for h in available:
        yield V(h)
    if inp.trees.is_var(tree) or len(tree) == 1:
        yield tree
        return
    for children in product(*(bodies(s, available) for s in tree[1:])):
        yield F(tree[0], *children)


def solve(data, moves, premise, conclusion, base=("a",), *, singleton=False):
    scopes = {y: [h for q, h in moves[:i] if q == "all"]
              for i, (q, y) in enumerate(moves) if q == "some"}
    if singleton:
        return dict.fromkeys([*data, *scopes], base)
    joint = inp.unify(premise + conclusion)
    if joint is None:
        return None
    tested = [y for y in scopes if any(
        set(pins.prior.positions(l, y)) != set(pins.prior.positions(r, y))
        for l, r in premise)]
    shapes = {y: inp.apply(V(y), joint) for y in tested}
    public = set(data) | {x for _, x in moves}
    residuals = inp.collect(shapes.values())
    fresh = {}
    for r in sorted(residuals, key=repr):
        name = ("joint residual", r)
        while name in public:
            name = ("fresh", name)
        public.add(name)
        fresh[r] = V(name)
    for y, shape in shapes.items():
        for h in scopes[y]:
            if not inp.vars_in(shape) <= inp.vars_in(inp.apply(V(h), joint)):
                raise ValueError(f"input {h!r} could occur inside a residual of {y!r}")
    remaining = [(q, x) for q, x in moves if x not in shapes]
    extra = [v[1] for v in fresh.values()]
    erase = {y: base for y in scopes if y not in shapes}
    choices = [bodies(inp.once(shapes[y], fresh), scopes[y]) for y in tested]
    for combination in product(*choices):
        selected = dict(zip(tested, combination))
        reduced = inp.map_eqs(premise, {**erase, **selected})
        need = inp.map_eqs(conclusion, selected)
        solution = inp.solve([*data, *extra], remaining, reduced, need, base)
        if solution is None:
            continue
        result = {x: term for x, term in solution.items() if x not in extra}
        result.update((y, inp.once(tree, solution)) for y, tree in selected.items())
        active = inp.unify(inp.map_eqs(premise, result))
        assert active is not None
        assert all(inp.apply(l, active) == inp.apply(r, active)
                   for l, r in inp.map_eqs(conclusion, result))
        return result
    return None


def check():
    a, b = F("a"), F("b")
    h, k, y, z = map(V, ("h", "k", "y", "z"))
    moves = [("all", "h"), ("all", "k"), ("some", "y"), ("some", "z")]
    f = lambda l, r: F("f", l, r)
    equal = [(y, z)]
    # Moving the conclusion pin into the premise creates an extra solution.
    assert solve([], moves, equal, [(y,a),(h,a),(k,a)]) is None
    assert solve([], moves, [*equal,(y,a)], [(h,a),(k,a)]) is not None
    assert solve([], moves, equal, [(y,f(a,b)),(h,a),(k,b)]) is not None
    # The joint shapes f(k,k) have a residual shared by both input values.
    assert solve([], moves, equal, [(y,f(h,k)),(h,k)]) is not None
    # A read in the interior of a free residual is outside this algorithm.
    try:
        solve([], moves, equal, [(y,h)])
    except ValueError:
        pass
    else:
        raise AssertionError("accepted an unrestricted residual")
    cases = 0
    for moveset in (moves, [moves[i] for i in (0,2,1,3)]):
        visible_y = (a,b,h,k) if moveset == moves else (a,b,h)
        for literal, l, r in product((a,b), (a,b,h,k,y,z), (a,b,h,k,y,z)):
            conclusion = [(y,literal),(l,r)]
            exists = False
            for by, bz in product(visible_y, (a,b,h,k)):
                active = inp.unify([(by,bz)])
                if active is not None and all(inp.apply(s,active) == inp.apply(t,active)
                    for s,t in inp.map_eqs(conclusion, {"y":by,"z":bz})):
                    exists = True
                    break
            assert (solve([],moveset,equal,conclusion) is not None) == exists
            cases += 1
    print(f"{cases} exact comparisons passed, including interleaved scope.")


if __name__ == "__main__":
    check()
