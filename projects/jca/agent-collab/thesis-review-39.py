"""Check universal recursive typings against quantified linear rational arithmetic."""
import argparse
from itertools import product
from pathlib import Path
import random
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent


def numeric_oracle(driver, problem=None):
    rng = random.Random(39)
    i,l,j,k,m,n = z3.Reals("i l j k m n")
    def make_formula(variables):
        def term():
            coefs = [rng.choice([-2,-1,0,0,0,1,2]) for _ in variables]
            c = rng.randint(-2,2)
            ds = [rng.choice([1,1,2,3]) for _ in variables] if trial >= 384 else [1]*len(variables)
            def coefficient(a,d):
                return str(a) if d==1 else f"{a}/{d}"
            terms = [f"{coefficient(a,d)} {x}" for a,d,x in zip(coefs,ds,variables) if a]
            return " + ".join(terms+[f"({c})"]),sum((z3.Q(a,d)*x for a,d,x in zip(coefs,ds,variables)),c)
        atoms,txt = [],[]
        for _ in range(rng.randrange(4)):
            (a,u),(b,v) = term(),term()
            op = rng.randrange(4)
            txt.append([f"{a}≤{b}",f"{a}={b}",f"min||max({a},{b})",f"min|max({a},{b})"][op])
            atoms.append([u<=v,u==v,z3.Or(u<=0,v<=0),
                          z3.And(u<=0,v<=0,z3.Or(u==0,v==0))][op])
        return (" ∧ ".join(txt) or "0=0",z3.And(*atoms))

    inputs,expected = [],[]
    for trial in range(768):
        pre = make_formula([i,l])
        domains = [make_formula([i,j,k]) for _ in range(rng.randrange(4))]
        post = make_formula([i,l,j,k]+[m,n][:trial%3])
        if trial % 4 == 0:
            post = post[0]+" ∧ 2 m=k+l ∧ n=j", z3.And(post[1],2*m==k+l,n==j)
        inputs.append("\t".join([pre[0],post[0],*(a for a,_ in domains)]))
        s = z3.Solver()
        s.add(pre[1],z3.ForAll([j,k],z3.Implies(z3.Or(*(a for _,a in domains)),z3.Exists([m,n],post[1]))))
        result = s.check()
        assert result != z3.unknown,(s,s.reason_unknown())
        expected.append(str(result))

    # Bounds around zero, empty fibres, and independently chosen package witnesses.
    for pre,post,domains,want in [
        ("i=0","k≤0",["0≤k ∧ k≤i"],"sat"),
        ("2 i=1","k≤0",["0≤k ∧ k≤i"],"unsat"),
        ("0≤i ∧ i≤1","k≤0",["0≤k ∧ k≤i","i=0 ∧ k=2"],"unsat"),
        ("0≤i ∧ i≤1","k≤0",["0≤k ∧ k≤i"],"sat"),
        ("0=0","2 m=k ∧ n=m+j",["0=0"],"sat"),
        ("l=1","min(k+l + -1,1 + -k)≤0",["0≤k ∧ k≤1"],"unsat"),
        ("l=0","min(k+l + -1,1 + -k)≤0",["0≤k ∧ k≤1"],"sat"),
        ("0=0","1=0",[],"sat"),
        ("0=0","0≤m ∧ m≤1 ∧ min(m,1 + -m)≤0 ∧ 2 m=k",["0≤k ∧ k≤2"],"unsat"),
        ("0=0","0≤m ∧ m≤1 ∧ min(m,1 + -m)≤0 ∧ 2 m=k",["k=0","k=2"],"sat"),
        ("0=0","min(j + -k,k + -j)≤0",["0=0"],"sat"),
        ("l=1","j=k",["j=k","2 j=1 ∧ k=l"],"unsat"),
    ]:
        inputs.append("\t".join([pre,post,*domains]));expected.append(want)
    if problem is not None:
        if not 1 <= problem <= len(inputs):
            raise ValueError(f"problem must be in 1..{len(inputs)}")
        inputs, expected = [inputs[problem-1]], [expected[problem-1]]
        print(inputs[0])
    run = subprocess.run([driver],input="\n".join(inputs)+"\n",text=True,capture_output=True,check=True)
    if problem is not None and run.stderr:
        print(run.stderr.rstrip())
    results = run.stdout.splitlines()
    assert len(results) == len(expected)
    for src,a,b in zip(inputs,expected,results):
        assert a == b,(src,a,b)
    if problem is None:
        print(f"All {len(results)} quantified problems agreed ({results.count('sat')} satisfiable).")
    else:
        print(f"Problem {problem} agreed: {results[0]}.")


