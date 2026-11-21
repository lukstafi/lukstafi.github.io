"""A constructor-free ordinary JCA reduction from elementary Diophantine systems."""

import importlib.util
from itertools import combinations, product
from pathlib import Path


spec = importlib.util.spec_from_file_location(
    'round10', Path(__file__).with_name('round-10-experiments.py'))
r10 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(r10)
V, once = r10.V, r10.once
A, B = ('a',), ('b',)


def f(left, right):
    return ('f', left, right)


def call(name, *args):
    return (name, *args)


def hole(index):
    return V(('hole', index))


def insert(body, args):
    return once(body, {('hole', j): t for j, t in enumerate(args)})


def interpret(expr, bodies, env):
    if r10.is_var(expr):
        return env[expr[1]]
    return insert(bodies[expr[0]], [interpret(t, bodies, env) for t in expr[1:]])


def iterate(fun, n, initial):
    for _ in range(n):
        initial = fun(initial)
    return initial


def arithmetic(constraints):
    """Constraint triples ('+',m,n,p), ('*',m,n,p), or ('1',p)."""
    numbers = sorted({name for c in constraints for name in c[1:]})
    arities = {'L': 2, **{('N', name): 3 for name in numbers}}
    v, w, i, j, x, y, r = map(V, 'vwijxyr')
    def pair(a, b):
        return call('L', a, b)
    def succ(a, b, t):
        return pair(a, pair(b, t))
    def num(name, a, b, t):
        return call(('N', name), a, b, t)
    identities = [(num(name, v, w, succ(v, w, x)), succ(v, w, num(name, v, w, x)))
                  for name in numbers]
    for pos, c in enumerate(constraints):
        if c[0] == '1':
            identities.append((num(c[1], v, w, x), succ(v, w, x)))
            continue
        op, m, n, p = c
        if op == '+':
            identities.append((num(p, v, w, x), num(m, v, w, num(n, v, w, x))))
        elif op == '*':
            g = ('G', pos)
            arities[g] = 7
            def history(tail, first, second):
                return call(g, tail, first, second, v, w, i, j)
            end = pair(num(p, v, w, x), num(m, i, j, y))
            identities.append((history(pair(end, r), x, y),
                               pair(pair(x, y), history(r, num(n, v, w, x), succ(i, j, y)))))
        else:
            raise ValueError(op)
    return arities, identities


def arithmetic_bodies(constraints, values, pairing):
    def pair(a, b):
        return insert(pairing, (a, b))
    def numeral(n, a, b, t):
        return iterate(lambda u: pair(a, pair(b, u)), n, t)
    bodies = {'L': pairing}
    for name, n in values.items():
        bodies['N', name] = numeral(n, hole(0), hole(1), hole(2))
    for pos, c in enumerate(constraints):
        if c[0] == '*':
            _, m, n, _ = c
            tail, x, y, v, w, i, j = map(hole, range(7))
            for index in reversed(range(values[m])):
                head = pair(numeral(index * values[n], v, w, x), numeral(index, i, j, y))
                tail = pair(head, tail)
            bodies['G', pos] = tail
    return bodies


