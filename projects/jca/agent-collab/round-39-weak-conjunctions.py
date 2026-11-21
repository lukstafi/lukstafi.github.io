"""One-branch reduction for arbitrary weak conjunctions, with a data guard."""
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location("weak",Path(__file__).with_name("round-38-weak-solved.py"))
weak = module_from_spec(spec)
spec.loader.exec_module(weak)
prior,inp,V,f,a,pack = weak.prior,weak.inp,weak.V,weak.f,weak.a,weak.pack


def guard(data,ports,left,right,source,z):
    tail = a
    for val in reversed([*data,*ports,pack(a,[*left,source]),pack(a,[*right,z])]):
        tail = f(val,tail)
    return tail


def compile_calls(enc,s,t):
    slots = enc.slots
    z,r,e,k = map(V,["z","r","E","K"])
    (left,source),(right,_) = enc.samples(s,t,z)
    early = [("all",x) for x in ["x","z",*slots]]+[("some","G"),("some","K")]
    prefix = early+[("all","r"),("some","E")]
    masks = {x:{v for _,v in prefix} for x in slots}
    masks["K"] = {v for _,v in prefix if v!="r"}
    j = guard([V("x"),z],left,left,right,source,z)
    d = [(V("G"),j)]
    c = [*zip(map(V,slots),left),(e,pack(r,[*map(V,slots),source])),(k,pack(r,[*right,z]))]
    return (prefix,masks,d,c),left,right,source,j


def check():
    zero,one = ("zero",),("one",)
    rules = [(('next',zero),('next',one)),(('next',one),one)]
    enc = prior.source.OneConstantEncoding(rules,{'zero':0,'one':0,'next':1,'pair':2})
    s,t = ('pair',rules[0][0],V("x")),('pair',one,V("x"))
    instance,left,right,source,j = compile_calls(enc,s,t)
    slots = enc.slots
    r,k,e,g = map(V,["r","K","E","G"])
    body = enc.path_body([(i,('pair',V('redex'),zero)) for i in (1,2)])
    data = {"x":enc.encode(zero),"z":inp.once(body,dict(zip(slots,right)))}
    guard0 = inp.once(j,data)
    left0 = [inp.once(v,data) for v in left]
    goal0 = inp.once(source,data)
    for value in [*left0,goal0,pack(a,[*left0,goal0]),pack(a,[*right,data['z']])]:
        assert value != guard0 and value in inp.subterms(guard0)
    guard_body = inp.once(guard([V("x"),V("z")],list(map(V,slots)),left,right,source,V("z")),data)
    assert inp.once(guard_body,dict(zip(slots,left0))) == guard0
    answer = [(g,guard_body),(k,pack(r,[*right,data["z"]])),(e,pack(r,[*map(V,slots),body]))]
    subs = {**dict(zip(slots,right)),"K":e}
    assert weak.check_answer(answer,instance,subs,solved=True)
    # Add a distinct, redundant equation. Its primitive mentions a port
    # and needs individual validity. There are now two definitions of E.
    redundant = answer[-1]
    larger = [*answer,(f(redundant[0],g),f(redundant[1],g))]
    assert weak.check_answer(larger,instance,subs,solved=False)
    assert not weak.check_answer(larger,instance,subs,solved=True)
    i,h = [slots.index(('out',m)) for m in (1,2)]
    swap = {slots[i]:V(slots[h]),slots[h]:V(slots[i])}
    permuted = [(l,inp.once(v,swap) if l==e else v) for l,v in answer]
    ns = list(right)
    ns[i],ns[h] = ns[h],ns[i]
    assert weak.check_answer(permuted,instance,{**dict(zip(slots,ns)),"K":e},solved=False)
    order = prior.recover_permutation(left0,right,ns)
    extracted = inp.once(body,swap)
    normalized = inp.once(extracted,{slots[u]:V(slots[j]) for j,u in enumerate(order)})
    assert inp.once(normalized,dict(zip(slots,left0))) == goal0
    assert inp.once(normalized,dict(zip(slots,right))) == data["z"]
    # Reverse the irreversible path; compare each read change independently.
    neg,left_neg,right,src,j = compile_calls(enc,t,s)
    prefix,masks,d,c = neg
    data = {"x":a,"z":a}
    g0 = inp.once(guard([V("x"),V("z")],list(map(V,slots)),left_neg,right,src,V("z")),data)
    s0 = inp.once(src,data)
    right_tree = pack(r,[*right,a])
    ordinary = [(g,g0),(k,right_tree),(e,pack(r,[*map(V,slots),s0]))]
    reads = {**dict.fromkeys(slots,a),"K":right_tree}
    assert not weak.check_answer(ordinary,neg,reads,solved=False)
    direct = {**masks,"K":{v for _,v in prefix}}
    assert weak.check_answer(ordinary,(prefix,direct,d,c),reads,solved=False)
    p = slots[i]
    y,k0 = pack(a,[*map(V,slots),s0]),pack(a,[*right,a])
    # A literal guard leaves the ports free on active rows. The non-solved
    # presentation still makes p=r, but the new port conclusion exposes it.
    bridge = [(g,inp.once(j,data)),(k,k0),(e,y),(e,inp.once(y,{p:r}))]
    reads = {**dict.fromkeys(slots,a),p:r,"K":k0}
    assert weak.admissible(bridge,prefix,masks)
    assert weak.game(inp.map_eqs(bridge,reads),prefix)
    assert not prior.binary.verify(bridge,[(d,c)])
    assert not weak.check_answer(bridge,neg,reads,solved=False)
    print("Verified guarded path, weak conjunction, recovered permutation, the restored read, and the rejected bridge.")


if __name__=='__main__':
    check()
