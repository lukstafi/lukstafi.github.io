"""Three binary-signature JCA branches for rigid reachability with ground rules."""

import importlib.util
from functools import lru_cache
from pathlib import Path


def sibling(module, filename):
    spec = importlib.util.spec_from_file_location(module, Path(__file__).with_name(filename))
    loaded = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(loaded)
    return loaded


r14 = sibling('round14', 'round-14-experiments.py')
r10, V, f, A, B = r14.r10, r14.V, r14.f, r14.a, r14.b
NIL = ('nil',)
MARK = f(B, f(B, B))
FRAME = f(B, B)


class Encoding:
    def __init__(self, rules, arities):
        self.rules = rules
        self.m = len(rules) + 1
        self.arity = {**arities, 'cons': 2}
        self.arity.pop('nil', None)
        self.arity.update((('wrap', i), 1) for i in range(1, self.m + 1))
        self.tags, self.symbols = {}, {}
        tag = B
        for g in self.arity:
            self.tags[g], self.symbols[tag] = tag, g
            tag = f(tag, B)
        self.slots = [(arm, i) for i in range(1, self.m) for arm in ('in', 'out')] + [('tail',)]
        self.defaults = [NIL, *(r for _, r in rules), NIL]

    def macro(self, g, *args):
        assert len(args) == self.arity[g]
        spine = B
        for x in reversed(args):
            spine = f(f(FRAME, x), spine)
        return f(MARK, f(self.tags[g], spine))

    @lru_cache(maxsize=8192)
    def parse(self, term):
        if term[0] != 'f' or term[1] != MARK or term[2][0] != 'f':
            return None
        _, tag, spine = term[2]
        g = self.symbols.get(tag)
        if g is None:
            return None
        slots = []
        for _ in range(self.arity[g]):
            if spine[0] != 'f' or spine[1][0] != 'f' or spine[1][1] != FRAME:
                return None
            slots.append(spine[1][2])
            spine = spine[2]
        return (g, slots) if spine == B else None

    def wrappers(self, first, last, x):
        for j in reversed(range(first, last + 1)):
            x = self.macro(('wrap', j), x)
        return x

    def encode(self, term, mode=0):
        if r10.is_var(term) or term == NIL:
            assert mode == 0
            return A if term == NIL else term
        g, *args = term
        return self.wrappers(mode + 1, self.m, self.macro(g, *(self.encode(t) for t in args)))

    def decode(self, t, mode=0, holes=False):
        if holes and r10.is_var(t):
            name = t[1]
            if name == ('tail',) and mode == 0:
                return V('last')
            if name == ('in', mode):
                return V(('rule', mode))
            return self.defaults[mode]
        match = self.parse(t)
        if match:
            g, args = match
            if mode < self.m and g == ('wrap', mode + 1):
                return self.decode(args[0], mode + 1, holes)
            if mode == self.m and isinstance(g, str):
                return (g, *(self.decode(x, 0, holes) for x in args))
        return self.defaults[mode]

    def samples(self, s, t, z):
        left, right = [], []
        for i, (l, r) in enumerate(self.rules, start=1):
            left.extend([self.encode(l, mode=i), A])
            right.extend([A, self.encode(r, mode=i)])
        left.append(self.encode(('cons', t, NIL)))
        right.append(A)
        return [(left, self.encode(('cons', s, z))), (right, z)]

    def compile(self, s, t):
        z = V(('result',))
        data = sorted(r10.variables(s) | r10.variables(t)) + [z[1]]
        _, *three = r14.compile_instance(data, self.slots, ('body',), [], self.samples(s, t, z))
        return three

    def list_node(self, head, tail):
        return self.wrappers(1, self.m, self.macro('cons', head, tail))

    def path_body(self, steps):
        # A step gives a rule number and a one-hole source context at its redex.
        value = V(('tail',))
        for i, ctx in reversed(steps):
            outer = self.encode(ctx)
            for arm in ('out', 'in'):
                head = r10.once(outer, {'redex': self.wrappers(1, i, V((arm, i)))})
                value = self.list_node(head, value)
        return value


def at_holes(body, names, values):
    # Insert only at actual occurrences; sharing intact ground subtrees matters
    # for the expanded size of the history used by the example.
    env = dict(zip(names, values))
    return r10.once(body, env)


class OneConstantEncoding(Encoding):
    # 0 is the state of a, every hole and every complete macro.
    # 1 generates tags and marks slot entries, 2 marks entries, 3 marks spine nodes.
    generator = f(A, A)

    def __init__(self, rules, arities):
        super().__init__(rules, arities)
        self.tags, self.symbols = {}, {}
        tag = A
        for state, g in enumerate(self.arity, start=4):
            tag = f(tag, self.generator)
            self.tags[g], self.symbols[state] = tag, g

    @lru_cache(maxsize=16384)
    def state(self, t):
        if t[0] != 'f':
            return 0
        left, right = self.state(t[1]), self.state(t[2])
        if left == right == 0:
            return 1
        if left == 1:
            return 2
        if left == 2:
            return 3
        if right == 1:
            if left == 0:
                return 4
            if left >= 4 and left + 1 in self.symbols:
                return left + 1
        return 0

    def macro(self, g, *args):
        assert len(args) == self.arity[g]
        spine = A
        for x in reversed(args):
            spine = f(f(self.generator, x), spine)
        return f(self.tags[g], spine)

    @lru_cache(maxsize=8192)
    def parse(self, t):
        if t[0] != 'f':
            return None
        g = self.symbols.get(self.state(t[1]))
        if g is None:
            return None
        slots, spine = [], t[2]
        for _ in range(self.arity[g]):
            if self.state(spine) != 3 or spine[0] != 'f':
                return None
            head, spine = spine[1:]
            if self.state(head) != 2 or head[0] != 'f':
                return None
            slots.append(head[2])
        return (g, slots) if self.state(spine) == 0 else None


