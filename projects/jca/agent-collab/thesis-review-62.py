"""Decide rational polyhedral typability in a supplied common isometry frame.

A field is (O, r), acting by (p,t) -> (O p,r t). A guard (a,c) means
a.p <= c+t. Supply a nonempty caller in vertex/ray form, using both
signs for a line. The standalone decision and examples use only Python.
"""
from argparse import ArgumentParser
from collections import deque
from fractions import Fraction as F
from itertools import product
from math import isqrt
from pathlib import Path


def dot(x, y):
    return sum((a*b for a, b in zip(x, y, strict=True)), F(0))


def transpose(m):
    return tuple(zip(*m, strict=True))


def mv(m, v):
    return tuple(dot(row, v) for row in m)


def mm(a, b):
    return tuple(mv(transpose(b), row) for row in a)


def identity(n):
    return tuple(tuple(F(i == j) for j in range(n)) for i in range(n))


def linear_solutions(rows, rhs, n):
    """Particular solution and a basis of the homogeneous kernel, or None."""
    aug = [list(map(F, x))+[F(b)] for x, b in zip(rows, rhs, strict=True)]
    pivots = []
    for col in range(n):
        i = len(pivots)
        j = next((j for j in range(i, len(aug)) if aug[j][col]), None)
        if j is None:
            continue
        aug[i], aug[j] = aug[j], aug[i]
        aug[i] = [v/aug[i][col] for v in aug[i]]
        for j, row in enumerate(aug):
            if j != i and row[col]:
                aug[j] = [v-row[col]*u for v, u in zip(row, aug[i])]
        pivots.append(col)
    if any(row[-1] for row in aug[len(pivots):]):
        return None
    base = [F(0)]*n
    for j, row in zip(pivots, aug):
        base[j] = row[-1]
    kernel = []
    for k in sorted(set(range(n))-set(pivots)):
        v = [F(i == k) for i in range(n)]
        for j, row in zip(pivots, aug):
            v[j] = -row[k]
        kernel.append(tuple(v))
    return tuple(base), kernel


def coordinates(v, basis):
    """Coefficients in an independent basis, or None outside its span."""
    if not basis:
        return None if any(v) else ()
    solution = linear_solutions(transpose(basis), v, len(basis))
    return solution[0] if solution is not None else None


def span(seeds, maps):
    basis = []
    todo = deque(seeds)
    while todo:
        v = todo.popleft()
        if coordinates(v, basis) is None:
            basis.append(v)
            todo.extend(mv(m, v) for m in maps)
    return basis


def inverse(m):
    return tuple(coordinates(e, m) for e in identity(len(m)))


def positive_definite(m):
    if transpose(m) != m:
        return False
    while m:
        pivot = m[0][0]
        if pivot <= 0:
            return False
        m = tuple(tuple(x-a[0]*b/pivot for x, b in zip(a[1:], m[0][1:])) for a in m[1:])
    return True


def reduction_prime(maps):
    denominators = [x.denominator for m in maps for a in (m, inverse(m)) for row in a for x in row]
    p = 3
    while any(p % j == 0 for j in range(2, 1 + isqrt(p))) or any(d % p == 0 for d in denominators):
        p += 2
    return p


def residue(m, p):
    return tuple(x.numerator * pow(x.denominator, -1, p) % p for row in m for x in row)


def finite_orbit_subspace(maps):
    """All finite-orbit vectors satisfy rows.y=0. Their orbit is {g.y | g in reps}."""
    n = len(maps[0])
    p = reduction_prime(maps)
    unit = identity(n)
    seen = {residue(unit, p): unit}
    todo = deque([unit])
    equations = []
    while todo:
        g = todo.popleft()
        for h in maps:
            gh = mm(h, g)
            key = residue(gh, p)
            if key in seen:
                for a, b in zip(gh, seen[key]):
                    row = tuple(x-y for x, y in zip(a, b))
                    if coordinates(row, equations) is None:
                        equations.append(row)
                        if len(equations) == n:
                            return equations, (unit,)  # Only zero can have finite orbit.
            else:
                seen[key] = gh
                todo.append(gh)
    return equations, tuple(seen.values())


