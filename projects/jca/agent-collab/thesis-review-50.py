"""Eliminate admitted term keys by two symbolic probes and ordinary unification."""
import argparse
from pathlib import Path
from random import Random
import runpy
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
lib = runpy.run_path(str(HERE/"round-10-experiments.py"))
V, F, variables, once, matches, apply, unify, lgg = (
    lib[name] for name in ("V","F","variables","once","matches","apply","unify","lgg"))
A, B = F("A"), F("B")


def pair(x,y):
    return F("Pair",x,y)


def probes(key, private):
    left, right = {}, {}
    tag = A
    for hole in sorted(private):
        tag = F("S",tag)
        left[hole], right[hole] = A, tag
    return once(key,left), once(key,right)


def opening(inputs, key, package):
    """The admitted relation on (inputs,result); None represents the empty relation."""
    r = V(("result",))
    first, second = probes(key, variables(key)-variables(inputs))
    def copy(n):
        return once(package, {x:V(("local",n,x)) for x in variables(package)})
    solution = unify([(pair(first,r),copy(0)), (pair(second,r),copy(1))])
    return apply(pair(inputs,r),solution) if solution is not None else None


def checks():
    rng = Random(501)
    ground = [A,B,F("S",A),F("S",B),pair(A,B),pair(A,A),pair(B,B)]
    def inst(p):
        return once(p,{v:rng.choice(ground) for v in sorted(variables(p))})
    def pattern(names,depth):
        if depth and rng.randrange(3) == 0:
            return pair(pattern(names,depth-1), pattern(names,depth-1))
        return rng.choice([A,B,*map(V,names)])
    examples = [
        (V("x"),pair(V("x"),V("u")),pair(pair(V("c"),V("d")),pair(V("c"),V("w")))),
        (V("x"),pair(V("x"),V("u")),pair(pair(V("c"),V("d")),V("d"))),
        (pair(A,V("x")),V("x"),pair(V("v"),V("v"))),
    ]
    for _ in range(500):
        inputs, key = (pattern("xyz",2) for _ in range(2))
        s,t = (pattern("pqr",2) for _ in range(2))
        examples.append((inputs,key,pair(s,t)))
    queries = positives = 0
    for inputs,key,package in examples:
        opened = opening(inputs,key,package)
        for x in [inst(inputs) for _ in range(4)]+ground:
            fixed = matches(inputs,x)
            if fixed is not None:
                fiber = once(key,fixed)
                k0,k1 = probes(fiber,variables(fiber))
                (gen,) = lgg([(k0,),(k1,)])
                assert matches(gen,fiber) is not None and matches(fiber,gen) is not None
            for r in [inst(package[2]) for _ in range(2)]+ground:
                actual = opened is not None and matches(opened,pair(x,r)) is not None
                # One-sided matching treats the target's remaining holes as rigid.
                direct = fixed is not None and matches(package,pair(fiber,r)) is not None
                assert actual == direct, (inputs,key,package,x,r)
                positives += actual
                queries += 1
    assert 0 < positives < queries
    print(f"{len(examples)} projected openings, {queries} tests against rigid matching, {positives} accepted.")


def programs(compiler):
    source = (HERE/"packed_payload.gadt").read_text()
    branches = source[:source.index("datatype Nat")] + "let payload = function Left y -> y | Right x -> x\n"
    with TemporaryDirectory() as temp:
        def run(name, text, rejects=False):
            p = Path(temp)/(name+".gadt")
            p.write_text(text)
            r = subprocess.run([compiler,"-full_annot","-overwrite_ml",p],text=True,capture_output=True)
            if rejects:
                assert r.returncode and "Type mismatch" in r.stdout+r.stderr, r
                return
            assert r.returncode == 0,r
            subprocess.run(["ocaml",p.with_suffix(".ml")],text=True,capture_output=True,check=True)
            return " ".join(p.with_suffix(".gadti").read_text().split())
        hidden = ("datatype Hidden\ndatacons Hide : ∀a. a ⟶ Hidden\n"
                  "let duplicate = efunction Hide x -> (x,x)\n")
        assert "val duplicate : Hidden → ∃a.(a, a)" in run("hidden",hidden)
        assert "Tag (Marker, a) → Nat → ∃.(a, a)" in run("packed",source)
        assert "val payload : ∀a. Tag (a, a) → a" in run("payload",branches)
        run("separate_left",branches+"let bad = payload (Left Box)\n",True)
        for ctor,domain in [("Left","Marker,a"),("Right","a,Marker")]:
            annotated = branches.replace("let payload =",f"let payload : ∀a. Tag ({domain}) → a =")
            run("annotated"+ctor,annotated+f"let seen = payload ({ctor} Box)\n")
    print("Captured and hidden pair types, the inferred diagonal, and both written axis types checked.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--compiler",type=Path)
    args=parser.parse_args()
    checks()
    if args.compiler:
        programs(args.compiler.resolve())
