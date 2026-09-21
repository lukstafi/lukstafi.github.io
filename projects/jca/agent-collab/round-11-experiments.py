"""Reproducible finite checks for round 11 of ordinary equational JCA.

Run from any directory with Python 3.9+ (standard library only):
    python3 /path/to/round-11-experiments.py
    python3 /path/to/round-11-experiments.py --discover 10000

The imported round-10 kernel implements finite-tree unification and simultaneous
LGG. This file adds exact bounded ground-witness search, explicit UNKNOWN results,
and regression examples. A failed bounded search is never a general NO answer.
All depths count constructor edges: constants have depth 0. Terms use the fixed
signature {a/0, b/0, f/2}. Tuple encodings are meta-level, not extra constructors.

The equality-only obstruction was supplied by the round-11 flat-fragment agent;
the amplification family and shallow chain were proposed by the coordinator and
shallow-boundary agent. The two-variable depth jump was found by the deterministic
random search reproduced by --discover. These are experiments, not a proof of an
unrestricted bound, decidability, or undecidability.
"""

import argparse
from dataclasses import dataclass
from functools import lru_cache
import importlib.util
from itertools import combinations, product
from pathlib import Path
import random


_spec = importlib.util.spec_from_file_location(
    'round10', Path(__file__).with_name('round-10-experiments.py'))
round10 = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(round10)
V, F = round10.V, round10.F
is_var, variables = round10.is_var, round10.variables
apply, once, unify = round10.apply, round10.once, round10.unify
answer, lgg = round10.answer, round10.lgg
pattern_answer = round10.pattern_answer
A, B = F('a'), F('b')


@lru_cache(None)
def depth(term):
    """Ground-tree depth; parameters are treated as depth-0 leaves."""
    return 0 if is_var(term) or len(term) == 1 else 1 + max(map(depth, term[1:]))


@lru_cache(None)
def tree_size(term):
    return 1 if is_var(term) else 1 + sum(map(tree_size, term[1:]))


def all_subterms(term):
    result = {term}
    if not is_var(term):
        for child in term[1:]:
            result.update(all_subterms(child))
    return result


@lru_cache(None)
def ground_term_count(max_depth):
    """Number of terms of depth at most max_depth over the fixed signature."""
    return 0 if max_depth < 0 else (2 if max_depth == 0
                                    else 2 + ground_term_count(max_depth - 1) ** 2)


@lru_cache(None)
def ground_terms(max_depth):
    """Deterministic enumeration; callers check size before constructing it."""
    if max_depth < 0:
        return ()
    if max_depth == 0:
        return A, B
    smaller = ground_terms(max_depth - 1)
    return (A, B) + tuple(F('f', left, right)
                          for left, right in product(smaller, repeat=2))


def fresh_hull(names, rows):
    """Keep LGG parameter names disjoint from all original instance names."""
    hull = lgg(rows)
    parameters = sorted(set().union(*(variables(t) for t in hull)))
    occupied, renaming = set(names), {}
    counter = 0
    for old in parameters:
        while '$w' + str(counter) in occupied:
            counter += 1
        new = '$w' + str(counter)
        occupied.add(new)
        renaming[old] = V(new)
    return tuple(once(t, renaming) for t in hull)


@dataclass(frozen=True)
class SearchResult:
    status: str  # FOUND, UNKNOWN, or NO (only a complete negative certificate)
    reason: str
    depth_bound: int
    examined_families: int = 0
    checked_hulls: int = 0
    witness_depth: object = None
    rows: object = None
    hull: object = None
    last_branch_counts: tuple = ()


class ResourceLimit(Exception):
    pass


def _pattern(names, branch):
    premise, conclusion = branch
    mu = unify(premise + conclusion)
    return None if mu is None else tuple(apply(V(name), mu) for name in names)


