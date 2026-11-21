"""Compile ordinary JCA on unary trees to finite disjunctions of word equations.

A term is (prefix, tail). Unary letters and ground constants are strings.
A variable tail is ('x', name), a free pattern parameter is ('p', index).
Each symbolic word is a tuple of letters and unknowns. Empty tuples mean epsilon.
The checker recovers all residual words from proposed answer-prefix values.
"""

from itertools import product
import importlib.util
from pathlib import Path


def var(x):
    return ('x', x)


def parameter(index):
    return ('p', index)


def word(x):
    return ('w', x)


def term(prefix, tail):
    return (tuple(prefix), tail)


def apply_chains(t, subst):
    prefix, tail = t
    while tail in subst:
        more, tail = subst[tail]
        prefix += more
    return prefix, tail


def unifier_traces(premise, branch, pos=0, subst=None, conditions=()):
    if subst is None:
        subst = {}
    if pos == len(premise):
        yield subst, conditions
        return

    (a, x), (b, y) = [apply_chains(t, subst) for t in premise[pos]]
    def proceed(bindings, equation):
        return unifier_traces(premise, branch, pos + 1,
                              bindings, conditions + (equation,))
    if x == y:
        yield from proceed(subst, (a, b))
        return
    for shorter, p, longer, q in [(a, x, b, y), (b, y, a, x)]:
        if isinstance(p, tuple) and p[0] == 'p':
            diff = ('diff', branch, pos)
            yield from proceed({**subst, p: ((diff,), q)}, (shorter + (diff,), longer))


def branch_systems(premise, conclusion, branch):
    for subst, conditions in unifier_traces(premise, branch):
        pairs = [(apply_chains(l, subst), apply_chains(r, subst)) for l, r in conclusion]
        if all(x == y for (_, x), (_, y) in pairs):
            yield conditions + tuple((a, b) for (a, _), (b, _) in pairs)


def prefix_conditions(prefix, choice):
    """Empty prefixes at universals, and no later universal tail in earlier coordinates."""
    seen, fixed = set(), []
    for quantifier, name in prefix:
        tail = choice[name]
        if quantifier == 'all':
            if not (isinstance(tail, tuple) and tail[0] == 'p') or tail in seen:
                return None
            fixed.append(((word(name),), ()))
        elif quantifier != 'some':
            raise ValueError(quantifier)
        seen.add(tail)
    return tuple(fixed)


def systems(branches, constants, leaf_choice=None, prefix=()):
    prefix = tuple(prefix)
    terms = [t for prepost in branches for eqs in prepost for eq in eqs for t in eq]
    names = list(dict.fromkeys([tail[1] for _, tail in terms if isinstance(tail, tuple)]
                               + [name for _, name in prefix]))
    leaves = tuple(constants) + tuple(parameter(i) for i in range(len(names)))
    choices = (leaf_choice,) if leaf_choice is not None else (
        dict(zip(names, selected)) for selected in product(leaves, repeat=len(names)))

    for choice in choices:
        fixed = prefix_conditions(prefix, choice)
        if fixed is None:
            continue
        def expand(t):
            prefix, tail = t
            if isinstance(tail, tuple):
                x = tail[1]
                return prefix + (word(x),), choice[x]
            return t
        def visit(i, eqs):
            if i == len(branches):
                yield choice, eqs
                return
            pre, post = [[(expand(l), expand(r)) for l, r in sides] for sides in branches[i]]
            for added in branch_systems(pre, post, i):
                yield from visit(i + 1, eqs + added)
        yield from visit(0, fixed)


def fits_prefixes(equations, prefixes):
    """Check a trace at fixed answer words. Prefix cancellation determines each diff."""
    env = {word(k): tuple(v) for k, v in prefixes.items()}
    def value(w):
        return tuple(z for token in w for z in (env[token] if isinstance(token, tuple) else (token,)))
    for l, r in equations:
        if l and isinstance(l[-1], tuple) and l[-1][0] == 'diff' and l[-1] not in env:
            before, full = value(l[:-1]), value(r)
            if full[:len(before)] != before:
                return False
            env[l[-1]] = full[len(before):]
        elif value(l) != value(r):
            return False
    return True


def from_word_system(names, literals, products, equalities, marker_letter, constant):
    """Relations W=w, UV=W and U=V over named word unknowns."""
    def t(v):
        return term('', var(v))
    def marked(w, side):
        return t(('copy', w, side))
    p, q = t('p'), t('q')
    a, ha = term('', constant), term((marker_letter,), constant)
    branches = [([(h, val)], []) for h in [p, q] for val in [a, ha]]
    branches.append(([(p, a), (q, ha)], []))
    for w in names:
        for side in ('p', 'q'):
            z = ('test', w, side)
            branches.append(([(t(side), term((marker_letter,), var(z)))], []))
            branches.append(([(marked(w, side), t(z))], [(t(side), a)]))
    branches.append(([(p, q)], [(marked(w, 'p'), marked(w, 'q')) for w in names]))
    for w, value in literals:
        branches.append(([], [(marked(w, 'p'), term(value, var('p')))]))
    for u, v, w in products:
        branches.append(([(p, marked(v, 'q'))], [(marked(u, 'p'), marked(w, 'q'))]))
    branches.extend(([], [(marked(u, 'p'), marked(v, 'p'))]) for u, v in equalities)
    return branches


