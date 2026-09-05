"""Finite checks for round-10-witness-generalization.md; Python standard library.

This tests ordinary JCA only, not prefix validity or the InvarGenT code.
Variables are ('var', name); constructors are (symbol, *children).
The unifier follows rounds 8/9. Matching deliberately applies bindings once.
"""

from itertools import combinations, product


def V(name):
    return ('var', name)


def F(symbol, *children):
    return (symbol, *children)


def is_var(term):
    return term[0] == 'var'


def variables(term):
    if is_var(term):
        return {term[1]}
    return set().union(*(variables(c) for c in term[1:]))


def apply(term, subst):
    """Resolve an acyclic unification substitution transitively."""
    if is_var(term):
        return apply(subst[term[1]], subst) if term[1] in subst else term
    return F(term[0], *(apply(c, subst) for c in term[1:]))


def once(term, subst):
    """Homomorphic one-time application, including p -> f(p,p)."""
    if is_var(term):
        return subst.get(term[1], term)
    return F(term[0], *(once(c, subst) for c in term[1:]))


def unify(equations):
    pending, subst = list(equations), {}
    while pending:
        left, right = pending.pop()
        left, right = apply(left, subst), apply(right, subst)
        if left == right:
            continue
        if is_var(right) and not is_var(left):
            left, right = right, left
        if is_var(left):
            if left[1] in variables(right):
                return None
            subst[left[1]] = right
        elif left[0] != right[0] or len(left) != len(right):
            return None
        else:
            pending.extend(zip(left[1:], right[1:]))
    return subst


def matches(pattern, target):
    """Return a one-sided matcher, or None; target variables are rigid."""
    pending, subst = [(pattern, target)], {}
    while pending:
        pat, tgt = pending.pop()
        if is_var(pat):
            name = pat[1]
            if name in subst and subst[name] != tgt:
                return None
            subst[name] = tgt
        elif is_var(tgt) or pat[0] != tgt[0] or len(pat) != len(tgt):
            return None
        else:
            pending.extend(zip(pat[1:], tgt[1:]))
    assert once(pattern, subst) == target
    return subst


def answer(equations, branches):
    if unify(equations) is None:
        return False
    for premise, conclusion in branches:
        mu = unify(equations + premise)
        if mu is None or any(apply(l, mu) != apply(r, mu)
                             for l, r in conclusion):
            return False
    return True


def pattern_answer(names, pattern):
    return list(zip(map(V, names), pattern))


def lgg(rows):
    """Ground tuple lgg, sharing one memo table across all coordinates."""
    assert rows and all(len(row) == len(rows[0]) for row in rows)
    assert all(not variables(term) for row in rows for term in row)
    memo = {}

    def descend(vector):
        head = vector[0]
        if all(t[0] == head[0] and len(t) == len(head) for t in vector):
            return F(head[0], *(descend(tuple(t[j] for t in vector))
                                for j in range(1, len(head))))
        if vector not in memo:
            memo[vector] = V('h' + str(len(memo)))
        return memo[vector]

    return tuple(descend(tuple(column)) for column in zip(*rows))


def ground_witness(names, equations):
    mu = unify(equations)
    assert mu is not None
    row = tuple(apply(V(name), mu) for name in names)
    residual = set().union(*(variables(t) for t in row))
    return tuple(once(t, {v: F('a') for v in residual}) for t in row)


def ground_determined(names, branches):
    """Theorem 5.1: None means outside fragment, False means no answer."""
    rows, outside = [], False
    for premise, conclusion in branches:
        mu = unify(premise + conclusion)
        if mu is None:
            return False
        row = tuple(apply(V(name), mu) for name in names)
        outside |= any(variables(t) for t in row)
        rows.append(row)
    if outside:
        return None
    return answer(pattern_answer(names, lgg(rows)), branches)


