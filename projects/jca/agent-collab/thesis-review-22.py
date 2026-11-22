"""Compile guard contracts, execute their clients and compare discard traces."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
old = runpy.run_path(str(HERE / "thesis-review-21.py"))
CALL, PINNED, PLAIN = old["CALL"], old["PINNED"], old["PLAIN"]
compile_and_run = old["previous"]["compile_and_run"]
written = old["previous"]["written"]


def single(source):
    start = source.index("      let ok =")
    end = source.index("in same x Box", source.index("f (First Box)", start)) + len("in same x Box")
    return source[:start] + "      " + CALL + source[end:]


def helper(source):
    return (source.replace("test (match seed", "test (let rec relay n = function "
                           "Z -> observed n | S d -> relay n d in match seed")
            .replace("1 <= observed n", "1 <= relay n (S Z)"))


def trace(exe, path, budget, *, cut_limit=None):
    env = os.environ.copy()
    env.pop("JCA_TRACE_CUT_LIMIT", None)
    if cut_limit:
        env["JCA_TRACE_CUT_LIMIT"] = str(cut_limit)
    r = subprocess.run([exe, "-no_ml", "-no_sig", "-no_verif", "-full_annot",
                        "-iterations_timeout", str(budget), path],
                       env=env, capture_output=True, text=True, timeout=30)
    cuts = [" ".join(x.split()) for x in re.findall(r"TRACE cut (.*?) END_CUT", r.stderr, re.S)]
    events = re.findall(r"^TRACE (enter|update|fail) (\d+)$", r.stderr, re.M)
    return r.returncode, cuts, [(k, int(n)) for k, n in events]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before", type=Path, help="ordinary executable at 16509d9")
    parser.add_argument("--before-joint", type=Path, help="ordinary executable at 82587e2")
    parser.add_argument("--trace", type=Path, help="82587e2 executable with the review-22 trace patch")
    parser.add_argument("--old-trace", type=Path, help="16509d9 executable with the same patch")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    pair = (HERE / "opaque_guard_pair.gadt").read_text()
    packed = (HERE / "local_packed_guard.gadt").read_text()
    pinned = PINNED.replace("(a,a)", "(a, a)")
    first_use = "\nlet later = " + CALL.replace("Third Box", "First Box") + "\n"
    third_use = "\nlet later = " + CALL + "\n"
    with TemporaryDirectory() as tmp:
        root = Path(tmp)

        def check(name, src, expected=None, *, budget=11, error=None, binary=exe, flags=()):
            sig = compile_and_run(root, binary, name, src, error=error,
                                  options=("-full_annot", "-iterations_timeout", str(budget), *flags))
            if expected:
                assert ("val f : " + expected) in " ".join(sig.split()), sig
            return sig

        check("opaque_pair", pair, PLAIN, budget=5)
        check("already_accepted_client", single(pair) + third_use, pinned, budget=6)
        check("subsequent_first", pair + first_use, PLAIN)
        check("subsequent_third", pair + third_use, error="Type mismatch")
        check("written_subsequent_third", written(pair + third_use, PINNED), pinned)
        check("opaque_endpoint", pair.replace("1 <= observed n", "0 <= observed n"), error="Quantifier violation")
        check("outside_precondition", pair.replace("∀i. Num i → Num i", "∀i[i≤-1]. Num i → Num i"),
              error="Quantifier violation")
        check("invalid_guard", pair.replace("1 <= observed n", "1 <= observed Box"), error="Type mismatch")
        check("twice", pair.replace("1 <= observed n", "1 <= observed (observed n)")
              .replace("!calls = 1", "!calls = 2"), PLAIN)
        check("two_independent_instances", pair.replace("1 <= observed n", "observed 1 <= observed 0")
              .replace("!calls = 1", "!calls = 2"), PLAIN)
        check("two_instances_live", pair.replace("1 <= observed n", "observed 0 <= observed 1"),
              error="Quantifier violation")
        check("ordinary_lets", pair.replace("1 <= observed n", "1 <= (let u = observed n in let v = u in v)"), PLAIN)
        signature = 'external let seal : ∀i. Num i → ∃j[j≤i]. Num j = "fun n -> n"\n'
        sealpair = pair.replace("external let seed", signature + "external let seed")
        inside = (sealpair.replace("Pick n when 1 <= observed n ->",
                                   "Pick n -> let k = seal (observed n) in let copy = k in "
                                   "(match copy with r when 1 <= r ->").replace("| _ -> True)", "| _ -> True))"))
        check("inside_open", inside, PLAIN)
        check("open_can_return_one", inside.replace("j≤i", "j≤i+1").replace('"fun n -> n"', '"fun n -> n+1"'),
              error="term abduction failed")
        # At zero this broader package can actually return one.
        endpoint = "datatype Seed\ndatacons Pick : ∀i[i≤0]. Num i ⟶ Seed\n" + signature.replace(
            "j≤i", "j≤i+1").replace('"fun n -> n"', '"fun n -> n+1"') + """