def finite_orbit(y, maps):
    """Return the exact orbit, or None on an infinite-order congruence collision."""
    basis = span([y], maps)
    if not basis:
        return {y}
    action = [transpose(tuple(coordinates(mv(m, b), basis) for b in basis)) for m in maps]
    p = reduction_prime(action)

    unit = identity(len(basis))
    seen = {residue(unit, p): unit}
    todo = deque([unit])
    while todo:
        g = todo.popleft()
        for h in action:
            gh = mm(h, g)
            key = residue(gh, p)
            if key in seen:
                if seen[key] != gh:
                    return None
            else:
                seen[key] = gh
                todo.append(gh)
    # y is the first cyclic basis vector.
    return {mv(transpose(basis), tuple(row[0] for row in g)) for g in seen.values()}


def observable(metric, fields, guards):
    metric = tuple(tuple(map(F, row)) for row in metric)
    fields = [(tuple(tuple(map(F, row)) for row in m), F(r)) for m, r in fields]
    guards = [(tuple(map(F, a)), F(c)) for a, c in guards]
    assert fields and guards and positive_definite(metric)
    assert all(mm(transpose(m), mm(metric, m)) == metric for m, _ in fields)
    assert all(len(a) == len(metric) for a, _ in guards)
    raw = [m for m, _ in fields]
    b = span((a for a, _ in guards), [transpose(m) for m in raw])
    maps = [tuple(coordinates(mv(transpose(m), a), b) for a in b) for m in raw]
    rates = [r for _, r in fields]
    guards = [(coordinates(a, b), c) for a, c in guards]
    dual = mm(b, mm(inverse(metric), transpose(b))) if b else ()
    primal = inverse(dual)
    return b, maps, rates, guards, dual, primal


def decide(metric, fields, guards, vertices, rays=()):
    """Return (status, field word). A guard failure on a ray uses intercept zero."""
    assert vertices
    b, maps, rates, guards, dual, primal = observable(metric, fields, guards)
    assert min(rates) > 1
    checked_guards = [(a, c, dot(a, mv(dual, a))) for a, c in guards]
    for family, lam in ((vertices, 1), (rays, 0)):
        for p, t in family:
            assert len(p) == len(metric)
            y, t = mv(b, p), F(t)
            if t < 0:
                return 'negative slack', None
            if t == 0:
                orbit = finite_orbit(y, maps)
                if orbit is None:
                    return 'infinite observable orbit', None
                if any(dot(a, v) > c*lam for v in orbit for a, c in guards):
                    return 'zero-slack guard failure', None
                continue
            q = dot(y, mv(primal, y))
            lower = t
            frontier = {(y, t): ()}
            while any(c*lam+lower < 0 or (c*lam+lower)**2 < n*q for _, c, n in checked_guards):
                children = {}
                for (v, s), w in frontier.items():
                    if any(dot(a, v) > c*lam+s for a, c in guards):
                        return 'guard failure', w
                    for i, (m, r) in enumerate(zip(maps, rates)):
                        children.setdefault((mv(m, v), r*s), (*w, i))
                frontier = children
                lower *= min(rates)
    return 'typable', None


def determinant(matrix):
    m = [list(map(F, row)) for row in matrix]
    det = F(1)
    for i in range(len(m)):
        j = next((j for j in range(i, len(m)) if m[j][i]), None)
        if j is None:
            return F(0)
        if j != i:
            det = -det
            m[i], m[j] = m[j], m[i]
        det *= m[i][i]
        for j in range(i+1, len(m)):
            coef = m[j][i]/m[i][i]
            m[j] = [a-coef*b for a, b in zip(m[j], m[i])]
    return det


