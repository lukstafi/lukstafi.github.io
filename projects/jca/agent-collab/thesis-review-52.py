"""Exact public preconditions for a term-pattern implication, and compiler replays."""
import argparse
from pathlib import Path
from random import Random
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
lib = runpy.run_path(str(HERE / "thesis-review-50.py"))
A, B, V, F, pair, variables, apply, once, matches, unify, probes = (
    lib[n] for n in ("A", "B", "V", "F", "pair", "variables", "apply", "once",
                     "matches", "unify", "probes"))


def fresh(pattern, label):
    names = {}
    def rename(term):
        if term[0] == "var":
            return names.setdefault(term[1], V((label, len(names))))
        return F(term[0], *(rename(child) for child in term[1:]))
    return rename(pattern)


def guards(reach, goal):
    """Return the input patterns L,G such that L implies G is the weakest guard."""
    if reach is None:
        return None, None
    _, inputs, local = fresh(reach, "reach")
    if goal is None:
        return inputs, None
    first, second = probes(local, variables(local) - variables(inputs))
    subst = unify([(pair(inputs, first), fresh(goal, 0)),
                   (pair(inputs, second), fresh(goal, 1))])
    return inputs, None if subst is None else apply(inputs, subst)


def member(pattern, ground):
    return pattern is not None and matches(pattern, ground) is not None


def missed(query, live, good):
    """Either the proposed scheme is safe, or return a ground counterexample."""
    if query is None or live is None:
        return None
    query = fresh(query, "query")
    subst = unify([(query, fresh(live, "live"))])
    if subst is None:
        return None
    common = apply(query, subst)
    if member(good, common):
        return None
    return next(row for row in probes(common, variables(common)) if not member(good, row))


def sequence(first, second):
    """Compose two pairs (list of public guards, positive input/output pattern)."""
    checks, h = first
    later, j = second
    if h is None:
        return list(checks), None
    h = fresh(h, "first")
    _, x, y = h
    pulled = list(checks)
    for live, good in later:
        if live is None:
            continue
        subst = unify([(y, fresh(live, "live"))])
        if subst is not None:
            target = None if good is None else pair(V("any input"), fresh(good, "good"))
            pulled.append(guards(apply(h, subst), target))
    if j is None:
        return pulled, None
    _, arg, result = fresh(j, "second")
    subst = unify([(y, arg)])
    return pulled, None if subst is None else apply(pair(x, result), subst)


def sequences():
    a, b = V("a"), V("b")
    # Preserve the input so the second call can inspect both original indices.
    first = [], pair(pair(a, b), pair(b, pair(a, a)))
    second = [(pair(a, pair(a, a)), None)], pair(pair(b, pair(a, a)), pair(a, b))
    third = [(pair(a, b), pair(a, A))], pair(pair(a, b), pair(a, a))
    left = sequence(sequence(first, second), third)
    right = sequence(first, sequence(second, third))
    ground = [A, B, F("S", A), F("S", B)]
    for restrictions, result in (left, right):
        assert len(restrictions) == 2
        for x in ground:
            for y in ground:
                row = pair(x, y)
                safe = all(not member(l, row) or member(g, row) for l, g in restrictions)
                assert safe == (x != y and y == A)
                for z in ground:
                    assert member(result, pair(row, pair(z, z))) == (z == x)
    print("Both associations of a three-call sequence preserve the two guards and the shared result.")


def check():
    rng = Random(520)
    h, j = V("h"), V("j")
    examples = [(pair(pair(h, h), A), None), (pair(h, j), pair(h, h)),
                (pair(pair(h, j), h), pair(pair(h, A), h)), (None, None)]
    def pat(depth):
        if depth and rng.randrange(3) == 0:
            return pair(pat(depth-1), pat(depth-1))
        return rng.choice([A, B, h, j])
    for _ in range(450):
        examples.append((pair(pat(2), pat(2)), pair(pat(2), pat(2))))
    ground = [A, B, F("S", A), pair(A, A), pair(B, B), pair(A, B), pair(B, A)]
    checked = counterexamples = 0
    for reach, target in examples:
        live, good = guards(reach, target)
        def direct(x):
            if reach is None:
                return True
            fixed = matches(reach[1], x)
            return fixed is None or member(target, pair(x, once(reach[2], fixed)))
        for x in ground:
            assert direct(x) == (not member(live, x) or member(good, x))
        for query in [None, h, pair(h, h), pair(h, F("S", h)), *ground, pat(2)]:
            witness = missed(query, live, good)
            if witness is None:
                assert all(direct(x) for x in ground if member(query, x))
            else:
                assert not variables(witness) and member(query, witness) and not direct(witness)
                counterexamples += 1
            checked += 1
    print(f"Checked {checked} proposed public patterns, including {counterexamples} ground counterexamples.")


def compile_source(exe, root, name, source, opts=("-full_annot", "-overwrite_ml"), ok=True):
    path = root / (name + ".gadt")
    path.write_text(source)
    cmd = subprocess.run([exe, *opts, path], capture_output=True, text=True)
    if ok:
        assert cmd.returncode == 0 and "exited with code 0" in cmd.stdout, cmd
        run = subprocess.run(["ocaml", "-noinit", path.with_suffix(".ml")], capture_output=True, text=True)
        assert run.returncode == 0, run
    else:
        assert cmd.returncode != 0 and "term abduction failed" in cmd.stdout + cmd.stderr, cmd
    return path


