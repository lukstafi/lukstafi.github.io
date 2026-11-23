"""Decide whole-family polyhedral typability with rational signed slack multipliers."""
from argparse import ArgumentParser
from fractions import Fraction as F
from itertools import product
from pathlib import Path
import heapq
import runpy

HERE = Path(__file__).resolve().parent
BASE = runpy.run_path(str(HERE / 'thesis-review-62.py'))
identity, mv, mm, transpose = (BASE[k] for k in ('identity', 'mv', 'mm', 'transpose'))
dot, coordinates, span = (BASE[k] for k in ('dot', 'coordinates', 'span'))
linear_solutions, finite_orbit_subspace = (BASE[k] for k in ('linear_solutions', 'finite_orbit_subspace'))


def neutral_reduction(maps, rates, guards, primal):
    """Retain the largest admissible subspace and absorb the neutral group."""
    expanding = [(m, r) for m, r in zip(maps, rates) if r > 1]
    neutral = [m for m, r in zip(maps, rates) if r == 1]
    hrows, representatives = finite_orbit_subspace(neutral)
    rows = span(hrows, [transpose(m) for m in maps])
    _, allowed = linear_solutions(rows, [0]*len(rows), len(primal))
    def restrict(m):
        return transpose(tuple(coordinates(mv(m, v), allowed) for v in allowed))
    neutral_group = {restrict(m) for m in representatives}
    factored = [(tuple(dot(a, v) for v in allowed), c) for a, c in guards]
    saturated = {(mv(transpose(h), a), c) for h in neutral_group for a, c in factored}
    moves = {(mm(restrict(m), h), r) for m, r in expanding for h in neutral_group}
    metric = mm(allowed, mm(primal, transpose(allowed))) if allowed else ()
    return allowed, metric, sorted(moves), sorted(saturated)


def neutral_decision(b, maps, rates, guards, primal, vertices, rays):
    if max(rates) > 1 and any(t < 0 for _, t in (*vertices, *rays)):
        return 'negative slack', None
    allowed, metric, moves, saturated = neutral_reduction(maps, rates, guards, primal)
    def reindex(family):
        return [(coordinates(mv(b, p), allowed), t) for p, t in family]
    vertices, rays = reindex(vertices), reindex(rays)
    if any(p is None for p, _ in (*vertices, *rays)):
        return 'infinite neutral orbit reachable', None
    if not moves:
        for family, lam in ((vertices, 1), (rays, 0)):
            for v, t in family:
                if any(dot(a, v) > c*lam+t for a, c in saturated):
                    return 'neutral guard failure', None
        return 'typable', None
    # Any returned word is in the saturated alphabet of expanding macro-steps.
    return BASE['decide'](metric, moves, saturated, vertices, rays)


def neutral_examples():
    rot = ((F(3,5), F(-4,5), 0), (F(4,5), F(3,5), 0), (0,0,1))
    mix = ((0,0,1), (0,1,0), (1,0,0))
    guard = [((1,0,0), 1)]
    assert decide(identity(3), [(rot,1), (mix,2)], guard, [((0,0,1), 20)])[0] == 'infinite neutral orbit reachable'
    assert decide(identity(3), [(rot,1), (mix,2)], guard, [((0,0,0), 1)])[0] == 'typable'
    mixed_guard = [((1,0,1), 1)]
    fields = [(rot,1), (identity(3),2)]
    assert decide(identity(3), fields, mixed_guard, [((0,0,2),1)], [((0,0,1),1)])[0] == 'typable'
    assert decide(identity(3), fields, mixed_guard, [((0,0,3),1)])[0] == 'guard failure'
    assert decide(identity(3), fields, mixed_guard, [((0,0,0),1)], [((1,0,-10),0)])[0] == 'infinite neutral orbit reachable'
    assert decide(identity(3), [(rot,1)], [((1,0,0),2)], [((0,0,0),-1)])[0] == 'typable'
    assert decide(identity(3), [(rot,1)], [((1,0,0),2)], [((0,0,0),-3)])[0] == 'neutral guard failure'
    # Saturation must test a neutral suffix after the expander as well as a
    # neutral prefix. Enumerate all sign changes independently between turns.
    turn = tuple(row[:2] for row in rot[:2])
    flip = ((F(-1),0), (0,F(1)))
    for x, y in product(range(-2,3), repeat=2):
        def safe(v, t, depth):
            orbit = {v, mv(flip, v)}
            if any(a > 1+t for a, _ in orbit):
                return False
            return depth == 2 or all(safe(mv(turn, u), 2*t, depth+1) for u in orbit)
        got = decide(identity(2), [(flip,1), (turn,2)], [((1,0),1)], [((x,y),1)])[0]
        # Every later word has slack at least four and radius at most sqrt(8).
        assert (got == 'typable') == safe((x,y), 1, 0)
    print('Neutral saturation agreed on 25 independently unfolded callers and detected an infinite orbit reached after one expansion.')


