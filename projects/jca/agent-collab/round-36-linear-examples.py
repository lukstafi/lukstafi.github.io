"""Preserve finite linear example inspections through one-branch compression."""
from collections import Counter
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path


def load(name,file):
    spec = spec_from_file_location(name,Path(__file__).with_name(file))
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


example = load("examples","round-35-required-example.py")
dags = load("dags","round-29-small-dags.py")
inp,a,V = example.inp,example.a,example.V
f = example.prior.f
is_var = inp.trees.is_var


def covers(pattern, row):
    # The caller assigns distinct names to sample blanks and pattern parameters.
    return inp.unify([(pattern[x],value) for x,value in row.items()]) is not None


def compress(pattern,rows,universal,premise,conclusion,witness):
    kept = set(universal)
    paths = {x:set() for x in pattern}
    for x in universal:
        assert pattern[x] == V(x)
        paths[x].add(())

    def inspect(owner,body,sample,path):
        if is_var(sample):
            return
        paths[owner].add(path)
        if is_var(body):
            kept.add(body[1])
            return
        assert body[0] == sample[0]
        for i in range(1,len(body)):
            inspect(owner,body[i],sample[i],(*path,i))

    for row in rows:
        counts = Counter(t[1] for term in row.values() for t in inp.subterms(term) if is_var(t))
        if any(count > 1 for count in counts.values()):
            raise ValueError("A blank occurs more than once in the example")
        assert set(counts).isdisjoint(witness) and covers(pattern,row)
        for x,value in row.items():
            inspect(x,pattern[x],value,())
    fixed = {x:v for x,v in witness.items() if x not in kept}
    gaps = {}
    def fragment(owner,body,path):
        if path not in paths[owner]:
            key = ("unseen",owner,path)
            gaps[key] = inp.once(body,fixed)
            return V(key)
        if is_var(body):
            return body
        return inp.F(body[0],*(fragment(owner,body[i],(*path,i)) for i in range(1,len(body))))
    frames = {x:fragment(x,b,()) for x,b in pattern.items()}
    moves = [("all",h) for h in kept]+[("some",p) for p in gaps]
    small = dags.small([],moves,inp.map_eqs(premise,frames),inp.map_eqs(conclusion,frames),
                       gaps,{h:witness[h] for h in kept})
    assert all(inp.vars_in(v)<=inp.vars_in(gaps[x]) for x,v in small.items())
    rebuilt = {x:inp.once(frame,small) for x,frame in frames.items()}
    assert all(covers(rebuilt,row) for row in rows)
    assert example.prior.binary.verify([],[(inp.map_eqs(premise,rebuilt),inp.map_eqs(conclusion,rebuilt))])
    return rebuilt


def check():
    h,b,t = map(V,["h","bridge","discard"])
    tail = t
    for _ in range(12):
        tail = f(a,tail)
    pattern = {"h":h,"y":f(h,f(b,tail)),"q":f(a,f(b,tail)),"z":b}
    rows = [{"y":f(V("slot1"),f(f(a,a),V("slot2"))),"z":f(a,a)},{"z":a}]
    w = {"h":a,"bridge":f(a,a),"discard":a}
    source = ({"h"},[(V("h"),a)],[(V("y"),V("q"))],w)
    p = compress(pattern,rows,*source)
    assert "bridge" in inp.vars_in(p["z"]) and all("discard" not in inp.vars_in(u) for u in p.values())
    try:
        compress(pattern,[{"y":f(V("repeat"),V("repeat"))}],*source)
    except ValueError:
        pass
    else:
        raise AssertionError("A repeated blank was accepted as linear")

    for weights,m,cap,expected in [([1],1,1,True),([1,1],2,1,True),([2],2,1,False)]:
        inputs,outputs,d,c = example.bins.instance(weights,m,cap)
        ins,outs = sum(inputs,[]),sum(outputs,[])
        prefix = [("some",x[1]) for x in ins+outs]
        bits = [([(x,f(a,a) if i & (1<<j) else a) for i,x in enumerate(ins,1)],[])
                for j in range(len(ins).bit_length())]
        assert example.full_example(prefix,dict.fromkeys((x[1] for x in ins+outs),a),
                                    [(d,c),*bits]) == expected
    print("Compressed the linear samples, preserved the shared nuisance parameter, and checked three bit encodings.")


if __name__ == '__main__':
    check()
