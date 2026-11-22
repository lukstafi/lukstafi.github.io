"""Compare InvarGenT with exact rational halfspace and shared-witness problems."""
import argparse
from dataclasses import dataclass
from itertools import combinations
from pathlib import Path
from random import Random
import subprocess
from tempfile import TemporaryDirectory

from z3 import FreshReal, Or, SolverFor, Sum, sat, unsat


def decide(constraints, theory):
    solver = SolverFor(theory)
    solver.add(*constraints)
    status = solver.check()
    assert status in (sat, unsat), solver.reason_unknown()
    return status == sat


def affine(coords, coeffs, offset=0):
    return sum((k*x for k, x in zip(coeffs, coords)), offset)


def term(names, coeffs, constant=0):
    terms = [str(constant)] if constant else []
    terms += [f"{k} {x}" for x, k in zip(names, coeffs) if k]
    return " + ".join(terms) or "0"


@dataclass(frozen=True)
class Live:
    # A segment plus one recession direction. Zero directions are allowed.
    origin: tuple
    step: tuple = (0, 0)
    ray: tuple = (0, 0)

    def witness(self, t, u):
        return [p + t*v + u*d for p, v, d in zip(self.origin, self.step, self.ray)]

    def source(self):
        terms = [f"{x}=" + term("kl", (v, d), p)
                 for x, v, d, p in zip("ij", self.step, self.ray, self.origin)]
        return " ∧ ".join(terms+["0≤k", "k≤1", "0≤l"])


def bad_form(cell):
    # Nonnegative combinations of Ax-b are nonpositive throughout Ax≤b.
    weights = [FreshReal() for _ in cell]
    normal = [Sum([w*r[k] for w, r in zip(weights, cell)]) for k in (0, 1)]
    constant = -Sum([w*r[2] for w, r in zip(weights, cell)])
    return normal, constant, [w >= 0 for w in weights]


def one_face(live, cell):
    a, c, constraints = bad_form(cell)
    for state in live:
        end = state.witness(1, 0)
        constraints.append(Or(affine(state.origin, a, c) > 0, affine(end, a, c) > 0,
                              affine(state.ray, a) > 0))
    return decide(constraints, "QF_LRA")


def shared(live, cells):
    constraints, points = [], []
    for state in live:
        t, u = FreshReal(), FreshReal()
        constraints.extend((t >= 0, t <= 1, u >= 0))
        points.append(state.witness(t, u))
    for cell in cells:
        a, c, signs = bad_form(cell)
        constraints.extend(signs)
        constraints.extend(affine(point, a, c) >= 1 for point in points)
    return decide(constraints, "QF_NRA")


def row(cell):
    return " ∧ ".join(f"{term('ij', (a,b))}≤{c}" for a,b,c in cell)


def native(exe, problems):
    lines = ["\t".join([*(s.source() for s in live), "--", *map(row, cells)])
             for live, cells in problems]
    out = subprocess.run([exe], input="\n".join(lines)+"\n", text=True, capture_output=True)
    assert out.returncode == 0, (out.stderr, lines[len(out.stdout.splitlines())])
    answers = [tuple(map(int, line.split())) for line in out.stdout.splitlines()]
    assert len(answers) == len(lines)
    return answers


def point(x, y):
    return [(1,0,x), (-1,0,-x), (0,1,y), (0,-1,-y)]


