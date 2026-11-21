"""Compress a strategy by pooling branch traces at a single ground witness."""
from functools import lru_cache
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
from random import Random

spec = spec_from_file_location("input_solver", Path(__file__).with_name("round-20-one-branch.py"))
inp = module_from_spec(spec)
spec.loader.exec_module(inp)
V, F, is_var = inp.V, inp.F, inp.trees.is_var
a, b = F("a"), F("b")


def at(term, path):
    for child in path:
        term = term[child]
    return term


def disagreement(l, r):
    if is_var(l) or is_var(r):
        return (), (r,l) if not is_var(l) else (l,r)
    assert l[0] == r[0] and len(l) == len(r)
    j = next(i for i in range(1,len(l)) if l[i] != r[i])
    path, pair = disagreement(l[j],r[j])
    return (j,*path), pair


def support_paths(term):
    """One original occurrence of each variable, with one-based child indices."""
    found = {}
    def visit(s, path):
        if is_var(s):
            found.setdefault(s[1],path)
        else:
            for i,c in enumerate(s[1:],1):
                visit(c,(*path,i))
    visit(term,())
    return found


def compress(data, moves, premise, conclusion, strategy, witness, base=a, pack_op=("f",2),
             *, preserve_support=False, other_branches=()):
    """pack_op is a constructor name and arity, or None for constants alone."""
    known = set()
    for q,x in moves:
        if q == "all":
            known.add(x)
        else:
            assert inp.vars_in(strategy[x]) <= known
    assert all(not inp.vars_in(strategy[x]) for x in data)
    assert set(witness) == known and all(not inp.vars_in(w) for w in witness.values())
    value = lru_cache(None)(lambda t: inp.once(t, witness))
    branches = [(premise, conclusion), *other_branches]
    systems = [(inp.map_eqs(d, strategy), inp.map_eqs(c, strategy)) for d,c in branches]
    assert all(value(l) == value(r) for active,_ in systems for l,r in active)
    vars_at_witness = {**witness, **{x:value(body) for x,body in strategy.items()}}
    distinguished = set(vars_at_witness.values())
    fixed = set()
    for l,r in (eq for d,c in branches for eq in [*d,*c]):
        for side in (l,r):
            for node in inp.subterms(side):
                v = inp.once(node, vars_at_witness)
                distinguished.add(v)
                if not is_var(node):
                    fixed.add(v)
    retained = {v:set() for v in distinguished}

    def retain_path(v, path):
        while path:
            # The path finishes at the value of a public input.
            n = next(j for j in range(1,len(path)+1) if at(v,path[:j]) in distinguished)
            part = path[:n]
            if v in fixed:
                assert n == 1
            else:
                retained[v].add(part)
            v, path = at(v,part), path[n:]

    if preserve_support:
        for body in strategy.values():
            for path in support_paths(body).values():
                retain_path(value(body),path)

    traces = []
    for active, need in systems:
        bindings = []
        working = active
        while any(l != r for l,r in working):
            l,r = next((l,r) for l,r in working if l != r)
            path,(h,u) = disagreement(l,r)
            assert h[1] not in inp.vars_in(u) and value(h) == value(u)
            retain_path(value(l),path)
            bindings.append((h[1],u))
            working = inp.map_eqs(working,{h[1]:u})
        assert len(bindings) <= len(witness)
        resolved = dict(bindings)
        assert all(inp.apply(l,resolved) == inp.apply(r,resolved) for l,r in need)
        traces.append(bindings)

    def pack(children):
        if not children:
            return base
        name,arity = pack_op
        if arity == 1:
            assert len(children) == 1
            return F(name,children[0])
        result = base
        for child in reversed(children):
            result = F(name,child,result,*([base]*(arity-2)))
        return result

    @lru_cache(None)
    def project(term):
        if is_var(term):
            return term
        v = value(term)
        if v in fixed:
            return F(term[0],*(project(child) for child in term[1:]))
        return pack([project(at(term,p)) for p in sorted(retained[v])])

    new_strategy = {x:project(body) for x,body in strategy.items()}
    if preserve_support:
        assert all(inp.vars_in(new_strategy[x]) == inp.vars_in(body) for x,body in strategy.items())
    new_witness = {h:project(w) for h,w in witness.items()}
    for (premise,conclusion),(active,need),bindings in zip(branches,systems,traces):
        new_active = inp.map_eqs(premise,new_strategy)
        new_need = inp.map_eqs(conclusion,new_strategy)
        assert new_active == [(project(l),project(r)) for l,r in active]
        assert new_need == [(project(l),project(r)) for l,r in need]
        assert all(inp.once(l,new_witness) == inp.once(r,new_witness) for l,r in new_active)
        # Check independently that each retained binding follows after the
        # preceding ones, then check the original relevance condition directly.
        reduced = new_active
        for h,u in bindings:
            mu = inp.unify(reduced)
            assert mu is not None and inp.apply(V(h),mu) == inp.apply(project(u),mu)
            reduced = inp.map_eqs(reduced,{h:project(u)})
        assert all(l == r for l,r in reduced)
        mu = inp.unify(new_active)
        assert mu is not None
        assert all(inp.apply(l,mu) == inp.apply(r,mu) for l,r in new_need)
    return new_strategy, new_witness, retained


