"""A fixed-branch constructor-free counter, attached to the Round 15 compiler."""

import importlib.util
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    'round15', Path(__file__).with_name('round-15-experiments.py'))
r15 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r15)
A, B, V, f, r10 = r15.A, r15.B, r15.V, r15.f, r15.r10


def pack(terms):
    """One common tree shape for two equal-length vectors."""
    if not terms:
        return A
    if len(terms) == 1:
        return terms[0]
    mid = len(terms) // 2
    return f(pack(terms[:mid]), pack(terms[mid:]))


class ArithmeticBase:
    def __init__(self, constraints, distinguished):
        self.constraints = constraints
        arities, identities = r15.arithmetic(constraints)
        v, w = V('v'), V('w')
        self.inputs = [V('counter-left'), V('counter-right')]
        self.next = [('L', v, ('L', w, arg)) for arg in self.inputs]
        self.end = [(('N', distinguished), v, w, arg) for arg in self.inputs]
        identities.extend((expr, expr) for expr in self.next + self.end)
        self.flat = r15.FlatInstance(arities, identities, [('L', 0), ('L', 1)])
        self.markers = [self.flat.global_vars[arg[1]] for arg in self.inputs]


class Counter:
    def __init__(self, base, n):
        if n < 0:
            raise ValueError('A counter length must be nonnegative')
        self.base, self.n = base, n
        self.branches, self.selectors, self.groups = [], [], []
        flat, markers = base.flat, base.markers
        endpoint = flat.apps[base.end[n % 2]]
        self.stages = [markers[0]] + [V(('counter-stage', i)) for i in range(1, n)]
        if n == 0:
            taut = V(('tautology',))
            self.branches.append(([(taut, taut)], [(markers[0], endpoint)]))
            return
        self.stages.append(endpoint)
        for parity in range(2):
            # The fixed base already scopes both endpoints.
            interior = self.stages[2 if parity == 0 else 1:n:2]
            if interior:
                self.exclude(markers[1 - parity], interior, parity)
            links = list(zip(self.stages[parity:n:2], self.stages[parity + 1:n + 1:2]))
            if links:
                opposite_step = flat.apps[base.next[1 - parity]]
                self.branches.append(([(markers[parity], opposite_step)], links))

    def guard(self, equations):
        k = len(self.selectors)
        u, v = (V(('counter-selector', k, name)) for name in 'uv')
        self.selectors.append((u, v, equations))
        self.branches.append(([(u, v)], equations))

    def exclude(self, marker, terms, group):
        u, v, r = (V(('counter-group', group, name)) for name in 'uvr')
        ps = [V(('counter-slot', group, j)) for j in range(len(terms))]
        ca, cb = (V(('anchor', c)) for c in (A, B))
        self.branches.append(([(u, v)], [(p, ca) for p in ps] + [(r, cb)]))
        self.guard([(p, cb) for p in ps] + [(r, ca)])
        self.guard([(p, u) for p in ps])
        self.guard(list(zip(ps, terms)) + [(marker, v)])
        self.groups.append((group, u, v, r, ps))

    def witness(self, baseline, pairing):
        P = dict(baseline)
        v, w = (P[self.base.flat.global_vars[name][1]] for name in 'vw')
        def step(term):
            return r15.insert(pairing, (v, r15.insert(pairing, (w, term))))
        for i in range(1, self.n):
            seed = P[self.base.markers[i % 2][1]]
            P[self.stages[i][1]] = r15.iterate(step, i, seed)
        for g, u, v_coord, r, ps in self.groups:
            ss = [V(('counter-slot-param', g, j)) for j in range(len(ps))]
            t = V(('counter-final-param', g))
            P.update((p[1], s) for p, s in zip(ps, ss))
            P[r[1]] = t
            P[u[1]], P[v_coord[1]] = pack([A] * len(ps) + [B]), pack(ss + [t])
        for u, v_coord, eqs in self.selectors:
            terms = [(P[l[1]], P[r[1]]) for l, r in eqs]
            mu = r10.unify(terms)
            if mu is None:
                raise ValueError('The proposed pattern has no joint guard witness')
            names = sorted({q for eq in terms for t in eq for q in r10.variables(t)})
            params = [V(name) for name in names]
            values = [r10.apply(t, mu) for t in params]
            grounding = {q: A for value in values for q in r10.variables(value)}
            P[u[1]] = pack(params)
            P[v_coord[1]] = pack([r10.once(t, grounding) for t in values])
        return P


def check():
    # Equality d = 1*d permits every input and exercises the multiplication compiler.
    constraints = [('1', 'one'), ('*', 'one', 'd', 'd')]
    base = ArithmeticBase(constraints, 'd')
    fixed = base.flat.branches
    cases = [(n, f(r15.hole(0), r15.hole(1))) for n in range(10)]
    cases.append((3, f(f(r15.hole(0), r15.hole(0)), r15.hole(1))))
    for n, pairing in cases:
        bodies = r15.arithmetic_bodies(constraints, {'one': 1, 'd': n}, pairing)
        baseline = base.flat.witness(bodies)
        assert all(r15.passes(baseline, br) for br in fixed)
        counter = Counter(base, n)
        branches = fixed + counter.branches
        assert len(counter.branches) <= 10
        assert all(len(pre) == 1 and all(map(r10.is_var, pre[0]))
                   for pre, _ in branches)
        atoms = [t for _, post in branches for eq in post for t in eq if not r10.is_var(t)]
        assert atoms == [A, B]
        P = counter.witness(baseline, pairing)
        assert all(r15.passes(P, br) for br in counter.branches)
        for br in counter.branches:
            coords = {t[1] for eqs in br for eq in eqs for t in eq}
            assert r10.answer([(V(k), P[k]) for k in coords], [br])
        for other in (n + 1, max(0, n - 1)):
            if n == other:
                continue
            wrong = Counter(base, other)
            Q = wrong.witness(baseline, pairing)
            assert any(not r15.passes(Q, br) for br in wrong.branches)
    print(f'{len(fixed):,} fixed arithmetic branches; '
          f'{len(Counter(base, 9).branches)} extra branches at length 9.')
    print('Checked lengths 0 through 9, incorrect endpoints on each side, '
          'and a pairing operation that duplicates its head.')


if __name__ == '__main__':
    check()
