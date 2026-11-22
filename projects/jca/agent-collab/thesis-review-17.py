"""Check external package openings and the four-constructor counterexample."""
import argparse
from pathlib import Path
import runpy
import tempfile

HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    binary = parser.parse_args().invargent.resolve(strict=True)
    pair = (HERE / "packed_payload.gadt").read_text()
    four = (HERE / "four_axis_payload.gadt").read_text()
    with tempfile.TemporaryDirectory() as tmp:
        def check(name, source, budget=11, *, error=None, full=False, extra=()):
            options = ("-iterations_timeout", str(budget), *extra)
            if full:
                options += ("-full_annot",)
            return compile_and_run(Path(tmp), binary, name, source, options=options, error=error)

        for budget in range(6):
            check(f"before_confirmation_{budget}", pair, budget, error="Answers do not converge")
        for name, side, args in [("left", "Left", "Marker, a"), ("right", "Right", "a, Marker")]:
            source = pair.replace("Left Box", side + " Box")
            sig = check(name, source, 6, full=True)
            assert f"∀a. Tag ({args}) → Nat → ∃.(a, a)" in " ".join(sig.split())
            check(name + "_wrong", source.replace("same x Box", "same y Mark"), error="Type mismatch")

        mixed = pair.replace("in same x Box",
                             "in let (u,v) = f (Right Box) Z in let ok = same u Box in same x Box")
        check("two_incompatible_calls", mixed, error="Type mismatch")
        for budget in (0, 1, 2, 8, 11, 80, 10000):
            check(f"third_axis_{budget}", four, budget,
                  error="term abduction failed" if budget else "Answers do not converge")
        written_type = "∀a. Tag (Marker, Marker, a, Marker) → Nat → ∃.(a,a)"
        typed = four.replace("let rec f t =", f"let rec f : {written_type} = fun t ->")
        other_arms = "".join(f"\nlet ok{i} = let (x,y) = f ({ctor} Mark) (S Z) in same y Mark\n"
                             for i, ctor in enumerate(("First", "Second", "Fourth")))
        check("third_axis_certificate", typed + other_arms, full=True)
        check("wrong_component_type", typed.replace("same x Box", "same x Mark"), error="Type mismatch")
        check("inner_budget_28", four, error="term abduction failed",
              extra=("-term_abduction_fail", "28"))
        discovered = check("inner_budget_29", four, full=True,
                           extra=("-term_abduction_fail", "29"))
        old_order = "First x -> x | Second x -> x | Third x -> x | Fourth x -> x"
        swapped = "First x -> x | Fourth x -> x | Third x -> x | Second x -> x"
        assert old_order in four
        new_sig = check("swapped_arms", four.replace(old_order, swapped), full=True)
        expected = written_type.replace("(a,a)", "(a, a)")
        for sig in (new_sig, discovered):
            assert expected in " ".join(sig.split())


if __name__ == "__main__":
    main()
