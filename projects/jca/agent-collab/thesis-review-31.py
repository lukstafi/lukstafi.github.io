"""Check symbolic recursive witnesses on bounded and unbounded observations."""
import argparse
from pathlib import Path
import re
import runpy
from tempfile import TemporaryDirectory

import z3
from z3.z3util import get_vars

HERE = Path(__file__).resolve().parent
review = runpy.run_path(str(HERE / "thesis-review-28.py"))


def width_guard(guard, z3, sort):
    atoms = " ".join(guard.split()).split(" ∧ ")
    # Identify the opening compared to zero in both directions. The trace
    # introduces equalities between the source operands and the comparisons.
    parent = {}
    def root(v):
        while v in parent:
            v = parent[v]
        return v
    for atom in atoms:
        eq = re.fullmatch(r"(\w+) = (\w+)", atom)
        if eq and root(eq[1]) != root(eq[2]):
            parent[root(eq[1])] = root(eq[2])
    edges = set()
    for atom in atoms:
        le = re.fullmatch(r"(\w+) ≤ (\w+)", atom)
        if le:
            edges.add((root(le[1]), root(le[2])))
    packages = set()
    for atom in atoms:
        band = re.fullmatch(r"(n\d+) ≤ (n\d+) \+ (n\d+)", atom)
        if band and (root("0"), root(band[1])) in edges and (root(band[1]), root("0")) in edges:
            r, a, b = band.groups()
            for c, w in ((a,b), (b,a)):
                if f"{c} ≤ {r}" in atoms:
                    packages.add((r,c,w))
    [(opening, child, child_width)] = packages
    r, c, w, i, k, n = map(sort, (opening, child, child_width, "i", "k", "n"))
    full = z3.And(*review["numeric_constraints"](atoms, z3, sort))
    hidden = [v for v in get_vars(full) if not any(v.eq(t) for t in (r,c,w,i,k,n))]
    expected = z3.And(i == -1, n >= 1, k <= i, i <= k+n, c == i, w == n, r == 0)
    solver = z3.Solver()
    solver.set(timeout=30000)
    solver.add(z3.Xor(z3.Exists(hidden, full), expected))
    assert solver.check() == z3.unsat, solver.reason_unknown()


def public_bounds(signature, *, finite=False, weighted=False, two_bands=False):
    sig = " ".join(signature.split()).split("val run : ")[1]
    bounds, a, b, key = re.match(
        r"∀[^\[]+\[(.*?)\]\. (?:Num|State) (\w+) → (?:Num|State) (\w+) → Nat → ∃\w+\[(\w+) ≤ ", sig).groups()
    for sort in (z3.Int, z3.Real):
        i, j, k = map(sort, (a,b,key))
        f = 2*i-3*j+1 if weighted else 4*(i+j)+1 if finite else i+j
        domain = [k <= f, f <= k+2]
        if finite:
            domain += [z3.Or(i == 0, i == 1), z3.Or(j == 0, j == 1)]
        else:
            domain.append(z3.Or(f <= 1, f >= 5))
            if two_bands:
                domain.append(z3.Or(f <= 9, f >= 13))
        actual = review["numeric_constraints"](bounds.split(" ∧ "), z3, sort)
        solver = z3.Solver()
        solver.add(z3.Xor(z3.And(*actual), z3.And(*domain)))
        assert solver.check() == z3.unsat


