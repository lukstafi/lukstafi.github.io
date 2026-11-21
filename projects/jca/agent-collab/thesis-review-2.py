"""Executable checks for the mixed-prefix and strict branch compilers.

The compilers operate on symbolic terms. Only the independent test oracle
below enumerates finite carriers. Run with Python 3.10 or later.
"""
from dataclasses import dataclass
from itertools import count, product
from random import Random


TYPE = "type"


@dataclass(frozen=True)
class Var:
    sort: str
    name: str


@dataclass(frozen=True)
class App:
    sort: str
    name: str
    args: tuple


def app(sort, name, *args):
    return App(sort, name, args)


def variables(t):
    if isinstance(t, Var):
        return {t}
    return set().union(*(variables(a) for a in t.args))


def normalize(t, subst):
    if isinstance(t, Var):
        return normalize(subst[t], subst) if t in subst else t
    return App(t.sort, t.name, tuple(normalize(a, subst) for a in t.args))


def instantiate(t, witnesses):
    """Apply written witnesses simultaneously, including non-idempotent maps."""
    if isinstance(t, Var):
        return witnesses.get(t, t)
    return App(t.sort, t.name, tuple(instantiate(a, witnesses) for a in t.args))


def solve(equations):
    """Return type bindings and side obligations, or None on structural failure."""
    subst, residual, pending = {}, [], list(equations)
    while pending:
        l, r = (normalize(t, subst) for t in pending.pop())
        assert l.sort == r.sort
        if l == r:
            continue
        if l.sort != TYPE:
            residual.append((l, r))
        elif isinstance(l, Var) or isinstance(r, Var):
            if isinstance(r, Var):
                l, r = r, l
            if l in variables(r):
                return None
            subst[l] = r
        elif l.name == r.name:
            pending.extend(zip(l.args, r.args, strict=True))
        else:
            return None
    return subst, residual


def leaves(t):
    """Yield type holes and maximal side expressions at their type addresses."""
    if isinstance(t, Var) or t.sort != TYPE:
        yield t
    else:
        for arg in t.args:
            yield from leaves(arg)


def compile_game(prefix, equations, side_sorts):
    """Compile a positive mixed game to one game per side sort."""
    solved = solve(equations)
    if solved is None:
        return None
    subst, residual = solved
    games = {s: ([], []) for s in side_sorts}
    for l, r in residual:
        games[l.sort][1].append((l, r))
    seen, names, serial = set(), {v for _, v in prefix}, count()
    for quant, v in prefix:
        if v.sort != TYPE:
            games[v.sort][0].append((quant, v))
            continue
        pat = normalize(v, subst)
        if quant == "all" and (not isinstance(pat, Var) or pat in seen):
            return None
        for leaf in leaves(pat):
            if leaf.sort == TYPE:
                seen.add(leaf)
            else:
                c = Var(leaf.sort, f"frozen{next(serial)}")
                while c in names:
                    c = Var(leaf.sort, f"frozen{next(serial)}")
                names.add(c)
                local_prefix, conditions = games[c.sort]
                local_prefix.append(("ex", c))
                conditions.append((c, leaf))
    return games


def compile_branch(premise_and_answer, conclusions, side_sorts):
    """Compile strict consistency and relevance. The conclusion holes are rigid."""
    solved = solve(premise_and_answer)
    if solved is None:
        return None
    subst, guards = solved
    tests = {s: ([], []) for s in side_sorts}
    for l, r in guards:
        tests[l.sort][0].append((l, r))
    pending = list(conclusions)
    while pending:
        l, r = (normalize(t, subst) for t in pending.pop())
        if l == r:
            continue
        if l.sort != TYPE:
            tests[l.sort][1].append((l, r))
        elif isinstance(l, Var) or isinstance(r, Var) or l.name != r.name:
            return None
        else:
            pending.extend(zip(l.args, r.args, strict=True))
    return tests


# A complete finite free type algebra, with two independent leaf sorts.
N, B = "index", "flag"
SIDE = (N, B)
VALUES = {N: (0, 1), B: (0, 1)}
VALUES[TYPE] = (("Unit",), *(("Num", n) for n in VALUES[N]),
                *(("Tag", n, b) for n, b in product(VALUES[N], VALUES[B])))


def evaluate(t, env):
    if isinstance(t, Var):
        return env[t]
    args = tuple(evaluate(a, env) for a in t.args)
    if t.sort == TYPE:
        return (t.name, *args)
    if t.name == "flip":
        return 1 - args[0]
    return int(t.name)


def holds(eqs, env):
    return all(evaluate(l, env) == evaluate(r, env) for l, r in eqs)


def play(prefix, eqs, env=None):
    env = {} if env is None else env
    if not prefix:
        return holds(eqs, env)
    (quant, v), *tail = prefix
    aggregate = all if quant == "all" else any
    return aggregate(play(tail, eqs, env | {v: value}) for value in VALUES[v.sort])


def strict_branch(guard, goal):
    vs = sorted(set().union(*(variables(t) for eq in guard + goal for t in eq)),
                key=lambda v: (v.sort, v.name))
    witnessed = False
    for row in product(*(VALUES[v.sort] for v in vs)):
        env = dict(zip(vs, row))
        if holds(guard, env):
            if not holds(goal, env):
                return False
            witnessed = True
    return witnessed


def game_ok(prefix, eqs):
    gs = compile_game(prefix, eqs, SIDE)
    return gs is not None and all(play(q, c) for q, c in gs.values())


