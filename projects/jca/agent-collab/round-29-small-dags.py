"""Replay the small-DAG construction on a supplied successful strategy."""
from functools import lru_cache
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
from random import Random

spec = spec_from_file_location("shallow", Path(__file__).with_name("round-28-compression.py"))
shallow = module_from_spec(spec)
spec.loader.exec_module(shallow)
inp = shallow.inp
V, F, at, is_var, a = inp.V, inp.F, shallow.at, inp.trees.is_var, shallow.a


def small(data, moves, premise, conclusion, strategy, witness, base=a, pack_op=("f",2),
          *, preserve_support=False, rebuild_holes=None):
    original, _, _ = shallow.compress(data,moves,premise,conclusion,strategy,witness,base,pack_op,
                                       preserve_support=preserve_support)
    roots = dict(original)
    formulas = {}
    for part, eqs in enumerate([premise,conclusion]):
        formulas[part] = []
        for i,eq in enumerate(eqs):
            pair = []
            for j,term in enumerate(eq):
                owner = ("formula",part,i,j)
                roots[owner] = term
                pair.append((owner,()))
            formulas[part].append(pair)
    seen = {x:set() for x in original}
    if preserve_support:
        for x,body in original.items():
            seen[x].update(shallow.support_paths(body).values())
    bindings = {}

    def raw(ref):
        owner,path = ref
        return at(roots[owner],path)

    def deref(ref, trace=False):
        while True:
            owner,path = ref
            term = raw(ref)
            if trace and owner in original:
                seen[owner].add(path)
            if not is_var(term):
                return ref
            x = term[1]
            if owner not in original and x in original:
                ref = (x,())
            elif x in bindings:
                ref = bindings[x]
            else:
                return ref

    def child(ref,j):
        return ref[0], (*ref[1],j)

    # Bindings grow between pivots. Keep the original child pointers so the
    # final fragment for each strategy is shared between all its occurrences.
    def norm(ref):
        ref = deref(ref)
        term = raw(ref)
        if is_var(term):
            return term
        return F(term[0],*(norm(child(ref,j)) for j in range(1,len(term))))

    while True:
        pair = next(((l,r) for l,r in formulas[0] if norm(l) != norm(r)),None)
        if pair is None:
            break
        l,r = pair
        while True:
            l,r = deref(l,True),deref(r,True)
            lt,rt = raw(l),raw(r)
            if is_var(lt) or is_var(rt):
                h,target = (lt[1],r) if is_var(lt) else (rt[1],l)
                assert h not in inp.vars_in(norm(target))
                bindings[h] = target
                break
            assert lt[0] == rt[0]
            j = next(j for j in range(1,len(lt)) if norm(child(l,j)) != norm(child(r,j)))
            l,r = child(l,j),child(r,j)
    assert all(norm(l) == norm(r) for l,r in formulas[1])
    holes = {}
    def skeleton(owner,term,path=()):
        if path not in seen[owner]:
            name = ("gap",owner,path)
            holes[name] = (owner,path)
            return V(name)
        if is_var(term):
            return term
        return F(term[0],*(skeleton(owner,term[j],(*path,j)) for j in range(1,len(term))))
    for paths in seen.values():
        paths.update(q[:j] for q in list(paths) for j in range(len(q)))
    skeletons = {x:skeleton(x,term) for x,term in original.items()}
    inputs = [h for q,h in moves if q == "all"]
    rigid = {h:F(("residual",h)) for h in inputs if h not in bindings}
    values = {h:inp.once(norm(bindings[h]),rigid) if h in bindings else rigid[h] for h in inputs}
    values.update((gap,inp.once(norm(ref),rigid)) for gap,ref in holes.items())

    forced = set(rigid.values())
    def observe(term, env):
        if is_var(term):
            return env[term[1]]
        value = F(term[0],*(observe(c,env) for c in term[1:]))
        forced.add(value)
        return value
    public = {**values,**{x:observe(t,values) for x,t in skeletons.items()}}
    for eq in premise+conclusion:
        assert observe(eq[0],public) == observe(eq[1],public)
    @lru_cache(None)
    def shrink(value):
        if value not in forced:
            return base
        return F(value[0],*(shrink(c) for c in value[1:]))
    compressed = {x:shrink(value) for x,value in values.items()}
    @lru_cache(None)
    def generate(value,allowed):
        for h in allowed:
            if compressed[h] == value:
                return V(h)
        assert value not in rigid.values()
        return F(value[0],*(generate(c,allowed) for c in value[1:]))
    if rebuild_holes is None:
        filling = {gap:generate(compressed[gap],tuple(sorted(inp.vars_in(raw(ref)),key=repr)))
                   for gap,ref in holes.items()}
    else:
        filling = rebuild_holes(original,{p:raw(ref) for p,ref in holes.items()},
                                skeletons,values,forced,set(rigid.values()),inputs)
    result = {x:inp.once(term,filling) for x,term in skeletons.items()}
    if preserve_support:
        assert all(inp.vars_in(result[x]) == inp.vars_in(term) for x,term in original.items())
    active = inp.map_eqs(premise,result)
    mu = inp.unify(active)
    assert mu is not None
    assert all(inp.apply(l,mu) == inp.apply(r,mu) for l,r in inp.map_eqs(conclusion,result))
    return result


def shared_witness():
    depth = 10
    rng = Random(2910)
    h,k,y,z = map(V,"hkyz")
    f = lambda l,r:F("f",l,r)
    names = [f"x{i}" for i in range(depth+1)]
    data = {names[0]:a}
    premise = [(y,z),(V(names[0]),a)]
    for prev,name in zip(names,names[1:]):
        data[name] = f(data[prev],data[prev])
        premise.append((V(name),f(V(prev),V(prev))))
    def marked(n):
        return f(marked(n-1),marked(n-1)) if n else rng.choice([h,k,a])
    strategy = {**data,"y":marked(depth),"z":data[names[-1]]}
    moves = [("all","h"),("all","k"),("some","y"),("some","z")]
    conclusion = [(y,V(names[-1])),(h,a),(k,a)]
    result = small(names,moves,premise,conclusion,strategy,{"h":a,"k":a})
    def dag_size(xs):
        return len({u for term in xs.values() for u in inp.subterms(term)})
    before,after = dag_size(strategy),dag_size(result)
    assert after < before
    return before,after


if __name__ == "__main__":
    # Run every initial-data, scope, pivot and signature example through both
    # transformations, then independently check the resulting strategies.
    def both(*args, **kwargs):
        small(*args,**kwargs)
        return shallow.compress(*args,**kwargs)
    shallow.check(both)
    before,after = shared_witness()
    print(f"The 1,024-leaf example went from {before} distinct strategy nodes to {after}.")
