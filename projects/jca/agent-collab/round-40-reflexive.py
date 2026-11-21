"""A guarded branch for the reflexive comparison, with prior substituted ports."""
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location("guarded",Path(__file__).with_name("round-39-weak-conjunctions.py"))
guarded = module_from_spec(spec)
spec.loader.exec_module(guarded)
prior,weak,inp,V,f,a,pack = guarded.prior,guarded.weak,guarded.inp,guarded.V,guarded.f,guarded.a,guarded.pack


def check():
    zero,one = ("zero",),("one",)
    rule = (('next',zero),one)
    enc = prior.source.OneConstantEncoding([rule],{'zero':0,'one':0,'next':1,'pair':2})
    s,t = ('pair',rule[0],V("x")),('pair',one,V("x"))
    (_,_,d,c),left,right,src,_ = guarded.compile_calls(enc,s,t)
    slots = enc.slots
    g,r,h,k,e = map(V,["G","r","H","K","E"])
    prefix = [("some","G"),("all","r"),("all","K"),("some","H")]
    prefix += [("all",x) for x in ["x","z",*slots]]+[("some","E")]
    names = {v for _,v in prefix}
    masks = {v:names for v in slots}
    masks["K"] = names-{"r"}
    instance = prefix,masks,d,[*c,(h,f(r,r))]
    body = enc.path_body([(1,('pair',V('redex'),zero))])
    data = {"x":enc.encode(zero),"z":inp.once(body,dict(zip(slots,right)))}
    guard_body = guarded.guard([V("x"),V("z")],list(map(V,slots)),left,right,src,V("z"))
    answer = [(g,inp.once(guard_body,data)),(h,f(r,r)),(k,pack(r,[*right,data["z"]])),
              (e,pack(r,[*map(V,slots),body]))]
    subs = {**dict(zip(slots,right)),"K":e}
    kwargs = {"solved":True,"designated":{"K"},"reflexive":True}
    assert weak.check_answer(answer,instance,subs,**kwargs)
    assert not weak.check_answer(answer,instance,{**subs,"K":h},**kwargs)
    assert not weak.admissible([(k,f(r,V(slots[0])))],prefix,{"K"},reflexive=True)
    assert weak.admissible([(k,f(r,V(slots[0])))],prefix,{"K",slots[0]},reflexive=True)
    # Without the ordinary separator equality, the original move H can
    # freely copy r and the observation can build its own value directly.
    (_,_,d,c),left,right,src,_ = guarded.compile_calls(enc,t,s)
    data = {"x":a,"z":a}
    gb = guarded.guard([V("x"),V("z")],list(map(V,slots)),left,right,src,V("z"))
    rhs = pack(r,[*right,a])
    fake = [(g,inp.once(gb,data)),(k,rhs),(e,pack(r,[*map(V,slots),inp.once(src,data)]))]
    read = {**dict.fromkeys(slots,a),"K":inp.once(rhs,{"r":h})}
    assert weak.check_answer(fake,(prefix,masks,d,c),read,**kwargs)
    assert not weak.check_answer(fake,(prefix,masks,d,[*c,(h,f(r,r))]),read,**kwargs)
    print("Verified reflexive certificate, prior-parameter scope, and the need to constrain the separator.")


if __name__=='__main__':
    check()
