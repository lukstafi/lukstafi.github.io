"""One leading-fresh branch implementing two evaluations of an unknown term."""
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

def sibling(name, file):
    spec = spec_from_file_location(name,Path(__file__).with_name(file))
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

source = sibling("binary_source","round-17-three-branches.py")
binary = sibling("dag_check","round-25-binary.py")
inp = sibling("input_terms","round-20-one-branch.py")
V,F,f,a = inp.V,inp.F,source.f,source.A
tag = ("tag input",)
result = ("right output",)
carrier = ("carrier",)
observation = ("observation",)


def pack(values):
    """Every constructor on the route to a payload depends on the varying tag."""
    r = V(tag)
    tail = a
    for value in reversed(values):
        tail = f(f(r,value),tail)
    return f(r,tail)


def compile_calls(slots,data,left,right,targets):
    """Right input entries are ground. targets[1] is a ground-data coordinate."""
    prefix = ([("all",x) for x in slots]+[("some",x) for x in [*data,observation]]
              +[("all",tag),("some",carrier)])
    permissions = {x:set() for x in [*slots,*data]}
    permissions[observation] = {carrier}
    premise = list(zip(map(V,slots),left))
    conclusion = [(V(carrier),pack([*map(V,slots),targets[0]])),
                  (V(observation),pack([*right,targets[1]]))]
    return prefix,permissions,premise,conclusion


def verify(instance,answer,witnesses,*,weak=True):
    prefix,permissions,premise,conclusion = instance
    designated = set(permissions)
    names = {x for _,x in prefix}
    universals = {x for q,x in prefix if q=="all"}
    blocks = {}
    last = None
    block = -1
    for q,x in prefix:
        if q != last:
            block += 1
            last = q
        blocks[x] = block
    if not set(answer) <= names or set(witnesses) != designated:
        return False
    if any(not inp.vars_in(b) <= permissions[k] for k,b in witnesses.items()):
        return False
    for x,body in answer.items():
        used = inp.vars_in(body)
        if not used <= names or used & set(answer):
            return False
        univ = ({x}|used)&universals
        local = ({x}|used)&designated
        if x in designated and any(blocks[u] <= blocks[x] for u in univ):
            return False
        if weak and local and any(all(blocks[u] <= blocks[k] for k in local) for u in univ):
            # Individual prefix validity for an oriented primitive.
            individual = ((x not in universals and all(blocks[u]<blocks[x] for u in used&universals))
                          or (inp.trees.is_var(body) and body[1] not in universals
                              and blocks[body[1]]>blocks[x]))
            if not individual:
                return False
    atoms = [(V(x),body) for x,body in answer.items()]
    if not binary.verify(atoms,[(premise,conclusion)]):
        return False
    # After the supplied simultaneous substitution, check the prefix game
    # of the resulting equation tuple using an independent unifier.
    mu = inp.unify(inp.map_eqs(atoms,witnesses))
    if mu is None:
        return False
    preceding = set()
    for q,x in prefix:
        val = inp.apply(V(x),mu)
        if q=="all" and (not inp.trees.is_var(val) or val[1] in preceding):
            return False
        preceding.update(inp.vars_in(val))
    return True


def recover_permutation(left,desired,actual):
    """Each decoded probe selects a bare coordinate. Compare the two columns."""
    remaining = set(range(len(actual)))
    ordering = []
    for l,r in zip(left,desired):
        found = [i for i in remaining if (left[i],actual[i]) == (l,r)]
        if len(found) != 1:
            return None
        ordering.append(found[0])
        remaining.remove(found[0])
    return ordering


def check():
    zero,one = ("zero",),("one",)
    rules = [(('next',zero),('next',one)),(('next',one),one)]
    enc = source.OneConstantEncoding(rules,{'zero':0,'one':0,'next':1,'pair':2})
    slots = enc.slots
    s,t = ('pair',rules[0][0],V('x')),('pair',one,V('x'))
    (left,start),(right,end) = enc.samples(s,t,V(result))
    instance = compile_calls(slots,['x',result],left,right,(start,end))
    path = [(i,('pair',V('redex'),zero)) for i in (1,2)]
    body = enc.path_body(path)
    data = {'x':enc.encode(zero),result:inp.once(body,dict(zip(slots,right)))}
    answer = {**data,carrier:pack([*map(V,slots),body]),
              observation:pack([*right,data[result]])}
    witnesses = {**dict(zip(slots,right)),**data,observation:V(carrier)}
    assert verify(instance,answer,witnesses)
    prefix,masks,premise,conclusion = instance
    names = {x for _,x in prefix}
    existential = {x for q,x in prefix if q == "some"}
    common = {x:names-{tag} for x in masks}
    single_deletion = {x:names for x in masks}
    single_deletion[observation] = names-{tag}
    for policy in [common,{x:existential for x in masks},single_deletion]:
        assert verify((prefix,policy,premise,conclusion),answer,witnesses)
    # Incoming atomic ports may be permuted without changing the first row.
    i,j = (slots.index(('out',n)) for n in (1,2))
    swap = {slots[i]:V(slots[j]),slots[j]:V(slots[i])}
    renamed = {x:inp.once(b,swap) for x,b in answer.items()}
    changed = dict(witnesses)
    changed[slots[i]],changed[slots[j]] = changed[slots[j]],changed[slots[i]]
    assert verify(instance,renamed,changed)
    assert not verify(instance,renamed,witnesses)
    left_values = [inp.once(u,data) for u in left]
    actual = [changed[x] for x in slots]
    order = recover_permutation(left_values,right,actual)
    assert order[i] == j and order[j] == i
    assert recover_permutation(left_values,right,[a]*len(slots)) is None
    # A ground observation can satisfy the ordinary check but cannot
    # reproduce the independent tag through its sole permitted carrier.
    bad = {**witnesses,observation:a}
    assert not verify(instance,answer,bad)
    # Exercise the empty conversion, where the source body is precisely its tail.
    (empty_left,empty_start),_ = enc.samples(t,t,V(result))
    empty = compile_calls(slots,['x',result],empty_left,right,(empty_start,end))
    trivial = {**answer,result:a,carrier:pack([*map(V,slots),V(('tail',))]),
               observation:pack([*right,a])}
    assert verify(empty,trivial,{**witnesses,result:a})
    # Reverse the irreversible path. Letting the tag alias an atomic-left
    # port defeats the reduction precisely when the weak test is removed.
    (back_left,back_start),_ = enc.samples(t,s,V(result))
    negative = compile_calls(slots,['x',result],back_left,right,(back_start,end))
    counter = (prefix,single_deletion,negative[2],negative[3])
    port = slots[i]
    assert back_left[i] == a
    ground = {'x':a,result:a}
    bogus = {**ground,tag:V(port),
             carrier:inp.once(pack([*map(V,slots),inp.once(back_start,ground)]),{tag:V(port)}),
             observation:inp.once(pack([*right,a]),{tag:a})}
    free_reads = {**dict.fromkeys(slots,a),**ground,port:V(tag),
                  observation:bogus[observation]}
    assert verify(counter,bogus,free_reads,weak=False)
    assert not verify(counter,bogus,free_reads)
    assert not verify((prefix,common,*negative[2:]),bogus,free_reads,weak=False)
    print("Directed paths, port permutation, all four read policies, and the reversed-path scope check passed.")


if __name__ == '__main__':
    check()
