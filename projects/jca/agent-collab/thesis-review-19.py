"""Reconstruct signed affine tags in either field and execute their clients."""
import argparse
from pathlib import Path
import runpy
import tempfile

HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]
RECOVERED = "(tag+(-1*j)+(-1*e))"


def tagged(source, k, offset, swapped):
    def tag(v):
        terms = [v]
        if k:
            terms.append(f"({k}*j)")
        if offset:
            terms.append(f"({offset})")
        return "+".join(terms)

    def pair(v):
        return f"({tag(v)}, {v})" if swapped else f"({v}, {tag(v)})"

    recover = ["tag"]
    if k:
        recover.extend((f"({-k}*j)", f"({-k}*e)"))
    if offset:
        recover.append(f"({-offset})")
    assert source.count("(j, j+j)") == 2 and source.count(RECOVERED) == 1
    return (source.replace("(j, j+j)", pair("j")).replace("(u, u+j)", pair("u"))
            .replace("(r, tag)", "(tag, r)" if swapped else "(r, tag)")
            .replace(RECOVERED, "(" + "+".join(recover) + ")"))


def client(k, offset, swapped):
    eq = "k=j" + (f"+ {k} i" if k else "") + (f"+ {offset}" if offset else "")
    fields = "(Num k, Num j)" if swapped else "(Num j, Num k)"
    pattern = "(tag,r)" if swapped else "(r,tag)"
    return (f'\nexternal let graph : ∀i,j,k[{eq}]. Num i → {fields} → Bool =\n'
            f'  "fun p {pattern} -> assert (tag = r + ({k}) * p + ({offset})); true"\n'
            'let observed = let xy = climb 1 1 3 (-16) (S (S Z)) in graph 3 xy\n')


TRIPLE = """datatype Switch
datacons A : Switch
datacons B : Switch
external let same : ∀n. (Num n, Num n, Num n) → Bool =
  "fun (x,y,z) -> assert (x=y && y=z); true"
let triple = efunction A -> (0,0,0) | B -> (1,1,1)
let at_a = let xyz = triple A in same xyz
let at_b = let xyz = triple B in same xyz
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    source = (HERE / "tagged_floor.gadt").read_text()
    with tempfile.TemporaryDirectory() as tmp:
        def check(name, program, budget=9, error=None):
            return compile_and_run(Path(tmp), exe, name, program, error=error,
                                   options=("-iterations_timeout", str(budget), "-full_annot"))

        check("before_stopping_pass", source, 8, "Answers do not converge")
        assert check("recovered", source) == check("direct", source.replace(RECOVERED, "r"))
        for k, offset in ((-7, 4), (-2, 0), (-1, 0), (0, 0), (0, -3), (1, 0), (2, -3), (7, 4)):
            for swapped in (False, True):
                program = tagged(source, k, offset, swapped) + client(k, offset, swapped)
                check(f"tag_{k}_{offset}_{'first' if swapped else 'last'}", program)
        check("wrong_tag", source + client(1, 1, False), error="numerical abduction failed")
        sig = check("triple", TRIPLE)
        assert "∃n[0 ≤ n ∧ n ≤ 1].(Num n, Num n, Num n)" in " ".join(sig.split())
        check("unequal_triple", TRIPLE.replace("(1,1,1)", "(1,1,2)"),
              error="numerical abduction failed")


if __name__ == "__main__":
    main()