def common_metric(maps, n):
    """Get a rational invariant positive form, using exact real feasibility."""
    import z3
    if n == 0:
        return ()
    positions = [(i, j) for i in range(n) for j in range(i, n)]
    entries = [[positions.index(tuple(sorted((i, j)))) for j in range(n)] for i in range(n)]
    def matrix(v):
        return tuple(tuple(v[k] for k in row) for row in entries)
    errors = []
    for v in identity(len(positions)):
        q = matrix(v)
        moved = [mm(transpose(m), mm(q, m)) for m in maps]
        errors.append(tuple(g[i][j]-q[i][j] for g in moved for i, j in positions))
    eqs = transpose(errors)
    _, forms = linear_solutions(eqs, [0]*len(eqs), len(positions))
    if not forms:
        return None
    # The invariant forms are a rational linear space. Cholesky feasibility
    # tests whether it meets the open positive cone.
    coeff = [z3.Real(f'coef_{i}') for i in range(len(forms))]
    q = matrix([sum(z3.RealVal(str(b[j]))*u for b, u in zip(forms, coeff)) for j in range(len(positions))])
    l = [[z3.Real(f'l_{i}_{j}') for j in range(i+1)] for i in range(n)]
    solver = z3.SolverFor('QF_NRA')
    solver.add(*(l[i][i] > 0 for i in range(n)))
    solver.add(*(q[i][j] == sum(l[i][k]*l[j][k] for k in range(i+1)) for i, j in positions))
    result = solver.check()
    if result == z3.unsat:
        return None
    assert result == z3.sat, solver.reason_unknown()
    values = [solver.model().eval(c, model_completion=True) for c in coeff]
    precision = 4
    while True:
        rational = [v.approx(precision) if z3.is_algebraic_value(v) else v for v in values]
        coeffs = [F(v.numerator_as_long(), v.denominator_as_long()) for v in rational]
        q = matrix(mv(transpose(forms), coeffs))
        if positive_definite(q):
            return q
        precision *= 2


def recover(affine_fields, raw_guards):
    """Recognize simultaneous affine conjugacy to the expanding isometry class.

    Return (metric, fields, guards, transform) or None. transform(v, is_ray)
    translates points and applies only the linear change to recession vectors.
    """
    n = len(raw_guards[0][0])
    rates = [abs(determinant(m)) for m, _ in affine_fields]
    if min(rates) < 1 or max(rates) == 1:
        return None
    eye = identity(n)
    def kernel(transposed):
        rows = [tuple(x-r*y for x, y in zip(a, e))
                for (m, _), r in zip(affine_fields, rates)
                for a, e in zip(transpose(m) if transposed else m, eye)]
        return linear_solutions(rows, [0]*len(rows), n)[1]
    eig, dual = kernel(False), kernel(True)
    if len(eig) != 1 or len(dual) != 1 or not dot(eig[0], dual[0]):
        return None
    return realize_frame(affine_fields, raw_guards, eig[0], dual[0], rates)


def realize_frame(affine_fields, raw_guards, axis, covector, rates):
    n = len(axis)
    eye = identity(n)
    slopes = [-dot(a, axis) for a, _ in raw_guards]
    if all(k < 0 for k in slopes):
        axis = tuple(-v for v in axis)
        slopes = [-k for k in slopes]
    if min(slopes) <= 0:
        return None
    rows = [tuple(y-x for x, y in zip(a, e)) for m, _ in affine_fields for a, e in zip(m, eye)]
    fixed = linear_solutions(rows, [v for _, d in affine_fields for v in d], n)
    if fixed is None:
        return None
    center = fixed[0]
    _, plane = linear_solutions([covector], [0], n)
    fields = []
    for (m, _), r in zip(affine_fields, rates):
        columns = [coordinates(mv(m, b), plane) for b in plane]
        if None in columns:
            return None
        fields.append((transpose(columns), r))
    metric = common_metric([m for m, _ in fields], n-1)
    if metric is None:
        return None
    guards = [(tuple(dot(a, b)/k for b in plane), (c-dot(a, center))/k)
              for (a, c), k in zip(raw_guards, slopes)]
    def transform(p, is_ray=False):
        delta = p if is_ray else tuple(x-y for x, y in zip(p, center))
        entry = coordinates(delta, [*plane, axis])
        return entry[:-1], entry[-1]
    return metric, fields, guards, transform


