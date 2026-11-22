"""Check public interval bounds, scalar recovery and the two-input counterexample."""
import argparse
from pathlib import Path
import re
import runpy
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent
review = runpy.run_path(str(HERE / "thesis-review-28.py"))
NEGATIVE = 'external let negative : ∀i[i≤0]. Num i → Bool = "fun n -> assert (n <= 0); true"\n'


def public_domain(signature, *, stock):
    sig = " ".join(signature.split()).split("val run : ")[1]
    bounds, state, argument, key = re.match(
        r"∀[^\[]+\[(.*?)\]\. State (\w+) → Num (\w+) → Nat → ∃\w+\[(\w+) ≤ ", sig).groups()
    for sort in (z3.Int, z3.Real):
        public = z3.And(*review["numeric_constraints"](bounds.split(" ∧ "), z3, sort))
        i, l, k = map(sort, (state, argument, key))
        f = 4*i+1
        witness = k == z3.If(l <= f, l, f)
        solver = z3.Solver()
        if stock:
            solver.add(public, i == 0, l == -3, k == -3)
            assert solver.check() == z3.sat
        else:
            expected = z3.And(z3.Or(i == 0, i == 1, i == 2), witness, k <= f, f <= k+2)
            solver.add(z3.Xor(public, expected))
            assert solver.check() == z3.unsat


def explicit_joint(source):
    key = ("let key : ∀i,j. State i → State j → ∃k[k=min(6 i + 6 j + (-1),4 i + 4 j + 1)]. Num k =\n"
           "  fun a -> efunction A -> (match a with A -> (-1) | B -> 5) | B -> (match a with A -> 5 | B -> 9)\n\n")
    source = (source.replace("let rec run", key+"let rec run").replace("State j → Nat →", "State j → Num k → Nat →")
              .replace("fun a b -> efunction", "fun a b keyarg -> efunction")
              .replace("let prior = run a b d", "let child = key a b in let prior = run a b child d"))
    for states, parent in (("A A", "(-1)"), ("A B", "3"), ("B A", "3"), ("B B", "7")):
        source = source.replace("run "+states+" (S", "run "+states+" "+parent+" (S")
    return source


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--before", type=Path, help="stock compiler at revision 3eb191e")
    parser.add_argument("--trace", type=Path, help="bee08b1 with the four diagnostics from reviews 22–26")
    args = parser.parse_args()
    exe = args.compiler.resolve(strict=True)
    three, four, two, public = ((HERE / (name+".gadt")).read_text() for name in
                               ("three_state_interval", "four_state_interval", "two_input_interval", "public_interval_bound"))
    bad = public + NEGATIVE + "let broken = let p = run A (-3) Z in negative p\n"
    mirror = (three.replace("4 i + 1", "-4 i + 9").replace("4 i+1", "-4 i+9")
              .replace("A -> 1 | B -> 5 | C -> 9", "A -> 9 | B -> 5 | C -> 1")
              .replace("2 <= r && r <= 4", "6 <= r && r <= 8"))
    scalar = ("datatype Nat" + three.split("datatype Nat", 1)[1])
    scalar = re.sub(r"let base : [^\n]+", 'external let base : ∀i[0≤i ∧ i≤2]. Num i → Num (4 i + 1) = '
                    '"fun i -> [|1;5;9|].(i)"', scalar).replace("State i →", "Num i →")
    for i, tag in enumerate("ABC"):
        scalar = scalar.replace("run "+tag+" ", f"run {i} ")
    multiple = (four.replace("let rec run", 'external let loose : ∀i[i≤15]. Num i → Bool = '
                             '"fun n -> assert (n <= 15); true"\nlet rec run')
                .replace("S d -> let prior", "S d -> let l = run A d in let r = run D d in "
                         "let ok = loose l in let ok2 = loose r in let prior"))
    gaps = (four.replace("State 3", "State 9").replace("State 2", "State 6").replace("State 1", "State 3")
            .replace("i≤3", "i≤9").replace("i+(-2),3", "i+(-6),9").replace("min(i,1", "min(i,3")
            .replace("i + (-1),2", "i + (-3),6").replace("4 i", "2 i")
            .replace("B -> 5 | C -> 9 | D -> 13", "B -> 7 | C -> 13 | D -> 19")
            .replace("i≤13", "i≤19").replace("n <= 13", "n <= 19")
            .replace("r <= 4", "r <= 6").replace("10 <= r && r <= 12", "14 <= r && r <= 18"))
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, src, *, binary=exe, budget=2, annotated=True, **kw):
            opts = ("-full_annot",) if annotated else ()
            return review["compile_and_run"](out, binary, name, src, **kw,
                                            options=("-iterations_timeout", str(budget), *opts))

        for name, src in (("three", three), ("four", four), ("mirror", mirror), ("scalar", scalar),
                          ("multiple", multiple), ("gaps", gaps)):
            check(name, src)
            assert (out / (name+".ml")).read_text().count("run s d") == 1
        for name, src in (("three_plain", three), ("four_plain", four)):
            check(name, src, annotated=False)
        public_domain(check("public", public, budget=8), stock=False)
        check("bad_public", bad, budget=8, error="numerical abduction failed")
        check("bad_implicit", three+NEGATIVE+"let broken = let p = run A Z in negative p\n",
              error="numerical abduction failed", budget=8)
        check("joint_implicit", two, error="Type mismatch")
        check("joint_explicit", explicit_joint(two))
        climb = (HERE / "capped_climb.gadt").read_text()
        check("climb_8", climb, budget=8, error="Answers do not converge", annotated=False)
        check("climb", climb, budget=9, annotated=False)
        if args.before:
            before = args.before.resolve(strict=True)
            public_domain(check("old_bad_public", bad, binary=before, budget=8,
                                runtime_error=True), stock=True)
            check("old_three", three, binary=before, error="Type mismatch")
        if args.trace:
            traced = args.trace.resolve(strict=True)
            runpy.run_path(str(HERE / "thesis-review-29.py"))["check_climb_jump"](traced, out / "climb.gadt")
            for options in ((), ("-full_annot",)):
                review["trace"](traced, out / "joint_implicit.gadt", options,
                                indices=("i", "j"))


if __name__ == "__main__":
    main()