def explicit_width(source, cap=None):
    key = ("external let low : ∀n. Num n → Num ((-1) + -n) = \"fun n -> -1-n\"\n"
           "let key : ∀i,n[0≤n]. State i → Num n → ∃k[k≤i ∧ i≤k+n ∧ min(k+n+1,1 + -k)≤0]. Num k =\n"
           "  fun s w -> ematch s with Neg -> low w | Pos -> 1\n")
    source = (source.replace("let rec run", key+"let rec run")
              .replace("State i → Num n → Nat →", "State i → Num n → Num k → Nat →")
              .replace("fun s width ->", "fun s width child_arg ->")
              .replace("let prior = run s width d", "let child = key s width in let prior = run s width child d")
              .replace("run Neg 19 (S", "run Neg 19 (-20) (S").replace("run Pos 237 (S", "run Pos 237 1 (S"))
    if cap is not None:
        m = (cap+1)//2
        source = (source.replace("[0≤n", f"[n≤{cap} ∧ 0≤n")
                  .replace("∃k[k≤i ∧ i≤k+n ∧ min(k+n+1,1 + -k)≤0]", f"∃k[k=min(i,{m+1} i+{m} + -n)]"))
    return source


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--before", type=Path, help="compiler at bee08b1")
    parser.add_argument("--trace", type=Path, help="current compiler with the four existing diagnostic patches")
    args = parser.parse_args()
    exe = args.compiler.resolve(strict=True)
    finite, joint, width = ((HERE / (name+".gadt")).read_text() for name in
                            ("two_input_interval","joint_affine_interval","variable_width_interval"))
    weighted = (joint.replace("i+j","2 i + -3 j + 1").replace("5 + -i + -j","4 + -2 i + 3 j")
                .replace("a+b", "2*a - 3*b + 1").replace("(-1000) 1001","1500 1000")
                .replace("1000 (-995)","(-1498) (-1000)"))
    bands = (joint.replace("∧ k≤i+j", "∧ min(i+j+(-9),13 + -i + -j)≤0 ∧ k≤i+j")
             .replace("| _ -> base", "| r when 10 <= r && r <= 12 -> True | _ -> base")
             + "let more = let p = run 1000 (-987) (S Z) in between 11 p 13\n")
    reachable = (joint.replace("min(i+j + (-1),5 + -i + -j)≤0 ∧ ", "")
                 + "let bad = let p = run 3 0 (S Z) in between 1 p 3\n")
    bad_client = joint + "let bad = let p = run 1000 (-999) Z in between (-2) p 0\n"
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, source, binary=exe, *, annotated=True, budget=2, **kw):
            opts = ("-full_annot",) if annotated else ()
            return review["compile_and_run"](out, binary, name, source, options=("-iterations_timeout",str(budget),*opts), **kw)
        for name, source, kw in (("finite", finite, {"finite":True}), ("joint", joint, {}),
                                 ("weighted", weighted, {"weighted":True}), ("bands", bands, {"two_bands":True})):
            for annotated in (False,True):
                label = name+("_annot" if annotated else "")
                public_bounds(check(label, source, annotated=annotated), **kw)
                assert (out/(label+".ml")).read_text().count("run a b d") == 1
        check("reachable", reachable, error="Type mismatch")
        check("bad_client", bad_client, error="numerical abduction failed")
        check("width", width, error="Type mismatch")
        check("explicit_width", explicit_width(width))
        check("bounded_width", explicit_width(width, cap=240))
        wrong = explicit_width(width).replace("Neg -> low w | Pos -> 1", "Neg -> 0 | Pos -> 1")
        check("wrong_child", wrong, error="numerical abduction failed")
        exact = width.replace("∃l[k≤l ∧ l≤k+n]", "∃l[l=i]")
        check("exact_result", exact)
        retained = width.replace("∃l[k≤l ∧ l≤k+n]", "∃l[l=i ∧ k≤l ∧ l≤k+n]")
        check("retained_2", retained, error="Type mismatch")
        check("retained_3", retained, budget=3)
        if args.before:
            before = args.before.resolve(strict=True)
            for name, source in (("finite", finite), ("joint", joint), ("weighted", weighted), ("bands", bands)):
                check("old_"+name, source, before, error="Type mismatch")
        if args.trace:
            for options in ((), ("-full_annot",)):
                review["trace"](args.trace.resolve(strict=True), out/"width.gadt", options, projection=width_guard)


if __name__ == "__main__":
    main()
