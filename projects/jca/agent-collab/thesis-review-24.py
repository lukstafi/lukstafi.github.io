"""Place a package at its suppliers, then put a shared observation back in the loop."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]
trace = runpy.run_path(str(HERE / "thesis-review-22.py"))["trace"]
SCHEME = "val run : ∀n. State n → Nat → ∃.Num n"
ABDUCTION = "numerical abduction failed"
MATCH = "(match state with A -> 0 | B -> 1)"
SWITCH = """datatype Switch
datacons L : Switch
datacons R : Switch
"""
HIDE = """let hide : Switch → ∃a.a = efunction s -> (match s with L -> True | R -> 0)
let left = let h = hide L in True
let right = let h = hide R in True
"""
EFFECTS = '''external let log : ∀i. Num i → Num i =
  "let xs = ref [] in fun n -> if n = 73 then assert (List.rev !xs = [10;10;10;10;1;1]) else xs := n :: !xs; n"
external let seen : ∀i. State i → State i = "fun s -> ignore (log 10); s"
'''


def written(src):
    return src.replace("run state =", "run : ∀i. State i → Nat → ∃.Num i = fun state ->")


def check_feedback(exe, path, jump):
    result = subprocess.run([exe, "-full_annot", "-no_ml", "-no_sig", "-no_verif",
                             "-iterations_timeout", "40", "-convergence_step", str(jump), path], text=True, capture_output=True,
                            env=dict(os.environ, JCA_TRACE_INTERFACE="1", JCA_TRACE_DEMAND="1"), timeout=60)
    assert result.returncode and ABDUCTION in result.stdout + result.stderr, result.stdout
    log = " ".join(result.stderr.split())
    records = re.findall(r"DEMAND (\d+) (.*?) STORED (.*?) FORCE (.*?)FLAGS (.*?) END_DEMAND", log)
    # Skip the three initialization passes and the first changed stored relation.
    stable = [(int(i), demand, stored, force, flags) for i, demand, stored, force, flags in records
              if int(i) >= 2]
    assert [i for i, *_ in stable] == list(range(2, 41)), stable
    for _, demand, stored, force, flags in stable:
        m = re.fullmatch(r"(n\d+) ≤ 1 ∧ \1 ≤ 1", demand)
        assert m and stored == f"X1:=∃{m[1]}. δ' = () ∧ {demand} ∧ δ = (Num {m[1]})", stored
        assert not force and flags == "true true true"
    modes = re.findall(r"^JUMP (\d+) (true|false) (true|false) THRESHOLD (\d+) INIT (true|false) (true|false)$",
                       result.stderr, re.M)
    assert [int(i) for i, *unused in modes if int(i) >= 4] == list(range(4, 41))
    assert [int(i) for i, wide, *_ in modes if wide == "true"] == ([3] if jump == 3 else [])
    assert [int(i) for i, _, cap, *_ in modes if cap == "true"] == ([4] if jump == 3 else [10])
    assert all(old != new for i, _, _, _, old, new in modes if int(i) >= 4)
    proposals = re.findall(r"INTERFACE (\d+) (.*?) CALLS .*? END_INTERFACE", log)
    assert [int(i) for i, _ in proposals if int(i) >= 2] == list(range(2, 41))
    for i, relation in proposals:
        if int(i) >= 2:
            assert re.fullmatch(r"X1:=∃(n\d+)\. δ' = \(\) ∧ δ = \(Num \1\)", relation), relation


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before", type=Path, help="optional executable at e9d7a45")
    parser.add_argument("--before-contracts", type=Path, help="optional executable at fc7c3ab")
    parser.add_argument("--trace", type=Path, help="fc7c3ab with all three trace patches")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    state = (HERE / "state_coordinate.gadt").read_text()
    observed = (HERE / "observed_coordinate.gadt").read_text()
    with TemporaryDirectory() as tmp:
        root = Path(tmp)

        def check(name, src, *, budget=11, error=None, opts=(), expected=None, binary=exe):
            sig = compile_and_run(root, binary, name, src, error=error,
                                  options=("-full_annot", "-iterations_timeout", str(budget), *opts))
            if expected:
                assert expected in " ".join(sig.split()), sig

        check("state", state, budget=3, expected=SCHEME)
        check("strict", state, opts=("-force_no_dead_code",), expected=SCHEME)
        check("swapped", state.replace("A -> 0 | B -> 1", "B -> 1 | A -> 0"), expected=SCHEME)
        effects = state.replace("external let small", EFFECTS + "external let small")
        check("effects", effects.replace("match state", "match seen state").replace(
            "when r <=", "when log r <=") + "\nlet checked = log 73\n", expected=SCHEME)
        check("cross_state", state.replace("= run B d", "= run A d"), error=ABDUCTION)
        check("reachable_two", state.replace("r <= 0", "r <= 1"), error=ABDUCTION)
        check("wrong_client", state.replace("i≤1", "i≤0"), error=ABDUCTION)
        live = written(state).replace("∃.Num i", "∃j[0≤j ∧ j≤2].Num j").replace(
            "i≤1", "i≤2").replace("r <= 1", "r <= 2").replace("r <= 0", "r <= 1")
        live = live.replace("external let small", 'external let second : ∀i. Num i → Bool = '
                            '"fun r -> assert (r = 2); true"\nexternal let small')
        check("two_executes", live.replace("run B (S (S Z)) in small b", "run B (S Z) in second b"))
        check("heterogeneous", SWITCH + HIDE, expected="val hide : Switch → ∃a.a")
        check("unwritten", SWITCH + HIDE.replace(" : Switch → ∃a.a", ""), expected="val hide : Switch → ∃a.a")
        check("closure", SWITCH + HIDE.replace("L -> True", "L -> (fun x -> x)"))
        check("plain_bool", SWITCH + HIDE.replace("∃a.a", "Bool").replace("efunction s", "fun s"),
              error="Type mismatch")
        opening = SWITCH + 'external let any : Num 0 → ∃a.a = "fun n -> n"\n' + HIDE.replace("L -> True", "L -> any 0")
        check("one_opening", opening)
        ml = " ".join((root / "one_opening.ml").read_text().split())
        assert "L -> let Ex1 xcase = any 0 in Ex2 xcase" in ml and "R -> let xcase = 0 in Ex2 xcase" in ml
        for budget in (0, 1, 3, 4, 11, 10000):
            check(f"observed_{budget}", observed, budget=budget,
                  error=("Answers do not converge" if not budget else ABDUCTION) if budget < 4 else None,
                  expected=SCHEME if budget >= 4 else None)
        check("certificate", written(observed), expected=SCHEME)
        joined = "(let t = " + MATCH + " in obs t)"
        applied = observed.replace(joined, "obs " + MATCH)
        check("applied", applied, budget=40, expected=SCHEME)
        check("applied_certificate", written(applied), expected=SCHEME)
        check("local_observations", observed.replace(joined, "(match state with A -> obs 0 | B -> obs 1)"),
              expected=SCHEME)
        if args.before:
            prev = args.before.resolve(strict=True)
            check("old_state", state, binary=prev, budget=10000, error=ABDUCTION)
            check("old_heterogeneous", SWITCH + HIDE, binary=prev, error="Type mismatch")
        if args.before_contracts:
            prev = args.before_contracts.resolve(strict=True)
            for budget in (1, 3, 11, 10000):
                check(f"old_observed_{budget}", observed, binary=prev, budget=budget, error=ABDUCTION)
            check("old_applied", applied, binary=prev, budget=40, error=ABDUCTION)
        if args.trace:
            traced = args.trace.resolve(strict=True)
            failure = [("enter", 0), ("update", 0), ("enter", 1), ("fail", 1)]
            success = [(event, i) for i in range(4) for event in ("enter", "update")]
            assert trace(traced, root / "state.gadt", 3) == (0, [], failure * 2 + success)
            path = trace(traced, root / "observed_1.gadt", 1)
            assert path[0] and path[1:] == ([], failure * 4), path
            assert trace(traced, root / "observed_1.gadt", 10000) == path
            for jump in (8, 3):
                check_feedback(traced, root / "applied.gadt", jump)
            print("verified four early failures and 39 consecutive repeated feedback updates", flush=True)


if __name__ == "__main__":
    main()
