"""Compress comparable first- and second-stage valuations on shared term graphs."""
from functools import cache
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
from random import Random

spec = spec_from_file_location("leading",Path(__file__).with_name("round-31-leading.py"))
leading = module_from_spec(spec)
spec.loader.exec_module(leading)
dags,inp,V,F,a = leading.dags,leading.inp,leading.V,leading.F,leading.a
is_var = inp.trees.is_var


def build_from(target, generators, forbidden):
    """Return an open construction, with a generator used before unfolding it."""
    by_value = {value:V(name) for name,value in generators.items()}
    @cache
    def body(t):
        if t in by_value:
            return by_value[t]
        if t in forbidden or is_var(t):
            raise ValueError("A rigid leaf has no covering generator")
        return F(t[0],*(body(c) for c in t[1:]))
    return body(target)


def compress_levels(first, sigma, explicit, final_fixed, final_rigid):
    """first maps names to first-level terms; sigma instantiates their letters.
    explicit contains the first-level formula expressions evaluated using first.
    final_fixed lists every constructor value to keep for final-level equations.
    """
    marks = set(first.values()) | {V(h) for h in sigma}
    fixed = set()
    def inspect(t):
        if is_var(t):
            return first[t[1]]
        v = F(t[0],*(inspect(c) for c in t[1:]))
        fixed.add(v)
        marks.add(v)
        return v
    for term in explicit:
        inspect(term)
    @cache
    def final(t):
        if is_var(t):
            return sigma[t[1]]
        return F(t[0],*(final(c) for c in t[1:]))
    keep = set(final_fixed) | set(final_rigid) | {final(v) for v in fixed}
    @cache
    def shrink(t):
        if t not in keep:
            return a
        return F(t[0],*(shrink(c) for c in t[1:]))
    @cache
    def first_marks(t):
        if t in marks:
            return frozenset([t])
        assert not is_var(t)
        return frozenset().union(*(first_marks(c) for c in t[1:]))
    @cache
    def restore(v):
        if is_var(v):
            return v
        if v in fixed:
            return F(v[0],*(restore(c) for c in v[1:]))
        boundary = frozenset().union(*(first_marks(c) for c in v[1:]))
        body = build_from(shrink(final(v)),{b:shrink(final(b)) for b in boundary},final_rigid)
        return inp.once(body,{b:restore(b) for b in boundary})
    new_sigma = {h:shrink(v) for h,v in sigma.items()}
    for v in marks:
        rebuilt = restore(v)
        assert inp.vars_in(rebuilt) <= inp.vars_in(v)
        assert inp.once(rebuilt,new_sigma) == shrink(final(v))
    return {x:restore(v) for x,v in first.items()}, new_sigma, shrink


def compress_primitives(atoms, moves, permissions, premise, conclusion):
    """Synthesize shorter primitive right sides using the actual ordinary trace."""
    names = [x for _,x in moves]
    strategy = {("rhs",i):r for i,(_,r) in enumerate(atoms)}
    definitions = [(l,V(key)) for (l,_),key in zip(atoms,strategy)]
    all_moves = [("all",x) for x in names]+[("some",key) for key in strategy]
    mu = inp.unify(atoms+premise)
    witness = {x:inp.grounded(V(x),mu,a) for x in names}
    assert leading.valid(atoms,moves,permissions)
    def rebuild(original,raw_gaps,frames,values,forced,rigid,inputs):
        first_unifier = inp.unify(inp.map_eqs(definitions,original))
        env = {x:inp.apply(V(x),first_unifier) for x in inputs}
        first = {**env,**{p:inp.once(t,env) for p,t in raw_gaps.items()}}
        sigma = {x:values[x] for x,v in env.items() if v == V(x)}
        literals = list(frames.values())
        for eq in inp.map_eqs(definitions,frames):
            literals.extend(eq)
        shortened,_,shrink = compress_levels(first,sigma,literals,forced,rigid)
        filling = {}
        for p,t in raw_gaps.items():
            allowed = {x:shortened[x] for x in inp.vars_in(t)}
            filling[p] = build_from(shortened[p],allowed,set())
            assert inp.once(filling[p],{x:shrink(values[x]) for x in allowed}) == shrink(values[p])
        return filling
    small = dags.small([],all_moves,definitions+premise,conclusion,strategy,witness,
                       preserve_support=True,rebuild_holes=rebuild)
    shortened = [(l,small[key]) for (l,_),key in zip(atoms,strategy)]
    assert leading.valid(shortened,moves,permissions)
    assert inp.trees.answer(shortened,[(premise,conclusion)])
    return shortened


def check():
    f = lambda x,y:F("f",x,y)
    h,k = V("h"),V("k")
    q = F(("final letter",0))
    # Distinct first-stage values may coincide at the second stage. Each
    # generator test must still work in the reconstructed first-stage terms.
    large = f(h,k)
    for _ in range(8):
        large = f(large,large)
    first = {"x":h,"y":k,"pair":f(h,k),"large":large,"whole":f(large,large)}
    sigma = {"h":q,"k":q}
    explicit = [f(V("x"),V("y")),f(V("large"),V("large"))]
    small,_,_ = compress_levels(first,sigma,explicit,{f(q,q)},{q})
    for v,keys in [("large",["pair"]),("large",["x","y"]),("whole",["large"])]:
        build_from(small[v],{x:small[x] for x in keys},set())
    assert small["x"]!=small["y"]
    moves = [("all","h"),("all","k"),("some","e"),("some","y"),("some","z")]
    e,y,z = V("e"),V("y"),V("z")
    nested = h
    for _ in range(9):
        nested = f(nested,nested)
    atoms = [(e,k),(e,nested),(y,f(e,k)),(z,f(k,e))]
    reduced = compress_primitives(atoms,moves,{"k":{"h"}},[(h,a)],[(y,z)])
    assert len(set(inp.subterms(reduced[1][1]))) < len(set(inp.subterms(nested)))
    # Uninspected pieces shared across the primitive and the checked premise.
    atoms2 = [(y,f(h,e)),(z,f(k,e))]
    compress_primitives(atoms2,moves,{},[(y,z)],[(h,k)])
    # A generic game row with a hidden input read through a carrier. The
    # final-level generation constraint survives the collapse at that row.
    first = {"h":h,"carrier":f(h,h),"request":f(h,h)}
    small,play,shrink = compress_levels(first,{"h":q},[f(V("h"),V("h"))],{q},{q})
    game = {x:inp.once(v,play) for x,v in small.items()}
    assert build_from(game["request"],{"carrier":game["carrier"]},{q}) == V("carrier")
    assert game["h"] == q and game["request"] == shrink(f(q,q))
    rng = Random(37)
    for _ in range(80):
        terms = [a,h]
        for _ in range(6):
            terms.append(f(rng.choice(terms),rng.choice(terms)))
        term = terms[-1]
        atoms = [(e,term),(k,e),(y,f(k,e)),(z,f(e,k))]
        compress_primitives(atoms,moves,{"k":{"h"}},[(h,rng.choice([a,f(a,a)]))],[(y,z)])
    print("Verified both stages, a generic carrier, and 82 compressed ordinary implications.")


if __name__ == "__main__":
    check()
