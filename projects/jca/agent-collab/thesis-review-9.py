"""Replay caller-bound inference on a moving floor and cap."""

import argparse
from pathlib import Path
import subprocess
import tempfile


def source(cap, limit, rise, call):
    template = Path(__file__).with_name("unit_floor_shift.gadt").read_text(encoding="utf-8")
    definition = template.split("let witness =")[0]
    definition = (definition.replace("m+19", f"m+{cap}").replace("m+20", f"m+{limit}")
                  .replace("(j+1) (m+d)", f"(j+{rise}) (m+d)"))
    if call is None:
        return definition
    d, p, m = call
    return definition + f"let witness = climb ({d}) ({p}) ({m}) (S (S Z))\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("solver", type=Path)
    parser.add_argument("--ocaml", default="ocaml")
    args = parser.parse_args()
    solver = args.solver.resolve()
    cases = [
        (19, 20, 1, (1, 3, -16), None),
        (19, 20, 1, (0, 3, -16), None),
        (19, 20, 1, (2, 3, -16), None),
        (19, 20, 1, (1, 3, -17), None),
        (18, 20, 1, (1, 19, 0), None),
        (18, 20, 1, (1, 19, 0), 40),
        (17, 20, 2, (2, 18, 0), None),
        (17, 20, 2, (3, 18, 0), None),
        (3, 6, 3, None, None),
        (3, 6, 3, (3, 2, 0), None),
    ]
    for cap, limit, rise, call, budget in cases:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp, "climb.gadt")
            path.write_text(source(cap, limit, rise, call), encoding="utf-8")
            command = [solver, "-no_verif"]
            if budget is not None:
                command += ["-iterations_timeout", str(budget)]
            run = subprocess.run([*command, path], text=True, capture_output=True, timeout=120)
            if run.returncode == 0:
                scheme = path.with_suffix(".gadti").read_text(encoding="utf-8")
                outcome = " ".join(scheme.split("val climb :")[1].split("val witness :")[0].split())
                subprocess.run([args.ocaml, path.with_suffix(".ml")], check=True, timeout=60)
            else:
                messages = (run.stdout + run.stderr).splitlines()
                outcome = next((line for line in messages if "No answer in " in line), None)
                if outcome is None:
                    raise RuntimeError("\n".join(messages))
            print(f"{cap=} {limit=} {rise=} {call=} budget={budget or 'default'}  {outcome}",
                  flush=True)


if __name__ == "__main__":
    main()
