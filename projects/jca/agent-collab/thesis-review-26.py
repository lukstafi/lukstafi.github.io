"""Exercise affine inference and project the final guard onto its hidden call parameter."""
import argparse
import os
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]
ABDUCTION = "numerical abduction failed"


def difference_edges(formula):
    """Represent u ≤ v + c by the edge v → u of weight c."""
    def term(s):
        if re.fullmatch(r"-?\d+", s):
            return "zero", int(s)
        m = re.fullmatch(r"(\w+)(?: \+ (-?\d+))?", s)
        assert m, s
        return m[1], int(m[2] or 0)

    edges = []
    for atom in formula.split(" ∧ "):
        left, sign, right = re.fullmatch(r"(.+) (≤|=) (.+)", atom).groups()
        u, cu = term(left)
        v, cv = term(right)
        edges.append((v, u, cv-cu))
        if sign == "=":
            edges.append((u, v, cu-cv))
    return edges


def feasible(edges):
    # All vertices start at distance zero. A relaxation on the |V|th
    # pass detects a negative cycle, precisely an inconsistent guard.
    dist = {v: 0 for l, r, _ in edges for v in (l, r)}
    for _ in dist:
        changed = False
        for a, b, c in edges:
            if dist[b] > dist[a] + c:
                changed = True
                dist[b] = dist[a] + c
        if not changed:
            return True
    return False


def traced_guard(exe, path, budget):
    result = subprocess.run([exe, "-no_ml", "-no_sig", "-no_verif", "-full_annot",
                             "-iterations_timeout", str(budget), path], text=True, capture_output=True,
                            env=dict(os.environ, JCA_TRACE_INTERFACE="1", JCA_TRACE_LIVE_GUARD="1"), timeout=30)
    assert result.returncode == 2, result.stdout
    events = [(e, int(i)) for e, i in re.findall(r"^TRACE (enter|fail|update) (\d+)", result.stderr, re.M)]
    success = [(e, i) for i in range(3) for e in ("enter", "update")]
    failure = success[:2] + [("enter", 1), ("fail", 1)]
    expected = success[:2] * 2 if budget == 0 else (failure + (success[:4] if budget == 1 else success)) * 6
    assert events == expected and "TRACE cut" not in result.stderr, events
    guards = re.findall(r"^LIVE_GUARD (.*?) END_LIVE_GUARD", result.stderr, re.M | re.S)
    assert len(guards) == (6 if budget >= 2 else 0), guards
    for guard in guards:
        edges = difference_edges(" ".join(guard.split()))
        # Find the original package pair k ≤ o ≤ k+2, then check its projection.
        bands = [(k, o) for k, o, c in edges
                 if c == 2 and (o, k, 0) in edges and "zero" not in (k, o)]
        assert len(bands) == 1, bands
        k, o = bands[0]
        def at(key, value):
            return feasible(edges + [("zero", k, key), (k, "zero", -key),
                                     ("zero", o, value), (o, "zero", -value)])
        assert at(0, 0) and at(0, 1) and at(1, 1)
        assert not feasible(edges + [("zero", k, 2), (k, "zero", -2)])
        assert not feasible(edges + [("zero", k, -1)])
        assert not feasible(edges + [("zero", o, -1)])
        assert not feasible(edges + [(o, "zero", -2)])


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("invargent", type=Path)
    ap.add_argument("--before", type=Path, help="a3151c0 with default settings")
    ap.add_argument("--trace", type=Path, help="3ce4575 with review 22–24 and 26 trace patches")
    args = ap.parse_args()
    exe = args.invargent.resolve(strict=True)
    scaled, shifted, implicit, explicit = ((HERE / (n + ".gadt")).read_text() for n in
        ("scaled_coordinate", "translated_coordinate", "implicit_interval_parameter", "explicit_interval_parameter"))
    with TemporaryDirectory() as tmp:
        root = Path(tmp)
        def check(name, src, *, budget=4, error=None, expected=None, binary=exe, opts=()):
            sig = compile_and_run(root, binary, name, src, error=error,
                                  options=("-full_annot", "-iterations_timeout", str(budget), *opts))
            if expected:
                assert expected in " ".join(sig.split()), sig

        check("shifted", shifted, expected="State n → Nat → ∃.Num (n + 1)")
        for b in (4, 17, 997, 100003):
            source = (scaled.replace("-> 5 |", f"-> {b+1} |").replace("i≤4", f"i≤{b}")
                      .replace("<= 4);", f"<= {b});").replace("-> 4)", f"-> {b})"))
            check(f"scaled_{b}", source, expected=f"State n → Nat → ∃.Num ({b} n)")
            check(f"wrong_{b}", source.replace("= run B d", "= run A d"), error=ABDUCTION)
        rational = (scaled.replace("A : State 0", "A : State 2").replace("B : State 1", "B : State 5")
                    .replace("A -> 0", "A -> 1").replace("-> 4)", "-> 18)").replace("i≤4", "i≤18")
                    .replace("<= 4);", "<= 18);").replace("r <= 0 -> 5", "r <= 1 -> 19"))
        check("fraction", rational, expected="∃.Num ((17/3) n + (-31/3))")
        negative = (scaled.replace("A -> 0", "A -> 7").replace("-> 4)", "-> (-4))")
                    .replace("i≤4", "(-4)≤i").replace("r <= 4);", "r >= (-4));").replace("r <= 0 -> 5", "7 <= r -> (-5)"))
        check("signed", negative, expected="∃.Num (-11 n + 7)")
        triple = """datatype State : num
datacons A : State 0
datacons B : State 1
datacons C : State 2
external let check : ∀i. State i → Num (17 i) → Bool = "fun _ _ -> true"
let rec project = function A -> 0 | B -> 17 | C -> 34
test (let a = check A (project A) in let b = check B (project B) in check C (project C))
"""
        check("collinear", triple, expected="State n → Num (17 n)")
        check("off_line", triple.replace("C -> 34", "C -> 35"), error=ABDUCTION)
        check("implicit", implicit, budget=2, expected="Nat → ∃j[n ≤ j ∧ j ≤ n + 2].Num j")
        check("explicit", explicit, budget=2, expected="Num n → Nat → ∃j[n ≤ j ∧ j ≤ n + 2].Num j")
        check("shared_key", explicit.replace("= run B 2 d", "= run B 0 d"), error=ABDUCTION)
        wide = (explicit.replace("k+2", "k+97")
                .replace("run A (-1)", "run A (-96)").replace("run B 0 (S", "run B (-95) (S"))
        check("width_97", wide, expected="j ≤ n + 97")
        if args.before:
            old = args.before.resolve(strict=True)
            for n, src in (("scale", scaled), ("shift", shifted), ("fraction", rational)):
                check("prior_" + n, src, binary=old, budget=40, error=ABDUCTION)
        if args.trace:
            for budget in (0, 1, 2, 40, 10000):
                traced_guard(args.trace.resolve(strict=True), root / "implicit.gadt", budget)


if __name__ == "__main__":
    main()