def signed_maxima(maps, rates, dim):
    """Largest absolute nonzero product for each reachable (orientation, sign)."""
    unit = identity(dim)
    best = {}
    todo = [(F(1), unit, 1)]
    edges = [(m, 1 if r > 0 else -1, F(1)/abs(r)) for m, r in zip(maps, rates) if r]
    while todo:
        cost, g, sign = heapq.heappop(todo)
        if (g, sign) in best:
            continue
        best[g, sign] = 1/cost
        for m, d, price in edges:
            h = mm(m, g)
            if (h, sign*d) not in best:
                heapq.heappush(todo, (cost*price, h, sign*d))
    return best


def finite_domain(b, maps, rates, guards):
    """For a gain below +1, compute the greatest domain in finite-orbit coordinates."""
    assert min(rates) < 1
    equations, representatives = finite_orbit_subspace(maps)
    _, basis = linear_solutions(equations, [0]*len(equations), len(b))
    def restrict(m):
        return transpose(tuple(coordinates(mv(m, x), basis) for x in basis))
    group = {restrict(g) for g in representatives}
    factored = [(tuple(dot(a, x) for x in basis), c) for a, c in guards]
    rows = set()
    def add(g, rate):
        rows.update((mv(transpose(g), a), rate, c) for a, c in factored)

    high = max(map(abs, rates)) > 1
    shrink = min(map(abs, rates)) < 1
    if shrink or high:
        for g in group:
            add(g, F(0))
    if high:
        # Expansion forces nonnegative slack when all gains are nonnegative.
        # A negative edge additionally forces nonpositive slack.
        zero = (F(0),)*len(basis)
        rows.add((zero, F(1), F(0)))
        if min(rates) < 0:
            rows.add((zero, F(-1), F(0)))
    else:
        actions = [restrict(m) for m in maps]
        for (g, sign), bound in signed_maxima(actions, rates, len(basis)).items():
            add(g, sign*bound)
    return basis, rows


def decide(metric, fields, guards, vertices, rays=()):
    assert vertices
    if all(r > 1 for _, r in fields):
        return BASE['decide'](metric, fields, guards, vertices, rays)
    b, maps, rates, guards, _, primal = BASE['observable'](metric, fields, guards)
    if min(rates) == 1:
        return neutral_decision(b, maps, rates, guards, primal, vertices, rays)
    basis, rows = finite_domain(b, maps, rates, guards)
    for family, lam in ((vertices, 1), (rays, 0)):
        for p, t in family:
            y = coordinates(mv(b, p), basis)
            if y is None:
                return 'infinite observable orbit', None
            if any(dot(a, y) > r*t+c*lam for a, r, c in rows):
                return 'outside greatest polyhedral domain', None
    return 'typable', None


def signed_examples():
    rot = ((F(3,5), F(-4,5)), (F(4,5), F(3,5)))
    u, flip = identity(2), ((F(-1), F(0)), (F(0), F(1)))
    guard = [((1,0), 2)]
    assert decide(u, [(rot, F(1,2)), (u, 2)], guard, [((F(1,4),0),1)])[0] == 'infinite observable orbit'
    assert decide(u, [(u, F(-1,2)), (u, 2)], guard, [((0,0),1)])[0] == 'outside greatest polyhedral domain'
    assert decide(u, [(u,-2)], guard, [((1,0),0)])[0] == 'typable'
    assert decide(u, [(rot,-1)], guard, [((F(1,4),0),1)])[0] == 'infinite observable orbit'
    # Each example acts on x by a sign. For all signed nonexpansive
    # systems four signed states suffice. The independent oracle includes
    # all slopes through depth four, and the zero-slope limit when applicable.
    checked = 0
    for fields in ([(flip,F(-1,2)), (u,F(3,4))], [(flip,-1), (u,-1)],
                   [(flip,0), (u,F(1,2))], [(flip,F(-3,4)), (u,0)]):
        frontier = {(1,F(1))}
        known = set(frontier)
        for _ in range(4):
            frontier = {(s*int(m[0][0]), f*r) for s, f in frontier for m, r in fields}
            known |= frontier
        if any(abs(r) < 1 for _,r in fields):
            known |= {(s,F(0)) for s, _ in known}
        for x,t,lam in product(range(-3,4), range(-2,3), (0,1)):
            point = [((x,0),t)]
            expected = all(s*x <= 2*lam+r*t for s,r in known)
            actual = decide(u, fields, guard, point if lam else [((0,0),0)], [] if lam else point)
            assert (actual[0] == 'typable') == expected, (fields,x,t,lam,actual)
            checked += 1
    # A positive multiplier above one and a zero multiplier test both signs
    # of slack, including zero-slack homogeneous recession constraints.
    for x,t,lam in product(range(-2,3), range(-1,2), (0,1)):
        point = [((x,0),t)]
        actual = decide(u, [(flip,0),(u,2)], guard, point if lam else [((0,0),0)], [] if lam else point)
        assert (actual[0] == 'typable') == (t >= 0 and abs(x) <= 2*lam)
    print(f'Signed greatest domains agreed on {checked} vertex and ray cases, plus 30 reset/expansion cases.')


