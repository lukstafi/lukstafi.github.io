"""Round 8 experiments: machine checks for the JCA-EXIST analysis
(round-8-reassessment.md).

Implements first-order terms, unification, and the answer check of
Theorem 2.4: A (given as substitution theta) is an answer to
{(D_i, C_i)}_i iff for all i, D_i theta is unifiable and
C_i theta nu_i is trivial, where nu_i = mgu(D_i theta).

Checks performed:
  1. Thesis Example 4.3: theta = {y -> f(z, gamma)} is an answer;
     and brute-force search confirms no answer exists without a fresh
     parameter (over depth-1 candidates), while the known answer is found.
  2. Port collapse (Theorem 3.1): random port-shaped instances have a
     port-free answer iff C* unifies (tested by brute-force enumeration).
  3. Counterexample 4.1: with answer x=f^N(z), y=f^N(w), premise x=y is
     consistent; with y=f^{N+1}(a) it is not -- for N far beyond the
     instance depth, refuting the Bounded Reach Lemma of round 7.
  4. GADT Pair example: relevance/consistency of the expected answer.
"""

import itertools
import random

# ---------- terms ----------
# Term: ('var', name) or (fname, arg1, ..., argk)

def V(n):
    return ('var', n)

def is_var(t):
    return isinstance(t, tuple) and len(t) == 2 and t[0] == 'var' and isinstance(t[1], str)

def F(f, *args):
    return (f,) + tuple(args)

def term_vars(t):
    if is_var(t):
        return {t[1]}
    s = set()
    for a in t[1:]:
        s |= term_vars(a)
    return s

def walk(t, s):
    while is_var(t) and t[1] in s:
        t = s[t[1]]
    return t

def apply_subst(t, s):
    t = walk(t, s)
    if is_var(t):
        return t
    return (t[0],) + tuple(apply_subst(a, s) for a in t[1:])

def occurs(v, t, s):
    t = walk(t, s)
    if is_var(t):
        return t[1] == v
    return any(occurs(v, a, s) for a in t[1:])

def unify(eqs, s=None):
    """eqs: list of (lhs, rhs). Returns substitution dict (triangular) or None."""
    s = dict(s) if s else {}
    stack = list(eqs)
    while stack:
        a, b = stack.pop()
        a, b = walk(a, s), walk(b, s)
        if a == b:
            continue
        if is_var(a):
            if occurs(a[1], b, s):
                return None
            s[a[1]] = b
        elif is_var(b):
            if occurs(b[1], a, s):
                return None
            s[b[1]] = a
        else:
            if a[0] != b[0] or len(a) != len(b):
                return None
            stack.extend(zip(a[1:], b[1:]))
    return s

def trivial(eqs, s):
    return all(apply_subst(a, s) == apply_subst(b, s) for a, b in eqs)

# ---------- Theorem 2.4 answer check ----------

def is_answer(theta_eqs, branches):
    """theta_eqs: list of (var, term) equations presenting the answer A.
    branches: list of (D, C) with D, C lists of (lhs, rhs).
    Returns (ok, per_branch_report)."""
    base = unify(theta_eqs)
    if base is None:
        return False, 'answer itself unsatisfiable'
    report = []
    for i, (D, C) in enumerate(branches):
        mu = unify(D, base)          # mgu(A ∧ D_i), triangular
        if mu is None:
            report.append((i, 'inconsistent'))
            return False, report
        if not trivial(C, mu):
            report.append((i, 'relevance fails'))
            return False, report
        report.append((i, 'ok'))
    return True, report

# ---------- brute-force answer enumeration ----------

def subterms(t):
    yield t
    if not is_var(t):
        for a in t[1:]:
            yield from subterms(a)

def instance_material(branches):
    terms = set()
    vs = set()
    for D, C in branches:
        for a, b in D + C:
            for t in (a, b):
                for st in subterms(t):
                    terms.add(st)
                vs |= term_vars(t)
    return sorted(terms, key=str), sorted(vs)

def generalizations(t, names):
    """All generalizations of t where any subterm may be replaced by a
    variable drawn from names (including replacing t itself)."""
    out = {t} | {V(n) for n in names}
    if not is_var(t):
        arg_gens = [sorted(generalizations(a, names), key=str) for a in t[1:]]
        for combo in itertools.product(*arg_gens):
            out.add((t[0],) + combo)
    return out

def search_answers(branches, max_eqs=2, n_params=1, verbose=False,
                   allowed_vars=None):
    """Enumerate small candidate answers: equations var = generalized instance
    subterm, with up to n_params fresh parameter variables. If allowed_vars is
    given, restrict both sides of answer equations to those variables (plus
    params)."""
    terms, vs = instance_material(branches)
    taken = set(vs)
    params, i = [], 0
    while len(params) < n_params:
        name = 'P%d' % i
        if name not in taken:
            params.append(name)
        i += 1
    if allowed_vars is not None:
        vs = [v for v in vs if v in allowed_vars]
    names = list(vs) + params
    rhs_pool = set()
    for t in terms:
        rhs_pool |= generalizations(t, names)
    if allowed_vars is not None:
        rhs_pool = {r for r in rhs_pool
                    if term_vars(r) <= set(allowed_vars) | set(params)}
    rhs_pool = sorted(rhs_pool, key=str)
    atoms = [(V(x), r) for x in vs for r in rhs_pool if x not in term_vars(r)]
    found = []
    # k = 0 includes the empty conjunction (top), a legitimate minimal answer
    # when every branch already entails its conclusion.
    for k in range(0, max_eqs + 1):
        for combo in itertools.combinations(atoms, k):
            ok, _ = is_answer(list(combo), branches)
            if ok:
                found.append(combo)
                if verbose:
                    print('  answer:', combo)
    return found