def check(compressor=compress):
    f = lambda x,y:F("f",x,y)
    g = lambda x:F("g",x)
    h,k,u,v,w = map(V,"hkuvw")
    moves = [("all","h"),("all","k"),("some","u"),("some","v"),("some","w")]
    def wrap(t):
        for _ in range(20):
            t = f(t,a)
        return t
    tile = f(wrap(a),wrap(b))
    literal = f(tile,tile)
    pattern = f(f(wrap(h),wrap(b)),f(wrap(a),wrap(k)))
    result, _, retained = compressor([],moves,[(u,v)],[(h,a),(k,b)],
        {"u":pattern,"v":literal,"w":tile},{"h":a,"k":b})
    assert len(retained[tile]) == 2 and len(list(inp.subterms(result["u"]))) < 25
    # The second pivot is exposed only after replacing h by the first body.
    compressor([],moves,[(h,u),(h,v)],[(k,a)],{"u":wrap(k),"v":wrap(a),"w":a},
             {"h":wrap(a),"k":a})
    compressor([],moves,[(u,v)],[(h,k)],{"u":g(g(h)),"v":g(g(k)),"w":a},
             {"h":a,"k":a},pack_op=("g",1))
    compressor([],moves,[(u,v)],[(h,k)],{"u":h,"v":k,"w":a},
             {"h":b,"k":b},pack_op=None)
    # Generate witnessed strategies, with premises holding at the witness.
    # Derive candidate conclusions with a separate standard unifier.
    rng = Random(2828)
    moves = [("all","h"),("some","u"),("all","k"),("some","v"),("some","w")]
    for _ in range(400):
        def term(leaves, depth):
            if not depth or rng.randrange(3) == 0:
                return rng.choice(leaves)
            return f(term(leaves,depth-1),term(leaves,depth-1))
        ground = [a,b,f(a,a),f(a,b),f(b,a)]
        witness = {x:rng.choice(ground) for x in ("h","k")}
        strategy = {"d":rng.choice(ground),"u":term([a,b,h],3),"v":term([a,b,h,k],3)}
        strategy["w"] = inp.once(strategy["v"],witness)
        pool = [a,b,h,k,u,v,w,V("d"),f(h,k),f(u,v),f(v,w),*ground]
        possibilities = [(l,r) for i,l in enumerate(pool) for r in pool[i+1:]
                         if inp.once(inp.once(l,strategy),witness) == inp.once(inp.once(r,strategy),witness)]
        premise = rng.sample(possibilities, min(4,len(possibilities)))
        mu = inp.unify(inp.map_eqs(premise,strategy))
        implied = [(l,r) for l,r in possibilities
                   if inp.apply(inp.once(l,strategy),mu) == inp.apply(inp.once(r,strategy),mu)]
        conclusion = rng.sample(implied,min(3,len(implied)))
        compressor(["d"],moves,premise,conclusion,strategy,witness)
    print("404 compressed strategies passed independent unification and scope checks.")


if __name__ == "__main__":
    check()