class FlatInstance:
    def __init__(self, arities, identities, required):
        self.branches = []
        self.gadgets = []
        self.apps = {}
        self.partials = {}
        self.arities = arities
        variables = sorted(set().union(*(r10.variables(t) for eq in identities for t in eq)))
        self.global_vars = {v: V(('global', v)) for v in variables}
        self.formals = [V(('formal', j)) for j in range(max(arities.values(), default=0))]
        public = [*self.global_vars.values(), *self.formals]
        self.branches.extend(([(t, a)], []) for t in public for a in (A, B))
        self.branches.extend(([(t, A), (u, B)], []) for t, u in combinations(public, 2))
        for name in arities:
            for independent in [*self.global_vars.values(), *self.formals[arities[name]:]]:
                self.absent(independent, V(('body', name)))
        for name, j in required:
            h, y = self.formals[j], V(('body', name))
            z = V(('omit', name, j))
            self.gadgets.append(('omit', z, h, y))
            self.absent(h, z)
            self.branches.append(([(y, z)], [(h, A)]))
        self.final = [(self.flatten(l), self.flatten(r)) for l, r in identities]
        self.branches.extend(([], [eq]) for eq in self.final)
        self.selectors = []
        self.branches = self.single_comparisons(self.branches)

    def single_comparisons(self, branches):
        result = []
        taut = V(('tautology',))
        for pre, post in branches:
            if post:
                for eq in post:
                    result.append((pre or [(taut, taut)], [eq]))
            elif pre:
                index = len(self.selectors)
                u, v = (V(('selector', index, side)) for side in 'uv')
                self.selectors.append((u, v, pre))
                result.extend(([(u, v)], [eq]) for eq in pre)
        anchors = {constant: V(('anchor', constant)) for constant in (A, B)}
        anchored = [(pre, [(anchors.get(l, l), anchors.get(r, r)) for l, r in post])
                    for pre, post in result]
        return anchored + [([(taut, taut)], [(coordinate, constant)])
                           for constant, coordinate in anchors.items()]

    def absent(self, h, x):
        index = len(self.gadgets)
        u, v, p, r = (V(('private', index, name)) for name in 'uvpr')
        self.gadgets.append(('absent', u, v, p, r, index))
        self.branches.extend([
            ([(u, v)], [(p, A), (r, B)]),
            ([(p, B), (r, A)], []),
            ([(p, u)], []),
            ([(p, x), (h, v)], [])])

    def flatten(self, expr):
        if r10.is_var(expr):
            return self.global_vars[expr[1]]
        if expr in self.apps:
            return self.apps[expr]
        args = [self.flatten(t) for t in expr[1:]]
        assert len(args) == self.arities[expr[0]]
        previous = V(('body', expr[0]))
        site = len(self.apps)
        for j, (h, arg) in enumerate(zip(self.formals, args)):
            out = V(('stage', site, j))
            self.partials[out[1]] = (expr, j+1)
            self.absent(h, out)
            self.branches.append(([(h, arg)], [(previous, out)]))
            previous = out
        self.apps[expr] = previous
        # Final expression coordinates must be independent of every formal,
        # including those of higher-arity operations elsewhere in the system.
        for h in self.formals:
            self.absent(h, previous)
        return previous

    def witness(self, bodies):
        env = {v: V(('global-param', v)) for v in self.global_vars}
        P = {g[1]: env[v] for v, g in self.global_vars.items()}
        P.update((h[1], hole(j)) for j, h in enumerate(self.formals))
        P.update((('body', name), body) for name, body in bodies.items())
        for key, (expr, used) in self.partials.items():
            args = [interpret(child, bodies, env) for child in expr[1:used+1]]
            args += [hole(j) for j in range(used, self.arities[expr[0]])]
            P[key] = insert(bodies[expr[0]], args)
        for tag, *args in self.gadgets:
            if tag == 'omit':
                z, h, y = args
                P[z[1]] = once(P[y[1]], {P[h[1]][1]: A})
            else:
                u, v, p, r, index = args
                s, t = (V(('private-param', index, n)) for n in 'st')
                P.update({u[1]: f(A, B), v[1]: f(s, t), p[1]: s, r[1]: t})
        P[('tautology',)] = A
        P.update((('anchor', c), c) for c in (A, B))
        for u, v, pre in self.selectors:
            eqs = [(once(l, P), once(r, P)) for l, r in pre]
            mu = r10.unify(eqs)
            if mu is None:
                raise ValueError('The proposed pattern has no witness for a guard')
            names = sorted(set().union(*(r10.variables(t) for eq in eqs for t in eq)))
            def ground(t):
                value = r10.apply(t, mu)
                return once(value, {name: A for name in r10.variables(value)})
            left, right = A, A
            for name in names:
                left, right = f(V(name), left), f(ground(V(name)), right)
            P[u[1]], P[v[1]] = left, right
        return P


