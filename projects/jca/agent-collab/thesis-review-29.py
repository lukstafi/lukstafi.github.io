"""Check the two-state affine recovery and the three-state feedback counterexample."""
import argparse
import os
import re
from pathlib import Path
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
review28 = runpy.run_path(str(HERE / "thesis-review-28.py"))
compile_and_run = review28["compile_and_run"]


def controls(source):
    entry, rest = source.split("  | S d -> ")
    body, tests = rest.split("\ntest ")
    split = entry + "  | S d -> (match s with " + " | ".join(
        tag + " -> (" + body.replace("run s d", "run "+tag+" d").replace("base s", "base "+tag) + ")"
        for tag in ("A", "B", "C")) + ")\ntest " + tests
    key = ("let key : ∀i. State i → ∃j[j=min(6 i + (-1),4 i + 1)]. Num j = "
           "efunction A -> (-1) | B -> 5 | C -> 9\n\n")
    explicit = (source.replace("let rec run", key + "let rec run")
                .replace("State i → Nat →", "State i → Num k → Nat →")
                .replace("fun s -> efunction", "fun s child_key -> efunction")
                .replace("let prior = run s d", "let child = key s in let prior = run s child d"))
    for tag, key in (("A", "(-1)"), ("B", "3"), ("C", "7")):
        explicit = explicit.replace("run "+tag+" (S", "run "+tag+" "+key+" (S")
    return split, explicit


def check_climb_jump(trace, source):
    repaired = subprocess.run(
        [trace, "-no_ml", "-no_sig", "-no_verif", "-iterations_timeout", "9", source],
        text=True, capture_output=True, check=True, timeout=30,
        env=dict(os.environ, JCA_TRACE_DEMAND="1"))
    assert re.search(r"^JUMP 8 true .*\nDEMAND 8 [^\n]*\+ 20 STORED", repaired.stderr, re.M)
    assert re.search(r"^JUMP 9 true .*\nDEMAND 9  STORED", repaired.stderr, re.M)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("compiler", type=Path)
    parser.add_argument("--original", type=Path, help="compiler at revision 772b9b4")
    parser.add_argument("--before", type=Path, help="compiler at revision 311a5e4")
    parser.add_argument("--trace", type=Path, help="revision 3eb191e with the review 22–24 and 26 diagnostics")
    args = parser.parse_args()
    exe = args.compiler.resolve(strict=True)
    two = (HERE / "state_dependent_interval.gadt").read_text()
    three = (HERE / "three_state_interval.gadt").read_text()
    split, explicit = controls(three)
    mirror = (two.replace("4 i + 1", "-4 i + 5").replace("4 i+1", "-4 i+5")
              .replace("A -> 1 | B -> 5", "A -> 5 | B -> 1")
              .replace("2 <= r && r <= 4", "r <= 4 && 2 <= r"))
    spaced = (two.replace("State 0", "State (-2)").replace("i≤5", "i≤7").replace("n <= 5", "n <= 7")
              .replace("0≤i", "(-2)≤i").replace("min(i,1", "min(i+2,1")
              .replace("4 i + 1", "2 i + 5").replace("4 i+1", "2 i+5").replace("B -> 5", "B -> 7")
              .replace("k+2", "k+3").replace("r <= 4", "r <= 6"))
    unused = two.replace("datacons B : State 1", "datacons B : State 1\ndatacons C : State 2").replace(
        "B -> 5", "B -> 5 | C -> 9")
    parents = (two.replace("let base :", 'external let positive : ∀i[1≤i]. Num i → Bool = '
                           '"fun n -> assert (n >= 1); true"\nlet base :')
               .replace("run A (S Z) in accept p", "run A (S Z) in positive p"))
    # At the third constructor the sample index is a variable. The two literal
    # constructors suggest a line, but the opened value 3 reaches the guard.
    hidden = (two.replace("State 1", "State 2\ndatacons Other : ∀i. Num i ⟶ State i")
              .replace("4 i", "2 i").replace("B -> 5", "B -> 5 | Other n -> 2 * n + 1")
              .replace("i≤1 ∧ min(i,1 + -i)≤0", "i≤2")
              .replace("run A (S Z)", "run (Other 1) (S Z)"))
    with TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, source, *, binary=exe, error=None, options=()):
            return compile_and_run(out, binary, name, source, error=error,
                                   options=("-iterations_timeout", "2", *options))

        for name, source in (("two", two), ("mirror", mirror), ("spaced", spaced),
                             ("unused", unused), ("parents", parents)):
            for suffix, options in (("", ()), ("_annot", ("-full_annot",))):
                check(name+suffix, source, options=options)
                generated = (out / (name+suffix+".ml")).read_text()
                assert generated.count("run s d") == 1, "recursive call was duplicated or given a runtime key"
        check("three", three, error="Type mismatch")
        check("hidden", hidden, error="Type mismatch")
        check("explicit", explicit, options=("-full_annot",))
        check("split", split, options=("-full_annot",))
        climb = (HERE / "capped_climb.gadt").read_text()
        compile_and_run(out, exe, "climb", climb, options=("-iterations_timeout", "9"))
        if args.original:
            compile_and_run(out, args.original.resolve(strict=True), "original_climb", climb,
                            options=("-iterations_timeout", "40"), error="Answers do not converge")
        if args.before:
            before = args.before.resolve(strict=True)
            check("old_two", two, binary=before, error="Type mismatch")
        if args.trace:
            trace = args.trace.resolve(strict=True)
            check_climb_jump(trace, out / "climb.gadt")
            for options in ((), ("-full_annot",)):
                review28["trace"](trace, out / "three.gadt", options, states=(0, 1, 2))


if __name__ == "__main__":
    main()