def certificate(metric, fields, guards, vertices, rays):
    """Generate a V-representation of a covering invariant on a successful input."""
    b, maps, rates, guards, dual, primal = observable(metric, fields, guards)
    assert min(rates) > 1
    n = len(b)
    bound2 = max((dual[i][i] for i in range(n)), default=F(0))*sum(abs(v) for row in primal for v in row)
    K = 1
    while K*K < bound2:
        K *= 2
    side = F(1, 2*K*max(1, max(sum(map(abs, a)) for a, _ in guards)))
    height = max(1, max(-2*c for _, c in guards))
    corners = {(*v, F(1), lam) for v in product((-side, side), repeat=n) for lam in (F(0), F(1, height))}
    def child(m, r, v):
        return (*mv(m, v[:-2]), r*v[-2], v[-1])
    def children(v):
        return (child(m, r, v) for m, r in zip(maps, rates))
    def in_box(v):
        return v[-2] >= height*v[-1] and all(abs(x) <= side*v[-2] for x in v[:-2])
    # Take the conic hull of early images of an inner box. The box is
    # small enough that every transient image satisfies the actual guard.
    columns = set(corners)
    frontier, gain = corners, min(rates)
    while gain < K:
        frontier = {w for v in frontier for w in children(v)}
        columns.update(frontier)
        gain *= min(rates)
    callers = [(*mv(b, p), F(t), F(lam)) for family, lam in ((vertices, 1), (rays, 0)) for p, t in family]
    todo = deque(callers)
    while todo:
        v = todo.popleft()
        assert v[-2] >= 0
        if v in columns or in_box(v):
            continue
        if v[-2] == 0:
            orbit = finite_orbit(v[:-2], maps)
            assert orbit is not None
            columns.update((*y, F(0), v[-1]) for y in orbit)
        else:
            columns.add(v)
            todo.extend(children(v))
    assert all(dot(a, v[:-2]) <= c*v[-1]+v[-2] for a, c in guards for v in columns)
    return sorted(columns), callers, lambda v: tuple(children(v))


def certificate_example():
    """Recover rational nonnegative child coefficients and replay every equality."""
    import z3
    h = ((F(7,9), F(-8,9), 0), (F(4,9), F(7,9), 0), (0, 0, -1))
    reflect = ((1,0,0), (0,-1,0), (0,0,-1))
    q = ((1,0,0), (0,2,0), (0,0,1))
    fields = [(h, 4), (reflect, 3)]
    guards = [((1,0,1), 1), ((0,0,-1), 1)]
    vertices = [((0,0,1), 0), ((0,2,0), 1)]
    rays = [((1,0,0), 1)]
    assert decide(q, fields, guards, vertices, rays)[0] == 'typable'
    columns, callers, children = certificate(q, fields, guards, vertices, rays)
    rows = transpose(columns)
    coeff = [z3.Real(f'weight_{i}') for i in range(len(columns))]
    solver = z3.SolverFor('QF_LRA')
    solver.add(*(v >= 0 for v in coeff))
    sums = [sum(z3.RealVal(str(x))*v for x, v in zip(row, coeff) if x) for row in rows]
    cache = set(columns)  # A unit vector opens each of the original columns.
    def open_point(v):
        if v in cache:
            return
        solver.push()
        solver.add(*(s == z3.RealVal(str(x)) for s, x in zip(sums, v)))
        assert solver.check() == z3.sat
        model = solver.model()
        values = [model.eval(x, model_completion=True).as_fraction() for x in coeff]
        assert min(values) >= 0 and mv(rows, values) == v
        solver.pop()
        cache.add(v)
    for v in callers:
        open_point(v)
    for v in columns:
        for w in children(v):
            open_point(w)
    print(f'{len(columns)} homogeneous columns: exact child witnesses for both fields and all three caller generators.')


def recognition_examples():
    rotation = ((F(7,9), F(-8,9), 0), (F(4,9), F(7,9), 0), (0, 0, F(65,64)))
    back = ((F(7,9), F(8,9), 0), (F(-4,9), F(7,9), 0), (0, 0, 2))
    p = ((1,1,1), (0,1,1), (0,0,-1))
    pinv = inverse(p)
    center = (3, -4, 2)
    fields = []
    for m in (rotation, back):
        a = mm(p, mm(m, pinv))
        fields.append((a, tuple(u-v for u, v in zip(center, mv(a, center)))))
    raw = []
    for normal, c in (((1,0,-1), 1), ((0,1,-3), 2)):
        a = mv(transpose(pinv), normal)
        raw.append((a, c+dot(a, center)))
    answer = recover(fields, raw)
    assert answer is not None
    q, moves, guards, transform = answer
    def caller(u):
        return transform(tuple(x+c for x, c in zip(mv(p, u), center)))
    v = [caller((F(-51,25), 0, 1)), caller((0, 0, 0))]
    ray = [transform(mv(p, (F(-26,25), 0, 1)), True)]
    assert decide(q, moves, guards, v, ray)[0] == 'typable'
    assert decide(q, moves, guards, [caller((F(1,4), 0, 0))])[0] == 'infinite observable orbit'
    neutral_m = ((F(7,9), F(-8,9), 0), (F(4,9), F(7,9), 0), (0,0,1))
    a = mm(p, mm(neutral_m, pinv))
    mixed = recover([*fields, (a, tuple(u-v for u,v in zip(center, mv(a,center))))], raw)
    assert mixed is not None and min(r for _, r in mixed[1]) == 1
    assert recover(fields, [*raw, (tuple(-x for x in raw[0][0]), 3)]) is None
    shear = ((1,1,0), (0,1,0), (0,0,2))
    assert recover([(shear, (0,0,0))], [((1,0,-1), 1)]) is None
    assert recover([(rotation, (0,0,0)), (rotation, (1,0,0))], [((1,0,-1), 1)]) is None
    print('Recovered the shared frame from two translated affine fields and two guards; rejected all three controls.')


