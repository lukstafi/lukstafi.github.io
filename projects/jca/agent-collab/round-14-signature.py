"""Check the occurrence-preserving signature encoding for four-branch JCA."""

import importlib.util
from functools import lru_cache
from itertools import product
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    'round10', Path(__file__).with_name('round-10-experiments.py'))
r10 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r10)
V, once = r10.V, r10.once
A, B = ('a',), ('b',)
RESERVED = {('mid0',), ('mid1',), ('nil',)}
ARITY = {'zero': 0, 'one': 0, 'next': 1, 'pair': 2, 'triple': 3}


def f(left, right):
    return ('f', left, right)


def wrap(payload):
    return f(B, payload)


def template(tag, slots):
    tail = A
    for slot in reversed(slots):
        tail = f(f(A, slot), tail)
    return wrap(f(tag, tail))


TAGS = {}
tag = A
for symbol in ARITY:
    TAGS[symbol] = tag
    tag = f(A, tag)


def encode_closed_or_body(term):
    if r10.is_var(term) or term in RESERVED:
        return term
    symbol, *children = term
    assert len(children) == ARITY[symbol]
    return template(TAGS[symbol], [encode_closed_or_body(t) for t in children])


@lru_cache(maxsize=8192)
def decode(term):
    # Open trees use the same rules, with holes as rigid leaves during matching.
    if r10.is_var(term) or term in RESERVED:
        return term
    if term[0] == 'f' and term[1] == B and term[2][0] == 'f':
        _, tag, spine = term[2]
        for symbol, expected in TAGS.items():
            if tag != expected:
                continue
            slots = []
            while spine[0] == 'f':
                left, spine = spine[1:]
                if left[0] != 'f' or left[1] != A:
                    break
                slots.append(left[2])
            else:
                if spine == A and len(slots) == ARITY[symbol]:
                    return (symbol, *(decode(slot) for slot in slots))
    return ('zero',)


def vary_one_position(t, hole):
    yield hole
    if t[0] == 'f':
        yield from (f(l, t[2]) for l in vary_one_position(t[1], hole))
        yield from (f(t[1], r) for r in vary_one_position(t[2], hole))


def check():
    p, q = V('p'), V('q')
    zero, one = ('zero',), ('one',)
    sources = [zero, one, ('next', one), ('pair', ('next', one), zero),
               ('triple', zero, one, ('pair', one, zero))]
    protected = [encode_closed_or_body(t) for t in sources] + [
        wrap(A), wrap(B), wrap(f(B, B)), wrap(f(TAGS['pair'], A))]
    assert [decode(t) for t in protected[:len(sources)]] == sources

    small = (A, B, p, q)
    depth_one = small + tuple(f(l, r) for l, r in product(small, repeat=2))
    bodies = set(depth_one)
    bodies.update(f(l, r) for l, r in product(depth_one, repeat=2))
    source_bodies = [(symbol,) + tuple([p, q, p][:arity])
                     for symbol, arity in ARITY.items()]
    source_bodies += [('triple', ('pair', q, p), ('next', p), q)]
    for original in source_bodies:
        enc = encode_closed_or_body(original)
        assert decode(enc) == original
        bodies.update(vary_one_position(enc, p))
        bodies.update(vary_one_position(enc, q))
        bodies.update(template(TAGS['next'], [t]) for t in vary_one_position(enc, q))

    checked = 0
    for l, r in product(protected, repeat=2):
        assignment = {'p': l, 'q': r}
        decoded = {key: decode(value) for key, value in assignment.items()}
        for body in bodies:
            assert decode(once(body, assignment)) == once(decode(body), decoded)
            checked += 1
    print(f'{checked:,} substitution identities verified on {len(bodies)} bodies '
          f'and {len(protected)**2} protected argument pairs.')

    mixed = [*sorted(RESERVED), protected[0], protected[-1]]
    reserved_bodies = {*bodies, *RESERVED, encode_closed_or_body(('pair', ('mid0',), p))}
    extra = 0
    for l, r in product(mixed, repeat=2):
        for body in reserved_bodies:
            assert decode(once(body, {'p': l, 'q': r})) == once(
                decode(body), {'p': decode(l), 'q': decode(r)})
            extra += 1
    print(f'{extra:,} identities with atomic midpoints and protected trees.')

    # An unprotected input can complete a constructor template at a fixed position.
    broken = f(p, f(TAGS['one'], A))
    assert decode(once(broken, {'p': B})) == one
    assert once(decode(broken), {'p': decode(B)}) == zero
    print('An unprotected argument breaks the substitution identity as predicted.')


def check_split_path():
    # l -> r globally, followed by r -> one inside a pair with a repeated subterm.
    zero, one = ('zero',), ('one',)
    l = ('next', zero)
    r = ('next', one)
    mid0, mid1, nil = ('mid0',), ('mid1',), ('nil',)
    src, dst = ('pair', l, l), ('pair', one, l)
    steps = ['left0', 'right0', 'left1', 'right1']
    lefts, rights = [l, mid0, r, mid1], [mid0, r, mid1, one]
    body = V('tail')
    for step in reversed(steps):
        body = ('cons', ('pair', V(step), l), body)
    def check_body(term, names, first, second):
        ls = dict(zip(names, first), tail=('cons', dst, nil))
        rs = dict(zip(names, second), tail=nil)
        assert once(term, ls) == ('cons', src, once(term, rs))
    check_body(body, steps, lefts, rights)
    collapse = {'left0': V('rule0'), 'right0': r,
                'left1': V('rule1'), 'right1': one}
    check_body(once(body, collapse), ['rule0', 'rule1'], [l, r], [r, one])
    print('Rule splitting and body recovery pass on a four-step rigid rewrite path.')


if __name__ == '__main__':
    check()
    check_split_path()