def recover_observable_frame(affine_fields, guards):
    """Recognize a common affine frame on the already observable space."""
    import z3
    matrices = [m for m, _ in affine_fields]
    n = len(matrices[0])
    unit = identity(n)
    magnitudes = [abs(BASE['determinant'](m)) for m in matrices]

    def simultaneous(ms, rs):
        rows = [tuple(x-r*y for x,y in zip(row,e)) for m,r in zip(ms,rs) for row,e in zip(m,unit)]
        return linear_solutions(rows, [0]*len(rows), n)[1]

    if any(v != 1 for v in magnitudes):
        k = next(i for i,v in enumerate(magnitudes) if v != 1)
        for r in {magnitudes[k], -magnitudes[k]}:
            right = simultaneous([matrices[k]], [r])
            left = simultaneous([transpose(matrices[k])], [r])
            if len(right) != 1 or len(left) != 1 or not dot(right[0], left[0]):
                continue
            axis, row = right[0], left[0]
            rates = [coordinates(mv(m, axis), [axis]) for m in matrices]
            if any(v is None for v in rates):
                continue
            rates = [v[0] for v in rates]
            if list(map(abs,rates)) != magnitudes:
                continue
            if any(mv(transpose(m), row) != tuple(rate*x for x in row) for m,rate in zip(matrices,rates)):
                continue
            frame = BASE['realize_frame'](affine_fields, guards, axis, row, rates)
            if frame is not None:
                return frame
    else:
        q = BASE['common_metric'](matrices, n)
        if q is None:
            return None
        for rates in product((1,-1), repeat=len(matrices)):
            eig = simultaneous(matrices, rates)
            if not eig:
                continue
            u = [z3.Real(f'axis_{j}') for j in range(len(eig))]
            solver = z3.SolverFor('QF_LRA')
            for a, _ in guards:
                solver.add(sum(z3.RealVal(str(dot(a,v)))*c for v,c in zip(eig,u)) <= -1)
            if solver.check() == z3.sat:
                vals = [solver.model().eval(x,model_completion=True).as_fraction() for x in u]
                axis = mv(transpose(eig), vals)
                return BASE['realize_frame'](affine_fields, guards, axis, mv(q,axis), rates)
    return None


def recover(affine_fields, guards):
    """Discard invisible affine dynamics, then recognize the signed isometry class."""
    rows = span([a for a, _ in guards], [transpose(m) for m, _ in affine_fields])
    if not rows:
        return None
    projected = [(tuple(coordinates(mv(transpose(m), row), rows) for row in rows), mv(rows, d))
                 for m, d in affine_fields]
    observed = [(coordinates(a, rows), c) for a, c in guards]
    frame = recover_observable_frame(projected, observed)
    if frame is None:
        return None
    q, fields, normalized, to_frame = frame
    return q, fields, normalized, lambda x, is_ray=False: to_frame(mv(rows, x), is_ray)


