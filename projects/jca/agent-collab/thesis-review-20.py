"""Check guarded call discovery, sequential openings and higher-order arguments."""
import argparse
from pathlib import Path
import runpy
import tempfile

HERE = Path(__file__).resolve().parent
previous = runpy.run_path(str(HERE / "thesis-review-18.py"))
compile_and_run = previous["compile_and_run"]
CALL = previous["MARKED_CALL"]
PINNED = previous["PINNED"]
written = previous["written"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before", type=Path, help="also compare revision f570a4b")
    parser.add_argument("--before-alias", type=Path, help="also compare dbd005d before ordinary function aliases")
    args = parser.parse_args()
    current = args.invargent.resolve(strict=True)
    direct = (HERE / "four_axis_payload.gadt").read_text()
    guarded = (HERE / "guarded_payload.gadt").read_text()
    observed = "Pick n when 1 <= n -> " + CALL
    order = direct.replace(CALL, "let (u,v) = f (Third Mark) Z in let first = same u Mark in " + CALL)
    callback = direct.replace(CALL, "let call3 g = " + CALL.replace("= f ", "= g ") + " in call3 f")
    wrapped = direct.replace(CALL, "let wrap k g = k g in let observe g = " +
                             CALL.replace("= f ", "= g ") + " in wrap observe f")
    local = direct.replace(CALL, "let (selected,depth) = (Third Box,S Z) in " +
                           CALL.replace("(Third Box) (S Z)", "selected depth"))
    coupled = (guarded.replace("∀i. Num i ⟶ Seed", "∀i,j. (Num i,Num j) ⟶ Seed")
               .replace('"Pick 1"', '"Pick (3,2)"')
               .replace(observed, "Pick (n,m) when m+1 <= n -> " + CALL))
    nested = guarded.replace(CALL, "(match seed with Pick m when m <= n+1 -> " + CALL + " | _ -> True)")
    indexed = (guarded.replace("datatype Seed", "datatype Axis : type\ndatacons IsCargo : Axis Cargo\n"
                               "datacons IsMarker : Axis Marker\ndatatype Seed")
               .replace("∀i. Num i ⟶ Seed", "∀a. Axis a ⟶ Seed")
               .replace('"Pick 1"', '"Pick IsCargo"')
               .replace(observed + " | _ -> True", "Pick a -> (match a with IsCargo -> " +
                        CALL + " | IsMarker -> True)"))
    alias = direct.replace(CALL, "let g = f in " + CALL.replace("= f ", "= g "))
    partial = guarded.replace(CALL, "let g = f in let h = g in let at_box = h (Third Box) in "
                              "let (x,y) = at_box (S Z) in same x Box")
    apply = direct.replace(CALL, "let apply g a n = g a n in " + CALL.replace("= f ", "= apply f "))
    impossible_guard = guarded.replace("∀i. Num i", "∀i[i≤0]. Num i").replace('"Pick 1"', '"Pick 0"')
    impossible = """datatype Seed
datacons Live : Seed
datacons Pick : ∀i,j[1≤max(i,j) ∧ i≤0 ∧ j≤0]. (Num i, Num j) ⟶ Seed
let safe : Seed → Bool = function Live -> True | Pick (x,y) -> assert false
let at_live = safe Live
"""
    with tempfile.TemporaryDirectory() as tmp:
        def check(name, src, budget=11, error=None, exe=current):
            return compile_and_run(Path(tmp), exe, name, src, error=error,
                                   options=("-iterations_timeout", str(budget), "-full_annot"))

        check("one_pass_short", guarded, 5, "Answers do not converge")
        for name, src in [("guarded", guarded), ("stationary_guard", guarded.replace('"Pick 1"', '"Pick 0"')),
                          ("coupled", coupled), ("nested", nested), ("gadt", indexed),
                          ("reversed_calls", order), ("local_arguments", local), ("callback", callback),
                          ("callback_as_argument", wrapped), ("alias", alias), ("partial_alias", partial),
                          ("return_from_apply", apply)]:
            sig = check(name, src, 6)
            assert PINNED.replace("(a,a)", "(a, a)") in " ".join(sig.split()), sig
        sig = check("inferred_for_round_trip", wrapped)
        annotation = sig.split("val f :")[1].strip()
        check("same_callback_type_written", written(wrapped, annotation))
        check("wrong_guarded_result", guarded.replace("same x Box", "same x Mark"), error="Type mismatch")
        check("wrong_second_result", order.replace("same x Box", "same x Mark"), error="term abduction failed")
        check("impossible_maximum", impossible)
        check("attainable_maximum", impossible.replace("i≤0", "i≤1"), error="negative clause")
        check("written_impossible_guard", written(impossible_guard, PINNED))
        for name, src in [
            ("include_guard_endpoint", impossible_guard.replace("1 <= n", "0 <= n")),
            ("live_call_then_impossible_arm", impossible_guard.replace(
                "test (match", "test (let (u,v) = f (Third Box) Z in let ok = same u Box in match"))]:
            sig = check(name, src)
            assert PINNED.replace("(a,a)", "(a, a)") in " ".join(sig.split()), sig
        for budget in (0, 1, 4, 5, 6, 80, 10000):
            sig = check(f"impossible_guard_{budget}", impossible_guard, budget,
                        "Answers do not converge" if budget < 5 else None)
            if sig:
                assert "Tag (a, b, b, b) → Nat → ∃.(a, a)" in " ".join(sig.split()), sig
        if args.before_alias:
            old_alias = args.before_alias.resolve(strict=True)
            check("written_alias_before", written(alias, PINNED), exe=old_alias)
            check("previous_alias", alias, 10000, "term abduction failed", exe=old_alias)
        if args.before:
            old = args.before.resolve(strict=True)
            check("previous_hidden_guard", guarded, 10000, "term abduction failed", exe=old)
            check("previous_reversed_order", order, 80, "Type mismatch", exe=old)
            check("previous_impossible_maximum", impossible, error="negative clause", exe=old)
            check("previous_written_callback", written(wrapped, annotation),
                  error="Should not be existential", exe=old)


if __name__ == "__main__":
    main()