def check_named_examples():
    a, b = F('a'), F('b')
    x, y, z, p = map(V, ('x', 'y', 'z', 'p'))
    f = lambda l, r: F('f', l, r)
    example43 = [([(y, f(k, x))], [(z, k)]) for k in (a, b)]
    assert answer([(y, f(x, z))], example43)
    countermodel = {'x': a, 'z': b, 'y': f(a, b)}
    assert once(y, countermodel) == once(f(x, z), countermodel)
    assert matches(f(b, V('t')), f(a, b)) is None
    # Neither listed SCA answer covers B: also exhibit B with z != a.
    assert answer([(y, f(x, z))], example43[:1])
    assert once(z, countermodel) != a

    assert matches(p, f(p, p)) == {'p': f(p, p)}
    assert unify([(p, f(p, p))]) is None
    assert unify([(V('v'), p), (V('u'), f(p, p))]) is not None
    assert not answer([(V('v'), p), (V('u'), f(p, p))],
                      [([(V('v'), V('u'))], [])])

    linkage = [(V('u'), f(a, a)), (V('v'), f(p, p)), (V('u'), V('v'))]
    mu = unify(linkage)
    assert mu is not None and apply(V('u'), mu) == apply(V('v'), mu)
    assert apply(p, mu) == a

    positive = [([(x, a)], [(y, a)]), ([(x, b)], [(y, b)])]
    negative = [([], [(x, a)]), ([], [(x, b)])]
    assert ground_determined(('x', 'y'), positive) is True
    assert ground_determined(('x',), negative) is False
    assert ground_determined(('x',), [([], [(x, f(x, a))])]) is False
    assert ground_determined(('x', 'y'), [([], [(x, a)])]) is None

    branches = [([(x, a)], [(y, b)]), ([(x, b)], [(z, b)])]
    names = ('x', 'y', 'z')
    defaults = [ground_witness(names, d + c) for d, c in branches]
    assert defaults == [(a, b, a), (b, a, b)]
    assert not answer(pattern_answer(names, lgg(defaults)), branches)
    good = [(a, b, b), (b, b, b)]
    assert answer(pattern_answer(names, lgg(good)), branches)
    assert answer([(y, b), (z, b)], branches)

    for n in (1, 2, 8, 32):
        first, second, tag = a, a, b
        for _ in range(n):
            first = f(a, first)
            second = f(f(tag, a), second)
            tag = f(tag, b)
        assert len(variables(lgg([(first,), (second,)])[0])) == n
    print('PASS: named counterexamples, fragment decisions, and lgg widths 1/2/8/32')


def check_finite_family():
    """Exhaust 2,401 equality-only instances; exercise candidate strengthening.

    Ten canonical equality patterns are an independent bounded search for
    comparison, not an asserted complete algorithm outside Theorem 5.1.
    """
    names = ('x', 'y')
    x, y, p, q = map(V, ('x', 'y', 'p', 'q'))
    a, b = F('a'), F('b')
    atoms = list(combinations((x, y, a, b), 2))
    conjunctions = [[]] + [[atom] for atom in atoms]
    patterns = [(p, q), (p, p), (p, a), (p, b), (a, p), (b, p)]
    patterns += list(product((a, b), repeat=2))
    instances = strengthened = fragment = 0
    for d1, c1, d2, c2 in product(conjunctions, repeat=4):
        branches = [(d1, c1), (d2, c2)]
        found = False
        for pat in patterns:
            eqs = pattern_answer(names, pat)
            if not answer(eqs, branches):
                continue
            found = True
            rows = [ground_witness(names, eqs + d) for d, _ in branches]
            h = lgg(rows)
            # Witness hull lies below p and retains each sample.
            assert matches(F('tuple', *pat), F('tuple', *h)) is not None
            assert all(matches(F('tuple', *h), F('tuple', *g)) is not None
                       for g in rows)
            assert answer(pattern_answer(names, h), branches)
            strengthened += 1
        decision = ground_determined(names, branches)
        if decision is not None:
            assert decision == found
            fragment += 1
        instances += 1
    print(f'PASS: {instances} instances; {strengthened} witness-hull checks; '
          f'{fragment} fragment decisions agree with bounded pattern search')


def check_constructor_families():
    """Nonlinear and nested patterns with premise-driven leaf equalization."""
    a, b, p, q = F('a'), F('b'), V('p'), V('q')
    names = ('x', 'y', 'z')
    x, y, z = map(V, names)
    checked = 0
    for depth in range(5):
        term = F('f', p, q)
        for _ in range(depth):
            term = F('f', term, p)
        pat = (term, p, q)
        eqs = pattern_answer(names, pat)
        for left, right in product((a, b, F('f', a, b)), repeat=2):
            rows = []
            branches = []
            for value in (left, right):
                target = once(term, {'p': value, 'q': value})
                branches.append(([(x, target)], [(y, z)]))
                rows.append((target, value, value))
            assert answer(eqs, branches)
            h = lgg(rows)
            assert matches(F('tuple', *pat), F('tuple', *h)) is not None
            assert answer(pattern_answer(names, h), branches)
            checked += 1
    print(f'PASS: {checked} nested constructor witness-hull checks')


if __name__ == '__main__':
    check_named_examples()
    check_finite_family()
    check_constructor_families()
