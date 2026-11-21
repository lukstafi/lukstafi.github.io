"""Compare the InvarGenT numeric implication checker with a rational-arithmetic oracle."""

import argparse
from itertools import permutations
from pathlib import Path
import random
import subprocess


DRIVER = """let parse s =
  NumS.sort_formula (Parser.formula Lexer.token (Lexing.from_string s))

let () =
  try while true do
    let given = parse (read_line ()) in
    let goal = parse (read_line ()) in
    let state =
      try Some (NumS.satisfiable_exn given) with Terms.Contradiction _ -> None in
    let valid = match state with
      | None -> true
      | Some state -> NumS.implies_cnj state goal in
    print_endline (string_of_bool valid)
  done with End_of_file -> ()
"""


def cases(count):
    import z3

    variables = {name: z3.Real(name) for name in ("n1", "n2", "n3")}
    atoms = []
    for a, b, c in permutations(variables):
        x, y, z = variables[a], variables[b], variables[c]
        maximum = z3.If(y >= z, y, z)
        minimum = z3.If(y <= z, y, z)
        atoms.extend([
            (f"{a}=max({b},{c})", x == maximum),
            (f"{a}=min({b},{c})", x == minimum),
            (f"{a}<=max({b},{c})", x <= maximum),
            (f"min({b},{c})<={a}", minimum <= x),
            (f"{a}={b}+{c}", x == y + z),
            (f"{a}+{b}<=2 {c}", x + y <= 2*z),
            (f"{a}={b}+1", x == y + 1),
            (f"{a}+1<={b}", x + 1 <= y),
            (f"{a}<={b}", x <= y),
        ])
    for name, var in variables.items():
        for k in (-1, 0, 1):
            atoms.extend([(f"{name}= {k}", var == k), (f"{name}<= {k}", var <= k),
                          (f"{k}<={name}", k <= var)])

    rng = random.Random(4405)
    solver = z3.SolverFor("QF_LRA")
    for _ in range(count):
        given = rng.sample(atoms, rng.randrange(1, 6))
        goal, formula = rng.choice(atoms)
        solver.push()
        solver.add(*(expr for _, expr in given), z3.Not(formula))
        answer = solver.check()
        solver.pop()
        if answer == z3.unknown:
            raise RuntimeError("Z3 returned unknown")
        yield " ∧ ".join(text for text, _ in given), goal, answer == z3.unsat


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("checker", type=Path, nargs="?")
    parser.add_argument("--driver", action="store_true", help="print the OCaml line-protocol driver")
    parser.add_argument("--count", type=int, default=50000)
    args = parser.parse_args()
    if args.driver:
        print(DRIVER, end="")
        return 0
    if args.checker is None or args.count < 1:
        parser.error("supply the compiled checker and a positive count")
    sample = list(cases(args.count))
    lines = "".join(f"{p}\n{g}\n" for p, g, _ in sample)
    run = subprocess.run([str(args.checker.resolve())], input=lines, text=True,
                         stdout=subprocess.PIPE, check=True)
    answers = run.stdout.splitlines()
    if len(answers) != len(sample) or any(a not in ("true", "false") for a in answers):
        raise ValueError("invalid response from checker")
    false_positives = false_negatives = 0
    for (premise, goal, expected), answer in zip(sample, answers):
        if (answer == "true") != expected:
            if false_positives + false_negatives < 3:
                print(f"{premise}  ⇒  {goal}   checker={answer}, oracle={expected}")
            if expected:
                false_negatives += 1
            else:
                false_positives += 1
    print(f"{len(sample)} implications, {false_positives} false positives, "
          f"{false_negatives} false negatives")
    return int(bool(false_positives or false_negatives))


if __name__ == "__main__":
    raise SystemExit(main())
