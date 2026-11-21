"""Reduce unary-size bin partition to a single equality-only quantified branch."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location("terms", Path(__file__).with_name("round-10-experiments.py"))
t = module_from_spec(spec)
spec.loader.exec_module(t)


def instance(weights, bins, capacity):
    inputs = [[t.V(("input",j,s)) for s in range(capacity+1)] for j in range(bins)]
    outputs = [[t.V(("output",i,k)) for k in range(w+1)] for i,w in enumerate(weights)]
    def stars(groups):
        return [(group[0],v) for group in groups for v in group[1:]]
    return inputs, outputs, stars(outputs), stars(inputs)


def certificate(weights, bins, capacity, assignment, unary=False):
    inputs, outputs, premise, conclusion = instance(weights,bins,capacity)
    used = [0]*bins
    equations = []
    for w,ys,j in zip(weights,outputs,assignment):
        choices = [inputs[j][0], *inputs[j][used[j]+1:used[j]+1+w]]
        assert len(choices) == len(ys)
        if unary:
            choices = [t.F("g",u) for u in choices]
        equations.extend(zip(ys,choices))
        used[j] += w
    assert used == [capacity]*bins
    assert t.answer(equations,[(premise,conclusion)])


def exhaust(weights, bins, capacity, unary=False):
    inputs, outputs, premise, conclusion = instance(weights,bins,capacity)
    domain = [t.F("a"), t.F("b"), *sum(inputs,[])]
    if unary:
        domain += [t.F("g",u) for u in domain]
    coordinates = sum(outputs,[])
    for bodies in product(domain,repeat=len(coordinates)):
        subst = {v[1]:u for v,u in zip(coordinates,bodies)}
        mu = t.unify([(t.once(l,subst),t.once(r,subst)) for l,r in premise])
        if mu is not None and all(t.apply(l,mu) == t.apply(r,mu) for l,r in conclusion):
            return True
    return False


if __name__ == "__main__":
    for wrapped in (False,True):
        certificate([4,4,5,5,6,6],2,15,[0,1,0,1,0,1],wrapped)
    for weights, bins, capacity in [([1],1,1),([2],1,2),([1,1],2,1),([2],2,1)]:
        possible = any(all(sum(w for w,b in zip(weights,where) if b == j) == capacity
                           for j in range(bins)) for where in product(range(bins),repeat=len(weights)))
        assert exhaust(weights,bins,capacity) == possible
    assert not exhaust([2],2,1,True)
    print("Verified both full-size certificates and five exhaustive small-instance comparisons.")
