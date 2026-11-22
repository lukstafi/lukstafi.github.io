"""Exercise supplier coverage and recursive guards on an InvarGenT executable."""
import argparse
from pathlib import Path
import subprocess
import tempfile


HERE = Path(__file__).resolve().parent
DEPTH = "(S (S Z))"
AT_MOST = '''
external let at_most : ∀i,j[j≤i]. Num i → Num j → Bool =
  "fun x y -> assert (y <= x); true"
'''


def compile_and_run(directory, exe, name, source, *, error=None, runtime_error=False,
                    options=()):
    path = directory / (name + ".gadt")
    path.write_text(source)
    result = subprocess.run([exe, "-inform", "-no_verif", "-overwrite_ml", *options, path],
                            text=True, capture_output=True, timeout=180)
    report = result.stdout + result.stderr
    if error:
        if not result.returncode or error not in report:
            raise RuntimeError(f"{name} expected {error!r}\n{report}")
        print(f"{name} rejected ({error})", flush=True)
        return
    if result.returncode:
        raise RuntimeError(f"{name}\n{report}")
    result = subprocess.run(["ocaml", str(path.with_suffix(".ml"))],
                            text=True, capture_output=True, timeout=30)
    if runtime_error:
        if not result.returncode or "Assert_failure" not in result.stderr:
            raise RuntimeError(f"{name} expected a failing OCaml assertion\n{result.stderr}")
    elif result.returncode:
        raise RuntimeError(f"{name}\n{result.stderr}")
    print(f"{name} {'reached its failing assertion' if runtime_error else 'executed'}", flush=True)
    return path.with_suffix(".gadti").read_text()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--baseline", type=Path, help="executable from revision 8c9d34f")
    parser.add_argument("--projection", type=Path, help="8f22708, before the reflected-input repair")
    parser.add_argument("--before-pruning", type=Path, help="e78f3a1, before pruning implied arms")
    args = parser.parse_args()
    current = args.invargent.resolve(strict=True)
    climb = (HERE / "moving_floor_calls.gadt").read_text()
    choose = (HERE / "choice_arms.gadt").read_text()
    walk = (HERE / "stride_walk.gadt").read_text()
    bad = choose + AT_MOST + "let bad = let y = choose 0 3 C in at_most 0 y\n"
    two = choose.replace("datacons Again : ∀i,j[j+1≤i]. Num i ⟶ Choice (i,j)\n", "").replace(
        " | B when y+1 <= x -> Again x", "").replace(" | Again x -> x", "")
    rejected = "numerical abduction failed"
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, source, **kw):
            return compile_and_run(out, current, name, source, **kw)

        sig = check("three_arms", choose)
        if sig.split("val choose :")[-1] != check("two_arms", two).split("val choose :")[-1]:
            raise AssertionError("duplicating the supplier changed the result bounds")
        check("wrong_arm", bad, error=rejected)
        check("both_results", choose + AT_MOST +
              "let a = let r = choose 3 0 A in at_most 3 r\n"
              "let c = let r = choose 0 3 C in at_most 3 r\n")
        for limit in (8, 9):
            check(f"pass_{limit}", climb, error="Answers do not converge" if limit == 8 else None,
                  options=("-iterations_timeout", str(limit)))
        def client(inputs):
            return f"let result = climb {inputs} {DEPTH}\n"
        check("payload_above_floor", climb + AT_MOST +
              f"let ok = let r = climb 1 1 3 3 {DEPTH} in at_most 22 r\n")
        check("false_floor_equality", climb + AT_MOST +
              f"let bad = let r = climb 1 1 3 3 {DEPTH} in at_most 3 r\n", error=rejected)
        for label, values in [("negative_floor_step", "(-1) 1 3 0"), ("cap_too_fast", "0 2 3 0"),
                              ("shrinking_slack", "1 0 3 0"), ("floor_too_high", "1 1 20 0")]:
            check(label, climb + client(values), error=rejected)
        before, body, after = climb.split('"')
        body = body.replace("m+20", "m+.20.").replace("m+19", "m+.19.").replace("n+1", "n+.1.")
        floating = '"'.join((before, body, after))
        floating += 'external let half : Num (1/2) = "0.5"\nexternal let edge : Num (39/2) = "19.5"\n'
        check("half_boundary", floating + client("half half edge 0"), options=("-num_is", "float"))
        check("unsafe_midpoint", floating + client("half 0 3 (-17)"), error=rejected,
              options=("-num_is", "float"))
        reflected = (HERE / "reflected_floor.gadt").read_text()
        check("reflected", reflected)
        if args.projection:
            for budget in (2, 11, 80):
                compile_and_run(out, args.projection.resolve(strict=True), f"reflected_{budget}",
                                reflected, error=rejected, options=("-iterations_timeout", str(budget)))
        redundant = (HERE / "redundant_supplier.gadt").read_text()
        plain = redundant.replace(" ∧ k≤max(n+1,j+i)", "")
        assert plain != redundant
        check("identical_supplier_without_extra_atom", plain)
        check("same_scheme_with_redundant_atom", redundant)
        if args.before_pruning:
            old = args.before_pruning.resolve(strict=True)
            compile_and_run(out, old, "redundancy_before_repair", redundant, error=rejected,
                            options=("-iterations_timeout", "80"))
        tighter = (HERE / "tighter_supplier.gadt").read_text()
        weaker = tighter.replace(" ∧ k≤max(j,m+19+i)", "")
        assert weaker != tighter
        check("same_body_weaker_contract", weaker)
        for budget in (1, 2, 11, 80):
            check(f"tighter_supplier_{budget}", tighter,
                  error="Answers do not converge" if budget == 1 else rejected,
                  options=("-iterations_timeout", str(budget)))
        check("skew", (HERE / "skew_floor.gadt").read_text())
        tagged = (HERE / "tagged_floor.gadt").read_text()
        for budget in (11, 80):
            check(f"tagged_{budget}", tagged, error="Answers do not converge",
                  options=("-iterations_timeout", str(budget)))
        hint = (HERE / "symbolic_floor_hint.gadt").read_text()
        hint = hint.replace("i≤max", "-i≤max").replace("(j+e)", "(j+(-1 * e))")
        hint = hint.replace("rising = climb 1 1", "rising = climb (-1) 1")
        check("reflected_partial_annotation", hint)

        def walked(n):
            return walk + f"test (let r = walk (-{n}) (S Z) in True)\n"
        check("walk_9", walked(9) + "let crossing = walk (-9) (S (S (S (S (S Z)))))\n")
        check("walk_gap", walked(9) + "let gap = walk (-8) Z\n", error=rejected)
        check("walk_31_short", walked(31), error="Answers do not converge")
        check("walk_31_long", walked(31), options=("-iterations_timeout", "40"))
        if args.baseline:
            old = args.baseline.resolve(strict=True)
            compile_and_run(out, old, "old_floor", climb, options=("-iterations_timeout", "80"),
                            error="Answers do not converge")
            compile_and_run(out, old, "old_wrong_arm", bad, runtime_error=True)
            compile_and_run(out, old, "old_two_arms", two + bad[len(choose):], error=rejected)


if __name__ == "__main__":
    main()