def compiler(exe):
    with TemporaryDirectory() as temp:
        root = Path(temp)
        source = (HERE / "compare_term_indices.gadt").read_text()
        compile_source(exe, root, "full", source)
        compile_source(exe, root, "default", source, ("-overwrite_ml",))
        core = source[:source.index("let distinct")]
        for gap in (1, 2, 4, 8):
            higher = "a"
            for _ in range(gap):
                higher = f"(Step {higher})"
            for first, second in (("a", higher), (higher, "a")):
                ann = f"∀a. Rep {first} → Rep {second} → Bool"
                compile_source(exe, root, "gap", core + f"let reject : {ann} = fun x y -> "
                               "match compare x y with Same -> assert false | Apart -> True")
        for fixed, greater in [("Base", "(Step a)"),
                               ("(Step (Step Base))", "(Step (Step (Step a)))")]:
            for first, second in [(fixed, greater), (greater, fixed)]:
                compile_source(exe, root, "cutoff", core +
                               f"let reject : ∀a. Rep {first} → Rep {second} → Bool = fun x y -> "
                               "match compare x y with Same -> assert false | Apart -> True")
        for domain in ("∀a. Rep a → Rep a", "∀a,b. Rep a → Rep b"):
            compile_source(exe, root, "invalid", core + f"let reject : {domain} → Bool = fun x y -> "
                           "match compare x y with Same -> assert false | Apart -> True", ok=False)

        decls = ("datatype Hidden\ndatacons Hide : ∀a. a ⟶ Hidden\ndatatype Wrap : type\n"
                 "datatype Nat\ndatacons Z : Nat\ndatacons S : Nat ⟶ Nat\n"
                 'external let same : ∀a. a → a → Bool = "fun a b -> a = b"\n')
        mix = ("let rec mix h g x y = efunction "
               "Z -> let Hide a = h in let Hide b = g in ((x,a),(y,(b,a))) "
               "| S n -> mix h g x y n\n")
        use = ("let ((x,a),(y,(b,c))) = mix (Hide Z) (Hide True) Z False (S Z) in ")
        product = compile_source(exe, root, "mix", decls + mix +
                                 "let checkpair = " + use + "(same x Z,same y False,same a c)")
        signature = " ".join(product.with_suffix(".gadti").read_text().split())
        scheme = signature.split("val mix : ")[1].split("val checkpair")[0].strip()
        assert scheme == "∀a, b. Hidden → Hidden → b → a → Nat → ∃c, r.((b, c), (a, (r, c)))"
        compile_source(exe, root, "private", decls + mix + "let bad = " + use + "same a b", ok=False)
        body = ("let rec closure h = efunction Z -> let Hide x = h in fun y -> same x y "
                "| S n -> closure h n\n")
        producer = compile_source(exe, root, "closure", decls + body)
        scheme = " ".join(producer.with_suffix(".gadti").read_text().split()).split("val closure : ")[1]
        expected = "'a -> bool"
        assert expected in producer.with_suffix(".ml").read_text().split("type ex1 =")[1].split("let rec")[0]
        inp = compile_source(exe, root, "imported", decls + f'external let read : {scheme} = "fun _ _ _ -> true"')
        assert expected in inp.with_suffix(".ml").read_text().split("type ex1 =")[1].split("let read")[0]
        nested = compile_source(exe, root, "nested", decls +
                                'external let wrap : Nat → Wrap (∃a.a) = "fun _ -> assert false"')
        printed = " ".join(nested.with_suffix(".gadti").read_text().split()).split("val wrap : ")[1]
        compile_source(exe, root, "nestedimport", decls + f'external let wrap : {printed} = "fun _ -> assert false"')
        print("Ran the total recursive comparison, checked eight offsets, four cutoffs and two rejections, tested two independent hidden types, and re-imported both signatures.")


def verification(exe):
    with TemporaryDirectory(prefix="term result ") as temp:
        root = Path(temp)
        p = root / "control.gadt"
        p.write_text('external let bad : Bool = "0"')
        target = root / "alternate.ml"
        call = [exe, "-ml_file", target, p]
        bad = subprocess.run(call, capture_output=True, text=True)
        assert bad.returncode != 0 and "Regenerated file" in bad.stdout, bad
        assert target.exists() and not p.with_suffix(".ml").exists()
        saved = target.read_text() + "\n(* existing file *)\n"
        target.write_text(saved)
        protected = subprocess.run(call, capture_output=True, text=True)
        assert protected.returncode != 0 and "Regenerated file" not in protected.stdout
        assert target.read_text() == saved and not p.with_suffix(".ml").exists()
        p.write_text((HERE / "observed_tag.gadt").read_text())
        recovered = subprocess.run([exe, "-overwrite_ml", *call[1:]], capture_output=True, text=True)
        assert recovered.returncode == 0 and f"Regenerated file {target}" in recovered.stdout, recovered
        assert not p.with_suffix(".ml").exists()
        subprocess.run(["ocaml", "-noinit", target], check=True, capture_output=True)
        print("Verified target paths with spaces, OCaml failure status, and preservation of existing output.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--compiler", type=Path)
    args = parser.parse_args()
    check()
    sequences()
    if args.compiler:
        compiler(args.compiler.resolve())
        verification(args.compiler.resolve())