def check(implementation, atoms):
    zero, one = ('zero',), ('one',)
    rules = [(('next', zero), ('next', one)), (('next', one), one)]
    enc = implementation(rules, {'zero': 0, 'one': 0, 'next': 1, 'pair': 2})
    initial = ('pair', rules[0][0], zero)
    final = ('pair', one, zero)
    x = V('x')
    s = ('pair', rules[0][0], x)
    t = ('pair', one, x)
    steps = [(i, ('pair', V('redex'), zero)) for i in (1, 2)]
    body = enc.path_body(steps)
    raw = enc.samples(initial, final, V(('result',)))
    z = at_holes(body, enc.slots, raw[1][0])
    actual = at_holes(body, enc.slots, raw[0][0])
    assert actual == r10.once(raw[0][1], {('result',): z})
    canonical = {h: V(('param', h)) for h in enc.slots}
    canonical.update({'x': enc.encode(zero), ('result',): z,
                      ('body',): r10.once(body, canonical)})
    branches = enc.compile(s, t)
    assert len(branches) == 3
    def binary(t):
        return r10.is_var(t) or t in atoms or (t[0] == 'f' and all(binary(k) for k in t[1:]))
    assert all(binary(t) for br in branches for eqs in br for eq in eqs for t in eq)
    assert r14.accepts(canonical, branches)
    assert enc.path_body([]) == V(('tail',))
    empty = enc.samples(initial, initial, V(('result',)))
    assert empty[0][0][-1] == r10.once(empty[0][1], {('result',): A})

    # Read this source path backwards.  The new Y,Z contain separate
    # step bodies ending at the same right-row head for each adjacent pair.
    # Reversing two rules here is necessary: the starting `one` is irreducible.
    left_heads, right_heads = [], []
    for i, ctx in reversed(steps):
        outer = enc.encode(ctx)
        for arm in ('out', 'in'):
            redex = enc.wrappers(1, i, V((arm, i)))
            forward = r10.once(outer, {'redex': redex})
            target_head = at_holes(forward, enc.slots, raw[1][0])
            left_heads.append(target_head)
            right_heads.append(forward)
    body_y, body_z = V(('tail',)), A
    for y_head, z_head in reversed(list(zip(left_heads, right_heads))):
        body_y = enc.list_node(y_head, body_y)
        body_z = enc.list_node(z_head, body_z)
    backwards = enc.compile(t, s)
    leaking = {**canonical, ('body',): r10.once(body_y, canonical),
               ('result',): r10.once(body_z, canonical)}
    assert r14.accepts(leaking, backwards[1:])
    assert not r14.accepts(leaking, backwards)
    print('Both evaluation branches accept the reversed path; the scope guard rejects it.')

    # Move a hole through every fixed position and through genuine slots.
    def replace_one(t, hole):
        yield hole
        if t[0] == 'f':
            yield from (f(l, t[2]) for l in replace_one(t[1], hole))
            yield from (f(t[1], r) for r in replace_one(t[2], hole))
    malformed = [*atoms, f(A, A), f(f(A, A), A), f(A, f(A, A))]
    candidates = set(map(V, enc.slots)) | set(malformed) | {body}
    for g, arity in enc.arity.items():
        sample = enc.macro(g, *([V(('tail',))] * arity))
        for h in enc.slots:
            candidates.update(replace_one(sample, V(h)))
    for t0 in (zero, ('pair', zero, one)):
        candidates.add(enc.encode(t0))
    modes = range(enc.m + 1)
    for left_row, (args, _) in zip((True, False), raw):
        orig = {('rule', i): rule[0 if left_row else 1]
                for i, rule in enumerate(rules, start=1)}
        orig['last'] = ('cons', final, NIL) if left_row else NIL
        for candidate in candidates:
            evaluated = at_holes(candidate, enc.slots, args)
            for k in modes:
                expected = r10.once(enc.decode(candidate, k, holes=True), orig)
                assert enc.decode(evaluated, k) == expected
    # Arbitrary malformed target data still decode homomorphically at variable slots.
    for d in [*malformed, enc.encode(one), raw[0][0][0]]:
        assert enc.decode(r10.once(enc.encode(s), {'x': d})) == r10.once(s, {'x': enc.decode(d)})
    print('A two-step rewrite produces a passing three-branch binary JCA pattern.')
    print(f'{len(candidates) * len(modes) * 2:,} decoding identities checked in every mode, '
          'including malformed bodies and the complete encoded history.')


if __name__ == '__main__':
    check(Encoding, (A, B))
    check(OneConstantEncoding, (A,))
