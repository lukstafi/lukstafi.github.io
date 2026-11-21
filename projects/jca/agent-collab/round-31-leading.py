"""Leading-fresh single-branch validity under specified witness permissions."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations, permutations, product
from pathlib import Path

spec = spec_from_file_location("small_dags",Path(__file__).with_name("round-29-small-dags.py"))
dags = module_from_spec(spec)
spec.loader.exec_module(dags)
inp, V, F = dags.inp,dags.V,dags.F
a,b = F("a"),F("b")


def visibility(moves, permissions):
    """Return retained universal coordinates and ordinary-coordinate read masks."""
    retained = {x for q,x in moves if q == "all" and x not in permissions}
    before, earlier = {}, set()
    for q,x in moves:
        before[x] = set(earlier)
        if x in retained:
            earlier.add(x)
    masks = {}
    for q,x in moves:
        if x not in permissions:
            if q == "some":
                masks[x] = before[x]
            continue
        allowed = permissions[x]
        direct = allowed & retained
        for quantifier,e in moves:
            if e in allowed and quantifier == "some" and not before[e] <= direct:
                raise ValueError(f"{x} can read {e} without all its earlier retained inputs")
        masks[x] = direct
    return retained,masks


def valid(atoms,moves,permissions):
    retained,masks = visibility(moves,permissions)
    mu = inp.unify(atoms)
    if mu is None:
        return False
    normal = {x:inp.apply(V(x),mu) for _,x in moves}
    aliases = {h:normal[h] for h in retained}
    if any(not inp.trees.is_var(v) for v in aliases.values()) or len(set(aliases.values())) != len(aliases):
        return False
    return all(aliases[h][1] not in inp.vars_in(normal[x])
               for x,seen in masks.items() for h in retained-seen)


def ground_game(atoms,moves,permissions):
    """Direct two-constant interpretation, quantifying witness terms first."""
    names = list(permissions)
    choices = [(a,b,*(V(x) for x in sorted(permissions[t]))) for t in names]
    for terms in product(*choices):
        eqs = inp.map_eqs(atoms,dict(zip(names,terms)))
        def play(i,env):
            if i == len(moves):
                return all(inp.once(l,env) == inp.once(r,env) for l,r in eqs)
            q,x = moves[i]
            combine = all if q == "all" else any
            return combine(play(i+1,{**env,x:c}) for c in (a,b))
        if play(0,{}):
            return True
    return False


def compress_primitives(atoms, moves, permissions, premise, conclusion):
    """Process oriented primitive equalities first, then the actual premise."""
    assert valid(atoms,moves,permissions)
    mu = inp.unify(atoms+premise)
    assert mu is not None and all(inp.apply(l,mu) == inp.apply(r,mu) for l,r in conclusion)
    names = [x for _,x in moves]
    witness = {x:inp.grounded(V(x),mu,a) for x in names}
    body = {("rhs",i):r for i,(_,r) in enumerate(atoms)}
    trace_moves = [("all",x) for x in names]+[("some",key) for key in body]
    tests = [(l,V(key)) for (l,_),key in zip(atoms,body)] + premise
    reduced,_,_ = dags.shallow.compress([],trace_moves,tests,conclusion,body,witness,
                                         preserve_support=True)
    new_atoms = [(l,reduced[key]) for (l,_),key in zip(atoms,body)]
    assert valid(new_atoms,moves,permissions)
    assert inp.trees.answer(new_atoms,[(premise,conclusion)])
    return new_atoms


def check():
    names = ("h","e","k")
    possible = [a,b,*map(V,names)]
    primitive = list(combinations(possible,2))
    atom_sets = [[eq] for eq in primitive] + list(combinations(primitive,2))
    count = 0
    for order in permutations(names):
        moves = [("some" if x == "e" else "all",x) for x in order]
        for n in range(4):
            for leaves in combinations(names,n):
                permissions = {"k":set(leaves)}
                try:
                    visibility(moves,permissions)
                except ValueError:
                    continue
                for atoms in atom_sets:
                    assert valid(atoms,moves,permissions) == ground_game(atoms,moves,permissions)
                    count += 1
    # Exclusive access through a carrier really can change the verdict.
    h,e,k = map(V,names)
    moves = [("all","h"),("some","e"),("all","k")]
    assert ground_game([(e,h),(k,h)],moves,{"k":{"e"}})
    assert not ground_game([(e,h),(k,h)],moves,{"k":set()})
    # Preserve the answer unifier before imposing a premise that binds its universal.
    f = lambda l,r:F("f",l,r)
    large = f(h,h)
    for _ in range(7):
        large = f(large,a)
    atoms = [(e,large),(k,e)]
    result = compress_primitives(atoms,moves,{"k":{"h"}},[(h,b)],[(e,k)])
    assert inp.vars_in(result[0][1]) == {"h"}
    # Per-atom valid links via e need not survive orienting a global solved form.
    bridge = [("all","k"),("all","h"),("some","e")]
    assert valid([(e,k)],bridge,{}) and valid([(e,f(h,h))],bridge,{})
    assert valid([(e,k),(e,f(h,h))],bridge,{"k":{"h"}})
    # A polynomial-DAG strategy can retain a named input whose occurrence
    # plays no role in either relevance or consistency.
    kept = dags.small([], [("all","h"),("some","e")], [], [],
                      {"e":large},{"h":a},preserve_support=True)
    assert inp.vars_in(kept["e"]) == {"h"}
    print(f"{count:,} validity comparisons passed, along with carrier and two-stage checks.")


if __name__ == "__main__":
    check()
