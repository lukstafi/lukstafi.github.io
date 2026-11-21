"""A constructive decision procedure for one comparison with constant outputs.

solve((x, y), targets, guards) returns an answer pattern indexed by variable
name, or None on a proved negative instance. Names are strings. A guard is
a conjunction of flat equations in the Round 10 finite-term representation.
Run this file with Python 3.9+ to reproduce the checks in the Round 13 note.
"""

import importlib.util
from itertools import combinations_with_replacement, count, permutations, product
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    'round11', Path(__file__).with_name('round-11-experiments.py'))
r11 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r11)
V, F, A, B = r11.V, r11.F, r11.A, r11.B


def balanced(leaves):
    if len(leaves) == 1:
        return leaves[0]
    cut = len(leaves) // 2
    return F('f', balanced(leaves[:cut]), balanced(leaves[cut:]))


def project_guard(mu, core):
    """A star for each equality class on the core, with constants retained."""
    first = {A: A, B: B}
    result = []
    for term in core:
        value = r11.apply(term, mu)
        if value in first:
            result.append((term, first[value]))
        else:
            first[value] = term
    return result


def flat_answer(ports, targets, guards, fresh):
    x, y = ports
    fixed = [(V(name), value) for name, value in targets.items()]
    if all(r11.unify(g + fixed) is not None for g in guards):
        return {**targets, x: fresh(), y: fresh()}

    for c, d in ((A, B), (B, A)):
        main = {**targets, x: c, y: c}
        required = []
        for guard in guards:
            if any(r11.once(l, main) != r11.once(r, main) for l, r in guard):
                required.extend(guard)
        for fixed_port, switch_port in ((x, y), (y, x)):
            pins = [(V(fixed_port), c), (V(switch_port), d)]
            pins.extend((V(z), d) for z in targets if targets[z] == d)
            mu = r11.unify(required + pins)
            if mu is None:
                continue
            switch = fresh()
            result = {fixed_port: c, switch_port: switch}
            for z, target in targets.items():
                # Any still-free class in the second state may take c.
                result[z] = switch if target == c and r11.apply(V(z), mu) == d else target
            return result
    return None


def solve(ports, targets, guards):
    """The active branch is x=y => conjunction(z=targets[z]); all guards imply top."""
    x, y = ports
    names = set(ports) | set(targets)
    if x == y or set(ports) & set(targets) or not all(isinstance(v, str) for v in names):
        raise ValueError('ports and output names must be distinct strings')
    if any(value not in (A, B) for value in targets.values()):
        raise ValueError('outputs must be assigned a or b')
    core = tuple(map(V, (x, y, *targets)))
    guards = [list(g) for g in guards]
    for guard in guards:
        for left, right in guard:
            for term in (left, right):
                if term in (A, B):
                    continue
                if len(term) != 2 or not r11.is_var(term) or not isinstance(term[1], str):
                    raise ValueError('guard equations must be constructor-free')
                names.add(term[1])

    indices = count()

    def fresh():
        while True:
            name = '$r13_' + str(next(indices))
            if name not in names:
                return V(name)

    projected = []
    for guard in guards:
        mu = r11.unify(guard)
        if mu is None:
            return None
        projected.append(project_guard(mu, core))

    result = flat_answer(ports, targets, projected, fresh)
    if result is None:
        result = compound_answer(ports, targets, projected, fresh)
    if result is not None:
        result.update((v, fresh()) for v in sorted(names - result.keys()))
    return result


def compound_answer(ports, targets, guards, fresh):
    x, y = ports
    left_attached, right_attached = set(), set()
    fixed = [(V(z), value) for z, value in targets.items()]
    for guard in guards:
        mu = r11.unify(guard)
        left, right = (r11.apply(V(name), mu) for name in ports)
        if left in (A, B) or right in (A, B):
            return None
        at_left = {z for z in targets if r11.apply(V(z), mu) == left}
        at_right = {z for z in targets if r11.apply(V(z), mu) == right}
        if at_left and at_right:
            return None
        if left == right and r11.unify(guard + fixed) is None:
            return None
        left_attached.update(at_left)
        right_attached.update(at_right)
    if left_attached & right_attached:
        return None

    result = {}
    slots = []
    if len(guards) == 1:
        # The copied side can be entirely ground. Merge outputs with the
        # same (main value, guard value), keeping a distinct marker for a copy.
        mu = r11.unify(guards[0])
        attached = left_attached | right_attached
        copy = object()
        labels = {}
        for z, target in targets.items():
            value = r11.apply(V(z), mu)
            guard_value = copy if z in attached else (B if value == B else A)
            if target == guard_value:
                result[z] = target
                continue
            key = (target, guard_value)
            if key not in labels:
                param = labels[key] = fresh()
                slots.append((param, target) if right_attached else (target, param))
            result[z] = labels[key]
    else:
        for z, target in targets.items():
            param = result[z] = fresh()
            slots.append((target, param) if z in left_attached else (param, target))

    while len(slots) < 2:
        slots.append((A, A))
    left, right = zip(*slots)
    result[x], result[y] = balanced(left), balanced(right)
    return result


