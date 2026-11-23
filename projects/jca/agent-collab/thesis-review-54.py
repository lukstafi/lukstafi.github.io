"""Replay arithmetic abduction through InvarGenT and run each accepted OCaml file."""
import argparse
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
SOURCE = (HERE / "joint_affine_abduction.gadt").read_text()
AXIS, rest = SOURCE.split("datatype Bounds")
BOX = "datatype Bounds" + rest.split("external let verify")[0]
VERIFY = "external let verify" + rest.split("external let verify")[1].split("let axes")[0]


def run(compiler, source, *, accept=True, options=()):
    with TemporaryDirectory() as temp:
        path = Path(temp) / "example.gadt"
        path.write_text(source)
        c = subprocess.run([compiler, *options, "-full_annot", path],
                           capture_output=True, text=True)
        if accept:
            assert c.returncode == 0 and "exited with code 0" in c.stdout, c
            subprocess.run(["ocaml", "-noinit", path.with_suffix(".ml")],
                           capture_output=True, check=True)
            return path.with_suffix(".gadti").read_text()
        assert c.returncode != 0 and any(message in c.stdout + c.stderr for message in
               ("Contradiction in ", "No answer", "abduction failed")), c


def grid(slopes):
    names = ["Origin", "East", "North", "Top", "Back"][:1+len(slopes)]
    lines = ["datatype Grid : " + " * ".join("num" for _ in slopes)]
    for i, name in enumerate(names):
        indices = ",".join(str(int(i == j+1)) for j in range(len(slopes)))
        lines.append(f"datacons {name} : Grid ({indices})")
    values = list(zip(names, [0, *slopes]))
    lines.append("let f = function " + " | ".join(f"{k} -> {v}" for k, v in values))
    lines.append(VERIFY)
    calls = ", ".join(f"verify (f {k}) {v}" for k, v in values)
    lines.append(f"let samples = ({calls})")
    return "\n".join(lines)


def box(arity):
    public = [f"i{k}" for k in range(arity)]
    hidden = [f"j{k}" for k in range(arity)]
    args = [f"x{k}" for k in range(arity)]
    bounded = "Bounds (" + ",".join(public) + ")"
    premise = " ∧ ".join(f"{h}≤{i}" for h, i in zip(hidden, public))
    within = "external let within" + BOX.split("external let within")[1].split("let check")[0]
    return "\n".join([
        "datatype Bounds : " + " * ".join(["num"] * arity),
        f"datacons Bounded : ∀{','.join(public + hidden)}[{premise}]. " +
        " * ".join(f"Num {h}" for h in hidden) + f" ⟶ {bounded}",
        within,
        f"let check = function Bounded ({','.join(args)}) -> fun cap -> within ({'+'.join(args)}) cap",
        f"let exported : ∀{','.join(public + ['n'])}[{'+'.join(public)}≤n]. {bounded} → Num n → Bool = check",
    ])


def check(compiler, before):
    run(compiler, SOURCE)
    run(compiler, SOURCE + "\nlet bad = verify (value East) 8\n", accept=False)
    run(compiler, SOURCE + "\nlet bad = check (Bounded (3,4)) 6\n", accept=False)
    run(compiler, SOURCE + "\nlet bad = check_two (Two (4,4)) 5\n", accept=False)
    run(compiler, BOX.replace("k≤i ∧ l≤j", "k≤i"), accept=False)
    if before:
        for source, name, annotation in [
            (AXIS, "value", "∀i,j. Axis (i,j) → Num (7 i + 11 j)"),
            (BOX, "check", "∀i,j,k[i+j≤k]. Bounds (i,j) → Num k → Bool"),
        ]:
            run(before, source, accept=False)
            run(before, source.replace(f"let {name} =", f"let {name} : {annotation} ="))
    for slopes in [[37, -23], [7, 11, 13], [7, 11, 13, 17]]:
        run(compiler, grid(slopes), options=("-num_abduction_rotations", "1"))
    for arity in [3, 4, 6]:
        run(compiler, box(arity))
    for premise, expression, guard in [
        ("k+l≤i ∧ k + -1 l≤j", "3*x+y", "2 i+j≤n"),
        ("k≤i ∧ j≤l", "7*x + -11*y", "7 i≤11 j+n"),
    ]:
        source = BOX.replace("k≤i ∧ l≤j", premise).replace("(x+y)", f"({expression})")
        run(compiler, source + f"let exported : ∀i,j,n[{guard}]. Bounds (i,j) → Num n → Bool = check\n")
    # Before successful declarations were reconsidered, this scheme used just one bound.
    single = BOX.replace("k,l[k≤i ∧ l≤j]. Num k * Num l", "k[k≤i ∧ k≤j]. Num k")
    single = single.replace("Bounded (x,y)", "Bounded x").replace("(x+y)", "x")
    clients = ('external let left : Bounds (0,6) = "Bounded 0"\n'
               'external let right : Bounds (8,2) = "Bounded 2"\n'
               'let uses = (check left 0, check right 2)\n')
    exact = "let check : ∀i,j,n[min(i,j)≤n]. Bounds (i,j) → Num n → Bool ="
    run(compiler, single.replace("let check =", exact) + clients)
    inferred = " ".join(run(compiler, single).split("val check :")[1].split())
    run(compiler, single + clients, accept="min (" in inferred)
    print("Single-payload example, inferred scheme:", inferred)
    print("Arithmetic abduction examples and rejection controls passed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", type=Path, required=True)
    parser.add_argument("--before", type=Path)
    args = parser.parse_args()
    check(args.compiler.resolve(), args.before.resolve() if args.before else None)
