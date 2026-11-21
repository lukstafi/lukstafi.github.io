"""A fixed partial example for two-call synthesis and an exact full-example search."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path


def load(name,file):
    spec = spec_from_file_location(name,Path(__file__).with_name(file))
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


prior = load("carrier","round-33-carrier-reduction.py")
bins = load("partition","round-30-monadic.py")
inp,a,V = prior.inp,prior.a,prior.V


def prunings(t, values):
    """Generate all term patterns covering t, with canonical parameter names."""
    for i,v in enumerate(values):
        if v == t:
            yield V(i),values
    yield V(len(values)),(*values,t)
    if len(t) == 1:
        yield t,values
        return

    def descend(children, past, params):
        if not children:
            yield (t[0],*past),params
            return
        for child,more in prunings(children[0],params):
            yield from descend(children[1:],(*past,child),more)
    yield from descend(t[1:],(),values)


def full_example(prefix, ground, branches):
    """Decide the complete-tree example case by searching its prunings."""
    def search(i,values,shapes,seen):
        if i == len(prefix):
            rows = [(inp.map_eqs(d,shapes),inp.map_eqs(c,shapes)) for d,c in branches]
            return prior.binary.verify([],rows)
        q,x = prefix[i]
        for body,more in prunings(ground[x],values):
            if q == "all" and (not inp.trees.is_var(body) or body[1] in seen):
                continue
            if search(i+1,more,{**shapes,x:body},seen | inp.vars_in(body)):
                return True
        return False
    return search(0,(),{},set())


def check():
    zero,one = ("zero",),("one",)
    rules = [(('next',zero),one)]
    enc = prior.source.OneConstantEncoding(rules,{'zero':0,'one':0,'next':1})
    slots = enc.slots
    s,t = rules[0]
    z,y = V('result'),V('proof')
    (left,start),(right,_) = enc.samples(s,t,z)
    body = enc.path_body([(1,V('redex'))])
    z0 = inp.once(body,dict(zip(slots,right)))
    branch = (list(zip(map(V,slots),left)),[(y,start)])
    sample = [*zip(map(V,slots),right),(y,z)]
    answer = [(z,z0),(y,body)]
    assert prior.binary.verify(answer,[branch,(sample,[])])
    # The literal first result passes the ordinary branch and fails the second sample.
    literal = [(z,z0),(y,inp.once(start,{'result':z0}))]
    assert prior.binary.verify(literal,[branch])
    assert not prior.binary.verify(literal,[(sample,[])])
    for weights,m,b in [([1],1,1),([2],1,2),([1,1],2,1),([2],2,1)]:
        inputs,outputs,d,c = bins.instance(weights,m,b)
        prefix = [(q,v[1]) for q,groups in [('all',inputs),('some',outputs)]
                  for group in groups for v in group]
        ok = any(all(sum(w for w,j in zip(weights,p) if j==k)==b for k in range(m))
                 for p in product(range(m),repeat=len(weights)))
        assert full_example(prefix,dict.fromkeys((x for _,x in prefix),a),[(d,c)])==ok
    h,e = V("h"),V("e")
    node = prior.f(a,a)
    q = [("all","h"),("some","e")]
    assert full_example(q,{"h":node,"e":prior.f(node,a)},[([] ,[(e,prior.f(h,a))])])
    assert not full_example(q,{"h":node,"e":node},[([] ,[(e,prior.f(h,a))])])
    print("Verified the two-call sample, its rejected corruption, and six full-example decisions.")


if __name__ == '__main__':
    check()
