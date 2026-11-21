"""Compare guarded numeric pruning in InvarGenT with Z3 over the rationals."""

import argparse
from pathlib import Path
import random
import subprocess

import z3


def sample(count, seed):
    rng = random.Random(seed)
    terms = ["0", "1", "-1", "2", "n1", "n2", "n3", "n1+1", "n2+1", "n3+ -1", "2 n1", "2 n2"]

    def atom():
        a, b, c = (rng.choice(terms) for _ in range(3))
        return rng.choice([
            f"{a}<={b}", f"{a}={b}", f"{a}<=max({b},{c})",
            f"min({a},{b})<={c}", f"{a}=max({b},{c})", f"{a}=min({b},{c})",
        ])

    def conjunction(limit):
        return " ∧ ".join(atom() for _ in range(rng.randint(1, limit)))

    return [(conjunction(3), conjunction(4)) for _ in range(count)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("checker", type=Path, help="compiled thesis-review-7-pruning.ml driver")
    parser.add_argument("--count", type=int, default=4000)
    parser.add_argument("--seed", type=int, default=4407)
    args = parser.parse_args()
    if args.count < 1:
        parser.error("count must be positive")
    pairs = sample(args.count, args.seed)
    inputs = "".join(f"{guard}\n{formula}\n" for guard, formula in pairs)
    run = subprocess.run([args.checker.resolve()], input=inputs, text=True,
                         stdout=subprocess.PIPE, check=True)
    outputs = run.stdout.splitlines()
    if len(outputs) != len(pairs):
        raise ValueError("incomplete driver output")

    variables = {name: z3.Real(name) for name in ("n1", "n2", "n3")}
    solver = z3.Solver()
    errors = differences = 0
    for (guard, formula), line in zip(pairs, outputs):
        if line.startswith("error "):
            if errors < 2:
                print(guard, formula, line)
            errors += 1
            continue
        g, f, result = line.split("\t")
        query = z3.parse_smt2_string(f"(assert (and {g} (xor {f} {result})))", decls=variables)
        answer = solver.check(*query)
        if answer == z3.unknown:
            raise RuntimeError(solver.reason_unknown())
        if answer == z3.sat:
            if differences < 2:
                print(guard, formula, solver.model())
            differences += 1
    print(f"{len(pairs)} judgments, {differences} changed truth, {errors} exceptions")
    return int(bool(differences or errors))


if __name__ == "__main__":
    raise SystemExit(main())