def branches_for(ports, targets, guards):
    return [([(V(ports[0]), V(ports[1]))], [(V(z), c) for z, c in targets.items()])] + [
        (g, []) for g in guards]


def checked_witnesses(pattern, branches):
    names = tuple(pattern)
    eqs = r11.pattern_answer(names, tuple(pattern.values()))
    assert r11.answer(eqs, branches)
    rows = tuple(r11.round10.ground_witness(names, eqs + d) for d, _ in branches)
    hull = r11.fresh_hull(names, rows)
    assert r11.answer(r11.pattern_answer(names, hull), branches)
    return rows


def guard_partitions(names):
    for pattern in r11.flat_patterns(len(names)):
        first = {A: A, B: B}
        guard = []
        for name, label in zip(names, pattern):
            if label in first:
                guard.append((V(name), first[label]))
            else:
                first[label] = V(name)
        yield guard


def check_guard_pairs():
    # For two outputs Theorem 1 bounds the answer pattern depth by one.
    # Enumerate that space independently of the guard classification.
    ports = ('x', 'y')
    targets = {'u': A, 'v': B}
    names = ports + tuple(targets)
    guards = list(guard_partitions(names))
    active = branches_for(ports, targets, [])
    p, q = V('p'), V('q')
    leaves = (A, B, p, q) + tuple(V('t' + str(i)) for i in range(4))
    terms = leaves + tuple(F('f', l, r) for l, r in product(leaves, repeat=2))
    profiles = set()
    for left, right, u, v in product(terms, terms, (A, p), (B, q)):
        eqs = r11.pattern_answer(names, (left, right, u, v))
        if r11.answer(eqs, active):
            profiles.add(sum(1 << i for i, g in enumerate(guards)
                             if r11.unify(eqs + g) is not None))

    positive = total = 0
    for i, j in combinations_with_replacement(range(len(guards)), 2):
        pair = [guards[i], guards[j]]
        mask = (1 << i) | (1 << j)
        expected = any(profile & mask == mask for profile in profiles)
        pattern = solve(ports, targets, pair)
        assert expected == (pattern is not None), pair
        if pattern is not None:
            checked_witnesses(pattern, branches_for(ports, targets, pair))
            positive += 1
        total += 1
    print(f'PASS: {len(guards)} guard partitions, {total:,} guard pairs, '
          f'{positive:,} positive; independent depth-one pattern enumeration agrees')


def check_examples():
    x, y, u, v, z, w = map(V, ('x', 'y', 'u', 'v', 'z', 'w'))
    ports = ('x', 'y')
    targets = {'u': A, 'v': B, 'z': A, 'w': B}
    guard = [(u, B), (v, A), (z, x), (w, x)]
    pattern = solve(ports, targets, [guard])
    rows = checked_witnesses(pattern, branches_for(ports, targets, [guard]))
    assert max(map(r11.depth, pattern.values())) == 2
    assert tuple(max(map(r11.depth, row)) for row in rows) == (2, 4)
    for copied in (x, y):
        g = [(u, B), (v, A), (z, copied)]
        small = {'u': A, 'v': B, 'z': A}
        p = solve(ports, small, [g])
        checked_witnesses(p, branches_for(ports, small, [g]))
    assert solve(ports, targets, [guard, [(z, y)]]) is None
    assert solve(ports, targets, [[(u, B), (v, A), (z, x), (w, y)]]) is None
    opposite = [[(u, B), (v, A), (z, x)], [(u, B), (v, A), (w, y)]]
    checked_witnesses(solve(ports, targets, opposite), branches_for(ports, targets, opposite))
    # Extra variables project independently in each guard and can collide
    # with a generated-name prefix. Swapping both outputs forces compound ports.
    aux = V('$r13_0')
    guards = [guard + [(aux, x)], [(aux, A), (w, y)]]
    assert solve(ports, targets, guards) is None
    guards = [guard + [(aux, x)], [(aux, A)], [(x, y), (z, A)]]
    checked_witnesses(solve(ports, targets, guards), branches_for(ports, targets, guards))
    assert solve(ports, {}, [[(A, B)]]) is None
    assert solve(ports, {}, []) is not None
    print('PASS: sharp depth-four construction, both copy directions, cycles, '
          'projected variables and inconsistent guards')


