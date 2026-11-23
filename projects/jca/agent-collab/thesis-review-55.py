"""Synthesize and independently check a fixed number of convex keys for one marker.

Run with Python and z3-solver. Supply rational generators or affine inequalities.
"""
from dataclasses import dataclass
from itertools import product
import z3 as z


@dataclass(frozen=True)
class Cell:
    vertices: tuple
    rays: tuple = ()


@dataclass(frozen=True)
class Halfspaces:
    dimension: int
    rows: tuple  # a*x + b <= 0, with b in the last column


def dimension(cell):
    return cell.dimension if isinstance(cell, Halfspaces) else len(cell.vertices[0])


def dot(a, x):
    return sum(k * t for k, t in zip(a, x, strict=True))


def at(row, x):
    return dot(row[:-1], x) + row[-1]


def contains(cell, x):
    if isinstance(cell, Halfspaces):
        return z.And(*(at(row, x) <= 0 for row in cell.rows))
    weights = [z.FreshReal("weight") for _ in cell.vertices]
    rays = [z.FreshReal("ray") for _ in cell.rays]
    gens = list(zip(weights, cell.vertices)) + list(zip(rays, cell.rays))
    return z.And(sum(weights) == 1, *(v >= 0 for v in weights + rays),
                 *(v == sum(w*p[i] for w, p in gens) for i, v in enumerate(x)))


def feasible(formula):
    s = z.SolverFor("QF_LRA")
    s.add(formula)
    result = s.check()
    if result == z.unknown:
        raise RuntimeError(s.reason_unknown())
    return result == z.sat


def nonempty(cell):
    if isinstance(cell, Cell):
        return bool(cell.vertices)
    x = [z.FreshReal("x") for _ in range(cell.dimension)]
    return feasible(contains(cell, x))


def bounded(cell):
    if isinstance(cell, Cell):
        return not cell.rays
    ray = [z.FreshReal("direction") for _ in range(cell.dimension)]
    return not feasible(z.And(*(dot(row[:-1], ray) <= 0 for row in cell.rows),
                              z.Or(*(z.Or(c >= 1, c <= -1) for c in ray))))


def valid_certificate(callers, suppliers, supports):
    callers = [c for c in callers if isinstance(c, Halfspaces) or c.vertices]
    suppliers = [c for c in suppliers if isinstance(c, Halfspaces) or c.vertices]
    if not callers and not suppliers:
        return True
    dim = dimension((callers + suppliers)[0])
    x = [z.FreshReal("x") for _ in range(dim)]
    regions = [z.And(*(at(row, x) >= 1 for row in rows)) for rows in supports]
    return (all(not feasible(z.And(contains(h, x), z.Not(z.Or(*regions)))) for h in callers)
            and all(not feasible(z.And(contains(b, x), z.Or(*regions))) for b in suppliers))


def safe_on(row, cell):
    if isinstance(cell, Halfspaces):
        # Farkas certificate that the cell implies row <= 0.
        dual = [z.FreshReal("dual") for _ in cell.rows]
        combined = [sum(w*r[i] for w,r in zip(dual, cell.rows))
                    for i in range(cell.dimension+1)]
        return ([w >= 0 for w in dual] +
                [a == b for a,b in zip(row[:-1],combined[:-1],strict=True)] +
                [row[-1] <= combined[-1]])
    return [at(row, p) <= 0 for p in cell.vertices] + [dot(row[:-1], u) <= 0 for u in cell.rays]


def synthesize(callers, suppliers, keys=2):
    """None proves real infeasibility. Return only independently verified rational rows.

    For unbounded callers a real solution can leave rational reconstruction
    unresolved. Report that case separately.
    """
    assert keys >= 1
    callers = [c for c in callers if nonempty(c)]
    suppliers = [c for c in suppliers if nonempty(c)]
    if not suppliers:
        return [[] for _ in range(keys)]
    dim = dimension(suppliers[0])
    assert all(dimension(c) == dim for c in callers + suppliers)
    rows = [[[z.FreshReal("coef") for _ in range(dim + 1)] for b in suppliers] for _ in range(keys)]
    s = z.SolverFor("QF_NRA")
    for family in rows:
        for row, b in zip(family, suppliers):
            s.add(*safe_on(row, b))
    for h in callers:
        for group in product(*rows):
            if isinstance(h, Cell) and len(h.vertices) == 1 and not h.rays:
                s.add(z.Or(*(at(row, h.vertices[0]) >= 1 for row in group)))
                continue
            mixture = group[0]
            if keys > 1:
                weights = [z.FreshReal("mix") for _ in range(keys-1)]
                weights.append(1 - sum(weights))
                s.add(*(weight >= 0 for weight in weights))
                mixture = [dot(weights, column) for column in zip(*group)]
            violation = [-a for a in mixture[:-1]] + [1-mixture[-1]]
            s.add(*safe_on(violation, h))
    status = s.check()
    if status == z.unsat:
        return None
    if status != z.sat:
        raise RuntimeError(s.reason_unknown())
    m = s.model()
    exact = [[[m.eval(c, model_completion=True) for c in row] for row in family] for family in rows]
    return rational_certificate(callers, suppliers, exact)


