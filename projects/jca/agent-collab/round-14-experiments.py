"""Independent guard checks for the ordinary JCA reduction. Python 3.9+."""

import importlib.util
from itertools import product
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    'round10', Path(__file__).with_name('round-10-experiments.py'))
r10 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r10)
V = r10.V
a, b = r10.F('a'), r10.F('b')


def f(left, right):
    return r10.F('f', left, right)


def compile_instance(data, args, body, equations, samples):
    pack = a
    for name in reversed(data):
        pack = f(V(name), pack)
    scope = []
    for name in args:
        pack = f(pack, a)
        scope.append((V(name), pack))
    pin = [(V(h), a) for h in args]
    return [(pin, equations), (scope, [])] + [
        (list(zip(map(V, args), values)), [(V(body), rhs)])
        for values, rhs in samples]


def accepts(pattern, branches):
    return r10.answer(r10.pattern_answer(pattern, pattern.values()), branches)


def check_missing_guards():
    q, x = V('q'), V('x')
    evaluations = [((a,), x), ((b,), x), ((a,), a), ((b,), b)]
    pin, scope, *calls = compile_instance(['x'], ['h'], 'y', [], evaluations)
    leak = {'x': q, 'h': q, 'y': q}
    assert accepts(leak, [pin, *calls])
    assert not accepts(leak, [scope])
    # Two distinct ground outputs cannot both equal the same global x.
    assert a != b

    projections = [((f(a, a),), a), ((f(b, a),), b)]
    pin, scope, *calls = compile_instance([], ['h'], 'y', [], projections)
    destructor = {'h': f(q, a), 'y': q}
    assert accepts(destructor, [scope, *calls])
    assert not accepts(destructor, [pin])
    # A constant cannot return both leaves; a hole or f-root returns a compound.
    print('Both spurious answers pass with their respective guard removed.')


def check_recovery():
    # Each candidate tuple is an arbitrary answer, with globally shared names.
    # Use the original equation checker for the target, then instantiate the
    # decoded source body directly, independently of the two guard conditions.
    p, q, x = V('p'), V('q'), V('x')
    leaves = [a, b, p, q]
    terms = leaves + [f(l, r) for l, r in product(leaves, repeat=2)]
    samples = [((x,), f(x, x)), ((f(x, a),), f(f(x, a), f(x, a)))]
    branches = compile_instance(['x'], ['h'], 'y', [], samples)
    count = passed = 0
    for h, d, y in product(terms, repeat=3):
        count += 1
        pattern = {'h': h, 'x': d, 'y': y}
        if not accepts(pattern, branches):
            continue
        passed += 1
        assert r10.is_var(h) and h[1] not in r10.variables(d)
        default = {'p': a, 'q': a}
        value = r10.once(d, default)
        for (argument,), rhs in samples:
            actual = {**default, h[1]: r10.once(argument, {'x': value})}
            assert r10.once(y, actual) == r10.once(rhs, {'x': value})
    assert passed > 0
    print(f'{count:,} candidate patterns, {passed} accepted and decoded.')


def check_multiple_arguments():
    holes = [V('p'), V('q'), V('r')]
    x = V('x')
    body = f(holes[2], f(holes[0], holes[2]))
    inputs = [(a, x, b), (f(b, a), a, x)]
    samples = [(v, r10.once(body, dict(zip(('p', 'q', 'r'), v)))) for v in inputs]
    branches = compile_instance(['x'], ['h0', 'h1', 'h2'], 'y', [(x, b)], samples)
    pattern = dict(zip(('h0', 'h1', 'h2'), holes), x=b, y=body)
    assert accepts(pattern, branches)
    assert not accepts({**pattern, 'h1': holes[0]}, [branches[1]])
    assert not accepts({**pattern, 'x': f(a, f(b, holes[2]))}, [branches[1]])
    assert not accepts({**pattern, 'x': a}, [branches[0]])
    print('Three formal arguments support permutation, duplication and deletion; '
          'the guards reject aliasing, nested leakage and a false data equation.')


if __name__ == '__main__':
    check_missing_guards()
    check_recovery()
    check_multiple_arguments()