let taken = (match Pick 0 with Pick n -> let k = seal n in
             (match k with r when 1 <= r -> True | _ -> False))
external let require_true : Bool → Bool = "fun b -> assert b; b"
let checked = require_true taken
"""
        check("opened_endpoint_executes", endpoint)
        # The operand must have a single result index outside the package opening.
        escaping = single(sealpair).replace(CALL, "True").replace("1 <= observed n",
                                                                 "1 <= (let k = seal (observed n) in k)")
        check("escaping_index", escaping, error="numerical abduction failed")
        check("ordinary_helper_one", helper(single(pair)), pinned, budget=6)
        check("ordinary_helper_both", helper(pair), PLAIN, budget=5)
        check("helper_changes_index", helper(pair).replace("Z -> observed n", "Z -> 1"),
              error="Quantifier violation")
        check("helper_wrong_live_return", helper(single(pair)).replace("1 <= relay", "0 <= relay")
              .replace("same x Box", "same x Mark"), error="Quantifier violation")
        check("strict", pair, error="Quantifier violation", flags=("-force_no_dead_code",))
        local = re.search(r"test \((let rec relay .*?) in\s+match seed with", packed, re.S)
        assert local
        raised = packed.replace(local.group(0), "test (match seed with").replace(
            "let rec f t =", local[1] + "\nlet rec f t =")
        sig = check("separately_inferred_package", raised, PLAIN)
        assert "val relay : ∀n. Num n → Nat → ∃.Num n" in " ".join(sig.split()), sig
        check("one_packed_call", single(packed), pinned)
        check("erased_packed_clients", single(packed).replace(CALL, "True"), PLAIN)
        for budget in (0, 1, 2, 3, 4, 5, 6, 11, 80, 10000):
            check(f"packed_{budget}", packed, PLAIN if budget >= 6 else None, budget=budget,
                  error="Answers do not converge" if budget < 6 else None)
            if args.before_joint:
                check(f"before_joint_{budget}", packed, binary=args.before_joint.resolve(strict=True),
                      budget=budget, error="Answers do not converge" if budget < 6 else "Type mismatch")
        if args.before:
            before = args.before.resolve(strict=True)
            check("old_external_pair", pair, error="Quantifier violation", binary=before, budget=10000)
            check("old_later_client", single(pair) + third_use, pinned, binary=before)
        if args.trace:
            traced = args.trace.resolve(strict=True)
            path = root / "packed_11.gadt"
            rc, cuts, events = trace(traced, path, 6)
            assert rc != 0 and len([n for k, n in events if k == "enter"]) == 28, events
            assert max(n for k, n in events if k == "update") == 5
            assert [k for k, n in events if n == 6] == ["enter", "fail"] * 3
            assert trace(traced, path, 10000) == (rc, cuts, events)
            print("same 28 attempts with three failed pass-6 replays", flush=True)
        if args.old_trace:
            rc, cuts, events = trace(args.old_trace.resolve(strict=True), root / "ordinary_helper_one.gadt",
                                     1, cut_limit=64)
            assert rc == 86 and len(cuts) == 64 and len(set(cuts)) == 1, cuts[:3]
            assert max(n for k, n in events if k == "update") == 0
            print("stopped old search after 64 copies of one pass-0 discard", flush=True)


if __name__ == "__main__":
    main()
