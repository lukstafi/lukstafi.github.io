"""Decide existence of a synchronous witness family for ordinary finite-term JCA.

A negative result has this restricted meaning. See round-12-same-shape.md.
Run with Python 3.9+ and the adjacent Round 10 and Round 11 modules.
"""

import importlib.util
from itertools import combinations, count, product
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    'round11', Path(__file__).with_name('round-11-experiments.py'))
r11 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r11)
V, F, A, B = r11.V, r11.F, r11.A, r11.B
DOT = F('dot')


def fork(left, right):
    return F('f', left, right)


def shape(term, names):
    if term in (A, B):
        return DOT
    if r11.is_var(term) and len(term) == 2 and term[1] in names:
        return term
    if term[0] == 'f' and len(term) == 3:
        return fork(shape(term[1], names), shape(term[2], names))
    raise ValueError('expected a term over the listed variables and f/2, a, b')


def leaf_template(skeletons, premise_holes, hole_depth):
    """Every occurrence gets its own leaf labels, including repeated holes."""
    indices = count()

    def complete(depth):
        if depth == 0:
            return V('$leaf' + str(next(indices)))
        return fork(complete(depth - 1), complete(depth - 1))

    def expand(tree):
        if tree == DOT:
            return complete(0)
        if r11.is_var(tree):
            return complete(hole_depth if tree[1] in premise_holes else 0)
        return fork(expand(tree[1]), expand(tree[2]))

    return tuple(map(expand, skeletons))


def row_domain(templates, names, equations):
    """Factor one branch's binary leaf assignments by its required equalities."""
    by_name = dict(zip(names, templates))
    mu = r11.unify([(r11.once(s, by_name), r11.once(t, by_name))
                    for s, t in equations])
    if mu is None:
        return None
    row = tuple(r11.apply(t, mu) for t in templates)
    free = sorted(set().union(*(r11.variables(t) for t in row)))

    def rows():
        for values in product((A, B), repeat=len(free)):
            subst = dict(zip(free, values))
            yield tuple(r11.once(t, subst) for t in row)

    return rows


def synchronous_witnesses(names, branches):
    """Return successful rows, or None iff there is no synchronous family."""
    names = tuple(names)
    branches = [(list(d), list(c)) for d, c in branches]
    allowed = set(names)
    if len(allowed) != len(names) or not branches:
        raise ValueError('expected distinct coordinate names and at least one branch')
    equations = [d + c for d, c in branches]
    premises = [(shape(s, allowed), shape(t, allowed)) for d, _ in branches for s, t in d]
    conclusions = [(shape(s, allowed), shape(t, allowed)) for _, c in branches for s, t in c]
    mu = r11.unify(premises + conclusions)
    if mu is None or any(r11.unify(eqs) is None for eqs in equations):
        return None
    skeletons = tuple(r11.apply(V(name), mu) for name in names)
    # Both sides have the same unified shape. Only a hole visited by a
    # premise comparison can contain a marked edge of a spanning forest.
    premise_holes = set().union(*(r11.variables(r11.apply(s, mu)) for s, _ in premises))

    def search(domains, prefix):
        i = len(prefix)
        if i == len(domains):
            hull = r11.fresh_hull(names, prefix)
            if r11.answer(r11.pattern_answer(names, hull), branches):
                return prefix
            return None
        for row in domains[i]():
            result = search(domains, prefix + (row,))
            if result is not None:
                return result
        return None

    m = len(branches)
    max_marks = max(1, m * (2**m - 2))
    max_depth = (max_marks - 1).bit_length() if premise_holes else 0
    for hole_depth in range(max_depth + 1):
        templates = leaf_template(skeletons, premise_holes, hole_depth)
        domains = [row_domain(templates, names, eqs) for eqs in equations]
        if all(domain is not None for domain in domains):
            result = search(domains, ())
            if result is not None:
                return result
    return None


def check_obstruction():
    names = ('x', 'y', 'u', 'v', 'z')
    x, y, u, v, z = map(V, names)
    p, q, r = map(V, ('p', 'q', 'r'))
    branches = [([(x, y)], [(u, A), (v, B), (z, A)]),
                ([(u, B), (v, A), (z, x)], [])]
    pattern = (fork(fork(p, q), A), fork(fork(A, B), r), p, q, r)
    eqs = r11.pattern_answer(names, pattern)
    assert r11.answer(eqs, branches)
    rows = tuple(r11.round10.ground_witness(names, eqs + d) for d, _ in branches)
    assert tuple(max(map(r11.depth, row)) for row in rows) == (2, 3)
    hull = r11.fresh_hull(names, rows)
    assert max(map(r11.depth, hull)) == 2
    assert r11.answer(r11.pattern_answer(names, hull), branches)
    assert synchronous_witnesses(names, branches) is None

    # A depth-two witness pair forces P_x=f(L1,L2), with r absent, and
    # P_y=f(r,t) or f(t,r), with t at most depth one (Proposition 1).
    # Beyond p,q,r there are at most four leaf slots carrying other names.
    leaves = (A, B, p, q, r) + tuple(V('s' + str(i)) for i in range(4))
    terms = leaves + tuple(fork(l, s) for l, s in product(leaves, repeat=2))
    checked = 0
    for left, right in product((leaf for leaf in leaves if leaf != r), repeat=2):
        for t in terms:
            for compared in (fork(r, t), fork(t, r)):
                candidate = (fork(left, right), compared, p, q, r)
                assert not r11.answer(r11.pattern_answer(names, candidate), branches)
                checked += 1
    print(f'PASS: depth-two answer, depth-three witnesses, no synchronous family; '
          f'{checked:,} depth-two lower-bound cases rejected')


