"""Check witness equations, rate sharing and the exported scaled result bound."""
import argparse
from pathlib import Path
import runpy
import subprocess
import tempfile


HERE = Path(__file__).resolve().parent
compile_and_run = runpy.run_path(str(HERE / "thesis-review-13.py"))["compile_and_run"]
CLIENTS = ("test (let r = climb (-3) 4 0 0 (S (S (S (S Z)))) in "
           "let s = climb (-4) 6 (-4) (-6) (S Z) in True)\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("invargent", type=Path)
    parser.add_argument("--before-equations", type=Path, help="executable from 752520c")
    args = parser.parse_args()
    exe = args.invargent.resolve(strict=True)
    written = (HERE / "crossing_caps_annotated.gadt").read_text()
    weighted = (HERE / "sum_key.gadt").read_text()
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp)
        def check(name, program, **kwargs):
            return compile_and_run(out, exe, name, program, **kwargs)
        check("written", written)
        check("double_rate", (HERE / "double_rate_supplier.gadt").read_text())
        if args.before_equations:
            compile_and_run(out, args.before_equations.resolve(strict=True), "old_written", written,
                            error="numerical abduction failed")
        two = written.split("test (")[0] + CLIENTS
        check("two_clients", two)
        erased = two.replace("n≤max(j,-k+m+20)", "n≤max(j,m+16)")
        assert erased != two
        check("erased_rate", erased, error="numerical abduction failed")
        # Feed the value from one mode to the other one's actual primitive.
        # The checked calls above each use their own child value.
        ml = out / "two_clients.ml"
        with ml.open("a") as stream:
            stream.write("""
let () =
  let Ex1 r = climb (-3) 4 0 0 (S (S (S (S Z)))) in
  assert (r = 16);
  assert (try ignore (step (-4) (-4) (-6) r); false
          with Assert_failure _ -> true)
""")
        subprocess.run(["ocaml", str(ml)], check=True, timeout=30)

        pick = ("let pick : ∀i,j. Num i → Num j → ∃n[3 n≤max(3 i,3 j)].Num n = "
                "fun x -> efunction y -> x\n")
        def read_pick(binary, name, *, old):
            signature = compile_and_run(out, binary, name, pick).split("val pick :", 1)[1].strip()
            client = (f'external let pick : {signature} = "fun x _ -> x"\n'
                      'external let below : ∀i[i≤-3]. Num i → Bool = '
                      '"fun x -> assert (x <= -3); true"\n'
                      'let claimed = let r = pick (-1) (-1) in below r\n')
            compile_and_run(out, binary, name + "_client", client,
                            error=None if old else "numerical abduction failed", runtime_error=old)
        read_pick(exe, "exported", old=False)
        if args.before_equations:
            read_pick(args.before_equations.resolve(strict=True), "old_exported", old=True)

        sig = check("sum_key", weighted)
        header, body = weighted.split("let rec climb :", 1)
        inferred = header + "let rec climb z d j m = efunction\n" + body.split(" -> efunction\n", 1)[1]
        check("inferred_sum", inferred)
        scheme = sig.split("val climb :", 1)[1].strip()
        # Read the exported signature back as a primitive declaration.
        # At p=m=-100 the base case returns -100. The old printed type
        # allowed the client to claim it was at most -252.
        external = f'external let climb : {scheme} = "fun _ _ p _ _ -> p"\n'
        client = ('external let at_most : ∀j,k[k≤j]. Num j → Num k → Bool = '
                  '"fun x y -> assert (y <= x); true"\n'
                  'let value = let r = climb 7 4 (-100) (-100) Z in at_most (-84) r\n')
        nat = weighted.split("datatype StepResult")[0]
        check("reread_sum", nat + external + client)
        check("false_printed_bound", nat + external + client.replace("(-84) r", "(-252) r"),
              error="numerical abduction failed")


if __name__ == "__main__":
    main()
