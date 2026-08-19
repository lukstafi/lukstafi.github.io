"""Round 9 experiments: machine checks for the subsumption-bottleneck notes
(round-9-subsumption-bottleneck.md).

Self-contained: reproduces the round-8 unification engine, adds one-sided
matching by freezing, an SSU meta-checker for conditions (E)+(S), and the
checks listed in Section 7 of the notes.
"""

import itertools

# ---------- terms & unification (round-8 engine) ----------

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

def is_answer(theta_eqs, branches):
    base = unify(theta_eqs)
    if base is None:
        return False, 'answer itself unsatisfiable'
    report = []
    for i, (D, C) in enumerate(branches):
        mu = unify(D, base)
        if mu is None:
            report.append((i, 'inconsistent'))
            return False, report
        if not trivial(C, mu):
            report.append((i, 'relevance fails'))
            return False, report
        report.append((i, 'ok'))
    return True, report

# ---------- one-sided matching by freezing ----------

def freeze(t):
    """Turn variables into rigid constants (matching = unification against
    a frozen right-hand side; Section 5.3 of the notes)."""
    if is_var(t):
        return ('$frz_' + t[1],)
    return (t[0],) + tuple(freeze(a) for a in t[1:])

def matches_onto(s, t):
    """Is t a substitution instance of s, i.e. s sigma = t for some sigma?"""
    return unify([(s, freeze(t))]) is not None

# ---------- SSU and the (E)+(S) meta-checker ----------
# An SSU constraint a|alpha| = |beta|b is a tuple (a, alpha, beta, b).
# theta is given as a dict {name: term} over x_<alpha> and y_<a>_<alpha>.

def arr(l, r):
    return F('arr', l, r)

def tup(terms):
    out = F('c')
    for t in reversed(list(terms)):
        out = arr(t, out)
    return out

def check_E(constraints, theta):
    for (a, al, be, b) in constraints:
        xb = theta.get('x_' + be)
        y = theta.get('y_%d_%s' % (a, al))
        if xb is None or y is None or is_var(xb) or xb[0] != 'arr':
            return False
        if xb[1 + b] != y:
            return False
    return True

def check_S(constraints, theta):
    for a in (0, 1):
        P = sorted({al for (aa, al, _, _) in constraints if aa == a})
        if not P:
            continue
        xs = tup(theta['x_' + al] for al in P)
        ys = tup(theta['y_%d_%s' % (a, al)] for al in P)
        if not matches_onto(xs, ys):
            return False
    return True

def ssu_certificate(constraints, theta):
    return check_E(constraints, theta) and check_S(constraints, theta)

# ---------- J0 skeleton branches ----------

def J0(constraints):
    branches = []
    for k, (a, al, be, b) in enumerate(constraints):
        h0, h1 = V('h0_%d' % k), V('h1_%d' % k)
        D = [(V('x_' + be), arr(h0, h1))]
        C = [((h0 if b == 0 else h1), V('y_%d_%s' % (a, al)))]
        branches.append((D, C))
    return branches

def theta_eqs(theta):
    return [(V(n), t) for n, t in theta.items()]

# ---------- bounded search over small theta for (E)+(S) ----------

def small_terms(params, depth):
    pool = [V(p) for p in params]
    for _ in range(depth):
        pool = pool + [arr(l, r) for l in pool for r in pool]
        # dedupe
        pool = list(dict.fromkeys(pool))
    return pool

def search_certificates(constraints, depth=2, n_params=2, limit=None):
    names = []
    for (a, al, be, b) in constraints:
        for n in ('x_' + al, 'x_' + be, 'y_%d_%s' % (a, al)):
            if n not in names:
                names.append(n)
    pool = small_terms(['g%d' % i for i in range(n_params)], depth)
    found = []
    for combo in itertools.product(pool, repeat=len(names)):
        theta = dict(zip(names, combo))
        if ssu_certificate(constraints, theta):
            found.append(theta)
            if limit and len(found) >= limit:
                break
    return found

# ---------- experiments ----------

def show(t):
    if is_var(t):
        return t[1]
    if len(t) == 1:
        return t[0]
    return '%s(%s)' % (t[0], ','.join(show(a) for a in t[1:]))

print('=== 1. Proposition 2.1: canonical answer passes J0 (solvable SSU) ===')
# Solvable instance: single constraint 0|p| = |q|0.
# SSU model: phi(p) = g, psi_0(g) = d, phi(q) = arr(d, e).
solvable = [(0, 'p', 'q', 0)]
theta_can = {'x_p': V('g'), 'y_0_p': V('d'), 'x_q': arr(V('d'), V('e'))}
ok, rep = is_answer(theta_eqs(theta_can), J0(solvable))
print('canonical answer passes J0 branches:', ok, rep)
print('(E)+(S) certificate holds:', ssu_certificate(solvable, theta_can))

print()
print('=== 2. J0 alone admits junk; (S) carries the hardness ===')
# Unsolvable instance (Dudenhefner Example 13): 1|p| = |p|0,
# i.e. the unbounded machine {1p -> p0}.
unsolvable = [(1, 'p', 'p', 0)]
theta_junk = {'x_p': arr(V('d'), V('e')), 'y_1_p': V('d')}
ok, rep = is_answer(theta_eqs(theta_junk), J0(unsolvable))
print('junk answer passes J0 branches (unsolvable SSU!):', ok, rep)
print('junk fails (S):', not check_S(unsolvable, theta_junk),
      ' (E) holds:', check_E(unsolvable, theta_junk))

print()
print('=== 3. Lemma 3.1 on both instances (bounded search for (E)+(S)) ===')
cs = search_certificates(solvable, depth=2, n_params=2, limit=1)
print('solvable instance: certificate found:', bool(cs),
      '' if not cs else ' e.g. ' + ', '.join('%s=%s' % (n, show(t)) for n, t in sorted(cs[0].items())))
cu = search_certificates(unsolvable, depth=2, n_params=2)
print('unsolvable instance: certificates found in bounded search:', len(cu),
      ' (depth argument in the notes shows none exist at any depth)')

print()
print('=== 4. Lemma 5.1: merging kills subsumption; only consistency sees it ===')
g1, g2, g = V('g1'), V('g2'), V('g')
c = F('c')
v_pre, u_val = arr(g1, g2), arr(c, arr(c, c))
v_post = arr(g, g)
print('pre-merge:  u <= v:', matches_onto(v_pre, u_val))
print('post-merge: u <= v:', matches_onto(v_post, u_val), ' <- subsumption destroyed')
# The unifiability probe: branch D: v = u, C: top.
probe = [([(V('v'), V('u'))], [])]
ok_pre, _ = is_answer([(V('v'), v_pre), (V('u'), u_val)], probe)
ok_post, rep = is_answer([(V('v'), v_post), (V('u'), u_val)], probe)
print('probe accepts pre-merge:', ok_pre, '; rejects post-merge via consistency:',
      not ok_post, rep)