def rational_certificate(callers, suppliers, exact):
    if all(z.is_rational_value(c) for family in exact for row in family for c in row):
        if not valid_certificate(callers, suppliers, exact):
            raise AssertionError("invalid rational certificate")
        return exact
    # Gain slack at every caller. Approximate each face INSIDE the rational
    # cone of rows valid on its supplier, even when the supplier has rays.
    prec = 1
    bounded_callers = all(bounded(h) for h in callers)
    while prec <= 64 or bounded_callers:
        out = []
        for family in exact:
            approx = []
            for row, b in zip(family, suppliers):
                variables = [z.FreshReal("r") for _ in row]
                lp = z.SolverFor("QF_LRA")
                lp.add(*safe_on(variables, b))
                for v, c in zip(variables, row):
                    center = 2*(c.approx(prec+2) if z.is_algebraic_value(c) else c)
                    eps = z.Q(1, 2**prec)
                    lp.add(v >= center-eps, v <= center+eps)
                assert lp.check() == z.sat
                approx.append([lp.model().eval(v, model_completion=True) for v in variables])
            out.append(approx)
        if valid_certificate(callers, suppliers, out):
            return out
        prec *= 2
    raise RuntimeError("real solution with unbounded callers; rational reconstruction unresolved")


def examples():
    point = lambda *p: Cell((p,))
    left, right = point(-2, 2), point(2, 2)
    base = Cell(((-2, 0), (2, 0)))
    obstacles = [point(0, 1), point(0, 2)]
    h = [left, right, base]
    assert synthesize(h, obstacles, 1) is None
    assert synthesize(h, obstacles) is not None
    for i in range(3):
        assert synthesize([x for j,x in enumerate(h) if j != i], obstacles, 1) is None
    assert valid_certificate(h, obstacles, [[[-1,-1,1]], [[1,-1,1]]])
    assert synthesize(h, [point(0, 0)]) is None
    upward = [Cell(((0,1),), ((0,1),))]
    assert synthesize(h, upward) is not None
    scale = z.simplify(z.Sqrt(2))
    irrational = [[[z.simplify(scale*c) for c in row]] for row in [(-1,-1,1), (1,-1,1)]]
    assert valid_certificate(h, upward, rational_certificate(h, upward, irrational))
    # Present the same caller segment and supplier ray as conjunctions.
    segment = Halfspaces(2, ((1,0,-2), (-1,0,-2), (0,1,0), (0,-1,0)))
    ray = Halfspaces(2, ((1,0,0), (-1,0,0), (0,-1,1)))
    impossible = Halfspaces(2, ((1,0,0), (-1,0,1)))
    assert bounded(segment) and not bounded(ray) and not nonempty(impossible)
    clauses = [left,right,segment]
    dual = synthesize(clauses, [ray, impossible])
    assert dual is not None and valid_certificate(h, upward, dual)
    assert synthesize(clauses, [ray], 1) is None
    assert valid_certificate(h, upward, rational_certificate(clauses, [ray], irrational))
    assert synthesize([Cell(((-1,),), ((-1,),)), Cell(((1,),), ((1,),))], [point(0)]) is not None

    diamond = Cell(((4,0), (-4,0), (0,4), (0,-4)))
    tips = [point(12,0), point(0,12)]
    blockers = [point(6,6), point(3,3), point(-3,3), point(3,-3)]
    strips = [[[1,0,3], [-1,0,3]], [[0,1,3], [0,-1,3]]]
    assert valid_certificate([diamond] + tips, blockers, strips)

    intervals = [Cell(((a,), (a+1,))) for a in (0,3,6)]
    tolls = [point(2), point(5)]
    assert synthesize(intervals, tolls, 2) is None
    assert synthesize(intervals, tolls, 3) is not None

    count = 0
    for colors in product(range(3), repeat=5):
        callers = [point(i) for i,c in enumerate(colors) if c==1]
        bad = [point(i) for i,c in enumerate(colors) if c==2]
        if not callers or not bad:
            continue
        gaps = {sum(c==2 for c in colors[:i]) for i,c in enumerate(colors) if c==1}
        for k in [1,2]:
            assert (synthesize(callers, bad, k) is not None) == (len(gaps) <= k)
            count += 1
    print(f"Split-cell, crossing-strip and ray certificates verified; {count} interval-gap comparisons passed.")


if __name__ == "__main__":
    examples()