def examples():
    rotation = ((F(7, 9), F(-8, 9)), (F(4, 9), F(7, 9)))
    hexagon = ((F(1, 2), F(-3, 2)), (F(1, 2), F(1, 2)))
    hex_fields = [(hexagon, F(6, 5)), (inverse(hexagon), 9)]
    metric = ((1, 0), (0, 3))
    guard = [((1, 0), 1)]
    assert decide(metric, hex_fields, guard, [((1, 0), 0)]) == ('typable', None)
    assert decide(metric, hex_fields, guard, [((2, 2), 1)]) == ('guard failure', (0,)*5)
    assert decide(metric, hex_fields, guard, [((1, 0), 0)], [((1, 0), 0)])[0] == 'zero-slack guard failure'
    # A binary rotation/reflection group of order twelve. Its orbit on this
    # generic vector has twelve elements, including orientations of both signs.
    reflect = ((F(1), F(0)), (F(0), F(-1)))
    assert len(finite_orbit((F(1), F(2)), [hexagon, reflect])) == 12

    # Dense rotation, sign change, fixed offset. Change the public basis
    # so that the three invariant summands are no longer coordinate blocks.
    p = ((1, 1, 1, 0), (0, 1, 0, 1), (0, 0, 1, 1), (0, 0, 0, 1))
    pinv = inverse(p)
    block = ((*rotation[0], 0, 0), (*rotation[1], 0, 0), (0, 0, -1, 0), (0, 0, 0, 1))
    q = ((1, 0, 0, 0), (0, 2, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1))
    oblique = mm(p, mm(block, pinv))
    shape = mm(transpose(pinv), mm(q, pinv))
    rows, representatives = finite_orbit_subspace([oblique])
    assert len(rows) == 2
    for x, y, z, f in product((-1, 0, 1), repeat=4):
        v = mv(p, (x, y, z, f))
        finite = all(dot(row, v) == 0 for row in rows)
        assert finite == (x == y == 0)
        expected = finite_orbit(v, [oblique])
        assert expected == ({mv(g, v) for g in representatives} if finite else None)
    # Two reflections are individually periodic and their product rotates densely.
    h = ((F(7,9), F(8,9)), (F(4,9), F(-7,9)))
    rows, _ = finite_orbit_subspace([h, reflect])
    assert len(rows) == 2 and finite_orbit((F(1), F(0)), [h, reflect]) is None

    def query(a, v, rays=(), c=1):
        return decide(shape, [(oblique, 2)], [(mv(transpose(pinv), a), c)],
                      [(mv(p, x), t) for x, t in v], [(mv(p, x), t) for x, t in rays])[0]

    all_axes = (1, 0, 1, 1)
    assert query(all_axes, [((0, 0, 1, 0), 0), ((0, 3, 0, 0), 4)],
                 [((0, 0, 1, -1), 0), ((0, 2, 0, 0), 2)]) == 'typable'
    assert query(all_axes, [((F(1, 4), 0, 0, 0), 0)]) == 'infinite observable orbit'
    assert query(all_axes, [((0, 0, 0, 0), 0)], [((1, 0, 0, -10), 0)]) == 'infinite observable orbit'
    assert query((0, 0, 1, 1), [((1, 0, 1, 0), 0)],
                 [((1, 0, 0, 0), 0), ((-1, 0, 0, 0), 0)]) == 'typable'
    assert query(all_axes, [((0, 0, 0, 0), -1)]) == 'negative slack'
    assert query((0, 0, 0, 0), [((17, -1, 1, 0), 1)], c=-2) == 'guard failure'
    assert query((0, 0, 0, 0), [((17, -1, 1, 0), 2)], c=-2) == 'typable'

    # Cross-check against the explicit seven-inequality hexagonal answer.
    normal = (F(1), F(0))
    exact = []
    for k in range(6):
        exact.append((normal, F(6, 5)**k))
        normal = mv(transpose(hexagon), normal)
    tested = 0
    for x, y, t, lam in product(range(-2, 3), range(-2, 3), (-1, 0, 1, 2), (0, 1)):
        want = t >= 0 and all(dot(a, (x, y)) <= lam+r*t for a, r in exact)
        point = [((x, y), t)]
        got = decide(metric, hex_fields, guard, point if lam else [((0, 0), 0)], [] if lam else point)
        assert (got[0] == 'typable') == want, (x, y, t, lam, got)
        tested += 1
    print(f'Exact decision agreed on {tested} vertex and ray callers, including zero and negative slack.')
    return hex_fields, exact


