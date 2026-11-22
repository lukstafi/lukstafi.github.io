"""Check the packed-payload counterexample, affine tags and rational endpoints."""
import argparse
from pathlib import Path
import runpy
import tempfile


HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before-affine", type=Path, help="executable from e5cd09c")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    pair = (HERE / "packed_payload.gadt").read_text()
    numeric = (HERE / "affine_tag.gadt").read_text()
    halves = (HERE / "rational_endpoints.gadt").read_text()
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp)

        def check(name, source, *, binary=exe, budget=11, options=(), **kwargs):
            return compile_and_run(out, binary, name, source,
                                   options=("-iterations_timeout", str(budget), *options), **kwargs)

        for budget in (0, 1, 8, 11, 80, 10000):
            check(f"packed_{budget}", pair, budget=budget,
                  error="Answers do not converge" if budget == 0 else "Quantifier violation")
        definition = "let rec f t = efunction"
        def annotated(source, result):
            assert definition in source
            return source.replace(definition, f"let rec f : {result} = fun t -> efunction")

        typed = annotated(pair, "∀a. Tag (Marker,a) → Nat → ∃b.(a,a)")
        sig = check("written_payload", typed)
        exported = " ".join(sig.split("val f :", 1)[1].split())
        assert "∃." in exported
        check("reread_payload", annotated(pair, exported))
        check("other_constructor", typed +
              "\nlet other = let (x,y) = f (Right Mark) (S Z) in same x Mark\n")
        flipped = pair.replace("(Left Box)", "(Right Box)")
        check("right_client", annotated(flipped, "∀a. Tag (a,Marker) → Nat → ∃b.(a,a)"),
              options=("-full_annot",))
        check("wrong_scheme", annotated(flipped, "∀a. Tag (Marker,a) → Nat → ∃b.(a,a)"),
              error="Type mismatch")

        def ordinary(source):
            return (source.replace("efunction", "function").replace("(z,z)", "z")
                    .replace("let (x,y) = f", "let x = f"))

        check("plain_payload", ordinary(pair))
        check("plain_right", ordinary(flipped), options=("-full_annot",))
        check("affine_tag", numeric)
        check("false_tag", numeric.replace("in check 7 pair", "in check 8 pair"),
              error="numerical abduction failed")
        float_mode = ("-num_is", "float")
        check("rational_endpoints", halves, options=float_mode)
        check("outside_interval", halves.replace('Num (3/2) = "1.5"', 'Num (5/2) = "2.5"'),
              options=float_mode, error="Answers do not converge")

        if args.before_affine:
            old = args.before_affine.resolve(strict=True)
            for budget in (0, 4, 5, 80):
                check(f"old_tag_{budget}", numeric, binary=old, budget=budget,
                      error="Answers do not converge" if budget < 5 else "numerical abduction failed")
            written = numeric.replace("let rec f p = efunction",
                                      "let rec f : ∀i. Num i → Nat → ∃j.(Num j,Num (i+j)) = "
                                      "fun p -> efunction")
            check("old_written_tag", written, binary=old)
            check("old_fraction", halves, binary=old, options=float_mode,
                  error='Invalid_argument("compare: abstract value")')


if __name__ == "__main__":
    main()