def recognition_examples():
    p = ((1,2,1),(0,1,-1),(0,0,1))
    inv = BASE['inverse'](p)
    center = (3,-2,4)
    rot = ((F(3,5), F(-4,5)), (F(4,5), F(3,5)))
    flip = ((1,0),(0,-1))
    for r1,r2 in ((-2,F(1,3)),(0,-1),(-1,1),(F(-1,2),F(1,4))):
        raw = []
        for m,r in ((rot,r1), (flip,r2)):
            block = ((*m[0],0), (*m[1],0), (0,0,r))
            h = mm(p, mm(block, inv))
            raw.append((h, tuple(x-y for x,y in zip(center,mv(h,center)))))
        guards = []
        for normal,c in (((1,0,-1),2), ((0,-1,-2),3)):
            a = mv(transpose(inv),normal)
            guards.append((a,c+dot(a,center)))
        result = recover(raw, guards)
        assert result is not None
        metric, fields, factored, transform = result
        assert [r for _,r in fields] == [r1,r2]
        for y,t in (((0,0),0),((1,0),2), ((-1,1),-3)):
            x = tuple(a+b for a,b in zip(center,mv(p,(*y,t))))
            want = decide(identity(2), [(rot,r1),(flip,r2)],
                          [((1,0),2),((0,F(-1,2)),F(3,2))], [(y,t)])[0]
            assert (decide(metric,fields,factored,[transform(x)])[0]=='typable') == (want=='typable')
    # All maps are the identity: the slack line must be chosen inside a
    # strict guard cone rather than as the first common eigenbasis vector.
    assert recover([(identity(3),(0,0,0))], [((0,1,0),1),((1,-1,0),2)]) is not None
    assert recover([(identity(2),(0,0))], [((1,0),1),((-1,0),2)]) is None
    # These hidden coordinates have a translation with no fixed point and a
    # factor of five. A further change of basis conceals both from inspection.
    mix = ((1,1,0,1,0),(0,1,1,0,0),(0,0,1,1,0),(0,0,0,1,1),(0,0,0,0,1))
    undo = BASE['inverse'](mix)
    lifted = []
    for m,r in ((rot,2), (flip,F(1,2))):
        linear = ((*m[0],0,0,0), (*m[1],0,0,0), (0,0,r,0,0),
                  (0,0,0,1,0), (1,0,0,0,5))
        lifted.append((mm(mix, mm(linear, undo)), mv(mix, (0,0,0,1,0))))
    raw_guard = [(mv(transpose(undo), (1,0,-1,0,0)), 1)]
    assert recover_observable_frame(lifted, raw_guard) is None
    q, moves, normalized, transform = recover(lifted, raw_guard)
    assert len(q) == 2
    v = [transform(mv(mix, (0,0,1,-50,90)))]
    rays = [transform(mv(mix, (0,0,0,0,1)), True), transform(mv(mix, (0,0,0,0,-1)), True)]
    assert decide(q, moves, normalized, v, rays)[0] == 'typable'
    assert decide(q, moves, normalized, [transform(mv(mix, (F(1,4),0,1,0,0)))])[0] == 'infinite observable orbit'
    print('Recovered translated signed, singular and all-unit frames; both same-line and incompatible guard tests passed.')


def native(exe):
    from tempfile import TemporaryDirectory
    import z3
    lib = runpy.run_path(str(HERE / 'thesis-review-61.py'))
    rot = (F(3,5),F(-4,5),F(4,5),F(3,5),1)
    expand = (1,0,0,1,2)
    h = (F(1,2),F(-3,2),F(1,2),F(1,2),1)
    reflect = ((1,0,0,-1,1), (F(7,9),F(8,9),F(4,9),F(-7,9),1))
    with TemporaryDirectory() as folder:
        p = Path(folder)/'held.gadt'
        for fields in ([rot,expand], [*reflect,expand], [h,expand]):
            source = lib['weighted_source'](True, fields).split('let root')[0]
            source = source.replace('Fork (node,node)', 'Fork ('+','.join(['node']*len(fields))+')')
            # More than one alias exercises transport of the exact checked scheme.
            source += 'let again = alias\n'
            _, public = lib['coordinates'](True)
            source += 'let axis : ∀k[0≤k]. '+lib['node'](lambda i,j,k:public(0,0,k))+' = again\n'
            result = lib['native'](exe, p, source)
            printed = lib['signature'](result, 'node')
            assert printed == lib['signature'](result,'alias') == lib['signature'](result,'again')
            pub, rows = lib['scheme'](printed)
            raw = z3.Reals('a b c')
            u,v,t = lib['coordinates'](True)[0](*raw)
            actual = lib['constraints'](rows,dict(zip(pub,raw)))
            if fields[0] == h:
                normal = (F(1),F(0))
                hexguards = []
                for _ in range(6):
                    hexguards.append(lib['z'](normal[0])*u+lib['z'](normal[1])*v <= 1+t)
                    normal = mv(transpose((h[:2],h[2:4])), normal)
                expected = z3.And(t >= 0, *hexguards)
            else:
                expected = z3.And(t >= 0, u == 0, v == 0)
                wrong = lib['node'](lambda i,j,k:public(F(1,4),0,20))
                lib['native'](exe, p, source+'let wrong : '+wrong+' = again\n', ok=False)
            lib['check'](z3.unsat, z3.Xor(actual, expected))
    print('Native slack-preserving steps: two infinite actions give exactly the slack axis; the finite action gives its full hexagon.')


if __name__ == '__main__':
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--compiler', type=Path)
    parser.add_argument('--recognize', action='store_true')
    args = parser.parse_args()
    neutral_examples()
    signed_examples()
    if args.compiler or args.recognize:
        recognition_examples()
    if args.compiler:
        native(args.compiler.resolve())
