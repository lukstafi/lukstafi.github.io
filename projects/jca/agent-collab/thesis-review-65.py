"""Decide one-field polyhedral caller coverage over Q (requires sympy and z3-solver)."""
from fractions import Fraction
from functools import lru_cache
from math import comb, lcm

import sympy as sp
import z3
from z3.z3num import Numeral, isolate_roots

X, Z = sp.symbols('X Z')


def recurrence(field, guard, generator):
    """Find the first dependent column of the scalar Hankel matrix, including transients."""
    size = field.rows
    terms = []
    state = generator
    for _ in range(2 * size):
        terms.append((guard * state)[0])
        state = field * state
    hankel = sp.Matrix(size, size + 1, lambda i,j: terms[i+j])
    reduced, pivots = hankel.rref()
    degree = len(pivots)
    assert pivots == tuple(range(degree))
    polynomial = sp.Poly(X**degree - sum(reduced[i,degree] * X**i for i in pivots), X)
    return polynomial, terms[:degree]


@lru_cache(None)
def period(poly):
    """Kill root-of-unity ratios, then double to make periodic real signs positive."""
    distinct = poly.sqf_part()
    if distinct.eval(0) == 0:
        distinct = distinct.exquo(sp.Poly(X, X))
    if distinct.degree() == 0:
        return 1
    f = distinct.as_expr()
    ratios = sp.Poly(sp.resultant(f, f.subs(X, X*Z), X), Z)
    order = 1
    for factor, _ in ratios.factor_list()[1]:
        if factor.is_cyclotomic:
            # phi(n) >= sqrt(n/2).
            n = next(n for n in range(1, 2*factor.degree()**2 + 1)
                     if sp.Poly(sp.cyclotomic_poly(n, Z), Z) == factor.monic().set_domain(sp.ZZ))
            order = lcm(order, n)
    return 2*order


def magnitude(value):
    return 0-value if value < 0 else value


def schur_stable(q):
    """All roots of the real polynomial lie strictly in the unit disk."""
    while len(q) > 1:
        first, last = q[0], q[-1]
        if magnitude(first) >= magnitude(last):
            return False
        q = [(last*a - first*b) / (last*last - first*first)
             for a,b in zip(q[1:], reversed(q[:-1]))]
    return True


def dominant_part(poly):
    """Return rho, its multiplicity, and the monic stable factor of p(rho X)."""
    var = z3.RealVar(0)
    coeff = [Fraction(c) for c in reversed(poly.all_coeffs())]
    expr = z3.RealVal(str(coeff[-1]))
    for c in reversed(coeff[:-1]):
        expr = expr*var + z3.RealVal(str(c))
    roots = isolate_roots(expr)
    positive = [r for r in roots if r > 0]
    if not positive:
        return None
    rho = max(positive)
    if rho.is_rational():
        rho = rho.as_fraction()
        convert = Fraction
    else:
        convert = lambda c: Numeral(str(c))
    degree = poly.degree()
    q = [convert(c) / rho**(degree-i) for i,c in enumerate(coeff)]
    multiplicity = 0
    while len(q) > 1 and sum(q) == 0:
        # Synthetic division by X-1, coefficients in ascending order.
        quotient = [q[-1]]
        for c in reversed(q[1:-1]):
            quotient.append(c + quotient[-1])
        q = quotient[::-1]
        multiplicity += 1
    assert multiplicity
    return (rho, multiplicity, q, convert) if schur_stable(q) else None


def future_error_bound(q):
    """Bound every future coordinate by B times the current error window's max norm."""
    size = len(q)-1
    if size == 0:
        return 0
    row = [1] + [0]*(size-1)
    bound, small = 1, 0
    while small < size:
        row = [a-row[-1]*b for a,b in zip([0, *row[:-1]], q)]
        norm = sum(magnitude(x) for x in row)
        bound = max(bound, norm)
        small = small+1 if norm <= 1 else 0
    return bound


