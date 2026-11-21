"""Construct term strategies for a single input-only premise, Round 20.

An ordinary symbol is a string. Coordinate names are distinct. Terms and
unification use Round 10's finite-tree representation. Pass singleton=True for
a signature having only the supplied ground constant. The reference search
expands shared terms and is intended for small instances.
"""
import importlib.util
from itertools import combinations, permutations, product
from pathlib import Path

spec = importlib.util.spec_from_file_location('trees', Path(__file__).with_name('round-10-experiments.py'))
trees = importlib.util.module_from_spec(spec)
spec.loader.exec_module(trees)
V, F, apply, once, unify = trees.V, trees.F, trees.apply, trees.once, trees.unify
vars_in = trees.variables


def rigid(name):
    return F(('rigid', name))


def subterms(t):
    yield t
    if not trees.is_var(t):
        for child in t[1:]:
            yield from subterms(child)


def mixed(t):
    return any(isinstance(node[0], tuple) for node in subterms(t))


def map_eqs(equations, subst):
    return [(once(l, subst), once(r, subst)) for l, r in equations]


def collect(terms):
    return set().union(*(vars_in(t) for t in terms))


def grounded(t, solution, base):
    t = apply(t, solution)
    return once(t, {v: base for v in vars_in(t)})


def solve_membership(tasks):
    """Each task is a target tree and the list of generators in scope.
    Only pure unknowns remain. All selected matches share one unifier.
    """
    def search(pending, equalities, subst):
        if not pending:
            return subst
        (target, available), *rest = pending
        if not mixed(target):
            return search(rest, equalities, subst)
        for generator in available:
            if not mixed(generator):
                continue
            extended = [*equalities, (target, generator)]
            candidate = unify(extended)
            if candidate is None or any(mixed(t) for t in candidate.values()):
                continue
            found = search(rest, extended, candidate)
            if found is not None:
                return found
        if not isinstance(target[0], tuple):
            children = [(child, available) for child in target[1:]]
            return search(children + rest, equalities, subst)
        return None
    return search(tasks, [], {})


def extract_body(target, generators):
    if not mixed(target):
        return target
    for name, tree in generators.items():
        if tree == target:
            return V(name)
    if isinstance(target[0], tuple):
        return None
    children = [extract_body(t, generators) for t in target[1:]]
    if all(t is not None for t in children):
        return F(target[0], *children)
    return None


def solve(data, moves, premise, conclusion, base=('a',), *, singleton=False):
    """Return a map from existentials to certified terms, or None if impossible."""
    inputs = [h for q, h in moves if q == 'all']
    outputs = {y: [h for q, h in moves[:i] if q == 'all']
               for i, (q0, y) in enumerate(moves) if q0 == 'some'}
    names = [*data, *inputs, *outputs]
    assert len(set(names)) == len(names) and all(q in ('all','some') for q, _ in moves)
    assert collect(t for eq in premise for t in eq) <= set(data) | set(inputs)
    assert collect(t for eq in conclusion for t in eq) <= set(names)
    if singleton:
        return dict.fromkeys([*data, *outputs], base)

    mu = unify(premise)
    if mu is None:
        return None
    active = {x: apply(V(x), mu) for x in [*data, *inputs]}
    first_pure = collect(active[d] for d in data)
    rigidify = {v: rigid(v) for v in collect(active.values()) - first_pure}
    active = {x: once(t, rigidify) for x, t in active.items()}
    nu = unify(map_eqs(conclusion, active))
    if nu is None or any(mixed(apply(V(v), nu)) for v in first_pure):
        return None
    patterns = {x: apply(active[x], nu) for x in active}
    targets = {y: apply(V(y), nu) for y in outputs}
    forced_pure = collect(patterns.values())
    free = sorted(collect(targets.values()) - forced_pure, key=repr)
    pieces = {s for h in inputs for s in subterms(patterns[h]) if mixed(s)}

    def certificate(selected, solution):
        values = {x: grounded(t, solution, base) for x, t in patterns.items()}
        strategy = {d: values[d] for d in data}
        for y, visible in outputs.items():
            target = grounded(selected[y], solution, base)
            body = extract_body(target, {h: values[h] for h in visible})
            if body is None:
                return None
            assert vars_in(body) <= set(visible)
            strategy[y] = body
        witness = unify(map_eqs(premise, strategy))
        assert witness is not None
        assert all(apply(l, witness) == apply(r, witness)
                   for l, r in map_eqs(conclusion, strategy))
        return strategy

    # This default grounding suffices for the three-block and monadic cases.
    default = certificate(targets, {})
    if default is not None:
        return default
    if all(len(node) <= 2 for t in [*patterns.values(), *targets.values()] for node in subterms(t)):
        return None
    for choice in product([None, *sorted(pieces, key=repr)], repeat=len(free)):
        replace = {v: t for v, t in zip(free, choice) if t is not None}
        selected = {y: once(t, replace) for y, t in targets.items()}
        solution = solve_membership([(selected[y], [patterns[h] for h in visible])
                                     for y, visible in outputs.items()])
        if solution is None:
            continue
        strategy = certificate(selected, solution)
        assert strategy is not None
        return strategy
    return None