def _branch_rows(pattern, max_depth, max_rows, max_domain):
    """All solutions whose coordinate terms have depth <= max_depth.

    Every residual variable occurs in the projected tuple. Its maximum admissible
    depth is the minimum remaining depth at any of its occurrences. Enumeration
    over these independent finite domains is complete, and injective on rows.
    Constructor nodes below the depth limit immediately rule out this pattern.
    """
    caps = {}

    def inspect(term, remaining):
        if remaining < 0:
            return False
        if is_var(term):
            name = term[1]
            caps[name] = min(caps.get(name, remaining), remaining)
            return True
        return all(inspect(child, remaining - 1) for child in term[1:])

    if not all(inspect(term, max_depth) for term in pattern):
        return ()
    residuals = sorted(caps)
    counts = [ground_term_count(caps[v]) for v in residuals]
    if counts and max(counts) > max_domain:
        raise ResourceLimit('a residual-variable domain exceeds max_domain')
    number = 1
    for count in counts:
        number *= count
    if number > max_rows:
        raise ResourceLimit('a branch solution set exceeds max_rows')
    domains = [ground_terms(caps[v]) for v in residuals]
    result = []
    for values in product(*domains):
        substitution = dict(zip(residuals, values))
        result.append(tuple(once(term, substitution) for term in pattern))
    assert len(result) == number
    assert all(max(map(depth, row), default=0) <= max_depth for row in result)
    return tuple(result)


def bounded_search(names, branches, max_depth=2, *, max_rows=50000,
                   max_families=1000000, max_domain=100000):
    """Search ground witness hulls through max_depth, lowest depth first.

    FOUND includes a valid answer and witnesses of the least possible maximum
    depth: all lower depths were fully checked first. UNKNOWN means no conclusion
    beyond the stated depth/resource bound. NO is returned only for inconsistent
    D_i & C_i or a rejecting ground-determined instance (round 10, Theorem 5.1).

    Resource caps are optional practical limits, not mathematical witness bounds.
    All input variables must occur in names, which must contain distinct names.
    """
    names = tuple(names)
    assert max_depth >= 0 and len(set(names)) == len(names)

    def check_signature(term):
        if is_var(term):
            return len(term) == 2 and term[1] in names
        if term in (A, B):
            return True
        return (term[0] == 'f' and len(term) == 3 and
                all(check_signature(child) for child in term[1:]))

    if not all(check_signature(t) for d, c in branches for eq in d + c for t in eq):
        raise ValueError('terms must use the fixed signature f/2,a/0,b/0 and listed variables')
    mentioned = set().union(*(variables(t) for d, c in branches
                              for eq in d + c for t in eq))
    assert mentioned <= set(names), 'names must include every instance variable'
    patterns = [_pattern(names, branch) for branch in branches]
    if any(p is None for p in patterns):
        return SearchResult('NO', 'a branch premise and conclusion are inconsistent',
                            max_depth)
    if not branches:
        return SearchResult('FOUND', 'empty branch set: top is an answer', max_depth,
                            witness_depth=0, rows=(), hull=tuple(V('$w' + str(i))
                            for i in range(len(names))))
    if all(not variables(t) for row in patterns for t in row):
        hull = fresh_hull(names, patterns)
        if not answer(pattern_answer(names, hull), branches):
            return SearchResult('NO', 'the unique ground-determined hull fails',
                                max_depth, examined_families=1, checked_hulls=1)
        required = max((depth(t) for row in patterns for t in row), default=0)
        if required > max_depth:
            return SearchResult('UNKNOWN', 'the unique witnesses exceed depth bound',
                                max_depth)
        return SearchResult('FOUND', 'the unique ground-determined hull succeeds',
                            max_depth, examined_families=1, checked_hulls=1,
                            witness_depth=required, rows=tuple(patterns), hull=hull)
    families = checks = 0
    seen = set()
    counts = ()
    for bound in range(max_depth + 1):
        try:
            domains = [_branch_rows(p, bound, max_rows, max_domain) for p in patterns]
        except ResourceLimit as exc:
            return SearchResult('UNKNOWN', str(exc) + ' at depth ' + str(bound),
                                max_depth, families, checks, last_branch_counts=counts)
        counts = tuple(map(len, domains))
        if any(n == 0 for n in counts):
            continue
        for rows in product(*domains):
            if families >= max_families:
                return SearchResult('UNKNOWN', 'max_families reached at depth ' +
                                    str(bound), max_depth, families, checks,
                                    last_branch_counts=counts)
            families += 1
            hull = fresh_hull(names, rows)
            if hull in seen:
                continue
            seen.add(hull)
            checks += 1
            if answer(pattern_answer(names, hull), branches):
                actual_depth = max((depth(t) for row in rows for t in row), default=0)
                assert actual_depth == bound
                return SearchResult('FOUND', 'accepted simultaneous witness hull',
                                    max_depth, families, checks, actual_depth,
                                    rows, hull, counts)
    return SearchResult('UNKNOWN', 'all witness families through depth bound exhausted',
                        max_depth, families, checks, last_branch_counts=counts)


