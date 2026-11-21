"""Exercise a common witness with different and nested premise unifiers."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations
from pathlib import Path

spec = spec_from_file_location("projection", Path(__file__).with_name("round-28-compression.py"))
pr = module_from_spec(spec)
spec.loader.exec_module(pr)
inp, a, b, V = pr.inp, pr.a, pr.b, pr.V
h, k, y, u, v = map(V, "hkyuv")
f = lambda left, right: pr.F("f", left, right)


def wrap(t):
    for _ in range(15):
        t = f(t, a)
    return t


def check():
    moves = [("all","h"),("all","k"),("some","y"),("some","u"),("some","v")]
    # Same ground tile occurs twice. Its left path is needed in the
    # first branch and its right path is needed in the second.
    tile = f(wrap(a),wrap(b))
    witness = {"h":a, "k":b}
    strategy = {"y":f(wrap(h),wrap(k)), "u":f(wrap(a),wrap(k)), "v":f(wrap(h),wrap(b))}
    first, second = ([(y,u)],[(h,a)]), ([(y,v)],[(k,b)])
    _, _, retained = pr.compress([],moves,*first,strategy,witness,other_branches=[second])
    assert len(retained[tile]) == 2
    # A trace from the other branch cannot be used to establish this conclusion.
    bad_d, bad_c = first[0], second[1]
    mu = inp.unify(inp.map_eqs(bad_d,strategy))
    assert mu is not None
    assert any(inp.apply(l,mu)!=inp.apply(r,mu) for l,r in inp.map_eqs(bad_c,strategy))
    # Nested and incomparable premise families, all activated at this same tuple.
    inspected = 0
    atoms = [(y,u),(y,v),(u,v),(h,a),(k,b)]
    for first_size in (1,2):
        for left in combinations(atoms,first_size):
            for right in combinations(atoms,2):
                branches = []
                for d in [left,right,(*left,*right)]:
                    mu = inp.unify(inp.map_eqs(d,strategy))
                    c = [(l,r) for l,r in atoms
                         if inp.apply(inp.once(l,strategy),mu)==inp.apply(inp.once(r,strategy),mu)]
                    branches.append((list(d),c))
                pr.compress([],moves,*branches[0],strategy,witness,other_branches=branches[1:])
                inspected += 1
    separate = [[(h,a)],[(h,b)]]
    assert all(inp.unify(d) is not None for d in separate)
    assert inp.unify([eq for d in separate for eq in d]) is None
    print(f"Verified {inspected} common-witness families, distinct trace paths, and disjoint witnesses.")


if __name__ == "__main__":
    check()
