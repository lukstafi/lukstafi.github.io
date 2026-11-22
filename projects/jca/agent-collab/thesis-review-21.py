"""Check recursive callers under impossible guards and execute their OCaml."""
import argparse
from pathlib import Path
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE / "thesis-review-18.py"))
CALL, PINNED = previous["MARKED_CALL"], previous["PINNED"]
PLAIN = "∀a, b. Tag (a, b, b, b) → Nat → ∃.(a, a)"
OBSERVE = '''external let observed : ∀i. Num i → Num i =
  "let calls = ref 0 in fun n -> if n = 73 then assert (!calls = EXPECT) else incr calls; n"
'''
OVERFLOW = '''datatype Seed
datacons Pick : ∀i[i≤0]. Num i ⟶ Seed
datatype Input
datacons Low : ∀i[i≤0]. Num i ⟶ Input
external let low : Input = "Low (min_int + 1)"
let pack : ∀i[i≤0]. Num i → Seed = fun n -> Pick (n+n)
let seed = (match low with Low n -> pack n)
let answer = (match seed with Pick n when 1 <= n -> True | _ -> False)
external let check : Bool → Bool = "fun x -> assert x; x"
let checked = check answer
'''


def programs():
    dead = ((HERE / "guarded_payload.gadt").read_text()
            .replace("∀i. Num i ⟶ Seed", "∀i[i≤0]. Num i ⟶ Seed")
            .replace('"Pick 1"', '"Pick 0"'))
    pair = f"let ok = ({CALL}) in " + CALL.replace("Third Box", "First Box")

    def observe(guard, times=1, body=CALL):
        return (dead.replace("external let seed", OBSERVE.replace("EXPECT", str(times)) + "external let seed")
                .replace("1 <= n", guard).replace(CALL, body) + "\nlet checked = observed 73\n")

    return dead, pair, observe


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before", type=Path, help="optional executable at 253cd6b")
    parser.add_argument("--before-retry", type=Path, help="optional executable at 18f071c")
    parser.add_argument("--before-contract", type=Path, help="optional executable at 16509d9")
    parser.add_argument("--trace", type=Path, help="16509d9 executable built with thesis-review-21-trace.patch")
    args = parser.parse_args()
    current = args.invargent.resolve(strict=True)
    dead, pair, observe = programs()

    with TemporaryDirectory() as tmp:
        def check(name, src, budget=11, error=None, options=(), exe=current, runtime_error=False):
            return previous["compile_and_run"](Path(tmp), exe, name, src, error=error,
                options=("-full_annot", "-iterations_timeout", str(budget), *options),
                runtime_error=runtime_error)

        def expect_type(name, src, budget, expected):
            signature = " ".join(check(name, src, budget).split())
            assert "val f : " + expected in signature, signature

        climb = (HERE / "capped_climb.gadt").read_text()
        check("climb_before_jump_settles", climb, 8, "Answers do not converge")
        assert "k ≤ n + 20" in check("climb_after_jump", climb, 9)
        pinned = PINNED.replace("(a,a)", "(a, a)")
        expect_type("definition", dead.split("\ntest (")[0], 5, PLAIN)
        for budget in (0, 1, 4):
            check(f"short_{budget}", dead, budget, "Answers do not converge")
        for budget in (5, 6, 80, 10000):
            expect_type(f"direct_{budget}", dead, budget, PLAIN)
        expect_type("two_direct", dead.replace(CALL, pair), 5, PLAIN)
        expect_type("crossed_guard", dead.replace("1 <= n", "0 <= n"), 6, pinned)
        check("wrong_at_endpoint", dead.replace("1 <= n", "0 <= n").replace("same x Box", "same x Mark"),
              error="Type mismatch")
        check("missing_name", dead.replace(CALL, "missing_name"), error="Undefined variable")
        check("bad_guard_operand", dead.replace("1 <= n", "1 <= n && Box <= n"), error="Type mismatch")
        check("strict_dead", dead, error="Quantifier violation", options=("-force_no_dead_code",))
        many = observe("observed n <= n && 1 <= n", body="let ignored = efunction x -> x in " + pair)
        many += "\nlet later = efunction x -> x\nlet use_later = let x = later Box in same x Box\n"
        expect_type("effect_and_packages", many, 5, PLAIN)
        expect_type("short_circuit", observe("1 <= n && observed n <= n", 0, pair), 5, PLAIN)
        opaque = observe("1 <= observed n")
        nested = dead.replace("Pick n when 1 <= n -> " + CALL,
                              "Pick n -> (match n with m when 1 <= m -> " + CALL + " | _ -> True)")
        check("retry_one_pass_short", opaque, 5, "Answers do not converge")
        expect_type("retry_with_effect", opaque, 6, pinned)
        expect_type("retry_nested", nested, 6, pinned)
        residual = (HERE / "opaque_guard_pair.gadt").read_text()
        assert residual.split() == observe("1 <= observed n", body=pair).replace(
            "with Pick n", "with | Pick n").split()
        for budget in (0, 1, 4, 5, 6, 11, 80, 10000):
            if budget >= 5:
                expect_type(f"opaque_pair_{budget}", residual, budget, PLAIN)
            else:
                check(f"opaque_pair_{budget}", residual, budget,
                      "Quantifier violation" if budget else "Answers do not converge")
        if args.before_contract:
            old = args.before_contract.resolve(strict=True)
            check("pair_before_contract", residual, 10000, "Quantifier violation", exe=old)
            check("written_pair_before_contract", previous["written"](residual, PINNED),
                  error="Type mismatch", exe=old)
        if args.trace:
            trace = args.trace.resolve(strict=True)
            source = Path(tmp) / "opaque_pair_11.gadt"
            def events(budget):
                run = subprocess.run([trace, "-no_ml", "-no_sig", "-no_verif", "-full_annot",
                                      "-iterations_timeout", str(budget), source],
                                     capture_output=True, text=True, timeout=30)
                assert run.returncode, run.stdout
                return [line for line in run.stderr.splitlines() if line.startswith("guard-trace ")]
            path = events(1)
            assert path.count("guard-trace strengthen") == 1
            assert path.count("guard-trace updated 0") == 10
            assert path.count("guard-trace fail 1") == 10
            assert path.count("guard-trace fail 0") == 5
            assert set(path) <= {"guard-trace " + k for k in
                                 ("enter 0", "enter 1", "fail 0", "fail 1", "updated 0", "strengthen")}
            assert events(10000) == path
            print("same 25 attempted passes at budgets 1 and 10000", flush=True)
        check("written_pair", previous["written"](residual, PINNED))
        check("written_direct_pair", previous["written"](dead.replace(CALL, pair), PINNED))
        check("overflow_before_constructor", OVERFLOW)
        direct = '''datatype Seed
datacons Pick : ∀i. Num i ⟶ Seed
external let high : Seed = "Pick max_int"
let answer = (match high with Pick n when n+1 <= n -> True | _ -> False)
external let check : Bool → Bool = "fun x -> assert x; x"
let checked = check answer
'''
        check("overflow_in_guard", direct)
        check("overflow_in_called_guard", direct.replace("let answer", "let inc n = n+1\nlet answer")
              .replace("when n+1 <= n", "when inc n <= n"))
        # These integer literals fit the 64-bit OCaml compiler used for the comparison.
        float_case = '''datatype Seed
datacons Pick : ∀i[i≤9007199254740995]. Num i ⟶ Seed
let seed = Pick 9007199254740995
let answer = (match seed with Pick n when 9007199254740996 <= n -> True | _ -> False)
external let check : Bool → Bool = "fun x -> assert x; x"
let checked = check answer
'''
        check("rounded_float", float_case, options=("-num_is", "float"))
        if args.before:
            old = args.before.resolve(strict=True)
            check("original_direct", dead, 10000, "Quantifier violation", exe=old)
            neg = observe("1 <= observed n", body="assert false")
            check("dropped_effect", neg, exe=old, runtime_error=True)
            check("retained_effect", neg, exe=current)
        if args.before_retry:
            old = args.before_retry.resolve(strict=True)
            check("opaque_before_retry", opaque, 10000, "Quantifier violation", exe=old)


if __name__ == "__main__":
    main()
