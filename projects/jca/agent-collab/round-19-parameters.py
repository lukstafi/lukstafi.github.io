"""Monadic JCA with designated parameters. Emit systems of word equations.

Coordinates are r18.parameter(name), constants are strings. A term is
(prefix tokens, leaf). Fresh names use ('fresh', i). Public names must be disjoint.
The scope relation allows(u, d) is supplied on original prefix variables.
"""

import importlib.util
from itertools import combinations, product
from pathlib import Path


spec = importlib.util.spec_from_file_location('monadic', Path(__file__).with_name('round-18-monadic.py'))
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
P = m.parameter


def bare(x):
    return (), P(x)


def is_coord(tail):
    return isinstance(tail, tuple) and tail[0] == 'p'


def validity(atoms, prefix, namespace):
    """Check the quantifier game of this particular conjunction and presentation."""
    for bindings, equations in m.unifier_traces(atoms, namespace):
        used, extra = set(), []
        for quantifier, x in prefix:
            w, tail = m.apply_chains(bare(x), bindings)
            if quantifier == 'all':
                if not is_coord(tail) or tail in used:
                    break
                extra.append((w, ()))
            used.add(tail)
        else:
            yield equations + tuple(extra)


def substitute(t, witnesses):
    w, tail = t
    if is_coord(tail) and tail[1] in witnesses:
        v, leaf = witnesses[tail[1]]
        return w + v, leaf
    return t


def combine(tests, pos=0, conditions=()):
    if pos == len(tests):
        yield conditions
        return
    for disjunct in tests[pos]():
        yield from combine(tests, pos+1, conditions + disjunct)


def check_schema(atoms, witnesses, prefix, fresh, designated, branches, allows,
                 *, weak=True, strong=False):
    """A guessed atom skeleton and witness tails; prefixes may be word unknowns.

    The strong interface accepts solved substitutions only. All atom left sides
    are bare coordinates in that interface.
    """
    game = [('all', b) for b in fresh] + list(prefix)
    universals = {x for quantifier, x in prefix if quantifier == 'all'}
    if strong:
        lefts = [l[1] for l, _ in atoms]
        if (any(l[0] or not is_coord(l[1]) for l, _ in atoms)
                or len(lefts) != len(set(lefts)) or any(r[1] in lefts for _, r in atoms)):
            return
    checks = []
    for i, (l, r) in enumerate(atoms):
        names = {t[1][1] for t in (l, r) if is_coord(t[1])}
        local = names & designated
        if strong and l[1][1] in designated:
            if any(not allows(u, l[1][1]) for u in names & universals):
                return
        if weak and local and any(not any(allows(u, d) for d in local) for u in names & universals):
            checks.append(lambda l=l, r=r, i=i: validity([(l,r)], game, ('atom', i)))
    specialized = [(substitute(l, witnesses), substitute(r, witnesses)) for l,r in atoms]
    checks.append(lambda: validity(specialized, game, 'validity'))
    for i, (pre, post) in enumerate(branches):
        checks.append(lambda i=i, pre=pre, post=post: m.branch_systems(
            list(atoms) + list(pre), post, ('branch', i)))
    yield from combine(checks)


def candidates(prefix, constants, designated, targets, branches, allows, allowed_witness_leaf,
               *, weak=True, strong=False):
    """Enumerate the finite disjunction. Word unknowns range over the fixed unary alphabet.

    allowed_witness_leaf(target, name) admits named variables in substitution
    terms; all ground constant leaves are allowed. Prefixes contain only unary letters.
    """
    public = [x for _, x in prefix]
    for fresh_count in range(len(public) + 1):
        fresh = [('fresh', i) for i in range(fresh_count)]
        names = public + fresh
        leaves = [*map(P, names), *constants]
        edges = [(x, y) for x in names for y in leaves if y != P(x)]
        choices = [[(m.word(('witness', d)), y) for y in leaves
                    if not is_coord(y) or allowed_witness_leaf(d, y[1])] for d in targets]
        for size in range(len(names) + 1):
            for shape in combinations(edges, size):
                atoms = [(bare(x), ((m.word(('edge', i)),), y)) for i,(x,y) in enumerate(shape)]
                for selection in product(*choices):
                    witnesses = {d: ((token,), y) for d,(token,y) in zip(targets,selection)}
                    for eqs in check_schema(atoms, witnesses, prefix, fresh, designated,
                                            branches, allows, weak=weak, strong=strong):
                        yield atoms, witnesses, eqs