def _show(result):
    return (f'{result.status}: {result.reason}; bound={result.depth_bound}, '
            f'families={result.examined_families}, hulls={result.checked_hulls}' +
            (f', minimum witness depth={result.witness_depth}'
             if result.status == 'FOUND' else ''))


def check_kernel_and_bounds():
    """Independently compare optimized MGU enumeration with raw assignments."""
    names = ('x', 'y')
    x, y = map(V, names)
    examples = [([], [(x, y)]), ([(x, F('f', y, y))], []),
                ([(x, F('f', A, y))], [(y, B)]), ([], [])]
    assignments = list(product(ground_terms(1), repeat=2))
    for branch in examples:
        pattern = _pattern(names, branch)
        generated = set(_branch_rows(pattern, 1, 100000, 100000))
        brute = {row for row in assignments
                 if all(once(left, dict(zip(names, row))) ==
                        once(right, dict(zip(names, row)))
                        for left, right in branch[0] + branch[1])}
        assert generated == brute
    negative = [([], [(x, A)]), ([], [(x, B)])]
    assert bounded_search(('x',), negative, 0).status == 'NO'
    assert bounded_search(('x',), [([], [(x, F('f', x, A))])], 0).status == 'NO'
    free = [([(x, A)], [(y, B)]), ([(x, B)], [])]
    assert bounded_search(names, free, 1, max_families=0).status == 'UNKNOWN'
    assert bounded_search(names, free, 1, max_rows=0).status == 'UNKNOWN'
    # Fresh LGG parameters must not accidentally capture an instance variable.
    captured = [([(V('h0'), A)], [(V('$w0'), A)]),
                ([(V('h0'), B)], [(V('$w0'), B)])]
    assert bounded_search(('h0', '$w0'), captured, 0).status == 'FOUND'
    print('PASS: bounded enumeration agrees with brute force; NO/UNKNOWN guards')


def check_depth_jump():
    """Each branch has depth-1 models; jointly, depth 2 is necessary/sufficient."""
    names = ('x', 'y')
    x, y = map(V, names)
    branches = [([(y, F('f', A, x))], [(x, A)]),
                ([(x, F('f', B, y))], [])]
    shallow = bounded_search(names, branches, 1)
    deeper = bounded_search(names, branches, 2)
    assert shallow.status == 'UNKNOWN' and shallow.last_branch_counts == (1, 2)
    assert deeper.status == 'FOUND' and deeper.witness_depth == 2
    assert answer([(y, F('f', A, A))], branches)
    print('PASS: shallow two-variable depth jump; ' + _show(shallow))
    print('PASS: shallow two-variable depth jump; ' + _show(deeper))


def check_flat_obstruction():
    """Equality-only input can require constructors in every pattern answer."""
    names = ('x', 'y', 'u', 'v')
    x, y, u, v = map(V, names)
    branches = [([(x, y)], [(u, A), (v, B)]),
                ([(u, B), (v, A)], [])]
    # Four coordinates need at most four parameters in a constructor-free tuple.
    leaves = (A, B) + tuple(V('p' + str(i)) for i in range(4))
    checked = 0
    for pattern in product(leaves, repeat=4):
        assert not answer(pattern_answer(names, pattern), branches)
        checked += 1
    shallow = bounded_search(names, branches, 0)
    deeper = bounded_search(names, branches, 1)
    assert shallow.status == 'UNKNOWN' and shallow.examined_families == 8
    assert deeper.status == 'FOUND' and deeper.witness_depth == 1
    p, q = V('p'), V('q')
    explicit = (F('f', p, q), F('f', A, B), p, q)
    assert answer(pattern_answer(names, explicit), branches)
    print(f'PASS: equality-only obstruction: {checked} flat patterns and '
          '8 constant-only witness families fail; constructor answer succeeds')


def unary(tag, count, tail):
    for _ in range(count):
        tail = F('f', tag, tail)
    return tail