def color_problem(n, edges, *, colors_as_outputs=False):
    a = F('a')
    f = lambda x, y: F('f', x, y)
    colors = [a, f(a,a), f(f(a,a),a)]
    pairs = list(permutations(range(3), 2))
    data = [f'x{i}' for i in range(n)]
    inputs = [('all', f'h{i}{j}') for i, j in pairs]
    r = V('r')
    premise = [(V(h), f(f(colors[i],colors[j]),r)) for (_, h), (i,j) in zip(inputs, pairs)]
    packed = a
    for i, j in reversed(edges):
        packed = f(f(f(V(data[i]),V(data[j])),r), packed)
    outputs = [('some','result')]
    if colors_as_outputs:
        outputs.extend(('some', d) for d in data)
        data = []
    return solve(data, inputs + outputs + [('all','r')], premise, [(V('result'), packed)])


def check():
    a, f = F('a'), lambda x, y: F('f', x, y)
    h, k, r, d, y, z, w = map(V, ('h','k','r','d','y','z','w'))
    H, K, R = [('all', x) for x in ('h','k','r')]
    Y, Z, W = [('some', x) for x in ('y','z','w')]
    assert solve([], [H,Y,R], [(h,f(r,a))], [(y,r)]) is None
    assert solve([], [H,R,Y], [(h,f(r,a))], [(y,r)]) == {'y':r}
    # A shared residual is forced to a proper, rigid-containing subterm of h.
    small = f(r,a)
    assert solve([], [H,Y,R,Z], [(h,f(r,small))], [(y,f(r,z))]) == {'y':h, 'z':small}
    assert solve([], [H,Y,Z,R], [(h,f(r,small))], [(y,f(r,z))]) is None
    # Each early output alone works. Together they disagree about z.
    active = [(h,f(r,small)), (k,f(f(a,r),r))]
    assert solve([], [H,K,Y,W,R,Z], active, [(y,f(r,z)), (w,f(z,r))]) is None
    pin = [(h,f(r,d))]
    assert solve(['d'], [H,Y,R], pin, [(y,f(r,f(a,a)))]) == {'d':f(a,a), 'y':h}
    assert solve(['d'], [H,Y,W,R], pin, [(y,f(r,a)), (w,f(r,f(a,a)))]) is None
    assert solve(['d'], [R], [], [(d,r)]) is None
    assert solve([], [H,Y], [(h,f(h,a))], []) is None
    assert solve([], [H,Y], [], [(y,f(h,h))]) == {'y':f(h,h)}
    assert solve([], [H,Y], [(h,a)], []) == {'y':a}
    assert solve([], [H,R], [], [(h,r)], singleton=True) == {}
    # Every labeled simple graph on four vertices, plus a loop.
    edges = list(combinations(range(4), 2))
    for bits in product((False, True), repeat=len(edges)):
        selected = [e for e, take in zip(edges, bits) if take]
        colorable = any(all(colors[i] != colors[j] for i,j in selected)
                        for colors in product(range(3), repeat=4))
        assert (color_problem(4, selected) is not None) == colorable
    assert color_problem(1, [(0,0)]) is None
    assert color_problem(1, [(0,0)], colors_as_outputs=True) is None
    assert color_problem(3, [(0,1),(1,2),(2,0)], colors_as_outputs=True) is not None
    # A unary mixed target is a word on a single rigid leaf. An earlier
    # generator must be an accessible suffix, possibly after adding a prefix.
    g = lambda t: F('g', t)
    assert solve([], [H,Y,R], [(h,g(r))], [(y,g(g(r)))]) == {'y':g(h)}
    assert solve([], [H,Y,R], [(h,g(r))], [(y,r)]) is None
    print('Scope, mixed-subterm, shared-data checks and all 64 four-vertex graphs passed.')


if __name__ == '__main__':
    check()