def forest(atoms):
    """Keep a subset of a jointly satisfiable normalized presentation."""
    parent = {}
    def root(x):
        while x in parent:
            x = parent[x]
        return x
    edges, pins = [], []
    for l, r in atoms:
        x, y = l[1], r[1]
        if not is_coord(y):
            pins.append((l,r))
        elif root(x) != root(y):
            parent[root(x)] = root(y)
            edges.append((l,r))
    pinned = set()
    for l,r in pins:
        group = root(l[1])
        if group not in pinned:
            edges.append((l,r))
            pinned.add(group)
    return edges


def check():
    a, g = ((), 'a'), ('g',)
    u, chi, z, fresh = 'u', 'chi', 'z', ('fresh', 0)
    seed = lambda w, x: (w, P(x))
    relation = [(bare(chi), seed(g, u))]
    bridge = [(bare(u), bare(fresh)), (bare(chi), seed(g, fresh))]
    prefix = [('all',chi), ('some',z), ('all',u)]
    scope = lambda u0, d: (u0, d) != (u, chi)
    branches = [([], relation)]
    def passes(atoms, replacements, leading, test_prefix=prefix, strong=True, allows=scope):
        return any(m.fits_prefixes(eqs, {}) for eqs in check_schema(
            atoms, replacements, test_prefix, leading, {chi}, branches, allows, strong=strong))
    assert passes(bridge, {fresh:bare(u), chi:seed(g,u)}, [])
    assert not passes(bridge, {chi:seed(g,u)}, [fresh])
    assert not passes(relation, {chi:seed(g,u)}, [], strong=False)
    assert passes(relation, {chi:seed(g,u)}, [], [('all',u), ('some',z), ('all',chi)],
                  strong=False, allows=lambda u0, d: True)
    # Weak escape permits a locally prefix-valid atom, even if its endpoints fail the order.
    assert any(m.fits_prefixes(eqs, {}) for eqs in check_schema(
        [(bare(z),bare(chi))], {}, [('all',chi),('some',z)], [], {chi}, [], lambda u,d: False))
    # Exhaustive word/leaf assignments compare the chosen forest with the full presentation.
    names = ['x','y','z']
    ground = [(w, c) for c in ('a','b') for w in ((),g,g+g)]
    assignments = [dict(zip(names, vals)) for vals in product(ground, repeat=3)]
    def eval_term(t, env):
        w, leaf = t
        if not is_coord(leaf):
            return w, leaf
        v, c = env[leaf[1]]
        return w+v, c
    possible = [(bare(x),(w,y)) for x in names for y in [*map(P,names),'a','b']
                for w in ((),g)]
    for env in assignments:
        atoms = [(l,r) for l,r in possible if eval_term(l,env) == eval_term(r,env)]
        kept = forest(atoms)
        assert len(kept) <= len(names)
        def models(eqs, assignment):
            return all(eval_term(l,assignment) == eval_term(r,assignment) for l,r in eqs)
        for other in assignments:
            assert models(atoms, other) == models(kept, other)
    # The generator includes the nonempty answer x=a under an existential prefix.
    gen = candidates([('some','x')], ['a','b'], set(), [], [([],[(bare('x'), a)])],
                     lambda u,d: True, lambda d,v: True)
    assert any(m.fits_prefixes(eqs, {('edge',i): () for i in range(len(atoms))})
               for atoms, _, eqs in gen)
    print(f'{len(assignments)**2:,} forest equivalence checks; witness-order and scope examples passed.')


if __name__ == '__main__':
    check()
