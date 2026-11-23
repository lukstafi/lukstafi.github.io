"""Generate proof constructors from the search and check the resulting interfaces."""
import argparse
import os
import re
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent


def generate(table):
    lean = ["inductive Evidence : State → Tree → Type where"]
    gadt = ["datatype Evidence : type * type"]
    for row in table.splitlines():
        symbol, *inputs, output = row.split()
        if output == "many":
            continue  # Absorbing failure. many_absorbs justifies dropping it.
        name = symbol + "".join(q.title() for q in inputs or [output])
        if symbol == "fork":
            left, right = inputs
            lean_type = (f"Evidence .{left} l → Evidence .{right} r → "
                         f"Evidence .{output} (.fork l r)")
            gadt_type = (f"∀a,b. Evidence ({left.title()},a) * Evidence ({right.title()},b) "
                         f"⟶ Evidence ({output.title()},Fork (a,b))")
        else:
            lean_type = f"Evidence .{output} .{symbol}"
            gadt_type = f"Evidence ({output.title()},{symbol.title()})"
        lean.append(f"  | {name} : {lean_type}")
        gadt.append(f"datacons {name[0].upper() + name[1:]} : {gadt_type}")
    return lean, gadt


def generated_section(file, lines, begin, end, write):
    source = file.read_text()
    before, rest = source.split(begin + "\n")
    _, after = rest.split("\n" + end)
    expected = before + begin + "\n" + "\n".join(lines) + "\n" + end + after
    if source != expected:
        if not write:
            raise ValueError(f"{file.name} has stale generated rows. Run with --write.")
        file.write_text(expected)


def check_compiler(compiler, directory):
    source = (HERE / "unique.gadt").read_text()
    path = directory / "unique.gadt"

    def compile_with(client):
        path.write_text(source + client)
        return subprocess.run([compiler, "-full_annot", "-overwrite_ml", path],
                              cwd=directory, capture_output=True, text=True)

    run = compile_with("")
    if run.returncode or "exited with code 0" not in run.stdout:
        raise RuntimeError(run.stdout + run.stderr)
    signature = path.with_suffix(".gadti").read_text()
    scheme = next(line for line in signature.splitlines() if line.startswith("val choose :"))
    if not re.fullmatch(r"valchoose:Bool→∃(\w+)\.\(Tree\1,Evidence\(One,\1\)\)", "".join(scheme.split())):
        raise ValueError(f"Expected one shared existential tree index, got {scheme}")
    print(scheme)
    subprocess.run(["ocaml", "-noinit", path.with_suffix(".ml")], cwd=directory, check=True)
    for label, client in [
        ("swapped leaves", "locate (ForkOneZero (MarkOne,ClearZero)) (Node (Blank,Star))"),
        ("two marks", "locate (ForkOneZero (MarkOne,MarkOne)) (Node (Star,Star))"),
        ("unrelated package", "let (_,p) = choose True in let (t,_) = choose False in locate p t"),
    ]:
        run = compile_with("let bad = " + client + "\n")
        diagnostics = run.stdout + run.stderr
        if run.returncode == 0 or not any(reason in diagnostics for reason in
                ("Type mismatch", "Constructor mismatch", "term abduction failed")):
            raise RuntimeError(f"Expected a type rejection for {label}.\n{diagnostics}")
        print(f"Rejected {label}.")
    print("Certified root and nested path checks passed.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lean", default="lean", help="Lean 4 executable")
    parser.add_argument("--compiler", help="also check unique.gadt with InvarGenT and OCaml")
    parser.add_argument("--write", action="store_true", help="refresh the two generated sections")
    args = parser.parse_args()
    with TemporaryDirectory() as temp:
        work = Path(temp)
        subprocess.run([args.lean, "-o", work / "Search.olean", "Search.lean"],
                       check=True, cwd=HERE)
        table = subprocess.check_output([args.lean, "--run", "Search.lean"], text=True, cwd=HERE)
        lean, gadt = generate(table)
        generated_section(HERE / "Unique.lean", lean, "-- BEGIN generated rows",
                          "-- END generated rows", args.write)
        generated_section(HERE / "unique.gadt", gadt, "(* BEGIN generated rows *)",
                          "(* END generated rows *)", args.write)
        env = os.environ.copy()
        env["LEAN_PATH"] = str(work) + os.pathsep + env.get("LEAN_PATH", "")
        subprocess.run([args.lean, "Unique.lean"], check=True, cwd=HERE, env=env)
        print(f"Checked {len(gadt)-1} generated constructors and the Lean equivalence.")
        if args.compiler:
            check_compiler(Path(args.compiler).resolve(), work)


if __name__ == "__main__":
    main()