def branch_ok(guard, goal):
    bs = compile_branch(guard, goal, SIDE)
    return bs is not None and all(strict_branch(g, c) for g, c in bs.values())


def free(eqs):
    return set().union(*(variables(t) for pair in eqs for t in pair))


def assignments(vs):
    vs = sorted(vs, key=lambda v: (v.sort, v.name))
    for values in product(*(VALUES[v.sort] for v in vs)):
        yield dict(zip(vs, values))


def clause_ok(guard, goal, locals_):
    """Validate a positive clause whose head can introduce private witnesses."""
    assert not (free(guard) & locals_)
    solved = solve(guard)
    if solved is None:
        return True
    subst, residual = solved
    side_guards = {s: [eq for eq in residual if eq[0].sort == s] for s in SIDE}
    for guard_s in side_guards.values():
        if not any(holds(guard_s, env) for env in assignments(free(guard_s))):
            return True
    head = [(normalize(l, subst), normalize(r, subst)) for l, r in goal]
    globals_ = (free(head) | free(residual)) - locals_
    prefix = [(q, v) for q, vs in (("all", globals_), ("ex", locals_))
              for v in sorted(vs, key=lambda v: (v.sort, v.name))]
    games = compile_game(prefix, head, SIDE)
    if games is None:
        return False
    for s, (qs, matrix) in games.items():
        relevant = side_guards[s]
        for env in assignments(v for q, v in qs if q == "all"):
            if holds(relevant, env) and not play([(q, v) for q, v in qs if q == "ex"],
                                                  matrix, env):
                return False
    return True


def direct_clause(guard, goal, locals_):
    return all(not holds(guard, env) or
               any(holds(goal, env | w) for w in assignments(locals_))
               for env in assignments((free(guard) | free(goal)) - locals_))


def main():
    x, y = Var(TYPE, "x"), Var(TYPE, "y")
    h, v, b = Var(N, "h"), Var(N, "v"), Var(B, "b")
    zero, one = app(N, "0"), app(N, "1")
    def num(t):
        return app(TYPE, "Num", t)

    for digit in (zero, one):
        guard, goal = [(x, num(digit))], [(h, digit)]
        assert branch_ok(guard + [(x, num(h))], goal)
        assert not branch_ok(guard, goal)
    before = [("ex", x), ("all", h), ("ex", v)]
    after = [("all", h), ("ex", x), ("ex", v)]
    assert not game_ok(before, [(x, num(v)), (v, h)])
    assert game_ok(after, [(x, num(v)), (v, h)])
    assert solve([(x, app(TYPE, "Arrow", x, y))]) is None
    nested = [(x, app(TYPE, "Arrow", y, num(h)))]
    assert not game_ok([("ex", x), ("all", h), ("ex", y)], nested)
    assert not game_ok([("all", h), ("ex", x), ("all", y)], nested)
    assert game_ok([("all", y), ("all", h), ("ex", x)], nested)

    # With k designated, the same legal substitution k := h must be used
    # in both pieces. Ordinary branch checks still see the original k.
    k = Var(N, "k")
    raw = [(x, num(k)), (v, k)]
    instantiated = [(instantiate(l, {k: h}), instantiate(r, {k: h})) for l, r in raw]
    assert not game_ok(before, instantiated) and game_ok(after, instantiated)
    assert branch_ok(raw + [(k, zero)], [(v, zero)])
    assert instantiate(num(k), {k: h, h: zero}) == num(h)

    # Enumerate a small outer interface menu and an independent arithmetic menu.
    # Only the bridge with a transparent arithmetic component covers both rows.
    interface_menu = [[], [(x, num(h))], [(x, num(zero))]]
    arithmetic_menu = [[], [(h, zero)], [(h, one)]]
    accepted = [(i, j) for i, typ in enumerate(interface_menu)
                for j, side in enumerate(arithmetic_menu)
                if game_ok([("ex", x), ("ex", h)], typ+side)
                and all(branch_ok(typ+side+[(x, num(z))], [(h, z)]) for z in (zero, one))]
    assert accepted == [(1, 0)]

    rng = Random(405)
    ns = [zero, one, h, v, app(N, "flip", h), app(N, "flip", v)]
    flags = [b, app(B, "0"), app(B, "1"), app(B, "flip", b)]
    types = [x, y, app(TYPE, "Unit"), *(num(n) for n in ns),
             *(app(TYPE, "Tag", n, flag) for n in ns for flag in flags)]
    def equation():
        terms = rng.choice([types, types, ns, flags])
        return rng.choice(terms), rng.choice(terms)

    for _ in range(3500):
        vs = rng.sample([x, y, h, v, b], 5)
        prefix = [(rng.choice(("all", "ex")), z) for z in vs]
        eqs = [equation() for _ in range(rng.randrange(5))]
        assert game_ok(prefix, eqs) == play(prefix, eqs), (prefix, eqs)
        goal = [equation() for _ in range(rng.randrange(3))]
        assert branch_ok(eqs, goal) == strict_branch(eqs, goal), (eqs, goal)
        locals_ = {v for v in vs if v not in free(eqs) and rng.randrange(2)}
        assert clause_ok(eqs, goal, locals_) == direct_clause(eqs, goal, locals_), (eqs, goal)
    print("3500 each: mixed prefix games, strict branches, and existential-head clauses agree.")


if __name__ == "__main__":
    main()