def caller_policy_example():
    """Check global affine openings from the public point in a fixed vertex lift."""
    import z3
    corners = [(0,0,1), (0,1,1), (1,0,1), (1,1,1)]
    policy = [[z3.Real(f'a_{i}_{j}') for j in range(3)] for i in range(4)]
    def feasible(generators):
        solver = z3.SolverFor('QF_LRA')
        for u in generators:
            weights = [sum(k*x for k,x in zip(row, u)) for row in policy]
            solver.add(*(w >= 0 for w in weights))
            for row, value in zip(transpose(corners), u):
                solver.add(sum(a*w for a,w in zip(row,weights)) == value)
        return solver.check()
    assert feasible(corners) == z3.unsat
    assert all(feasible([corners[i] for i in tri]) == z3.sat for tri in [(0,1,3), (0,2,3)])
    print('Public affine openings exist on both caller triangles and fail on their whole square.')


SQUARE = """datatype Square : num * num
datacons Fork : ∀i,j[0≤i ∧ i≤1 ∧ 0≤j ∧ j≤1]. Square (1 + -1 j,i) * Square (1/2 i + 1/2 j,1/2 i + 1/2 j) ⟶ Square (i,j)
let rec square : ∀i,j,k0,k1,k2,k3[0≤k0 ∧ 0≤k1 ∧ 0≤k2 ∧ 0≤k3 ∧ 1=k0+k1+k2+k3 ∧ i=k2+k3 ∧ j=k1+k3]. Square (i,j) = Fork (square,square)
let box : ∀i,j[0≤i ∧ i≤1 ∧ 0≤j ∧ j≤1]. Square (i,j) = square
"""