def check_single_guards():
    ports = ('x', 'y')
    targets = {'u': A, 'v': B, 'z': A, 'w': B}
    total = positive = worst = 0
    for guard in guard_partitions(ports + tuple(targets)):
        pattern = solve(ports, targets, [guard])
        # Duplicating a guard uses the general packing algorithm instead.
        generic = solve(ports, targets, [guard, guard])
        assert (pattern is None) == (generic is None)
        if pattern is not None:
            positive += 1
            assert max(map(r11.depth, pattern.values())) <= 2
            rows = checked_witnesses(pattern, branches_for(ports, targets, [guard]))
            worst = max(worst, *(r11.depth(t) for row in rows for t in row))
        total += 1
    assert worst == 4
    print(f'PASS: single-guard and general constructions agree on {total:,} four-output '
          f'guards ({positive:,} positive); uniform depth four attained')


def check_depth_three():
    """Filter all triples (main port, guard x, guard y) of depth <= 3.

    Every possible family for the six-variable example is determined by that
    triple. A required parameter absent from the port comparison cannot be
    fixed by it. Bit sets apply just this necessary occurrence test before the
    independent LGG/unification check. Heap indices name ordered tree paths.
    """
    terms = r11.ground_terms(3)
    positions = {}
    main_bits = {}
    for index, term in enumerate(terms):
        by_value = {}
        pending = [(term, 1)]
        while pending:
            value, pos = pending.pop()
            by_value.setdefault(value, []).append(pos)
            if value[0] == 'f':
                pending.extend(((value[1], 2 * pos), (value[2], 2 * pos + 1)))
            else:
                key = (value, pos)
                main_bits[key] = main_bits.get(key, 0) | (1 << index)
        positions[term] = by_value

    def at_any(value, addresses):
        mask = 0
        for pos in addresses:
            mask |= main_bits.get((value, pos), 0)
        return mask

    checked = 0
    for guard_y, y_positions in positions.items():
        for guard_x, copies in y_positions.items():
            if guard_x[0] != 'f' or len(copies) < 2:
                continue
            # Columns (a,guard_x) and (b,guard_x) must occur in y.
            candidates = at_any(A, copies) & at_any(B, copies)
            # Columns (a,b) and (b,a) must occur in x or y.
            for main_value, guard_value in ((A, B), (B, A)):
                addresses = (positions[guard_x].get(guard_value, [])
                             + y_positions.get(guard_value, []))
                candidates &= at_any(main_value, addresses)
            while candidates:
                bit = candidates & -candidates
                candidates ^= bit
                main = terms[bit.bit_length() - 1]
                rows = ((main, main, A, B, A, B),
                        (guard_x, guard_y, B, A, guard_x, guard_x))
                hx, hy, *outputs = r11.lgg(rows)
                mu = r11.unify([(hx, hy)])
                assert mu is not None  # witnessed by the main row
                assert any(r11.apply(t, mu) != c for t, c in zip(outputs, (A, B, A, B)))
                checked += 1
    assert checked > 0
    print(f'PASS: all {len(terms)**3:,} depth-three witness triples excluded; '
          f'{checked:,} survive the necessary occurrence test and fail unification entailment')


def four(l, r, u, v):
    return F('f', F('f', l, r), F('f', u, v))


