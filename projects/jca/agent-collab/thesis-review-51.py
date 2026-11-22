"""Check minimal captures against symbolic all-key opening in the free term algebra."""
import argparse
from itertools import combinations, product
from pathlib import Path
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
lib = runpy.run_path(str(HERE / "thesis-review-50.py"))
A, B, V, F, pair, variables, apply, once, matches, unify, opening = (
    lib[n] for n in ("A", "B", "V", "F", "pair", "variables", "apply",
                     "once", "matches", "unify", "opening"))


def fresh(term, label):
    return once(term, {v: V((label, v)) for v in variables(term)})


def store(domain, key, public):
    """Project A(x,k) and U(x,r) onto (k,r), renaming their local holes apart."""
    if public is None:
        return None
    _, target, result = fresh(public, "public")
    solution = unify([(domain, target)])
    return None if solution is None else apply(pair(key, result), solution)


def needed(domain, public):
    """Return the essential holes of the domain pattern for an in-domain relation."""
    if public is None:
        return set()
    _, target, result = fresh(public, "public")
    assert matches(domain, target) is not None
    holes = sorted(variables(domain))
    solution = unify([(domain, target)])
    rows = [apply(V(h), solution) for h in holes] + [apply(result, solution)]
    essential = set()
    for i, (h, term) in enumerate(zip(holes, rows)):
        if term[0] != "var" or any(term[1] in variables(t)
                                   for j, t in enumerate(rows) if i != j):
            essential.add(h)
    return essential


def equivalent(p, q):
    if p is None or q is None:
        return p is q
    return matches(p, q) is not None and matches(q, p) is not None


def policies():
    a, b, c, u, v = map(V, "abcuv")
    subst_values = [A, u, v, F("S", u), pair(u, v)]
    results = [A, B, u, v, pair(u, u), pair(u, v), V("private")]
    checked = 0
    for domain in (a, pair(a, b), pair(a, pair(a, b)), pair(c, pair(a, b))):
        names = sorted(variables(domain))
        targets = [once(domain, dict(zip(names, row)))
                   for row in product(subst_values, repeat=len(names))]
        for public in [None] + [pair(t, r) for t in targets for r in results]:
            required = needed(domain, public)
            for width in range(len(names) + 1):
                for chosen in combinations(names, width):
                    capture = A
                    for name in reversed(chosen):
                        capture = pair(V(name), capture)
                    # The menus may have many keys, with arbitrary private structure.
                    for key in (capture, pair(V("j"), pair(capture, V("j")))):
                        package = store(domain, key, public)
                        exposed = None if package is None else opening(domain, key, package)
                        assert equivalent(public, exposed) == required.issubset(chosen), (
                            domain, public, chosen, key, exposed)
                        checked += 1
    assert needed(pair(a, b), pair(pair(A, u), B)) == {"a"}
    assert needed(pair(a, b), pair(pair(u, u), B)) == {"a", "b"}
    assert needed(pair(a, b), pair(pair(u, v), pair(u, u))) == {"a"}
    print(f"Checked {checked} symbolic capture choices against unification and opening.")


def feedback():
    """All 3-corner rectangular admissions and two-element packages, without syntax."""
    points = range(2)
    cells = set(product(points, repeat=2))
    relations = [set(s) for n in range(5) for s in combinations(sorted(cells), n)]
    def opened(a, p):
        return {(x,r) for x,r in cells if any((x,k) in a for k in points)
                and all((x,k) not in a or (k,r) in p for k in points)}
    def stored(a, u):
        return {(k,r) for k,r in cells if any((x,k) in a and (x,r) in u for x in points)}
    rectangular = [a for a in relations if all((x,j) in a for x,k in a for y,l in a
                                               for t,j in a if k == l and y == t)]
    for a in rectangular:
        for u in relations:
            expressible = any(opened(a, p) == u for p in relations)
            assert (opened(a, stored(a, u)) == u) == expressible
            for p in relations:
                if opened(a, p) == u:
                    assert stored(a, u) <= p
    diagonal = {(0,0), (1,1)}
    def step(a, p):
        demanded = {(0,0)}
        if (1,1) in opened(a, p):
            demanded.add((0,1))
        return stored(a, demanded)
    assert step(diagonal, diagonal) == {(0,0), (0,1)}
    assert step(cells, diagonal) == {(0,0), (1,0)}
    for a in (diagonal, cells):
        first = step(a, set())
        assert step(a, first) == first
    print("Checked all two-input rectangular admissions, least stores, and the feedback example.")


