"""Check consumed match contracts and the two parameter choices of a translated postcondition."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE / "thesis-review-24.py"))
compile_and_run, trace = previous["compile_and_run"], previous["trace"]
SCHEME, MATCH, ABDUCTION = (previous[k] for k in ("SCHEME", "MATCH", "ABDUCTION"))
TAG = "val reveal : ∀a. Tag a → Nat → ∃.a"
ARMS = "function A -> 0 | B -> 1"
EFFECTS = '''external let note : ∀i. Num i → Num i =
  "let xs = ref [] in fun n -> if n = 73 then assert (List.rev !xs = [10;20;30;1]) else xs := n :: !xs; n"
external let which : ∀i. State i → State i = "fun s -> ignore (note 10); s"
'''


def check_loop(exe, path, jump):
    result = subprocess.run([exe, "-full_annot", "-no_ml", "-no_sig", "-no_verif",
                             "-iterations_timeout", "40", "-convergence_step", str(jump), path],
                            capture_output=True, text=True, timeout=60,
                            env=dict(os.environ, JCA_TRACE_INTERFACE="1", JCA_TRACE_DEMAND="1"))
    assert result.returncode and ABDUCTION in result.stdout + result.stderr
    modes = re.findall(r"^JUMP (\d+) true ", result.stderr, re.M)
    assert modes == (["3", "4"] if jump == 3 else []), modes
    # Join wrapped formulas only within their own diagnostic records.
    interfaces = re.findall(r"^INTERFACE (\d+) (.*?) CALLS (.*?) END_INTERFACE", result.stderr, re.M | re.S)
    demands = re.findall(r"^DEMAND (\d+) (.*?) STORED (.*?) FORCE .*?FLAGS .*? END_DEMAND",
                         result.stderr, re.M | re.S)
    seen = []
    for i, proposal, calls in interfaces:
        i = int(i)
        if i < 4:
            continue
        seen.append(i)
        relation = " ".join(proposal.split())
        helper = re.search(r"State (n\d+) → Num \(\1 \+ 1\)", " ".join(calls.split()))
        assert helper, calls
        demand, stored = next((d, s) for n, d, s in demands if int(n) == i)
        demand = " ".join(demand.split())
        if i % 2 or (jump == 3 and i == 4):
            m = re.fullmatch(r"X1:=∃(n\d+)\. δ' = \(\) ∧ δ = \(Num \1\)", relation)
            assert m and demand == f"{m[1]} ≤ 2 ∧ {m[1]} ≤ 2", (relation, demand)
        else:
            m = re.match(r"X1:=∃(n\d+)\. δ' = \(\((n\d+)\)\) ∧ δ = \(Num \1\) ∧ ", relation)
            assert m, relation
            o, k = m.groups()
            assert set(relation[m.end():].split(" ∧ ")) == {f"{k} + 1 ≤ {o}", f"{o} ≤ {k} + 2"}
            assert demand == f"{k} ≤ 0", demand
        assert demand in " ".join(stored.split()), stored
    assert seen == list(range(4, 41)), seen


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before-replay", type=Path, help="unpatched 451b7ab")
    parser.add_argument("--trace", type=Path, help="a3151c0 with the three review 22–24 trace patches")
    parser.add_argument("--old-trace", type=Path, help="fc7c3ab with the review 22 trace patch")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    observed, tag, shifted = ((HERE / f"{name}.gadt").read_text()
                              for name in ("observed_coordinate", "observed_tag", "translated_coordinate"))
    scaled = (HERE / "scaled_coordinate.gadt").read_text()
    with TemporaryDirectory() as tmp:
        root = Path(tmp)

        def check(name, src, *, expected=None, error=None, budget=11, opts=(), binary=exe):
            sig = compile_and_run(root, binary, name, src, error=error,
                                  options=("-full_annot", "-iterations_timeout", str(budget), *opts))
            if expected:
                assert expected in " ".join(sig.split()), sig

        check("observed", observed, budget=4, expected=SCHEME)
        check("applied", observed.replace("(let t = " + MATCH + " in obs t)", "obs " + MATCH),
              budget=4, expected=SCHEME)
        check("swapped", observed.replace("A -> 0 | B -> 1", "B -> 1 | A -> 0"), expected=SCHEME)
        captured = observed.replace("let t = " + MATCH, "let a = obs 0 in let b = obs 1 in "
                                    "let t = (match state with A -> a | B -> b)")
        check("captures", captured, expected=SCHEME)
        check("one_use", observed.replace(MATCH, "(let view = " + ARMS + " in view state)"), expected=SCHEME)
        check("callback", observed.replace("let rec run", "let apply f x = f x\nlet rec run")
              .replace(MATCH, "(apply (" + ARMS + ") state)"), expected=SCHEME)
        mono = observed.partition("let rec run")[0] + "let use = let view = " + ARMS + " in let a = view A in view B\n"
        check("monomorphic_alias", mono, error=ABDUCTION)
        check("polymorphic_definition", mono.replace("let view =", "let rec view ="))
        flip = observed.replace("external let obs", 'external let flip : ∀i. Num i → Num (1 + -i) = '
                                '"fun n -> 1-n"\nexternal let obs')
        check("two_flips", flip.replace("in obs t", "in flip (flip t)"), expected=SCHEME)
        check("one_flip", flip.replace("in obs t", "in flip t"), error=ABDUCTION)
        check("restricted_observer", observed.replace("obs : ∀i.", "obs : ∀i[i≤0]."), error=ABDUCTION)
        effects = observed.replace("external let obs", EFFECTS + "external let obs").replace(
            MATCH, "(match which state with A -> 0 | B when note 20 <= 0 -> 1 | B -> let v = note 30 in 1)")
        check("guard_and_observer", effects.replace("in obs t", "in note t") + "\nlet check = note 73\n",
              expected=SCHEME)
        check("tag", tag, budget=5, expected=TAG)
        check("wrong_tag", tag.replace("in box b", "in mark b"), error="Type mismatch")
        tag_match = "(match tag with M -> Mark | C -> Box)"
        check("separate_tag", tag.replace(tag_match, "(project tag)").replace(
            "let rec reveal", "let project = function M -> Mark | C -> Box\nlet rec reveal"), expected=TAG)
        twins = tag.replace("in observe x", "in (observe x,observe x)").replace(
            "let a = reveal", "let (a,_) = reveal").replace("let b = reveal", "let (b,_) = reveal")
        check("pair_tag", twins, expected="→ Nat → ∃.(a, a)")
        if args.before_replay:
            for budget in (2, 11, 10000):
                check(f"provisional_clash_{budget}", tag, error="Type mismatch", budget=budget,
                      binary=args.before_replay.resolve(strict=True))

        def annotated(ty):
            return shifted.replace("run state =", "run : " + ty + " = fun state ->")

        check("translated", shifted, budget=40, expected="State n → Nat → ∃.Num (n + 1)")
        check("translated_early_jump", shifted, budget=40, opts=("-convergence_step", "3"), expected="∃.Num (n + 1)")
        check("exact_coordinate", annotated("∀i. State i → Nat → ∃.Num (i+1)"),
              expected=SCHEME.replace("∃.Num n", "∃.Num (n + 1)"))
        band = "∃j[k+1≤j ∧ j≤k+2].Num j"
        check("two_coordinates", annotated("∀i,k[k≤i ∧ i≤k+1]. State i → Nat → " + band),
              expected="State k → Nat → ∃j[n + 1 ≤ j ∧ j ≤ n + 2].Num j")
        check("one_coordinate", annotated("∀k. State k → Nat → " + band), error=ABDUCTION)
        for budget in (0, 1, 11, 10000):
            check(f"scaled_{budget}", scaled, budget=budget, error=("Answers do not converge" if not budget else ABDUCTION) if budget < 4 else None,
                  expected="∃.Num (4 n)" if budget >= 4 else None)
        check("scaled_exact", scaled.replace("run state =", "run : ∀i. State i → Nat → ∃.Num (4 i) = fun state ->"),
              expected="State n → Nat → ∃.Num (4 n)")
        check("postcondition_radius_4", scaled, opts=("-postcond_rotations", "4"), expected="∃.Num (4 n)")
        check("abduction_radius_4", scaled, opts=("-num_abduction_rotations", "4"),
              expected="State n → Nat → ∃")
        scaled_five = scaled.replace("-> 5 |", "-> 6 |").replace("4", "5")
        check("five_at_radius_4", scaled_five, opts=("-num_abduction_rotations", "4"), expected="∃.Num (5 n)")
        check("five_at_radius_5", scaled_five, opts=("-num_abduction_rotations", "5"),
              expected="State n → Nat → ∃")
        unit_band = scaled.replace("run state =",
                                   "run : ∀i[i≤4]. State i → Nat → ∃j[i≤j ∧ j≤4].Num j = fun state ->")
        check("written_band_default", unit_band, expected="∃j[n ≤ j ∧ j ≤ 4].Num j")
        check("written_band_radius_4", unit_band, opts=("-num_abduction_rotations", "4"),
              expected="State n → Nat → ∃j[n ≤ j ∧ j ≤ 4].Num j")
        # The Left opening supplies Cargo. This caller demands Marker.
        discard = tag.partition("datatype Tag")[0] + """datatype Tag : type * type
