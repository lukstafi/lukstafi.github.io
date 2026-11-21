"""One branch whose premise has at most one free input after the data are fixed.
Return an explicit term strategy. Uses expanded tuples for the small examples.
"""
import importlib.util
from itertools import product
from pathlib import Path

spec = importlib.util.spec_from_file_location('input_only', Path(__file__).with_name('round-20-one-branch.py'))
inp = importlib.util.module_from_spec(spec)
spec.loader.exec_module(inp)
V, F, apply, unify = inp.V, inp.F, inp.apply, inp.unify
is_var, vars_in = inp.trees.is_var, inp.vars_in


def positions(t, y, path=()):
    if is_var(t):
        if t[1] == y:
            yield path
    else:
        for i, child in enumerate(t[1:], 1):
            yield from positions(child, y, path + (i,))


def insert(tree, needle, label):
    """Replace one occurrence of needle, retaining all other equal subtrees."""
    if tree == needle:
        return label
    for i, child in enumerate(tree[1:], 1):
        changed = insert(child, needle, label)
        if changed is not None:
            return tree[:i] + (changed,) + tree[i+1:]
    return None


def eliminate_inputs(data, inputs, outputs, premise, conclusion):
    """Normalize one three-block clause. Return None for an inconsistent D.
    Any strategy for the returned clause lifts by ignoring the removed inputs.
    """
    mu = unify(premise)
    if mu is None:
        return None
    bound_inputs = {h:apply(V(h), mu) for h in inputs if h in mu}
    kept = [h for h in inputs if h not in mu]
    reduced = [(V(x),apply(V(x),mu)) for x in [*data,*outputs] if x in mu]
    return kept, reduced, inp.map_eqs(conclusion, bound_inputs)


def solve(data, moves, premise, conclusion, base=('a',), *, singleton=False):
    inputs = [h for q, h in moves if q == 'all']
    outputs = {y: [h for q, h in moves[:i] if q == 'all']
               for i, (quant, y) in enumerate(moves) if quant == 'some'}
    names = [*data, *inputs, *outputs]
    assert len(names) == len(set(names))
    assert all(q in ('all','some') for q, x in moves)
    assert inp.collect(t for eq in premise + conclusion for t in eq) <= set(names)
    if singleton:
        return dict.fromkeys([*data, *outputs], base)
    joint = unify(premise + conclusion)
    if joint is None:
        return None
    mu = unify(premise)
    pat = {x: apply(V(x), mu) for x in names}
    fixed = inp.collect(pat[x] for x in data)
    live = inp.collect(pat[h] for h in inputs) - fixed
    copied = inp.collect(pat[y] for y in outputs)

    def verify(body):
        assert all(vars_in(body[y]) <= set(scope) for y, scope in outputs.items())
        assert all(not vars_in(body[d]) for d in data)
        active = unify(inp.map_eqs(premise, body))
        assert active is not None
        assert all(apply(l, active) == apply(r, active)
                   for l, r in inp.map_eqs(conclusion, body))
        return body

    def constant_row(extra):
        return {x: inp.grounded(apply(V(x), joint), extra, base) for x in names}

    if live <= copied:
        row = constant_row({})
        return verify({x: row[x] for x in [*data, *outputs]})
    if len(live) > 1:
        raise ValueError('more than one free input residual and some are absent from outputs')
    r, = live
    assert r in inputs and pat[r] == V(r)
    varying = {h for h in inputs if r in vars_in(pat[h])}

    # A single asymmetric output occurrence can isolate the active point.
    for y, visible in outputs.items():
        if all(set(positions(l, y)) == set(positions(rhs, y)) for l, rhs in premise):
            continue
        target = apply(V(y), joint)
        for h in visible:
            if h not in varying:
                continue
            source = apply(V(h), joint)
            for node in inp.subterms(target):
                extra = unify([(source, node)])
                if extra is None:
                    continue
                row = constant_row(extra)
                strategy = {x: row[x] for x in [*data, *outputs]}
                strategy[y] = insert(row[y], row[h], V(h))
                assert strategy[y] is not None
                return verify(strategy)

    # Otherwise D must hold throughout its projected input set. Name the
    # residuals fixed by data as new initial data, and use the original input r.
    tags = {}
    for i, v in enumerate(sorted(fixed, key=repr)):
        name = ('fixed', i)
        while name in names:
            name = ('fixed', name)
        tags[v] = V(name)
    domain = [(V(x), inp.once(pat[x], tags)) for x in [*data, *inputs]]
    extended = [*data, *(term[1] for term in tags.values())]
    strategy = inp.solve(extended, moves, domain, premise + conclusion, base)
    if strategy is None:
        return None
    return verify({x: strategy[x] for x in [*data, *outputs]})