def numeric(driver, before):
    rng = Random(49)
    norms = [(x,y) for x in range(-2,3) for y in range(-2,3) if x or y]
    def vector():
        return tuple(rng.choices(range(-3,4), k=2))
    examples = []
    for _ in range(320):
        x, y = vector()
        cell = [(a,b,a*x+b*y+rng.randrange(2)) for a,b in rng.sample(norms,rng.randint(2,4))]
        lives = [Live(vector(), vector() if rng.randrange(2) else (0,0),
                      vector() if rng.randrange(3)==0 else (0,0)) for _ in range(rng.randint(2,4))]
        examples.append((lives, [cell]))
    low = [(1,0,0),(0,1,0)]
    high = [(-1,0,-1),(0,-1,-1)]
    extremes = [Live((1,0)),Live((0,1))]
    examples += [(extremes,[low]), ([Live((3,-4)),Live((-2,3))],[low])]
    target = [one_face(live, cells[0]) for live,cells in examples]
    # Test the shared-witness formulation independently on the one-cell subproblem.
    for (live,cells), expected in zip(examples[:48], target):
        assert shared(live,cells) == expected
    old_count = len(examples)
    # A rational guard exists exactly when a segment through the chosen live
    # witnesses can miss every forbidden cell. Singletons fix those witnesses.
    multi = [(extremes,[low,high]), ([Live((0,0)),Live((2,2))],[point(1,1), high]),
             ([Live((1,0)),Live((0,1)),Live((0,0),(1,1))],[low,high])]
    for _ in range(45):
        lives = [Live(vector()) for _ in range(rng.randint(2,4))]
        cells = [point(*vector()) for _ in range(rng.randint(2,4))]
        multi.append((lives,cells))
    multi.extend([
        ([Live((3,3)), Live((0,0),(-1,-2))], [point(0,-1),point(2,2)]),
        ([Live((0,0)), Live((2,0),(0,2))], [point(1,0),point(1,1)]),
    ])
    # Flexible live segments have to share a point across several exclusions.
    for _ in range(350):
        lives = [Live(vector(), vector() if rng.randrange(4) else (0, 0))
                 for _ in range(rng.randint(2,4))]
        multi.append((lives, [point(*vector()) for _ in range(rng.randint(2,4))]))
    # A closed pair of walls and a sequence of narrow open windows.
    def wall(lower,upper):
        a,b = lower
        c,d = upper
        return [(1,0,1), (-1,0,-1), (0,-b,-a), (0,d,c)]
    anchored = [Live((0,0)),Live((2,0),(0,2))]
    for q in (2,3,11,37,127,1021,1048576):
        multi.append((anchored,[point(1,0),wall((1,q),(1,1))]))
        multi.append((anchored,[wall((0,1),(1,q)),wall((1,q),(1,1))]))
    examples += multi
    target += [shared(live,cells) for live,cells in multi]
    if driver:
        ans = native(driver,examples)
        for (live,cells),(kept,killed),expected in zip(examples,ans,target):
            assert killed == len(cells), (live,cells,kept,killed)
            assert (kept == len(live)) == expected, (live,cells,kept,expected)
        if before:
            previous = native(before,examples)
            misses = sum(want and kept < len(live)
                         for (live,_),(kept,_),want in zip(examples,previous,target))
            print(f"Earlier compiler missed {misses} feasible instances.")
    print(f"{old_count} one-cell cases and {len(multi)} joint problems checked.")


def sharp():
    # A polygon with rational vertices on a parabola. Start at each edge
    # midpoint and move a rational distance outwards along the edge normal.
    from fractions import Fraction as Q
    for n in range(3, 22):
        vertices = [(k, k*k) for k in range(n)]
        edges = list(zip(vertices, vertices[1:]+vertices[:1]))
        rows = [(v-y, x-u, (v-y)*x+(x-u)*y) for (x,y),(u,v) in edges]
        assert all(a*x+b*y <= c for x,y in vertices for a,b,c in rows)
        step = Q(1)
        while True:
            bad = [((Q(x+u)/2 + step*a), (Q(y+v)/2 + step*b))
                   for ((x,y),(u,v)),(a,b,_) in zip(edges,rows)]
            if all(all(a*(x+u)+b*(y+v) <= 2*c for a,b,c in rows)
                   for (x,y),(u,v) in combinations(bad,2)):
                break
            step /= 2
        assert all(a*x+b*y > c for (x,y),(a,b,c) in zip(bad,rows))
    print("The sharp face-count construction checks for polygons with 3 through 21 edges.")


def programs(compiler,before):
    source = Path(__file__).with_name("oblique_guard.gadt").read_text()
    with TemporaryDirectory() as tmp:
        def check(exe, name, text, expected):
            path = Path(tmp)/(name+".gadt")
            path.write_text(text)
            r = subprocess.run([exe, "-full_annot", "-overwrite_ml",path],capture_output=True,text=True)
            if not expected:
                assert r.returncode and any(d in r.stdout+r.stderr for d in
                                            ("No answer in num","Contradiction in num")), r
                return
            assert r.returncode == 0, r
            ml = path.with_suffix(".ml")
            with ml.open("a") as f:
                f.write('\nlet () = print_endline (string_of_bool (a && b && east && north && fixed && along && origin && tip))\n')
            assert subprocess.run(["ocaml",ml],capture_output=True,text=True,check=True).stdout == "true\n"
            return " ".join(path.with_suffix(".gadti").read_text().split())
        if before:
            check(before,"before",source,False)
        sig = check(compiler,"after",source,True)
        assert "1 ≤ k + n" in sig and "Band (n, -n + 1) → Bool" in sig
        assert "Track (n, (8/7) n + (-3/7))" in sig and "n ≤ 4194304 k" in sig
        for i, call in enumerate(("accept Bad","inside Below","inside Above","follow First","follow Second","pass Shut","pass Wall")):
            check(compiler, f"forbidden{i}", source+"\nlet invalid = "+call, False)
    print("Four inferred guards run eight live calls and reject seven forbidden ones.")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    for arg in ("driver","before-driver","compiler","before"):
        p.add_argument("--"+arg, type=Path)
    args = p.parse_args()
    sharp()
    numeric(args.driver,args.before_driver)
    if args.compiler:
        programs(args.compiler,args.before)
