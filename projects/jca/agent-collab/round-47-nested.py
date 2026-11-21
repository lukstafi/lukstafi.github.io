"""Synthesize simultaneous term witnesses for an inclusion chain of input premises."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location("trees", Path(__file__).with_name("round-10-experiments.py"))
t = module_from_spec(spec)
spec.loader.exec_module(t)
a, b = t.F("a"), t.F("b")
f = lambda x,y: t.F("f",x,y)


def at_row(eqs, subst):
    return [(t.once(l, subst),t.once(r, subst)) for l,r in eqs]


def equal_after(pair, mu):
    return t.apply(pair[0],mu)==t.apply(pair[1],mu)


def solve(inputs, outputs, chain):
    """Weakest first. Raise ValueError if the promised chain has a crossing."""
    templates = {y:t.V(y) for y in outputs}
    free = set(outputs)
    prior = []
    for premise,conclusion in chain:
        mu = t.unify(premise)
        if mu is None:
            return None
        if not all(equal_after(eq,mu) for eq in prior):
            raise ValueError("Premises are not nested")
        prior = premise
        rigid = {h:t.F(("input",h)) for h in inputs}
        observed = {h:t.once(t.apply(t.V(h),mu),rigid) for h in inputs}
        conditions = at_row(at_row(conclusion,templates),observed)
        theta = t.unify(conditions)
        if theta is None:
            return None
        def lift(term):
            if isinstance(term[0],tuple):
                return t.V(term[0][1])
            if t.is_var(term):
                return term
            return t.F(term[0],*(lift(c) for c in term[1:]))
        bindings = {y:lift(t.apply(t.V(y),theta)) for y in free if y in theta}
        templates = {y:t.once(v,bindings) for y,v in templates.items()}
        free.difference_update(bindings)
    return {y:t.once(v,dict.fromkeys(free,a)) for y,v in templates.items()}


def valid(answer, chain):
    return t.answer([],[(at_row(d,answer),at_row(c,answer)) for d,c in chain])


def check():
    h,k,y,z = map(t.V,"hkyz")
    chain = [([],[(y,f(h,z))]), ([(h,f(k,k))],[(z,k)])]
    result = solve("hk","yz",chain)
    assert valid(result,chain) and result=={"y":f(h,k), "z":k}
    assert solve("hk","yz",chain+[([(h,f(a,a)),(k,a)],[(z,b)])]) is None
    # Exhaustive comparison to literal term enumeration over two constants.
    atoms = [(y,h),(y,k),(y,z),(y,a),(z,h),(z,k),(z,b),(h,k),(a,b)]
    ds = [[],[(h,k)],[(h,k),(h,a)]]
    candidates = [dict(zip("yz",vals)) for vals in product([h,k,a,b],repeat=2)]
    count = 0
    for choices in product([None,*atoms], repeat=3):
        rows = list(zip(ds, [[c] if c else [] for c in choices]))
        expected = any(valid(ans,rows) for ans in candidates)
        out = solve("hk","yz",rows)
        assert (out is not None)==expected and (out is None or valid(out,rows))
        count += 1
    try:
        solve("hk","yz",[([(h,a)],[]), ([(k,b)],[])])
    except ValueError:
        pass
    else:
        raise AssertionError("A crossing pair passed the chain test")
    print(f"Verified {count} nested systems against all strategies, constructive binary lifting, and a crossing pair.")


if __name__=="__main__":
    check()