def joint_iteration():
    """Compute exact term-pattern hulls for demand and result clauses together."""
    def hull(rows):
        if not rows:
            return None
        holes = {}
        def descend(column):
            first = column[0]
            if first[0] != "var" and all(t[0] == first[0] and len(t) == len(first)
                                         for t in column):
                return F(first[0], *(descend(children) for children in zip(
                    *(t[1:] for t in column))))
            return holes.setdefault(column, V(("hull", len(holes))))
        return descend(tuple(rows))

    x, r = V("x"), V("r")
    def succ(t):
        return F("S", t)
    rules = [
        ([], ("D", succ(A))),
        ([("D", succ(x))], ("D", x)),
        ([("D", A)], ("U", pair(A, A))),
        ([("D", succ(x)), ("U", pair(x, r))], ("U", pair(succ(x), succ(r)))),
        ([("U", pair(x, r))], ("D", x)),
    ]
    state = {"D": None, "U": None}
    stages = [state]
    for _ in range(6):
        rows = {name: [pat] if pat is not None else [] for name, pat in state.items()}
        for premises, (dest, head) in rules:
            if any(state[name] is None for name, _ in premises):
                continue
            subst = unify([(args, fresh(state[name], ("premise", i)))
                           for i, (name, args) in enumerate(premises)])
            if subst is not None:
                rows[dest].append(apply(head, subst))
        new = {name: hull(patterns) for name, patterns in rows.items()}
        if all(equivalent(p, new[name]) for name, p in state.items()):
            break
        state = new
        stages.append(state)
    else:
        raise AssertionError("failed to stabilize")
    expected = [(None, None), (succ(A), None), (x, None), (x, pair(A, A)), (x, pair(r, r))]
    assert len(stages) == len(expected)
    for stage, (domain, public) in zip(stages, expected):
        assert equivalent(stage["D"], domain) and equivalent(stage["U"], public)
    print("Joint call-demand and result iteration reached the diagonal in four productive rounds.")


def compiler_examples(compiler):
    source = """datatype Nat
datacons Z : Nat
datacons S : Nat ⟶ Nat
datatype Hidden
datacons Hide : ∀a. a ⟶ Hidden
datatype Cargo
datacons Box : Cargo
external let same : ∀a. a → a → Bool = "fun a b -> a = b"
let rec f h known ignored = efunction
  | Z -> let Hide x = h in (x,(known,x))
  | S n -> f h known ignored n
"""
    with TemporaryDirectory() as d:
        expected = "val f : ∀a, b. Hidden → b → a → Nat → ∃a.(a, (b, a))"
        clients = [
            ("test (let (u,(k,v)) = f (Hide Z) Box Z (S Z) in same k Box)", True),
            ("test (let (u,(k,v)) = f (Hide Z) Box Z (S Z) in same u v)", True),
            ("let bad = let (u,(k,v)) = f (Hide Z) Box Z (S Z) in same u Box", False),
        ]
        for i, (client, accepts) in enumerate(clients):
            p = Path(d) / f"capture{i}.gadt"
            p.write_text(source + client + "\n")
            run = subprocess.run([compiler, "-full_annot", "-overwrite_ml", p],
                                 capture_output=True, text=True)
            if accepts:
                assert run.returncode == 0, run.stderr + run.stdout
                assert expected in " ".join(p.with_suffix(".gadti").read_text().split())
                ml = p.with_suffix(".ml")
                assert "type _ ex1 =" in ml.read_text() and "nat -> b ex1" in ml.read_text()
                subprocess.run(["ocaml", ml], check=True, capture_output=True)
            else:
                assert run.returncode and "term abduction failed" in run.stderr + run.stdout
    print("InvarGenT preserved the public type and private equality and rejected an escaping equality.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--compiler", type=Path)
    args = parser.parse_args()
    policies()
    feedback()
    joint_iteration()
    if args.compiler:
        compiler_examples(args.compiler.resolve())