def check_copy_chain():
    for k in range(1, 9):
        u, v = V('u'), V('v')
        p, q = V('p'), V('q')
        pattern = {'u': p, 'v': q, 't0': four(p, q, A, B)}
        main = {'p': A, 'q': B}
        variation = {'p': B, 'q': A}
        guard = [(u, B), (v, A)]
        branches = []
        last = r11.once(pattern['t0'], variation)
        for j in range(1, k + 1):
            prev, nxt = 't' + str(j - 1), 't' + str(j)
            z, w = 'z' + str(j), 'w' + str(j)
            r, s = 'r' + str(j), 's' + str(j)
            target = [(V(z), A), (V(w), B)]
            if j == 1:
                target += [(u, A), (v, B)]
            branches.append(([(V(prev), V(nxt))], target))
            guard.extend(((V(z), V(prev)), (V(w), V(prev))))
            pattern[z], pattern[w] = V(r), V(s)
            pattern[nxt] = (four(A, B, V(r), V(s)) if j % 2
                            else four(V(r), V(s), A, B))
            main[r], main[s] = A, B
            variation[r] = variation[s] = last
            last = r11.once(pattern[nxt], variation)
        branches.append((guard, []))
        names = tuple(pattern)
        eqs = r11.pattern_answer(names, tuple(pattern.values()))
        assert r11.answer(eqs, branches)
        main_row = tuple(r11.once(term, main) for term in pattern.values())
        guard_row = tuple(r11.once(term, variation) for term in pattern.values())
        rows = (main_row,) * k + (guard_row,)
        for row, (d, c) in zip(rows, branches):
            env = dict(zip(names, row))
            assert all(r11.once(l, env) == r11.once(r, env) for l, r in d + c)
        hull = r11.fresh_hull(names, rows)
        assert r11.answer(r11.pattern_answer(names, hull), branches)
        assert max(map(r11.depth, hull)) == 2
        assert r11.depth(last) == 2 * k + 2
        assert r11.tree_size(last) == 12 * 2**k - 5
        all_nodes = set().union(*(r11.all_subterms(t) for row in (main_row, guard_row)
                                  for t in row))
        assert len(all_nodes) <= 3 * k + 8
        # Conjoining all active comparisons gives them one collective
        # obligation. The same two port patterns can now serve every stage.
        merged = [([e for d, _ in branches[:-1] for e in d],
                   [e for _, c in branches[:-1] for e in c]), (guard, [])]
        shallow = {'u': p, 'v': q}
        for j in range(1, k + 1):
            shallow['t' + str(j - 1)] = four(A, B, A, B)
            shallow['z' + str(j)] = V('r')
            shallow['w' + str(j)] = V('s')
        shallow['t' + str(k)] = four(p, q, V('r'), V('s'))
        merged_rows = checked_witnesses(shallow, merged)
        assert max(r11.depth(t) for row in merged_rows for t in row) == 4
    print('PASS: chains of 1..8 comparisons, two distinct witness rows, '
          'exact guard depths 4..18 and expanded-tree sizes; merging allows depth four')


def check_graph_construction():
    vertices = range(3)
    orders = list(permutations(vertices))
    possible = list(product(vertices, repeat=2))
    checked = 0
    for mask in range(1 << len(possible)):
        edges = [e for i, e in enumerate(possible) if mask & (1 << i)]
        if not any(all(order.index(u) < order.index(v) for u, v in edges) for order in orders):
            continue
        checked += 1
        p, q = V('p'), V('q')
        blocks = [[] for _ in vertices]
        pattern = {'u': p, 'v': q}
        guard = [(V('u'), B), (V('v'), A)]
        branches = []
        for i, (source, target) in enumerate(edges):
            x, y = V('t' + str(source)), V('t' + str(target))
            z, w = 'z' + str(i), 'w' + str(i)
            r, s = V('r' + str(i)), V('s' + str(i))
            pattern[z], pattern[w] = r, s
            branches.append(([(x, y)], [(V('u'), A), (V('v'), B), (V(z), A), (V(w), B)]))
            guard.extend(((V(z), x), (V(w), x)))
            for j in vertices:
                block = (A, B, A, B)
                if j == source:
                    block = (p, q, A, B)
                elif j == target:
                    block = (A, B, r, s)
                blocks[j].extend(block)
        for j in vertices:
            pattern['t' + str(j)] = balanced(blocks[j]) if edges else A
        checked_witnesses(pattern, branches + [(guard, [])])
    assert checked == 25
    print('PASS: graph construction supplies successful hulls for all 25 '
          'labelled acyclic directed graphs on three vertices')


if __name__ == '__main__':
    check_examples()
    check_depth_three()
    check_copy_chain()
    check_graph_construction()
    check_single_guards()
    check_guard_pairs()
