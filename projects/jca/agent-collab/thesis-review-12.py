"""Exercise existential result alignment and the two-component caller with InvarGenT."""
import argparse
from pathlib import Path
import subprocess
import tempfile


HERE = Path(__file__).resolve().parent
EQUAL = '''external let equal : ∀i. (Num i, Num i) → Bool =
  "fun (x,y) -> assert (x=y); true"
'''
SCALED_SEED = '''datatype Seed
datacons V : ∀i. Num i ⟶ Seed
external let seed : Seed = "V 1"
'''
LIMIT = "Answers do not converge"
REJECT = "numerical abduction failed"


def check(exe, out, name, source, *, error=None, assertion=False, options=()):
    path = out / (name + ".gadt")
    path.write_text(source)
    run = subprocess.run([exe, "-inform", "-overwrite_ml", *options, str(path)],
                         text=True, capture_output=True, timeout=180)
    log = run.stdout + run.stderr
    if error:
        if run.returncode == 0 or error not in log:
            raise RuntimeError(f"{name} expected {error}\n{log}")
        print(f"{name} reported {error}")
        return
    if run.returncode:
        raise RuntimeError(f"{name} failed inference or compilation\n{log}")
    result = subprocess.run(["ocaml", str(path.with_suffix(".ml"))],
                            text=True, capture_output=True, timeout=30)
    if assertion:
        if result.returncode == 0 or "Assert_failure" not in result.stderr:
            raise RuntimeError(f"{name} expected a runtime assertion\n{result.stderr}")
        print(f"{name} compiled and failed the runtime assertion")
    else:
        result.check_returncode()
        print(f"{name} compiled and ran")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path, help="solver with injective alignment")
    parser.add_argument("--baseline", type=Path, help="solver at revision e7dc91c")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    sample = (HERE / "separating_pair.gadt").read_text()
    small = sample.split("external let bounds")[0]
    equal_two = EQUAL + "let seen = let xy = pair (S (S Z)) in equal xy\n"
    cap = (HERE / "capped_pair.gadt").read_text()
    definition = cap.split("test (")[0]
    ninth = '''external let ninth : Nat =
  "let rec nat i = if i=0 then Z else S (nat (i-1)) in nat 9"
'''
    equal_nine = EQUAL + ninth + "let seen = let xy = pair ninth in equal xy\n"
    later_bound = definition + ninth + "let seen = let xy = pair ninth in bound xy\n"
    box = cap.replace("[j≤9]", "[i≤8 ∧ j≤9]").replace(
        "fun (_,y) -> assert (y <= 9)", "fun (x,y) -> assert (x <= 8 && y <= 9)")
    box += ninth + "let seen = let xy = pair ninth in bound xy\n"
    seed = small.split("let rec pair")[0] + SCALED_SEED + '''let rec pair = efunction
  | Z -> let V z = seed in (z,2*z)
  | S t -> let (x,y) = pair t in (x,y+1)
external let lower : ∀i,j[2 i≤j]. (Num i, Num j) → Bool =
  "fun (x,y) -> assert (2*x <= y); true"
let seen = let xy = pair (S Z) in lower xy
'''
    with tempfile.TemporaryDirectory() as directory:
        out = Path(directory)
        check(exe, out, "three_pairs", sample)
        check(exe, out, "independent", small + equal_two, error=REJECT)
        check(exe, out, "shared", small.replace("(1, x+1)", "(y+1, x+1)") + equal_two)
        check(exe, out, "scaled", seed)
        check(exe, out, "after_jump", definition + equal_nine, error=REJECT)
        for budget in (11, 40, 80):
            check(exe, out, f"single_bound_{budget}", cap, error=LIMIT,
                  options=("-iterations_timeout", str(budget)))
        check(exe, out, "later_bound", later_bound, error=REJECT,
              options=("-iterations_timeout", "80"))
        check(exe, out, "two_bounds", box)
        check(exe, out, "delayed_jump", cap,
              options=("-convergence_step", "13", "-iterations_timeout", "30"))
        if args.baseline:
            old = args.baseline.resolve(strict=True)
            check(old, out, "old_independent", small + equal_two, assertion=True)
            check(old, out, "old_after_jump", definition + equal_nine, assertion=True)
            check(old, out, "old_scaled", seed, error="Assertion failed")


if __name__ == "__main__":
    main()