def check_skeletons():
    names = ('x', 'y', 'u', 'v')
    x, y, u, v = map(V, names)
    branches = [([(x, y)], [(u, A), (v, B)]), ([(u, B), (v, A)], [])]
    rows = synchronous_witnesses(names, branches)
    assert rows is not None and max(r11.depth(t) for row in rows for t in row) == 1

    # One residual shape occurs in both children of the extra coordinate.
    t = V('t')
    extended = [(d, c + [(t, fork(x, y))]) for d, c in branches]
    rows = synchronous_witnesses(names + ('t',), extended)
    assert rows is not None and all(row[-1] == fork(*row[:2]) for row in rows)
    assert rows[1][0] != rows[1][1]  # same shape, independent labels

    # Constructors in conclusions, an input name used by the LGG machinery,
    # and a branch collision hidden by erasing a and b.
    s, t = V('$w0'), V('h0')
    branches = [([(s, k)], [(t, fork(k, k))]) for k in (A, B)]
    assert synchronous_witnesses(('$w0', 'h0'), branches) == (
        (A, fork(A, A)), (B, fork(B, B)))
    assert synchronous_witnesses(('x',), [([], [(x, A), (x, B)])]) is None
    assert synchronous_witnesses(('x',), [([(x, fork(x, A))], [])]) is None
    assert synchronous_witnesses((), [([], [])]) == ((),)
    assert synchronous_witnesses(('x',), [([(x, A)], []), ([(x, fork(A, B))], [])]) is None
    # Three branch-specific bit columns. Equalities in the first premise
    # propagate through two labels before fixing the two conclusion leaves.
    names = ('s', 'u', 'v', 't')
    s, u, v, t = map(V, names)
    branches = [([(s, u), (u, v), (v, A)], [(t, fork(A, A))]),
                ([(s, B), (u, A), (v, B)], [(t, fork(B, A))]),
                ([(s, A), (u, B), (v, B)], [(t, fork(A, B))])]
    rows = synchronous_witnesses(names, branches)
    assert rows is not None and all(row[3] == fork(row[0], row[1]) for row in rows)
    for k in range(9):
        names = tuple('t' + str(j) for j in range(k + 1))
        ts = tuple(map(V, names))
        chain = [(ts[j], fork(ts[j - 1], A)) for j in range(1, k + 1)]
        rows = synchronous_witnesses(names, [([], chain)])
        assert rows is not None and r11.depth(rows[0][-1]) == k
    print('PASS: repeated shape holes, constructor conclusions, shape and label '
          'conflicts, fresh names, three-branch propagation, and sharp depth bounds 0..8')


def check_small_instances():
    # Round 11 Appendix B ensures that two constructor-free coordinates
    # have a flat answer whenever they have any ordinary answer.
    names = ('x', 'y')
    x, y = map(V, names)
    conjuncts = [[]] + [[atom] for atom in combinations((x, y, A, B), 2)]
    flat_answers = [r11.pattern_answer(names, p) for p in r11.flat_patterns(2)]
    positive = total = 0
    for d1, c1, d2, c2 in product(conjuncts, repeat=4):
        branches = [(d1, c1), (d2, c2)]
        expected = any(r11.answer(eqs, branches) for eqs in flat_answers)
        rows = synchronous_witnesses(names, branches)
        assert (rows is not None) == expected, branches
        positive += expected
        total += 1
    print(f'PASS: {total:,} two-coordinate instances agree with flat-answer '
          f'enumeration ({positive:,} positive)')


def check_branch_count_family():
    def balanced(leaves):
        if len(leaves) == 1:
            return leaves[0]
        half = len(leaves) // 2
        return fork(balanced(leaves[:half]), balanced(leaves[half:]))

    for r in range(2, 6):
        codes = tuple(product((A, B), repeat=r))[1:]  # omit all zeroes
        names = ('x', 'y') + tuple('u' + str(i) for i in range(len(codes)))
        x, y, *outputs = map(V, names)
        branches = [([(x, y)], [(u, A) for u in outputs])]
        branches.extend((list(zip(outputs, bits)), []) for bits in zip(*codes))
        params = tuple(V('p' + str(i)) for i in range(len(codes)))
        pattern = (balanced(params), balanced((A,) * len(codes))) + params
        eqs = r11.pattern_answer(names, pattern)
        assert r11.answer(eqs, branches)
        rows = tuple(r11.round10.ground_witness(names, eqs + d) for d, _ in branches)
        assert all(max(map(r11.depth, row)) == r for row in rows)
        assert all(len({shape(t, set()) for t in column}) == 1 for column in zip(*rows))
        assert r11.answer(r11.pattern_answer(names, r11.fresh_hull(names, rows)), branches)
        if r == 2:
            found = synchronous_witnesses(names, branches)
            assert found is not None and max(r11.depth(t) for row in found for t in row) == r
    print('PASS: branch-count family attains depths 2..5; search finds depth two '
          'on the three-branch instance')


if __name__ == '__main__':
    check_obstruction()
    check_skeletons()
    check_small_instances()
    check_branch_count_family()