def nonnegative_tail(initial, decomposition):
    rho, order, q, convert = decomposition
    seq = [convert(v)/rho**i for i,v in enumerate(initial)]
    # s_n/rho^n = P(n) + e_n.  q(E) kills e, and q(1+delta) acts
    # triangularly on the coefficients of P in the binomial basis.
    values = [sum(c*v for c,v in zip(q, seq[i:])) for i in range(order)]
    differences = []
    while values:
        differences.append(values[0])
        values = [b-a for a,b in zip(values, values[1:])]
    shifted = [sum(comb(i,j)*q[i] for i in range(j,len(q))) for j in range(order)]
    coeff = [0]*order
    for i in reversed(range(order)):
        coeff[i] = (differences[i]-sum(shifted[j-i]*coeff[j] for j in range(i+1,order))) / shifted[0]
    if coeff[-1] < 0:
        return False
    error = [seq[i]-sum(comb(i,j)*a for j,a in enumerate(coeff) if j<=i)
             for i in range(len(q)-1)]
    bound = future_error_bound(q)
    while True:
        if coeff[0] + (error[0] if error else 0) < 0:
            return False
        if min(coeff) >= 0 and coeff[0] >= bound*max(map(magnitude,error), default=0):
            return True
        coeff = [a+b for a,b in zip(coeff, [*coeff[1:],0])]
        if error:
            error = [*error[1:], 0-sum(a*b for a,b in zip(q,error))]


def analyse(poly, initial):
    """None requests a residue split. True and False already decide the sequence."""
    if any(x < 0 for x in initial):
        return False
    if poly == sp.Poly(X**poly.degree(), X):
        return True
    part = dominant_part(poly)
    return None if part is None else nonnegative_tail(initial, part)


def realisable(field, guard, generator):
    poly, initial = recurrence(field, guard, generator)
    result = analyse(poly, initial)
    if result is not None:
        return result
    step = period(poly)
    jump = field**step
    for _ in range(step):
        result = analyse(*recurrence(jump, guard, generator))
        if result is not True:
            return False
        generator = field * generator
    return True


def covers(field, guards, generators):
    """Input is homogeneous. Supply a base, rays and both signs of each free line."""
    return all(realisable(field, guard, v) for v in generators for guard in guards)


def examples():
    M = sp.Matrix
    row = lambda *xs: M([xs])
    rot = M([[3,-4],[4,3]])/5
    drift = M([[1,1],[0,1]])
    F = sp.diag(rot, drift)
    guard = row(-1,0,1,0)
    v = M([1,0,2,1])
    assert not covers(F, [guard], [v])                     # n+2-cos(n theta) >= 1
    assert covers(sp.diag(rot/2, drift), [guard], [v])     # strict spectral gap
    assert covers(F, [guard], [M([0,0,2,1])])              # cancellation at caller
    assert covers(F, [row(0,0,1,0)], [v])                  # cancellation at guard
    assert not covers(F, [guard], [M([0,0,2,1]), M([1,0,1,0])])
    assert not covers(F, [guard,row(1,0,0,0)], [M([0,0,2,1]), M([-1,0,0,0])])
    flip = sp.diag(2,-2,sp.Rational(1,2))
    assert covers(flip, [row(1,1,1)], [M([1,1,1])])       # odd residue loses both large roots
    assert not covers(flip, [row(1,1,1)], [M([1,1,-1])])
    # Leading periodic poles can conceal smaller, nonperiodic peripheral poles after a split.
    masked = sp.diag(2,-2,1,rot)
    assert not covers(masked, [row(1,1,2,1,0)], [M([1,1,1,1,0])])
    third = M([[0,-1],[1,-1]])
    assert covers(sp.diag(1,third), [row(2,1,0)], [M([1,1,0])])
    shift = M([[0,1,0],[0,0,1],[0,0,0]])
    assert covers(shift, [row(1,0,0)], [M([1,0,2])])
    assert not covers(shift, [row(1,0,0)], [M([1,0,-2])])
    # A finite negative dip well past the recurrence order, and its boundary case.
    square = M([[1,1,0],[0,1,1],[0,0,1]])
    assert not covers(square, [row(1,0,0)], [M([99**2-1,1-2*99,2])])
    assert covers(square, [row(1,0,0)], [M([99**2,1-2*99,2])])
    fib = M([[0,1],[1,1]])
    assert covers(fib, [row(1,0)], [M([0,1])])             # irrational dominant root
    # Nontrivial stable companion transient (complex repeated poles) and a repeated dominant.
    sys = sp.diag(drift, sp.kronecker_product(drift,rot/2))
    assert covers(sys, [row(1,0,1,0,0,0)], [M([2,1,1,0,1,0])])
    print('Passed caller, recession, periodic cancellation, buried poles, repeated roots and late sign checks.')


if __name__ == '__main__':
    examples()
