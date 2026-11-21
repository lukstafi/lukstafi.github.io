"""Check shifted-cap calls against a built InvarGenT executable and OCaml."""

import argparse
from pathlib import Path
import shutil
import subprocess
import tempfile


def program(cap, limit, shift):
    return f"""datatype Nat
datacons Z : Nat
datacons S : Nat ⟶ Nat

datatype StepResult : num * num
datacons B : ∀m, n, k [0≤k ∧ k≤n+1 ∧ k≤max(m+{cap}, 0)]. Num k ⟶ StepResult (m, n)
external let step : ∀m, n [0≤n ∧ n≤max(m+{limit}, 0)]. Num m → Num n → StepResult (m, n) =
  "fun m n -> assert (0 <= n && n <= max (m + {limit}) 0); B (min (n+1) (max (m + {cap}) 0))"

let rec climb d m = efunction
  | Z -> 0
  | S t -> let r = climb d (m+d) t in
           let B u = step m r in u

let witness = climb ({shift}) ({-limit}) (S (S Z))
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("solver", type=Path)
    parser.add_argument("--ocaml", default="ocaml")
    args = parser.parse_args()
    solver = args.solver.resolve()
    ocaml = shutil.which(args.ocaml)
    if not ocaml:
        parser.error(f"OCaml executable missing: {args.ocaml}")

    for cap, limit in [(19, 20), (3, 5), (0, 0), (-2, -1)]:
        slack = limit - cap
        for shift in (slack - 1, slack, slack + 1):
            with tempfile.TemporaryDirectory() as tmp:
                source = Path(tmp, "climb.gadt")
                source.write_text(program(cap, limit, shift), encoding="utf-8")
                run = subprocess.run(
                    [solver, "-no_verif", source], capture_output=True, text=True, timeout=60
                )
                if shift <= slack:
                    run.check_returncode()
                    subprocess.run([ocaml, source.with_suffix(".ml")], check=True, timeout=60)
                    if shift == slack:
                        sig = source.with_suffix(".gadti").read_text(encoding="utf-8")
                        scheme = sig.split("val climb :", 1)[1].split("val witness :", 1)[0]
                        print(" ".join(scheme.split()))
                    result = "accepted and executed"
                elif run.returncode and "numerical abduction failed" in run.stdout + run.stderr:
                    result = "rejected at the call"
                else:
                    raise RuntimeError(f"unexpected solver result {run.returncode}\n{run.stdout}{run.stderr}")
                print(f"cap {cap}, limit {limit}, shift {shift}: {result}")

    split = Path(__file__).with_name("split_capped_climb.gadt")
    for budget in (11, 40):
        run = subprocess.run(
            [solver, "-no_sig", "-no_ml", "-iterations_timeout", str(budget), split],
            capture_output=True, text=True, timeout=60,
        )
        if not run.returncode or "Answers do not converge" not in run.stdout + run.stderr:
            raise RuntimeError(f"split-constructor result changed\n{run.stdout}{run.stderr}")
        print(f"split constructor, budget {budget}: iteration limit reached")


if __name__ == "__main__":
    main()
