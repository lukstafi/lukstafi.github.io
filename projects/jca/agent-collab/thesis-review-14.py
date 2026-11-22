"""Run the two-cap examples with InvarGenT and execute the emitted OCaml."""
import argparse
from pathlib import Path
import re
import runpy
import subprocess
import tempfile


HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]
TIMEOUT = "Answers do not converge"
ABDUCTION = "numerical abduction failed"


def as_float(source):
    before, body, after = source.split('"')
    body = re.sub(r"\b\d+\b", lambda m: m[0] + ".", body)
    return '"'.join((before, body.replace("+", "+.").replace("*", "*."), after))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before-replay", type=Path, help="executable from a52dbe2")
    parser.add_argument("--before-equations", type=Path, help="executable from 752520c")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    tighter, crossing, double = [(HERE / name).read_text() for name in
                                 ("tighter_supplier.gadt", "crossing_caps.gadt",
                                  "double_rate_supplier.gadt")]
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, source, *, budget=11, error=None, options=(), binary=exe):
            return compile_and_run(out, binary, name, source, error=error,
                                   options=("-iterations_timeout", str(budget), *options))

        check("lowered_8", tighter, budget=8, error=TIMEOUT)
        check("lowered_9", tighter, budget=9)
        client = "\nlet rising = climb (-1) 2 3 0 (S (S Z))\n"
        check("wider_domain", tighter + client)
        check("weaker_supplier", tighter.replace(" ∧ k≤max(j,m+19+i)", "") + client,
              error=ABDUCTION)
        check("cap_moves_too_far", tighter + client.replace("(-1) 2", "(-1) 3"),
              error=ABDUCTION)
        if args.before_replay:
            check("old_jump", crossing, binary=args.before_replay.resolve(strict=True),
                  budget=80, error=TIMEOUT)
        check("crossing_10", crossing, budget=10, error=TIMEOUT)
        check("crossing_11", crossing, budget=11)
        check("double_default", double)
        if args.before_equations:
            old = args.before_equations.resolve(strict=True)
            for budget in (0, 1, 2, 11, 80):
                check(f"double_rate_{budget}", double, budget=budget, binary=old,
                      error=TIMEOUT if budget < 2 else ABDUCTION)

        one_cap = ("-postcond_subopti_limit", "1")
        check("crossing_one_cap", crossing, options=one_cap, error=TIMEOUT)
        check("double_one_cap", double + client.replace("(-1) 2", "(-1) 3"),
              budget=9, options=one_cap)
        check("double_outside", double + client.replace("(-1) 2", "(-1) 4"),
              options=one_cap, error=ABDUCTION)

        float_options = ("-num_is", "float")
        floating = as_float(crossing)
        check("float_crossing", floating, options=float_options)
        midpoint = ('\nexternal let half : Num (3/2) = "1.5"\n'
                    'let gap = climb (-1 * half) half 0 0 Z\n')
        check("midpoint_rejected", floating + midpoint, options=float_options, error=ABDUCTION)
        # Invoke the emitted function directly to observe the bad depth.
        # The typed client above cannot enter it on this input.
        ml = out / "float_crossing.ml"
        with ml.open("a") as stream:
            stream.write("""
let rec depth n = if n = 0 then Z else S (depth (n-1))
let () =
  ignore (climb (-1.) 1. 0. 0. (depth 30));
  ignore (climb (-2.) 2. 0. 0. (depth 30));
  ignore (climb (-1.5) 1.5 0. 0. (depth 8));
  assert (try ignore (climb (-1.5) 1.5 0. 0. (depth 9)); false
          with Assert_failure _ -> true)
""")
        subprocess.run(["ocaml", str(ml)], check=True, timeout=30)
        print("Both endpoints executed at depth 30. The midpoint first failed at depth 9.")


if __name__ == "__main__":
    main()
