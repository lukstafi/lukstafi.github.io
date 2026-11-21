"""Run reflected split-constructor programs on both sides of the proved shift threshold."""

import argparse
from pathlib import Path
import shutil
import subprocess
from tempfile import TemporaryDirectory


def program(cap, limit, upward, shift):
    if upward:
        payload = f"0≤k ∧ k≤n+1 ∧ k≤m+{cap}"
        demand = f"0≤n ∧ n≤max(0, m+{limit})"
        runtime = (f"assert (0 <= n && n <= max (m + {limit}) 0); "
                   f"if m + {cap} <= 0 then Zero else B (min (n+1) (m + {cap}))")
        start = -limit
    else:
        payload = f"k≤0 ∧ n+ -1≤k ∧ m+{-cap}≤k"
        demand = f"n≤0 ∧ min(0,m+{-limit})≤n"
        runtime = (f"assert (n <= 0 && min (m + {-limit}) 0 <= n); "
                   f"if m + {-cap} >= 0 then Zero else B (max (n-1) (m + {-cap}))")
        start = limit
    return f"""datatype Nat
datacons Z : Nat
datacons S : Nat ⟶ Nat

datatype StepResult : num * num
datacons B : ∀m, n, k [{payload}]. Num k ⟶ StepResult (m, n)
datacons Zero : ∀m, n. StepResult (m, n)
external let step : ∀m, n [{demand}]. Num m → Num n → StepResult (m, n) =
  "fun m n -> {runtime}"

let rec climb d m = efunction
  | Z -> 0
  | S t -> let r = climb d (m+d) t in
           (ematch step m r with B u -> u | Zero -> 0)

let witness = climb ({shift}) ({start}) (S (S Z))
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("solver", type=Path)
    parser.add_argument("--ocaml", default="ocaml")
    args = parser.parse_args()
    solver, ocaml = args.solver.resolve(), shutil.which(args.ocaml)
    if not ocaml:
        parser.error(f"OCaml executable missing: {args.ocaml}")
    for cap, limit in [(19, 20), (3, 5), (0, 0), (-2, -1)]:
        for upward in (True, False):
            for step in (-1, 0, 1):
                shift = (limit - cap + step) * (1 if upward else -1)
                with TemporaryDirectory() as tmp:
                    source = Path(tmp, "climb.gadt")
                    source.write_text(program(cap, limit, upward, shift), encoding="utf-8")
                    run = subprocess.run([solver, "-no_verif", source],
                                         capture_output=True, text=True, timeout=60)
                    if step <= 0:
                        run.check_returncode()
                        subprocess.run([ocaml, source.with_suffix(".ml")], check=True, timeout=60)
                        result = "accepted and executed"
                        if step == 0:
                            scheme = source.with_suffix(".gadti").read_text(encoding="utf-8")
                            print(" ".join(scheme.split("val climb :")[1].split("val witness :")[0].split()))
                    elif run.returncode and "numerical abduction failed" in run.stdout + run.stderr:
                        result = "rejected at the call"
                    else:
                        raise RuntimeError(f"unexpected solver result {run.returncode}\n{run.stdout}{run.stderr}")
                    print(f"{'max' if upward else 'min'} {cap=} {limit=} {shift=}: {result}")


if __name__ == "__main__":
    main()