def check_depth_amplification():
    """Exact finite lower checks for B0 y=F^h(x)->x=a; B1 x=G^k(y)->top.

    The first witness is fixed as (a,F^h(a)); the second has form (G^k(t),t).
    A joint maximum depth < h+k implies depth(t)<h. Thus enumerating all t of
    depth <=h-1 exhausts *all* putative smaller witness families, without building
    the much larger generic term domain through h+k. We test h,k=1,2,3.
    """
    names = ('x', 'y')
    x, y = map(V, names)
    rejected = 0
    for h, k in product(range(1, 4), repeat=2):
        first = (A, unary(A, h, A))
        branches = [([(y, unary(A, h, x))], [(x, A)]),
                    ([(x, unary(B, k, y))], [])]
        for term in ground_terms(h - 1):
            rows = first, (unary(B, k, term), term)
            assert not answer(pattern_answer(names, fresh_hull(names, rows)), branches)
            rejected += 1
        term = unary(A, h, A)
        rows = first, (unary(B, k, term), term)
        assert max(depth(t) for row in rows for t in row) == h + k
        assert answer(pattern_answer(names, fresh_hull(names, rows)), branches)
    # Success need not copy y1 exactly or retain its final a. Sharing can suffice.
    branches = [([(y, F('f', A, x))], [(x, A)]),
                ([(x, F('f', B, y))], [])]
    for term in (F('f', B, A), F('f', B, B)):
        rows = ((A, F('f', A, A)), (F('f', B, term), term))
        assert answer(pattern_answer(names, fresh_hull(names, rows)), branches)
    print(f'PASS: 9 amplification cases attain h+k; {rejected} smaller families '
          'exhaustively fail; exact-copy conjecture has two counterexamples')


def check_shallow_chains():
    """Shallow equations can force exponentially large expanded tree witnesses."""
    for length in range(9):
        names = tuple('x' + str(i) for i in range(length + 1))
        xs = tuple(map(V, names))
        chain = [(xs[i], F('f', xs[i-1], xs[i-1])) for i in range(1, length + 1)]
        branches = [(chain + [(xs[0], atom)], []) for atom in (A, B)]
        result = bounded_search(names, branches, length)
        assert result.status == 'FOUND' and result.witness_depth == length
        expanded = sum(tree_size(term) for row in result.rows for term in row)
        dag_nodes = len(set().union(*(all_subterms(t) for row in result.rows for t in row)))
        assert expanded == 2 ** (length + 3) - 2 * length - 6
        assert dag_nodes == 2 * (length + 1)
        if length:
            assert bounded_search(names, branches, length - 1).status == 'UNKNOWN'
    print('PASS: shallow chains 0..8; exact tree-size formula and linear DAG count')


def check_constant_premise_fragment():
    """All 3,969 two-variable cases in a precisely bounded fragment.

    A premise is any consistent partial assignment of x,y to a,b (9 choices).
    A conclusion is top or one equation among x,y,a,b (7 choices). Enumerate
    400 tuple patterns of depth <=1 using parameters p,q; every accepted one
    remains an answer after f-rooted coordinates are replaced by a. Finally
    compare existence in this candidate family with exact binary witness search.
    This finite agreement is evidence, not a completeness proof for the fragment.
    """
    names = ('x', 'y')
    x, y = map(V, names)
    premises = [[(v, value) for v, value in zip((x, y), assignments)
                 if value is not None]
                for assignments in product((None, A, B), repeat=2)]
    conclusions = [[]] + [[eq] for eq in combinations((x, y, A, B), 2)]
    branch_options = list(product(premises, conclusions))
    leaves = (A, B, V('p'), V('q'))
    terms = leaves + tuple(F('f', left, right)
                           for left, right in product(leaves, repeat=2))
    patterns = tuple(product(terms, repeat=2))
    accepted_masks = []
    collapse_checks = 0
    for branch in branch_options:
        mask = 0
        for index, pattern in enumerate(patterns):
            if not answer(pattern_answer(names, pattern), [branch]):
                continue
            collapsed = tuple(A if t[0] == 'f' else t for t in pattern)
            assert answer(pattern_answer(names, collapsed), [branch])
            collapse_checks += 1
            mask |= 1 << index
        accepted_masks.append(mask)
    solvable = 0
    for i, j in product(range(len(branch_options)), repeat=2):
        constructor_found = bool(accepted_masks[i] & accepted_masks[j])
        binary_found = bounded_search(names, [branch_options[i], branch_options[j]],
                                      max_depth=0).status == 'FOUND'
        assert constructor_found == binary_found
        solvable += binary_found
    print(f'PASS: 3969 constant-premise instances: {solvable} binary-witness '
          f'successes agree with 400 candidate patterns; '
          f'{collapse_checks} accepted single-branch collapses retain validity')


def flat_patterns(coordinates):
    """All tuples over a,b and parameters, once each up to parameter renaming."""
    def build(prefix, used):
        if len(prefix) == coordinates:
            yield tuple(prefix)
            return
        for leaf in (A, B) + tuple(V('p' + str(i)) for i in range(used)):
            yield from build(prefix + [leaf], used)
        yield from build(prefix + [V('p' + str(used))], used + 1)
    yield from build([], 0)


