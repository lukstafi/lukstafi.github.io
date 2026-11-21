"""Maximize a seed relation and check weak presentations of a specified public tuple."""
from functools import cache
from itertools import combinations, product
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path


def load(name,file):
    spec = spec_from_file_location(name,Path(__file__).with_name(file))
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


ex = load("examples","round-35-required-example.py")
weak = load("weak","round-38-weak-solved.py")
games = load("games","round-32-carriers.py")
inp,V,a = ex.inp,ex.V,ex.a
f = ex.prior.f


def contains(general,specific,names):
    join = lambda p:inp.F("tuple",*(p[x] for x in names))
    return inp.trees.matches(join(general),join(specific)) is not None


def projection(atoms,names):
    mu = inp.unify(atoms)
    return {x:inp.apply(V(x),mu) for x in names}


def subsets(xs):
    xs = tuple(xs)
    for size in range(len(xs)+1):
        yield from combinations(xs,size)


def fixed_joint(joint,prefix,masks,designated,*,binary=True):
    """Find a weak presentation of a whole public/fresh tuple, or certify failure."""
    names = list(joint)
    @cache
    def builders(target):
        ways = [V(y) for y in names if joint[y]==target]
        if not inp.trees.is_var(target):
            ways.extend(inp.F(target[0],*args)
                        for args in product(*(builders(c) for c in target[1:])))
        return ways
    selected = []
    for x in names:
        for t in builders(joint[x]):
            if x in inp.vars_in(t):
                continue
            raw = V(x),t
            mu = inp.unify(selected)
            if inp.apply(raw[0],mu)==inp.apply(t,mu):
                continue
            # Scope is tested on the public prefix only. Fresh names are
            # leading universals for the individual-validity exemption.
            public = [(q,v) for q,v in prefix if not isinstance(v,Fresh)]
            def passes(atom):
                lhs,rhs = atom
                mentioned = inp.vars_in(lhs)|inp.vars_in(rhs)
                blocks = {}
                for i,(q,v) in enumerate(public):
                    blocks[v] = 0 if i==0 else blocks[public[i-1][1]]+(q!=public[i-1][0])
                local = mentioned & designated
                offending = any(q=="all" and v in mentioned and
                                all(blocks[v]<=blocks[k] for k in local) for q,v in public)
                return not local or not offending or weak.game([atom],prefix)
            for pads in subsets(designated) if binary else [()]:
                lhs,rhs = raw
                for v in pads:
                    lhs,rhs = f(lhs,V(v)),f(rhs,V(v))
                if passes((lhs,rhs)):
                    selected.append((lhs,rhs))
                    break
    normalized = projection(selected,names)
    if not contains(joint,normalized,names) or not contains(normalized,joint,names):
        return None
    if not games.valid(selected,prefix,masks):
        return None
    return selected


class Fresh(int):
    """Names for candidate leading parameters, disjoint from string public names."""


def realizes(pattern,prefix,masks,designated,*,fresh_allowed=False):
    residuals = sorted(set().union(*(inp.vars_in(t) for t in pattern.values())),key=repr)
    for named in subsets(residuals):
        fresh = [Fresh(i) for i in range(len(named))]
        joint = {**pattern,**{b:V(u) for b,u in zip(fresh,named)}}
        reads = {x:set(allowed)|(set(fresh) if fresh_allowed else set()) for x,allowed in masks.items()}
        atoms = fixed_joint(joint,[*(('all',b) for b in fresh),*prefix],reads,designated)
        if atoms is not None:
            return atoms
    return None


def maxima(seed,prefix,branches,admissible):
    names = [x for _,x in prefix]
    ground = {x:inp.once(t,{u:a for u in inp.vars_in(t)}) for x,t in seed.items()}
    result = []
    def walk(i,values,pattern):
        if i<len(prefix):
            x = names[i]
            for term,more in ex.prunings(ground[x],values):
                walk(i+1,more,{**pattern,x:term})
            return
        if not contains(pattern,seed,names):
            return
        if not ex.prior.binary.verify([],[(inp.map_eqs(d,pattern),inp.map_eqs(c,pattern)) for d,c in branches]):
            return
        if any(contains(old,pattern,names) for old in result) or not admissible(pattern):
            return
        result[:] = [old for old in result if not contains(pattern,old,names)]
        result.append(pattern)
    walk(0,(),{})
    return result


def check():
    x,y,z = map(V,"xyz")
    b = inp.F("b")
    names = list("xyz")
    prefix = [('some',n) for n in names]
    branches = [([(y,f(c,x))],[(z,c)]) for c in [a,b]]
    seed = {'x':V('s'),'y':f(V('s'),V('s')),'z':V('s')}
    result = maxima(seed,prefix,branches,lambda p:True)
    expected = [
        {'x':x,'y':f(z,V('fresh')),'z':z},
        {'x':x,'y':f(x,z),'z':z},
        {'x':z,'y':f(y,y),'z':z},
    ]
    def equivalent(p,q):
        return contains(p,q,names) and contains(q,p,names)
    assert len(result)==len(expected) and all(any(equivalent(p,q) for q in result) for p in expected),result
    for p in result:
        assert realizes(p,prefix,{},set()) is not None
    # This relation needs a visible fresh name, since its only public
    # coordinate has a constructor at its root.
    p = {'x':f(V('u'),V('u'))}
    assert fixed_joint(p,[('some','x')],{},set()) is None
    assert realizes(p,[('some','x')],{},set()) is not None
    # The same bare-copy relation can be admissible in exactly one read policy.
    copy = {'h':V('u'),'k':V('u')}
    moves = [('all','h'),('some','k')]
    assert realizes(copy,moves,{'k':{'h'}},set()) is not None
    assert realizes(copy,moves,{'k':set()},set()) is None
    print("Verified three maximal extensions of the example seed, a necessary fresh name, and both read policies.")


if __name__=='__main__':
    check()