def check():
    a, b = F('a'), F('b')
    f = lambda l, r: F('f', l, r)
    x, h, k, y, z, d = map(V, ('x','h','k','y','z','d'))
    H, K, X = [('all', n) for n in ('h','k','x')]
    Y, Z = [('some', n) for n in ('y','z')]
    assert solve([], [H,Y], [(y,a)], [(h,b)]) is None
    assert solve([], [H,Y], [(y,f(b,a))], [(h,b)]) == {'y':f(h,a)}
    assert solve([], [H,Y], [(y,f(a,a))], [(h,a)]) == {'y':f(h,a)}
    assert solve([], [H,Y], [(y,y)], [(h,a)]) is None
    assert solve([], [H,Y], [(y,y)], [(y,f(h,a))]) == {'y':f(h,a)}
    # Fixing y pins a latent residual, even though it is hidden in h.
    assert solve([], [H,Y], [(h,f(y,y))], [(y,b)]) == {'y':b}
    # Two visible inputs share one residual. Only the whole earlier input is usable.
    guard = [(h,f(x,a)), (y,f(b,a))]
    assert solve([], [H,Y,X], guard, [(x,b)]) == {'y':h}
    assert solve([], [H,Y,X], [(h,f(x,a)), (y,b)], [(x,b)]) is None
    assert solve([], [H,X,Y], [(h,f(x,a)), (y,b)], [(x,b)]) == {'y':x}
    # The projection can expose a residual that was originally an output.
    assert solve(['d'], [H,Y], [(d,f(y,a))], [(h,y)]) == {'d':f(a,a), 'y':h}
    # Two inputs can also be pinned just by fixing the outputs.
    assert solve([], [H,K,Y], [(y,f(h,k))], [(h,a),(k,b)]) == {'y':f(a,b)}
    # The only active point may be reached by a nonconstant strategy even
    # though substituting the ground row itself would activate all inputs.
    assert solve([], [H,Y,Z], [(y,z)], [(h,a),(y,f(b,h))]) is not None
    # Exhaust all unary contexts for the two-constant signature. These are
    # exactly a, b and the bare input, so this comparison is an exact oracle.
    alphabet = [a,b,h,y,z]
    equations = list(product(alphabet, repeat=2))
    cases = 0
    for prem, conc in product(equations, repeat=2):
        pred = lambda eq, env: inp.once(eq[0], env) == inp.once(eq[1], env)
        possible = False
        for by, bz in product([a,b,h], repeat=2):
            active = []
            for u in [a,b]:
                ground = {'h':u, 'y':inp.once(by,{'h':u}), 'z':inp.once(bz,{'h':u})}
                if pred(prem, ground):
                    active.append(pred(conc, ground))
            if active and all(active):
                possible = True
                break
        assert (solve([], [H,Y,Z], [prem], [conc]) is not None) == possible
        cases += 1
    print(f'{cases} exact finite-algebra comparisons and the branching examples passed.')

    # Compare original and normalized clauses over the full two-constant
    # algebra. Every term is a constant or a projection to one earlier input.
    def truth(inputs, prem, conc):
        scope = [a,b,*map(V,inputs)]
        plays = [dict(zip(inputs,vals)) for vals in product((a,b),repeat=len(inputs))]
        def holds(eqs, env):
            return all(inp.once(l,env)==inp.once(r,env) for l,r in eqs)
        for by in scope:
            rows = [{**play, 'y':inp.once(by,play)} for play in plays]
            if any(holds(prem,row) for row in rows) and all(
                    not holds(prem,row) or holds(conc,row) for row in rows):
                return True
        return False
    eqs = list(product([a,b,h,k,y],repeat=2))
    for prem, conc in product(eqs, repeat=2):
        norm = eliminate_inputs([], ['h','k'], ['y'], [(h,y),prem], [conc])
        assert truth(['h','k'], [(h,y),prem], [conc]) == (norm is not None and truth(*norm))
    assert eliminate_inputs([], ['h','k'], ['y'], [(h,f(k,y))], [(h,k)]) == (
        ['k'], [], [(f(k,y),k)])
    print('625 three-block eliminations agree with exhaustive strategies.')


if __name__ == '__main__':
    check()