@dataclass(frozen=True)
class FragmentDecision:
    status: str  # FOUND or NO after complete search; UNKNOWN only at resource cap
    reason: str
    examined_patterns: int = 0
    rows: object = None
    hull: object = None


def constant_test_decide(names, branches, *, max_patterns=None):
    """Complete decider for constant-test premises / constructor-free conclusions.

    Premise atoms must be variable=a/b (either orientation) or constant=constant.
    Conclusion atoms must equate variables and/or a,b. Unsupported syntax raises
    ValueError; it is never silently processed under the restricted theorem.

    By the round-11 constructor-collapse theorem, this fragment has an answer
    iff it has a flat pattern. All flat patterns on n coordinates use at most n
    parameters; canonical enumeration below is therefore finite and complete.
    The default has no resource cap. A caller-supplied cap may return UNKNOWN.
    A FOUND result is strengthened to and checked as a binary witness hull.
    """
    names = tuple(names)
    if len(set(names)) != len(names):
        raise ValueError('instance variable names must be distinct')
    allowed = set(names)

    def simple(term):
        return term in (A, B) or (is_var(term) and term[1] in allowed)

    for premise, conclusion in branches:
        for left, right in premise:
            if (not simple(left) or not simple(right) or
                    (is_var(left) and is_var(right))):
                raise ValueError('outside fragment: premise is not a constant test')
        for left, right in conclusion:
            if not simple(left) or not simple(right):
                raise ValueError('outside fragment: conclusion is not constructor-free')
    if max_patterns is not None and max_patterns < 0:
        raise ValueError('max_patterns must be nonnegative or None')
    if any(unify(d + c) is None for d, c in branches):
        return FragmentDecision('NO', 'a branch premise and conclusion are inconsistent')
    if not branches:
        return FragmentDecision('FOUND', 'no branches: every pattern is an answer',
                                rows=(), hull=tuple(A for _ in names))
    checked = 0
    for pattern in flat_patterns(len(names)):
        if max_patterns is not None and checked >= max_patterns:
            return FragmentDecision('UNKNOWN', 'max_patterns resource cap reached', checked)
        checked += 1
        # Canonical generator uses p0,p1,...; rename in case input uses those names.
        parameters = sorted(set().union(*(variables(t) for t in pattern)))
        occupied = set(names)
        rename = {}
        for old in parameters:
            new = '$flat' + str(len(rename))
            while new in occupied:
                new += '_'
            occupied.add(new)
            rename[old] = V(new)
        pattern = tuple(once(t, rename) for t in pattern)
        eqs = pattern_answer(names, pattern)
        if not answer(eqs, branches):
            continue
        rows = tuple(round10.ground_witness(names, eqs + d) for d, _ in branches)
        assert all(t in (A, B) for row in rows for t in row)
        hull = fresh_hull(names, rows)
        assert answer(pattern_answer(names, hull), branches)
        return FragmentDecision('FOUND', 'accepted binary witness hull', checked, rows, hull)
    return FragmentDecision('NO', 'all canonical flat patterns rejected in the '
                            'constant-test fragment', checked)


def coloring_instance(vertices, edges):
    """The explicit graph-3-colorability reduction audited in round 11."""
    names = tuple('c' + str(i) for i in range(3)) + tuple(
        'x' + str(i) for i in range(vertices))
    anchors = tuple(map(V, names[:3]))
    xs = tuple(map(V, names[3:]))
    branches = [([(c, A) for c in anchors], [(x, A) for x in xs]),
                ([(x, B) for x in xs], [])]
    branches += [([(xs[u], A), (xs[v], B)], []) for u, v in edges]
    return names, branches