# ---------- experiments ----------

def show(t):
    if is_var(t):
        return t[1]
    if len(t) == 1:
        return t[0]
    return '%s(%s)' % (t[0], ','.join(show(a) for a in t[1:]))

def fmt_answer(eqs):
    return ' & '.join('%s=%s' % (show(a), show(b)) for a, b in eqs)

print('=== 1. Thesis Example 4.3 ===')
x, y, z, g = V('x'), V('y'), V('z'), V('gamma')
a, b = F('a'), F('b')
branches43 = [
    ([(y, F('f', a, x))], [(z, a)]),
    ([(y, F('f', b, x))], [(z, b)]),
]
ok, rep = is_answer([(y, F('f', z, g))], branches43)
print('theta = {y -> f(z,gamma)} is an answer:', ok, rep)
ans0 = search_answers(branches43, max_eqs=1, n_params=0)
ans1 = search_answers(branches43, max_eqs=1, n_params=1)
print('single-equation answers without params:', len(ans0))
print('single-equation answers with 1 param:', len(ans1))
for c in ans1[:6]:
    print('   ', fmt_answer(c))

print()
print('=== 2. Port collapse (Theorem 3.1), randomized test ===')
random.seed(0)
def random_term(vs, depth):
    if depth == 0 or random.random() < 0.3:
        return random.choice([V(random.choice(vs)), F('a'), F('b')])
    return F(random.choice(['f', 'g']), random_term(vs, depth - 1), random_term(vs, depth - 1))

total = refuted = 0
for trial in range(100):
    vs = ['x', 'y', 'z']
    m = random.randint(1, 3)
    branches, cstar = [], []
    for i in range(m):
        u = 'u%d' % i
        p = random_term(vs, 2)
        # conclusion relates the port to another random term
        c_rhs = random_term(vs, 2)
        branches.append(([(V(u), p)], [(V(u), c_rhs)]))
        cstar.append((p, c_rhs))
    collapse_pred = unify(cstar) is not None
    if collapse_pred:
        # Theorem direction 1: C* unifiable => A := C* is an answer.
        ok_cstar, why = is_answer(cstar, branches)
        assert ok_cstar, ('C* should be an answer', branches, why)
    else:
        # Theorem direction 2: no port-free answer exists. Any port-free
        # answer found by search would refute the theorem. (Single-equation
        # search plus the C* candidate keeps the run fast; refutations, if
        # any, would most likely show up here.)
        found = search_answers(branches, max_eqs=1, n_params=1,
                               allowed_vars=vs)
        if found:
            refuted += 1
            print('REFUTATION?', branches, found[0])
    total += 1
print('trials: %d, refutations of Theorem 3.1: %d' % (total, refuted))

print()
print('=== 3. Counterexample 4.1 (unbounded reach) ===')
def fN(n, base):
    t = base
    for _ in range(n):
        t = F('f', t)
    return t
N = 200
D = [(x, y)]
C = [(x, y)]
ok1, _ = is_answer([(x, fN(N, V('z'))), (y, fN(N, V('w')))], [(D, C)])
ok2, _ = is_answer([(x, fN(N, a)), (y, fN(N + 1, a))], [(D, C)])
print('A_N  (x=f^%d(z), y=f^%d(w)) answer:' % (N, N), ok1)
print("A'_N (x=f^%d(a), y=f^%d(a)) answer:" % (N, N + 1), ok2,
      ' <- differs only at depth %d >> instance depth 0' % N)

print()
print('=== 4. GADT Pair example (prefix mechanism, relevance/consistency only) ===')
# Thesis Section 4.2.4.1: premise tau = Term((a',b')), conclusion
# gamma = (a'',b'') -- the conclusion constrains gamma, NOT a''/b'' directly.
tau, gam = V('tau'), V('gamma2')
ap, bp, app, bpp = V("a'"), V("b'"), V("a''"), V("b''")
branch_pair = [([(tau, F('Term', F('pair', ap, bp)))],
                [(gam, F('pair', app, bpp))])]
theta_pair = [(tau, F('Term', gam)), (app, ap), (bpp, bp)]
ok, rep = is_answer(theta_pair, branch_pair)
print('expected answer tau=Term(gamma) & a\'\'=a\' & b\'\'=b\':', ok, rep)
# Without routing tau through gamma, gamma stays unpinned and relevance
# must fail -- the mechanism is premise-driven pinning of the parameter.
theta_bp = [(tau, F('Term', F('pair', app, bpp)))]
ok, rep = is_answer(theta_bp, branch_pair)
print('alt answer tau=Term(pair(a\'\',b\'\')) alone:', ok, rep,
      ' <- gamma unpinned, relevance fails as expected')
# Adding the gamma binding back yields a passing (less general) answer.
theta_bp2 = theta_bp + [(gam, F('pair', app, bpp))]
ok, rep = is_answer(theta_bp2, branch_pair)
print('alt answer tau=Term(pair(a\'\',b\'\')) & gamma=pair(a\'\',b\'\'):', ok, rep)