def public_contract(signature, name):
    prior = runpy.run_path(str(HERE/"thesis-review-36.py"))
    arrow = " ".join(signature.split()).split("val run : ")[1]
    quant,pre,args,payload,post,result = re.fullmatch(
        r"∀([\w, ]+)\[(.*?)\]\. ((?:Num \w+ → )+)Nat → ∃(\w+)\[(.*?)\]\.\s*Num (\w+)",arrow).groups()
    assert payload == result
    # The package binder may shadow an outer offset in the printed signature.
    post = re.sub(r"\b"+re.escape(payload)+r"\b","payload",post)
    arguments = re.findall(r"Num (\w+)",args)
    other = set(quant.split(", ")) - set(arguments)
    for sort in (z3.Int,z3.Real):
        def read(atoms):
            return z3.And(*prior["read_atoms"](atoms.split(" ∧ "),z3,sort))
        f,n = map(sort,arguments[:2]);r=sort("payload")
        offsets = arguments[2:]
        graphs = dict(re.findall(r"(\w+)=max\s*\(([^)]+)\)",pre))
        assert len(graphs) == len(offsets)
        key, = other - graphs.keys()
        k = sort(key)
        measured = 2*k if name=="scaled" else k
        domain = z3.And(0<=f,f<=1,2<=n,0<=k,measured<=n,z3.Or(k<=0,1<=f))
        postcondition = z3.And(0<=r,r<=f,z3.Or(measured+r<=n,n+2<=measured+r))
        for offset in offsets:
            hinge, = [h for h,terms in graphs.items() if offset in re.findall(r"\w+",terms)]
            h,s = sort(hinge),sort(offset)
            domain = z3.And(domain,-2*n<=s,s<=0,h==z3.If(0<=s+k,s+k,0))
            postcondition = z3.And(postcondition,r<=h+2)
        if name=="double":
            domain = z3.And(domain, f==1)
        if name=="tied":
            postcondition = z3.And(postcondition,r<=k+2)
        prior["equivalent"](read(pre),domain)
        prior["equivalent"](z3.And(domain,read(post)),z3.And(domain,postcondition))


def check_hinge_cover():
    width = z3.Real("width")
    for dimension in range(1,5):
        offsets = [z3.Real(f"offset_{i}") for i in range(dimension)]
        solver = z3.Solver()
        solver.add(width>=2, *(z3.And(-2*width<=s,s<=0) for s in offsets))
        for hot in product((False,True),repeat=dimension):
            proposal = [width+s if active else 0 for active,s in zip(hot,offsets)]
            admitted = z3.And(*(j == z3.If(width+s>=0,width+s,0)
                                for j,s in zip(proposal,offsets)))
            solver.add(z3.Not(admitted))
        assert solver.check() == z3.unsat, dimension


def check_compiler_hinges(driver):
    for dimension in range(1,5):
        keys = ["k"]+[f"j{a}" for a in range(dimension)]
        offsets = [f"m{a}" for a in range(dimension)]
        input_domain = " ∧ ".join(["2≤n"] + [f"0≤{s}+2 n ∧ {s}≤0" for s in offsets])
        admission = " ∧ ".join(["0≤k","k≤n"] +
                               [f"{j}=max(0,k+{s})" for j,s in zip(keys[1:],offsets)])
        package = " ∧ ".join(["min(k+l + -n,n+2 + -k + -l)≤0"] +
                             [f"l≤{j}+2" for j in keys[1:]])
        problems = ["\t".join([f"l={result} ∧ "+input_domain,package,admission])
                    for result in (0,1)]
        run = subprocess.run([driver,"--keys",",".join(keys),"--witnesses",""],
                             input="\n".join(problems)+"\n",text=True,capture_output=True,check=True)
        assert run.stdout.splitlines() == ["sat","unsat"],(dimension,run.stdout)
    print("The compiler retained zero and excluded one in dimensions one through four.")


def run_offset_grid(generated):
    # The OCaml caller is separate so its constraints do not guide inference.
    ml = generated.read_text()
    package = re.search(r"let (Ex\d+) prior = run", ml)[1]
    grid = """
let () =
  for s = -10 to 0 do
    for t = -10 to 0 do
      let PACKAGE v = run 1 5 s t (S (S Z)) in
      assert (v = 0)
    done
  done
"""
    client = generated.with_name("grid.ml")
    client.write_text(ml + grid.replace("PACKAGE", package))
    subprocess.run(["ocaml",client],check=True)


def check_double_hinge(compiler):
    with TemporaryDirectory() as temp:
        src = Path(temp)/"double.gadt"
        src.write_text((HERE/"double_hinged_result_keys.gadt").read_text())
        subprocess.run([compiler,"-iterations_timeout","2","-no_verif","-full_annot",src],
                       check=True,capture_output=True,text=True)
        public_contract(src.with_suffix(".gadti").read_text(),"double")
        run_offset_grid(src.with_suffix(".ml"))
    print("Verified the two-offset definition and all 121 native executions at width five.")


def interior_source(exact):
    raw = (HERE/"switched_result_band.gadt").read_text()
    src = raw.replace("n+2 + -k + -l","n + -k")
    return src.replace("∃l[","∃l[l=0 ∧ ") if exact else src