def check_coloring_reduction():
    """All 76 labeled simple graphs with 0..4 vertices, including K3 and K4.

    Independently enumerate colorings and *all* canonical flat answer tuples.
    Filter flat patterns against the two common branches, then cache the edge
    branches each satisfies. This avoids repeating the same unification tests
    for each graph. It is an exhaustive flat-answer check, not a restatement of
    the coloring test. Positive certificates additionally undergo witness-LGG
    verification using one ground witness per branch.
    """
    graphs = positive = patterns_checked = k4_patterns = 0
    for vertices in range(5):
        possible_edges = tuple(combinations(range(vertices), 2))
        names, base = coloring_instance(vertices, ())
        edge_branches = [coloring_instance(vertices, [edge])[1][-1]
                         for edge in possible_edges]
        candidates = []
        for pattern in flat_patterns(len(names)):
            patterns_checked += 1
            if vertices == 4:
                k4_patterns += 1
            eqs = pattern_answer(names, pattern)
            if not answer(eqs, base):
                continue
            mask = sum(1 << i for i, branch in enumerate(edge_branches)
                       if answer(eqs, [branch]))
            candidates.append((pattern, mask))
        for graph in range(1 << len(possible_edges)):
            edges = tuple(edge for i, edge in enumerate(possible_edges)
                          if graph & (1 << i))
            colorable = any(all(colors[u] != colors[v] for u, v in edges)
                            for colors in product(range(3), repeat=vertices))
            flat = next((p for p, mask in candidates if mask & graph == graph), None)
            assert (flat is not None) == colorable
            if flat is not None:
                _, branches = coloring_instance(vertices, edges)
                eqs = pattern_answer(names, flat)
                rows = tuple(round10.ground_witness(names, eqs + d)
                             for d, _ in branches)
                assert all(t in (A, B) for row in rows for t in row)
                assert answer(pattern_answer(names, fresh_hull(names, rows)), branches)
                positive += 1
            graphs += 1
    assert (graphs, positive, patterns_checked, k4_patterns) == (76, 75, 21132, 17007)
    names3, branches3 = coloring_instance(3, tuple(combinations(range(3), 2)))
    names4, branches4 = coloring_instance(4, tuple(combinations(range(4), 2)))
    assert constant_test_decide(names3, branches3).status == 'FOUND'
    negative = constant_test_decide(names4, branches4)
    assert negative.status == 'NO' and negative.examined_patterns == 17007
    assert constant_test_decide(names4, branches4, max_patterns=10).status == 'UNKNOWN'
    try:
        constant_test_decide(('x', 'y'), [([(V('x'), V('y'))], [])])
    except ValueError:
        pass
    else:
        raise AssertionError('the constant-test decider accepted a variable equality')
    print('PASS: 3-coloring reduction on all 76 graphs with 0..4 vertices; '
          '21132 canonical flat tuples checked; K3 succeeds, all 17007 K4 '
          'flat tuples fail; 75 binary witness certificates verified; '
          'restricted decider returns FOUND/NO/UNKNOWN and rejects unsupported syntax')


def discover(trials):
    """Optional deterministic search; reports observations, not a global claim.

    Draw two branches with one premise/conclusion equation each, from all distinct
    unordered pairs of shallow terms on x,y,a,b. Search only satisfiable branches
    having individual depth-1 models. Stop at the first depth-1 UNKNOWN/depth-2
    FOUND instance. Seed 111 reproduces the initial discovery at trial 6601.
    """
    names = ('x', 'y')
    x, y = map(V, names)
    leaves = (x, y, A, B)
    terms = leaves + tuple(F('f', left, right) for left, right in product(leaves, repeat=2))
    equations = list(combinations(terms, 2))
    rng = random.Random(111)
    viable = shallow_failed = 0
    for trial in range(1, trials + 1):
        branches = [([rng.choice(equations)], [rng.choice(equations)]) for _ in range(2)]
        patterns = [_pattern(names, branch) for branch in branches]
        if any(p is None for p in patterns):
            continue
        viable += 1
        if any(not _branch_rows(p, 1, 50000, 100000) for p in patterns):
            continue
        lower = bounded_search(names, branches, 1)
        if lower.status != 'UNKNOWN':
            continue
        shallow_failed += 1
        higher = bounded_search(names, branches, 2)
        if higher.status == 'FOUND':
            print(f'DISCOVERY at trial {trial}; viable={viable}; '
                  f'shallow failures={shallow_failed}: {branches!r}')
            print(_show(higher))
            return
    print(f'UNKNOWN: no depth jump found in {trials} random trials; '
          f'viable={viable}; shallow failures={shallow_failed}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--discover', type=int, default=0,
                        help='additional deterministic random trials (default: none)')
    args = parser.parse_args()
    check_kernel_and_bounds()
    check_depth_jump()
    check_flat_obstruction()
    check_depth_amplification()
    check_shallow_chains()
    check_constant_premise_fragment()
    check_coloring_reduction()
    if args.discover:
        discover(args.discover)


if __name__ == '__main__':
    main()
