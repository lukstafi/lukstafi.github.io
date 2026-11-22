"""Reproduce the moving-floor calls with a built InvarGenT executable."""
import argparse
from pathlib import Path
import subprocess
import tempfile


HERE = Path(__file__).resolve().parent
DEPTH = "(S (S Z))"


def definition(filename):
    return (HERE / filename).read_text().split("let stationary =")[0]


def attached(*arguments):
    calls = "".join(f"let r = climb {args} {DEPTH} in " for args in arguments)
    return f"test ({calls}True)\n"


def client(arguments):
    return f"let result = climb {arguments} {DEPTH}\n"


def check(directory, exe, name, source, error=None, options=()):
    path = directory / f"{name}.gadt"
    path.write_text(source)
    result = subprocess.run(
        [exe, "-inform", "-overwrite_ml", "-no_verif", *options, str(path)],
        text=True, capture_output=True, timeout=180)
    log = result.stdout + result.stderr
    if error is None:
        if result.returncode:
            raise RuntimeError(f"{name}\n{log}")
        subprocess.run(["ocaml", str(path.with_suffix(".ml"))], check=True, timeout=30)
        print(f"{name} accepted and executed", flush=True)
    else:
        if result.returncode == 0 or error not in log:
            raise RuntimeError(f"{name} expected {error!r}\n{log}")
        print(f"{name} rejected ({error})", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    bare = definition("moving_floor_symbolic.gadt")
    hint = definition("symbolic_floor_hint.gadt")
    near, far, rise = "0 1 3 (-17)", "0 (-1) 3 (-18)", "1 1 3 (-16)"
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp)
        check(out, exe, "later_rising", bare + client(rise), "numerical abduction failed")
        check(out, exe, "early_rising", bare + attached(rise) + client(near))
        check(out, exe, "early_both", bare + attached(near, rise))
        for cap in (11, 40):
            check(out, exe, f"outside_convex_region_{cap}", bare + attached(far, rise),
                  "Answers do not converge", ("-iterations_timeout", str(cap)))
        check(out, exe, "hinted", hint + client(far) + client(rise))
        for name, args in [("negative_rise", "(-1) 1 3 0"),
                           ("fast_cap", "0 2 3 0"),
                           ("falling_distance", "1 0 3 0"),
                           ("high_floor", "1 1 20 0")]:
            check(out, exe, name, hint + client(args), "numerical abduction failed")

        # All three fractional inputs and all intermediate values in these
        # depth-two calls have exact binary floating-point representations.
        before, primitive, after = hint.split('"')
        primitive = primitive.replace("m+20", "m+.20.").replace(
            "m+19", "m+.19.").replace("n+1", "n+.1.")
        floating = '"'.join((before, primitive, after))
        floating += ('external let half : Num (1/2) = "0.5"\n'
                     'external let boundary : Num (39/2) = "19.5"\n')
        check(out, exe, "half_boundary", floating + client("half half boundary 0"),
              options=("-num_is", "float"))
        check(out, exe, "unsafe_midpoint", floating + client("half 0 3 (-17)"),
              "numerical abduction failed", ("-num_is", "float"))


if __name__ == "__main__":
    main()