def program_checks(compiler, before, trace, input_mutant, witness_mutant, check_interior):
    compile_and_run = runpy.run_path(str(HERE/"thesis-review-13.py"))["compile_and_run"]
    def source(name):
        return (HERE/(name+".gadt")).read_text()
    fixed = source("fixed_result_input")
    private = fixed.replace("∀i[","∀i,k[0≤k ∧ k≤1 ∧ ").replace("∃l[l=i]","∃l,m[l=i ∧ l=m+k]")
    cases = {"tied":source("tied_result_keys"),"scaled":source("scaled_result_key"),
             "hinged":source("hinged_result_keys"),"fixed":fixed,"private":private,
             "fractional":source("fractional_guard_result")}
    with TemporaryDirectory() as temp:
        out = Path(temp)
        def run(exe,name,src,amount=2,**kw):
            return compile_and_run(out,exe,name,src,options=("-iterations_timeout",str(amount),"-full_annot"),**kw)
        def check_output(name, expected):
            replay = subprocess.run(["ocaml",out/(name+".ml")],text=True,capture_output=True,check=True)
            assert replay.stdout == expected,(name,replay.stdout)

        check_hinge_cover()
        for name,src in cases.items():
            if name in ("tied","scaled","hinged"):
                public_contract(run(compiler,name,src),name)
                check_output(name, "0\n" * (4 if name=="hinged" else 2))
            else:
                run(compiler,name,src,error="Type mismatch")
        run(compiler,"fractional_live",cases["fractional"].replace("-> True","-> 0"))
        check_output("fractional_live", "0\n")
        if check_interior:
            run(compiler,"interior_exact",interior_source(True))
            check_output("interior_exact", "0\n0\n")
            run(compiler,"interior",interior_source(False),error="Type mismatch")
        if before:
            for name in ("tied","scaled"):
                run(before,"old_"+name,cases[name],10000,error="Type mismatch")
        if trace:
            for name in cases:
                run_trace = subprocess.run([trace,"-iterations_timeout","2","-no_verif","-no_ml",
                                            "-no_sig",out/(name+".gadt")],capture_output=True,text=True)
                report = run_trace.stdout+run_trace.stderr
                accepted = name in ("tied","scaled","hinged")
                assert (run_trace.returncode==0)==accepted
                assert re.search(r"^TUPLE \d+ "+str(accepted).lower()+"$",report,re.M),(name,report)
                assert max(map(int,re.findall(r"^TRACE enter (\d+)",report,re.M)))<=2
            if check_interior:
                failed = subprocess.run([trace,"-iterations_timeout","2","-no_verif","-no_ml",
                                         "-no_sig",out/"interior.gadt"],capture_output=True,text=True)
                report = failed.stdout+failed.stderr
                assert failed.returncode and "Type mismatch" in report
                assert "TRACE fail 1" in report and "TUPLE " not in report
        for exe,name,src in ((input_mutant,"wrong_input",fixed),(witness_mutant,"shared_witness",private)):
            if exe:
                run(exe,name,src,runtime_error=True)
                ocaml = subprocess.run(["ocaml",out/(name+".ml")],text=True,capture_output=True)
                where = re.search(r'\.ml",\s*(\d+),',ocaml.stderr)
                assert where and "-> assert false" in (out/(name+".ml")).read_text().splitlines()[int(where[1])-1]
    print("Verified the public schemes, runtime outputs, and reachable-guard controls.")


if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("compiler",nargs="?",type=Path)
    p.add_argument("--numeric-driver",type=Path)
    p.add_argument("--problem",type=int,help="show and check one numbered arithmetic problem")
    p.add_argument("--before",type=Path,help="revision e3b1348")
    p.add_argument("--trace",type=Path,help="compiler with the TUPLE and review 22 diagnostics")
    p.add_argument("--input-mutant",type=Path,help="quantify input slots too, omitting same_inputs")
    p.add_argument("--witness-mutant",type=Path,help="omit projection of package witnesses")
    p.add_argument("--double-hinge",action="store_true",help="also compile the two-offset definition and run its native grid")
    p.add_argument("--interior",action="store_true",help="also check the supplier-abduction controls")
    args = p.parse_args()
    if not (args.compiler or args.numeric_driver):
        p.error("supply a compiler or numeric driver")
    if args.double_hinge and not args.compiler:
        p.error("--double-hinge requires a compiler")
    if args.problem is not None and not args.numeric_driver:
        p.error("--problem requires --numeric-driver")
    if args.numeric_driver:
        driver = args.numeric_driver.resolve(strict=True)
        numeric_oracle(driver,args.problem)
        if args.problem is None:
            check_compiler_hinges(driver)
    if args.compiler:
        program_checks(*(path.resolve(strict=True) if path else None for path in
                         (args.compiler,args.before,args.trace,args.input_mutant,args.witness_mutant)), args.interior)
        if args.double_hinge:
            check_double_hinge(args.compiler.resolve(strict=True))