datacons Left : ∀a. a ⟶ Tag (Marker,a)
datacons Right : ∀a. a ⟶ Tag (a,Marker)
datatype Nat
datacons Z : Nat
datacons S : Nat ⟶ Nat
external let same : ∀a. a → a → Bool = "fun x y -> x = y"
let rec f t = efunction Z -> let z = (let rec project = function Left x -> x | Right x -> x in project t) in (z,z)
| S n -> f t n
test (let (x,y) = f (Left Box) (S Z) in same y Mark)
"""
        check("rejected_opening", discard, error="Type mismatch")
        if args.trace:
            traced = args.trace.resolve(strict=True)
            for jump in (8, 3):
                check_loop(traced, root / "translated.gadt", jump)
            failure = [("enter", 0), ("update", 0), ("enter", 1), ("fail", 1)] * 6
            for budget in (1, 11, 10000):
                assert trace(traced, root / "scaled_1.gadt", budget) == (2, [], failure)
            assert trace(traced, root / "scaled_0.gadt", 0) == (2, [], [("enter", 0), ("update", 0)] * 2)
            rc, cuts, _ = trace(traced, root / "rejected_opening.gadt", 11, cut_limit=64)
            assert rc == 2 and 1 < len(cuts) < 64, (rc, cuts)
        if args.old_trace:
            rc, cuts, _ = trace(args.old_trace.resolve(strict=True), root / "rejected_opening.gadt",
                                11, cut_limit=64)
            assert rc == 86 and len(cuts) == 64, (rc, cuts)


if __name__ == "__main__":
    main()