def native(exe, hex_fields, exact):
    from tempfile import TemporaryDirectory
    import runpy
    import z3
    lib = runpy.run_path(str(Path(__file__).with_name('thesis-review-61.py')))
    z, check = lib['z'], lib['check']
    build, signature, scheme = lib['native'], lib['signature'], lib['scheme']
    rot = lib['ROTATION']
    backwards = (*lib['BACKWARD'][:4], F(2))
    with TemporaryDirectory() as folder:
        p = Path(folder)/'node.gadt'
        def source(fields, callers, oblique=False):
            return lib['weighted_source'](oblique, fields).split('let root')[0]+callers+'\n'
        square = build(exe, p, SQUARE, ml=True)
        assert 'Square' in signature(square, 'box')
        build(exe, p, SQUARE+'let outside : Square (2,0) = square\n', ok=False)
        fields = [(*m[0], *m[1], r) for m, r in hex_fields]
        src = source(fields, 'let edge : Node (1,0,0) = alias')
        result = build(exe, p, src)
        for name in ('node', 'alias'):
            pub, rows = scheme(signature(result, name))
            x, y, t = z3.Reals('x y t')
            actual = lib['constraints'](rows, dict(zip(pub, (x, y, t))))
            expected = z3.And(t >= 0, *(z(a)*x+z(b)*y <= 1+z(r)*t for (a, b), r in exact))
            check(z3.unsat, z3.Xor(actual, expected))
        build(exe, p, src+'let wrong : Node (2,2,1) = alias\n', ok=False)
        # Independent relaxation by word length. For a finite planar group,
        # deleting a repeated orientation lowers cost; depth eleven suffices.
        h = hex_fields[0][0]
        mirror = ((F(1), F(0)), (F(0), F(-1)))
        rh = mm(h, mirror)
        atom_list = [((1,0), 1, 1), ((-1,2), -1, 2), ((0,1), 2, 0)]
        for branches in ([(h,F(6,5)), (inverse(h),9), (mirror,3)],
                         [(mirror,F(5,4)), (rh,F(9,8))]):
            flat = [(*m[0], *m[1], rate) for m, rate in branches]
            uv, public = lib['coordinates'](True)
            def form(normal, offset, slope):
                return lib['form'](lambda i,j,k: dot(normal, uv(i,j,k)[:2])-offset-slope*uv(i,j,k)[2])+'≤0'
            guards = ' ∧ '.join(form(a,c,k) for a,c,k in atom_list)
            base = source(flat, '', oblique=True).replace('Fork (node,node)', 'Fork ('+','.join(['node']*len(flat))+')')
            left, end = base.index('['), base.index(']')
            origin = lib['node'](lambda i,j,k: public(0,0,2))
            src = base[:left+1]+guards+base[end:]+'let adm : '+origin+' = alias\n'
            result = build(exe, p, src)
            pub, rows = scheme(signature(result, 'node'))
            sx, sy, st = z3.Reals('sx sy st')
            x, y, t = uv(sx, sy, st)
            expected = [t >= 0]
            for normal, c, slope in atom_list:
                best = {normal: F(1)}
                for _ in range(11):
                    updated = dict(best)
                    for a, price in best.items():
                        for m, rate in branches:
                            dest = mv(transpose(m), a)
                            updated[dest] = min(updated.get(dest, price*rate), price*rate)
                    best = updated
                expected.extend(z(a)*x+z(b)*y <= c+z(slope*price)*t for (a,b), price in best.items())
            actual = lib['constraints'](rows, dict(zip(pub, (sx,sy,st))))
            check(z3.unsat, z3.Xor(actual, z3.And(expected)))
        print('Both noncommuting dihedral exports equal the independently unfolded three-guard formula.')
        callers = ('let root : Node (-51/25,0,1) = alias\n'
                   'let ray : ∀i[0≤i]. Node (-26/25 i,0,i+1) = alias')
        for fields in ([rot], [rot, backwards]):
            flags = ('-term_abduction_timeout', '1') if len(fields) > 1 else ()
            src = source(fields, callers)
            result = build(exe, p, src, extra=flags)
            pub, rows = scheme(signature(result, 'node'))
            env = {v:z3.Real(v) for _, row in rows for v in row if v is not None}
            parent = lib['constraints'](rows, env)
            def admit(point):
                return lib['constraints'](rows, lib['tight'](rows, dict(zip(pub, point))))
            x, y, t = (env[v] for v in pub)
            check(z3.unsat, parent, x > 1+t)
            for a, b, c, d, r in fields:
                check(z3.unsat, parent, z3.Not(admit((z(a)*x+z(b)*y, z(c)*x+z(d)*y, z(r)*t))))
            i = z3.Real('caller_i')
            check(z3.unsat, i >= 0, z3.Not(admit((z(F(-26,25))*i, z(0), 1+i))))
            check(z3.unsat, z3.Not(admit((z(F(-51,25)), z(0), z(1)))))
            assert len(env)-len(pub) == 10
            assert sum(2 if op == '=' else 1 for op, _ in rows) == 27
        a, c, s = F(51, 25), F(7, 9), F(4, 9)
        wrong = ((c*c-2*s*s)*a, -2*s*c*a)
        build(exe, p, source([rot], f'let wrong : Node ({wrong[0]},{wrong[1]},1) = alias'), ok=False)
        print('Both finite signatures equal the exact domain. Z3 checked both folded types, every field and the full ray.')


if __name__ == '__main__':
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--compiler', type=Path)
    parser.add_argument('--recognize', action='store_true', help='also check affine frame recognition (requires z3-solver)')
    args = parser.parse_args()
    fields, guards = examples()
    if args.compiler or args.recognize:
        recognition_examples()
        certificate_example()
        caller_policy_example()
    if args.compiler:
        native(args.compiler.resolve(), fields, guards)
