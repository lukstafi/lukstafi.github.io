"""Weak-only solved reduction and the unrestricted-conjunction counterexample."""
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location("carrier",Path(__file__).with_name("round-33-carrier-reduction.py"))
prior = module_from_spec(spec)
spec.loader.exec_module(prior)
inp,V,f,a = prior.inp,prior.V,prior.f,prior.a


def pack(r,values):
    seq = a
    for t in reversed(values):
        seq = f(f(r,t),seq)
    return f(r,f(a,seq))


def game(atoms,prefix):
    mu = inp.unify(atoms)
    if mu is None:
        return False
    seen = set()
    for q,x in prefix:
        t = inp.apply(V(x),mu)
        if q=="all" and (not inp.trees.is_var(t) or t[1] in seen):
            return False
        seen.update(inp.vars_in(t))
    return True


def admissible(atoms,prefix,designated_names,*,reflexive=False):
    block = {}
    for i,(q,x) in enumerate(prefix):
        block[x] = (block[prefix[i-1][1]] + (q!=prefix[i-1][0])) if i else 0
    universals = {x for q,x in prefix if q=="all"}
    for l,t in atoms:
        names = inp.vars_in(l)|inp.vars_in(t)
        designated = names & set(designated_names)
        def allowed(u,k):
            return block[u]<=block[k] if reflexive else block[u]>block[k]
        if designated and any(not any(allowed(u,k) for k in designated) for u in names & universals):
            if not game([(l,t)],prefix):
                return False
    return True


def check_answer(atoms,instance,witnesses,*,solved,designated=None,reflexive=False):
    prefix,masks,d,c = instance
    if set(witnesses)!=set(masks) or any(not inp.vars_in(t)<=masks[k] for k,t in witnesses.items()):
        return False
    if solved:
        heads = {l[1] for l,_ in atoms if inp.trees.is_var(l)}
        if len(heads)!=len(atoms) or any(inp.vars_in(t)&heads for _,t in atoms):
            return False
    if designated is None:
        designated = masks
    return (admissible(atoms,prefix,designated,reflexive=reflexive) and prior.binary.verify(atoms,[(d,c)])
            and game(inp.map_eqs(atoms,witnesses),prefix))


def check():
    zero,one = ("zero",),("one",)
    rules = [(('next',zero),one)]
    enc = prior.source.OneConstantEncoding(rules,{'zero':0,'one':0,'next':1,'pair':2})
    slots = enc.slots
    s,t = ('pair',rules[0][0],V('x')),('pair',one,V('x'))
    r,k,e,z = map(V,["r","K","E","z"])
    moves = ([("some","x"),("some","z")]+[("all",x) for x in slots]
             +[("some","K"),("all","r"),("some","E")])
    names = {x for _,x in moves}
    masks = {x:names for x in slots}
    masks["K"] = names-{"r"}
    def compile_calls(start,stop):
        (left,l),(right,_) = enc.samples(start,stop,z)
        return (moves,masks,list(zip(map(V,slots),left)),
                [(e,pack(r,[*map(V,slots),l])),(k,pack(r,[*right,z]))]),l,right
    instance,_,right = compile_calls(s,t)
    body = enc.path_body([(1,('pair',V('redex'),zero))])
    z0 = inp.once(body,dict(zip(slots,right)))
    answer = [(V('x'),enc.encode(zero)),(z,z0),(k,pack(r,[*right,z0])),
              (e,pack(r,[*map(V,slots),body]))]
    witnesses = {**dict(zip(slots,right)),"K":e}
    assert check_answer(answer,instance,witnesses,solved=True)
    for (port,_) in instance[2]:
        for late in [k,e]:
            assert not prior.binary.verify([(port,late)],[(instance[2]+instance[3],[])])
        assert not admissible([(port,r)],moves,masks)
    for start,stop in [(s,t),(t,s),(t,t)]:
        instance,out,right = compile_calls(start,stop)
        scope = {"x":a,"z":a}
        p = next(x[1] for x,l in instance[2] if l==a)
        y = pack(a,[*map(V,slots),inp.once(out,scope)])
        k0 = pack(a,[*right,a])
        atoms = [(V(x),v) for x,v in scope.items()]+[(k,k0),(e,y),(e,inp.once(y,{p:r}))]
        sub = {**dict.fromkeys(slots,a),p:r,"K":k0}
        assert check_answer(atoms,instance,sub,solved=False)
        assert not check_answer(atoms,instance,sub,solved=True)
        assert prior.binary.verify(atoms,[([],[(V(p),r)])])
    print("Weak solved certificate, six excluded port aliases, and three unrestricted bridge answers passed.")


if __name__=='__main__':
    check()