def check_embedding(r10, tree):
    names = ['u', 'v', 'w']
    for u, v, w in product(('', 'h', 'g', 'hg'), repeat=3):
        words = dict(zip(names, (u, v, w)))
        branches = from_word_system(names, [('v', v)], [('u','v','w')], [], 'h', 'a')
        pattern = [(r10.V(var(side)), r10.V(parameter(i))) for i, side in enumerate('pq')]
        for name in names:
            for i, side in enumerate('pq'):
                pattern.append((r10.V(var(('copy', name, side))), tree((words[name], parameter(i)))))
                pattern.append((r10.V(var(('test', name, side))), tree((words[name], 'a'))))
        concrete = [[[(tree(l), tree(r)) for l, r in eqs] for eqs in br] for br in branches]
        assert r10.answer(pattern, concrete) == (u + v == w)
    print('64 concatenation examples, including empty and noncommuting words, verified.')


def check_palette(r10):
    # The guard for each edge depends only on its endpoints and can be checked once.
    from itertools import combinations
    a, b = ('a',), ('b',)
    vertices = [r10.V(('vertex', i)) for i in range(4)]
    palette = [r10.V(('palette', i)) for i in range(3)]
    shared = [([(h, a) for h in palette], [(v, a) for v in vertices]),
              ([(v, b) for v in vertices], [])]
    edges = list(combinations(range(4), 2))
    masks = [set(i for i in range(len(edges)) if bits & (1 << i)) for bits in range(64)]
    colorable = set()
    for colors in product(range(3), repeat=4):
        pattern = [(h, r10.V(parameter(i))) for i, h in enumerate(palette)]
        pattern += [(v, r10.V(parameter(c))) for v, c in zip(vertices, colors)]
        assert r10.answer(pattern, shared)
        allowed = {i for i, (u, v) in enumerate(edges)
                   if r10.answer(pattern, [([(vertices[u], a), (vertices[v], b)], [])])}
        assert allowed == {i for i, (u, v) in enumerate(edges) if colors[u] != colors[v]}
        colorable.update(i for i, mask in enumerate(masks) if mask <= allowed)
    assert colorable == set(range(63))
    print('The three-color construction admits 63 of the 64 graphs on four labelled vertices.')


def check_prefixes():
    domain = ('a', 'b')
    params = tuple(parameter(i) for i in range(3))
    names = 'xyz'
    total = 0
    for ends in product(domain + params, repeat=3):
        choice = dict(zip(names, ends))
        rows = {tuple(dict(zip(params, values)).get(t, t) for t in ends)
                for values in product(domain, repeat=3)}
        for qs in product(('all', 'some'), repeat=3):
            def game(xs):
                if len(xs) == 3:
                    return xs in rows
                test = all if qs[len(xs)] == 'all' else any
                return test(game(xs + (v,)) for v in domain)
            assert (prefix_conditions(zip(qs, names), choice) is not None) == game(())
            total += 1
    print(f'{total:,} prefix tests agree with explicit quantifier games on two constants.')


def check():
    spec = importlib.util.spec_from_file_location(
        'round10', Path(__file__).with_name('round-10-experiments.py'))
    r10 = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(r10)
    def tree(t):
        prefix, tail = t
        v = r10.V(tail) if isinstance(tail, tuple) else (tail,)
        for ch in reversed(prefix):
            v = (ch, v)
        return v
    x, y = var('x'), var('y')
    X, Y, a, b = (term('', t) for t in (x, y, 'a', 'b'))
    sets = [
        [([(X, a)], [(Y, b)]), ([(X, b)], [(Y, a)])],
        [([(X, term('h', y)), (Y, term('g', 'a'))], [(X, term('hg', 'a'))])],
        [([(X, term('h', y)), (Y, term('g', x))], [])],
        [([(term('h', x), term('hg', y))], [(X, term('g', y))])],
        [([], [(X, Y)]), ([(X, a)], []), ([(Y, b)], [])],
        [([(X, Y)], [(term('g', x), term('g', y))]), ([], [(X, term('h', 'a'))])],
    ]
    prefixes = ('', 'h', 'g', 'hh', 'hg', 'gh', 'gg')
    leaves = ['a', 'b', parameter(0), parameter(1)]
    checked = 0
    for branches in sets:
        concrete = [[[(tree(l), tree(r)) for l, r in eqs] for eqs in br] for br in branches]
        for endx, endy in product(leaves, repeat=2):
            choice = {'x': endx, 'y': endy}
            traces = [eqs for _, eqs in systems(branches, ['a','b'], choice)]
            for px, py in product(prefixes, repeat=2):
                words = {'x': px, 'y': py}
                symbolic = any(fits_prefixes(eqs, words) for eqs in traces)
                pattern = [(r10.V(x), tree((px, endx))), (r10.V(y), tree((py, endy)))]
                assert symbolic == r10.answer(pattern, concrete)
                checked += 1
    print(f'{checked:,} fixed-pattern checks agree with the finite-tree equation checker.')
    check_embedding(r10, tree)
    check_palette(r10)
    check_prefixes()


if __name__ == '__main__':
    check()
