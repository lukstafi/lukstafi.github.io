"""Check required calls, guarded inference and maximal payload patterns."""
import argparse
from collections import Counter
from itertools import product
from pathlib import Path
import runpy
import tempfile

HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]
MARKED_CALL = "let (x,y) = f (Third Box) (S Z) in same x Box"
PINNED = "∀a. Tag (Marker, Marker, a, Marker) → Nat → ∃.(a,a)"


def patterns(length, prefix=(), largest=0):
    # Zero is Marker. Number the holes in order of their first occurrence.
    if len(prefix) == length:
        yield prefix
    else:
        for symbol in range(largest + 2):
            yield from patterns(length, prefix + (symbol,), max(largest, symbol))


def rows(pattern):
    result = set()
    for values in product((0, 1), repeat=max(pattern)):
        env = (0,) + values
        result.add(tuple(env[h] for h in pattern))
    return result


def audit_patterns():
    for axes, expected in enumerate((1, 1, 1, 4, 7, 25, 85), start=1):
        marked = (1,) + (0,) * (axes - 1)
        valid = []
        for pattern in patterns(axes + 1):
            relation = rows(pattern)
            # A constructor-built input is all Marker or has just one Cargo.
            # Every admitted such input must allow its actual payload.
            admitted = {row[:-1] for row in relation}
            producer = all(args + (int(any(args)),) in relation
                           for args in admitted if sum(args) <= 1)
            client = marked + (1,) in relation and marked + (0,) not in relation
            rest = pattern[1:-1]
            counts = Counter(x for x in rest if x)
            predicted = (pattern[0] != 0 and pattern[0] == pattern[-1]
                         and pattern[0] not in rest and 1 not in counts.values())
            assert (producer and client) == predicted, (axes, pattern)
            if predicted:
                valid.append((pattern, relation))
        maxima = {p for p, r in valid if not any(r < s for _, s in valid)}
        predicted_maxima = {
            p for p, _ in valid if p[1:-1].count(0) <= 1
            and all(n <= 3 for h, n in Counter(p[1:-1]).items() if h)
        }
        assert maxima == predicted_maxima and len(maxima) == expected, (axes, maxima)
        print(f"{axes} axes, {len(valid)} valid patterns, {len(maxima)} maximal")


def written(source, signature):
    return source.replace("let rec f t =", f"let rec f : {signature} = fun t ->")


def exercise(binary, long_runs):
    direct = (HERE / "four_axis_payload.gadt").read_text()
    guarded = (HERE / "guarded_payload.gadt").read_text()
    entailed = direct.replace(MARKED_CALL, f"match 1 with n when 1 <= n -> {MARKED_CALL} | _ -> True")
    two = direct.replace("in same x Box",
                         "in let (u,v) = f (Third Mark) Z in let ok = same v Mark in same x Box")
    forward = "\nlet forward t = let (x,y) = f t (S Z) in (x,y)\n"
    other_arms = "".join(f"\nlet ok{i} = let (x,y) = f ({c} Mark) (S Z) in same y Mark\n"
                         for i, c in enumerate(("First", "Second", "Fourth")))

    with tempfile.TemporaryDirectory() as tmp:
        def check(name, source, budget=11, error=None):
            return compile_and_run(Path(tmp), binary, name, source, error=error,
                                   options=("-iterations_timeout", str(budget), "-full_annot"))

        expected = PINNED.replace("(a,a)", "(a, a)")
        for name, source in [("direct", direct), ("entailed", entailed)]:
            check(name + "_pass5", source, 5, "Answers do not converge")
            assert expected in " ".join(check(name + "_pass6", source, 6).split())
        ordinary = check("ordinary_pair", direct.replace("efunction", "function"), 2)
        assert expected.replace("∃.", "") in " ".join(ordinary.split())
        assert expected in " ".join(check("two_instances", two).split())
        check("wrong_result", direct.replace("same x Box", "same x Mark"), error="Type mismatch")
        check("incompatible_axes", two.replace("Third Mark", "Fourth Box").replace(
            "same v Mark", "same v Box"), error="Type mismatch")

        for budget in (0, 1, 5, 8, 11, 80, 10000):
            check(f"guarded_{budget}", guarded, budget,
                  "term abduction failed" if budget else "Answers do not converge")
        for value in (0, 1):
            check(f"written_guarded_{value}", written(guarded, PINNED).replace('"Pick 1"', f'"Pick {value}"'))
        for i, arguments in enumerate(("b,b,a,b", "Marker,b,a,b", "b,Marker,a,b", "b,b,a,Marker")):
            signature = f"∀a,b. Tag ({arguments}) → Nat → ∃.(a,a)"
            exported = " ".join(check(f"maximal_{i}", written(direct, signature) + other_arms + forward).split())
            # Exported binders are named in order of appearance in the arrow.
            indices = ", ".join({"a": "b", "b": "a"}.get(x, x) for x in arguments.split(","))
            assert f"val forward : ∀a, b. Tag ({indices}) → (b, b)" in exported, exported
        pinned = " ".join(check("inferred_forward", direct + forward).split())
        assert "val forward : ∀a. Tag (Marker, Marker, a, Marker) → (a, a)" in pinned

        tagged = (HERE / "tagged_floor.gadt").read_text()
        recovered = "(tag+(-1*j)+(-1*e))"
        assert tagged.count(recovered) == 1
        direct_result = tagged.replace(recovered, "r")
        signature = check("direct_numeric_payload", direct_result).split("val climb :")[1].strip()
        header = "let rec climb e d j m ="
        assert tagged.count(header) == 1
        annotated = tagged.replace(header, f"let rec climb : {signature} = fun e d j m ->")
        check("same_certificate_on_recovered_payload", annotated)
        for budget in ((11, 80, 171) if long_runs else (11,)):
            check(f"recovered_numeric_payload_{budget}", tagged, budget, "Answers do not converge")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path, nargs="?", help="also compile and execute the source programs")
    parser.add_argument("--long", action="store_true", help="also run the arithmetic example to passes 80 and 171")
    args = parser.parse_args()
    audit_patterns()
    if args.invargent:
        exercise(args.invargent.resolve(strict=True), args.long)
