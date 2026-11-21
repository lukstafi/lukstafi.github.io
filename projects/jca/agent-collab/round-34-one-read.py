"""The strong-only single-forbidden-read reduction, on actual binary JCA rows."""
from functools import cache
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location("carrier", Path(__file__).with_name("round-33-carrier-reduction.py"))
prior = module_from_spec(spec)
spec.loader.exec_module(prior)
a, f, V, inp = prior.a, prior.f, prior.V, prior.inp
tag = V(prior.tag)
codes = (f(a,f(a,a)),f(f(a,a),a))


def label(i, r):
    return f(codes[i],r)


def atom(r):
    return f(label(0,r),a)


def fork(r,x,y):
    return f(label(1,r),f(f(a,x),y))


@cache
def encode(t, r):
    if inp.trees.is_var(t):
        return t
    if t == a:
        return atom(r)
    assert t[0] == "f" and len(t) == 3
    return fork(r,encode(t[1],r),encode(t[2],r))


@cache
def decode(t):
    if inp.trees.is_var(t):
        return t
    if len(t) == 3 and t[1] == label(1,a):
        cell = t[2]
        if len(cell) == 3 and len(cell[1]) == 3 and cell[1][1] == a:
            return f(decode(cell[1][2]),decode(cell[2]))
    return a


def replacements(t, hole):
    yield hole
    if len(t) == 3:
        for l in replacements(t[1],hole):
            yield f(l,t[2])
        for r in replacements(t[2],hole):
            yield f(t[1],r)


def decoder_checks():
    x,y = V("x"),V("y")
    arguments = [atom(a),fork(a,a,f(a,a)),f(label(0,a),f(a,a)),f(label(1,a),a)]
    bodies = [x,y,atom(a),fork(a,x,y),f(fork(a,x,y),y)]
    for t in [atom(a),fork(a,a,f(a,a)),fork(a,fork(a,a,a),a)]:
        bodies.extend(replacements(t,x))
    count = 0
    for l in arguments:
        for r in arguments:
            for b in bodies:
                assert decode(inp.once(b,{"x":l,"y":r})) == inp.once(
                    decode(b),{"x":decode(l),"y":decode(r)})
                count += 1
    return count


def check():
    zero,one = ("zero",),("one",)
    rules = [(('next',zero),one)]
    source = prior.source.OneConstantEncoding(rules,{'zero':0,'one':0,'next':1,'pair':2})
    s,t = ('pair',rules[0][0],V('x')),('pair',one,V('x'))
    (left,start),(right,end) = source.samples(s,t,V(prior.result))
    slots = source.slots
    right_ports = [encode(v,tag) for v in right]
    prefix,_,premise,conclusion = prior.compile_calls(
        slots,['x',prior.result],[encode(v,tag) for v in left],right_ports,
        (encode(start,tag),end))
    names = {x for _,x in prefix}
    masks = {x:names for x in [*slots,'x',prior.result,prior.observation]}
    masks[prior.observation] = names-{prior.tag}
    instance = prefix,masks,premise,conclusion
    path = [(1,('pair',V('redex'),zero))]
    body = source.path_body(path)
    ground_z = inp.once(body,dict(zip(slots,right)))
    data = {'x':encode(source.encode(zero),tag),prior.result:encode(ground_z,tag)}
    answer = {**data,prior.carrier:prior.pack([*map(V,slots),encode(body,tag)]),
              prior.observation:prior.pack([*right_ports,data[prior.result]])}
    witnesses = {**dict(zip(slots,right_ports)),**data,prior.observation:V(prior.carrier)}
    for weak in [False,True]:
        assert prior.verify(instance,answer,witnesses,weak=weak)
    assert not prior.verify(instance,answer,{**witnesses,prior.observation:answer[prior.observation]})
    for x in slots:
        assert not prior.binary.verify([(tag,V(x))],[(premise,[])])
    # Restoring the read makes even the reversed irreversible source pass.
    (backward,back_target),_ = source.samples(t,s,V(prior.result))
    _,_,back_d,back_c = prior.compile_calls(slots,['x',prior.result],
        [encode(v,tag) for v in backward],right_ports,(encode(back_target,tag),end))
    simple_data = {'x':a,prior.result:a}
    simple = {**simple_data,prior.carrier:prior.pack(
        [*map(V,slots),inp.once(encode(back_target,tag),simple_data)]),
        prior.observation:prior.pack([*right_ports,a])}
    reads = {**dict.fromkeys(slots,a),**simple_data,prior.observation:simple[prior.observation]}
    assert prior.verify((prefix,{x:names for x in masks},back_d,back_c),simple,reads)
    assert not prior.verify((prefix,masks,back_d,back_c),simple,reads,weak=False)
    bad_data = f(a,a)
    assert decode(encode(body,a)) == body
    assert decode(inp.once(encode(start,a),{'x':bad_data,prior.result:bad_data})) == inp.once(
        start,{'x':decode(bad_data),prior.result:decode(bad_data)})
    print(f"Both scope variants, {len(slots)} impossible aliases, and {decoder_checks():,} decoder checks passed.")


if __name__ == '__main__':
    check()