def passes(P, branch):
    premise, post = branch
    def at(term):
        return P[term[1]] if r10.is_var(term) else term
    mu = r10.unify([(at(l), at(r)) for l, r in premise])
    return mu is not None and all(r10.apply(at(l), mu) == r10.apply(at(r), mu) for l, r in post)


def check_compiler():
    systems = [
        ([('1', 'one'), ('+', 'one', 'one', 'two'), ('*', 'two', 'one', 'two')],
         {'one': 1, 'two': 2}, f(hole(0), hole(1))),
        ([('*', 'm', 'n', 'p')], {'m': 1, 'n': 0, 'p': 0},
         f(A, f(hole(0), f(hole(1), hole(1))))),
    ]
    for constraints, values, pair in systems:
        arities, identities = arithmetic(constraints)
        target = FlatInstance(arities, identities, [('L', 0), ('L', 1)])
        bodies = arithmetic_bodies(constraints, values, pair)
        P = target.witness(bodies)
        assert all(t in (A, B) or r10.is_var(t) for br in target.branches
                   for equations in br for eq in equations for t in eq)
        assert all(len(pre) == len(post) == 1 and all(map(r10.is_var, pre[0]))
                   for pre, post in target.branches)
        literal_constants = [t for _, post in target.branches for eq in post for t in eq if t in (A, B)]
        assert literal_constants == [A, B]
        assert all(passes(P, br) for br in target.branches)
        # Each branch sees only its named coordinates. Their equations are
        # an exact projection because the pattern parameters are fresh.
        for br in target.branches:
            names = {t[1] for eqs in br for eq in eqs for t in eq if r10.is_var(t)}
            equations = [(V(name), P[name]) for name in names]
            assert r10.answer(equations, [br])
        print(f'{len(target.branches):,} constructor-free branches and '
              f'{len(P):,} coordinates verified by unification.')
    arities, identities = arithmetic([('*', 'm', 'n', 'p')])
    target = FlatInstance(arities, identities, [('L', 0), ('L', 1)])
    wrong = arithmetic_bodies([('*', 'm', 'n', 'p')], {'m': 1, 'n': 1, 'p': 0}, f(hole(0), hole(1)))
    wrong_pattern = target.witness(wrong)
    assert not all(passes(wrong_pattern, ([], [eq])) for eq in target.final)
    print('An incorrect endpoint fails the final equation.')


def check_absence():
    q, s, t = (V(k) for k in 'qst')
    h, x, u, v, p, r = (V(k) for k in 'hxuvpr')
    brs = [([(u, v)], [(p, A), (r, B)]), ([(p, B), (r, A)], []),
           ([(p, u)], []), ([(p, x), (h, v)], [])]
    leaves = [A, B, q, s, t]
    terms = [*leaves, *(f(l, k) for l, k in product(leaves, repeat=2))]
    total = accepted = 0
    for U, W in product(terms, repeat=2):
        for left, right in product((q,s,t), repeat=2):
            P = dict(h=q,u=U,v=W,p=left,r=right)
            if not all(passes(P, br) for br in brs[:3]):
                continue
            for X in terms:
                total += 1
                P['x'] = X
                if passes(P, brs[3]):
                    accepted += 1
                    assert 'q' not in r10.variables(X)
    assert accepted > 0
    P = dict(h=q,u=f(A,B),v=f(s,t),p=s,r=t)
    for X in terms:
        if set(r10.variables(X)) & {'s', 't'}:
            continue
        P['x'] = X
        assert all(passes(P, br) for br in brs) == ('q' not in r10.variables(X))
    print(f'{total:,} final guards tested after the first three branches, {accepted:,} accepted.')


if __name__ == '__main__':
    check_absence()
    check_compiler()
