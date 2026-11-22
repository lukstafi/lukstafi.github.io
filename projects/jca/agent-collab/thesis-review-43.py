"""Replay the simultaneous producer update and the all-keys guard checks."""
import argparse
from fractions import Fraction
from pathlib import Path
import re
import runpy
import subprocess
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent


def legal(x):
    return z3.And(0 <= x, x <= 1)


def admits(x, k):
    return z3.And(legal(k), z3.Or(x+k <= 1, z3.And(x == 1, k == 1)))


def cap(k, r):
    return z3.And(r <= 1, z3.Or(k+r <= 1, k == 1))


def points(n):
    return [1] + [1-2**j for j in range(n+1)]


def finite(n, k, r):
    c = 2**n-1
    return z3.And(legal(k), z3.Or(z3.And(-c*(1-k) <= r, r <= 1-k),
                                  z3.And(k == 1, z3.Or(*(r == s for s in points(n))))))


def opened(n, x, r):
    return z3.Or(z3.And(x == 0, r == 0),
                 z3.And(0 < x, x < 1, -(2**n-1)*x <= r, r <= x),
                 z3.And(x == 1, z3.Or(*(r == s for s in points(n)))))


def prove(claim):
    solver = z3.Solver()
    solver.add(z3.Tactic("qe")(z3.Not(claim)).as_expr())
    result = solver.check()
    assert result == z3.unsat, (result, solver.model() if result == z3.sat else claim)


def changing_admission():
    before = {0: {"a"}, 1: {"b"}}
    after = {0: {"a", "b"}, 1: {"b"}}
    candidate = {"a": {0, 1, 2}, "b": {0, 1}}
    def producer(admissions):
        stored = {k: set() for k in candidate}
        for x, keys in admissions.items():
            common = set.intersection(*(candidate[k] for k in keys))
            assert x in common
            results = {x} | {2*r-x for r in common}
            for k in keys:
                stored[k].update(results)
        return stored
    old, new = producer(before), producer(after)
    assert old == {"a": {0, 2, 4}, "b": {-1, 1}}
    assert new == {"a": {0, 2}, "b": {-1, 0, 1, 2}}
    assert 4 not in new["a"] | candidate["a"] and 2 not in old["b"] | candidate["b"]


def check_updates():
    x, k, r, t = z3.Reals("x k r t")
    base = z3.And(legal(r), admits(r, k))
    prove(base == finite(0, k, r))
    for n in range(10):
        common = z3.ForAll(k, z3.Implies(admits(x, k), finite(n, k, r)))
        prove(z3.Implies(legal(x), common == opened(n, x, r)))
        introduced = z3.Exists(x, z3.And(admits(x, k), opened(n, x, (r+x)/2)))
        prove(z3.Or(base, introduced) == finite(n+1, k, r))
    common = z3.ForAll(k, z3.Implies(admits(x, k), cap(k, r)))
    prove(z3.Implies(z3.And(legal(x), common), r <= x))
    adapted = 1-(r+x)/2
    prove(z3.Implies(z3.And(legal(x), x < r, r <= 1),
                     z3.And(admits(x, adapted), z3.Not(cap(adapted, r)))))
    midpoint = (1-x)/2
    prove(z3.Implies(z3.And(legal(x), r >= x+1),
                     z3.And(admits(x, midpoint), z3.Not(cap(midpoint, r)))))
    prove(z3.Implies(base, cap(k, r)))
    prove(z3.Implies(z3.And(legal(x), common, admits(x, t)), cap(t, 2*r-x)))
    # At every input the upper bound is reached by its own base.
    prove(z3.Implies(z3.And(legal(x), r <= x), common))
    closed = lambda k, r: z3.Or(r <= 1-k, z3.And(k == 1, r == 1))
    common = z3.ForAll(k, z3.Implies(admits(x, k), closed(k, r)))
    prove(z3.Implies(base, closed(k, r)))
    prove(z3.Implies(z3.And(legal(x), common, admits(x, t)), closed(t, 2*r-x)))
    # Removing the isolated admission leaves exactly zero at the last key.
    triangle = lambda x, k: z3.And(legal(k), k+x <= 1)
    limit = lambda k, r: z3.If(k == 1, r == 0, r <= 1-k)
    common = z3.ForAll(k, z3.Implies(triangle(x, k), limit(k, r)))
    producer = z3.Exists(x, z3.And(legal(x), triangle(x, t), z3.substitute(common, (r, (r+x)/2))))
    prove(z3.Implies(legal(t), limit(t, r) == z3.Or(z3.And(legal(r), triangle(r, t)), producer)))
    prove(z3.Implies(x == 0, common == (r == 0)))
    print("Verified ten full producer steps and openings, both closed invariants and the triangle control.")


def check_binary():
    ceiling = 4096
    initial = {2**n-1 for n in range(14) if 2**n-1 <= ceiling}
    reached = initial.copy()
    for m in range(13):
        formula = {2**j*a+b for j in range(m+1) for a in initial
                   if 2**j*a <= ceiling for b in range(min(2**j, ceiling-2**j*a+1))}
        assert formula == reached
        assert 2**m in reached and 2**(m+1) not in reached
        reached |= {2*d+b for d in reached for b in (0, 1) if 2*d+b <= ceiling}
    assert reached == set(range(ceiling+1))
    print("Checked all exceptional-key deficits through 4096 against the binary formula.")


def q(value):
    return str(Fraction(value))


def menu(inputs, width):
    blocks = []
    for offset in range(0, len(inputs), width):
        values = list(inputs[offset:offset+width])
        values.extend([Fraction(0)]*(width-len(values)))
        values[0] += 2*len(blocks)
        blocks.append(values)
    return blocks


def menu_queries():
    """Use the actual all-keys predicate to compare two menus on the cube."""
    queries = []
    for dimension in range(1, 7):
        inputs = [Fraction((2*i+1) % 5, 4) for i in range(dimension)]
        for width in (1, 2):
            given = menu(inputs, width)
            for changed in range(-1, dimension):
                result = inputs.copy()
                if changed >= 0:
                    result[changed] = Fraction(1,3)
                stored = menu(result, width)
                # Encode membership in the finite set using its outer
                # endpoints and the gaps between consecutive first coordinates.
                post = [f"{q(stored[0][0])}≤k", f"k≤{q(stored[-1][0])}"]
                for left, right in zip(stored, stored[1:]):
                    post.append(f"min(k + ({q(-left[0])}),({q(right[0])}) + -k)≤0")
                if width == 2:
                    # At k=a, require j=b. The other tags are at least one
                    # unit away, so |j-b|≤|k-a| admits their second coordinates.
                    post += ["0≤j", "j≤1"]
                    for a,b in stored:
                        for sign in (1, -1):
                            u = f"{sign} j + ({q(-sign*b+a)}) + -k"
                            v = f"{sign} j + ({q(-sign*b-a)}) + k"
                            post.append(f"min({u},{v})≤0")
                cells = [" ∧ ".join(f"{name}={q(value)}" for name,value in zip("kj",block))
                         for block in given]
                fields = ["l", "l=0", " ∧ ".join(post)]
                same = changed == -1
                queries.append((fields+cells, (same,same)))
                if not same and len(cells) >= 2:
                    block = changed//width
                    queries.append((fields+cells[:block]+cells[block+1:], (True,True)))
    return queries


def check_driver(driver):
    # Admission is a union of the ordinary triangle and its isolated point.
    cells = ["0≤k ∧ k≤1 ∧ i+k≤1", "i=1 ∧ k=1"]
    post = "l≤1 ∧ min(l+k + -1,1 + -k)≤0"
    queries = menu_queries()
    menu_count = len(queries)
    def add(pre, package, admissions, rational, integral):
        queries.append((["l", pre, package, *admissions], (rational, integral)))
    for inp in (0, Fraction(1,8), Fraction(1,2), Fraction(7,8), 1):
        for delta in (-1, 0, Fraction(1,16), 1):
            result = inp+delta
            add(f"i={q(inp)} ∧ l={q(result)}", post, cells, delta <= 0,
                delta <= 0 and Fraction(result).denominator == 1)
    # At fixed negative r, project the exact finite stage onto k.
    for n in range(1, 9):
        c = 2**n-1
        for deficit in sorted({1, c, Fraction(1,2)} | ({2} if c >= 2 else set())):
            interior = f"{c} k + ({q(deficit-c)})"
            at_top = -deficit in points(n)
            slice_post = (f"min({interior},1 + -k)≤0" if at_top else f"{interior}≤0")
            # A(0) is the entire unit interval. For the control, remove
            # the gap and keep exactly the ordinary keys permitting r.
            cut = 1-Fraction(deficit, c)
            for control in (False, True):
                domain = [f"0≤k ∧ k≤{q(cut)}"] if control else ["0≤k ∧ k≤1"]
                if control and at_top:
                    domain.append("k=1")
                assert cut >= 0
                allowed = control
                add(f"l={q(-deficit)}", slice_post, domain, allowed,
                    allowed and Fraction(deficit).denominator == 1)
    enc = "\n".join("\t".join(fields) for fields, _ in queries)+"\n"
    result = subprocess.run([driver], input=enc, text=True, capture_output=True, check=True)
    lines = result.stdout.splitlines()
    assert len(lines) == len(queries)
    for line, (fields, expected) in zip(lines, queries):
        assert line.split() == ["sat" if ok else "unsat" for ok in expected], (fields, line, expected)
    print(f"InvarGenT agreed on the rational and native result in {menu_count} finite-menu checks and {len(lines)-menu_count} guard checks.")


def check_scheme(signature, captured=False):
    text = " ".join(signature.split()).split("val run : ")[1]
    pattern = (r"∀([a-z, ]+)\[(.*?)\]\. Num (\w+) → Num \((\w+) \+ 1\) → Nat → "
               r"∃(\w+)\[(.*?)\]\.Num (\w+)$")
    match = re.fullmatch(pattern, text)
    assert match, text
    names, pre, input_name, threshold, payload, post, result_name = match.groups()
    public = set(names.split(", "))
    assert len(public) == 2 and threshold == input_name and input_name in public
    assert payload == result_name and payload not in public
    key_name, = public-{input_name}
    x, k, r = map(z3.Real, (input_name, key_name, payload))
    parse = runpy.run_path(str(HERE/"thesis-review-28.py"))["numeric_constraints"]
    prove(z3.And(*parse(pre.split(" ∧ "), z3, z3.Real)) == z3.And(legal(x), admits(x, k)))
    package = z3.And(*parse(post.split(" ∧ "), z3, z3.Real))
    equality = r == x if captured else True
    prove(package == z3.And(equality, r <= 1, z3.Or(k+r <= 1, k >= 1)))
    prove(z3.Implies(legal(k), package == z3.And(equality, cap(k, r))))


def check_source(compiler, *, trace=None):
    source = (HERE/"limit_result_keys.gadt").read_text()
    # Returning x in the successor leaves the same guard to discharge.
    simple = source.replace("r -> next x r", "_ -> x")
    with TemporaryDirectory() as temp:
        def run(src, expected, *, scheme=False, captured=False):
            path = Path(temp)/"limit.gadt"
            path.write_text(src)
            proc = subprocess.run([compiler, "-iterations_timeout", "4", "-num_abduction_timeout", "40",
                                   "-full_annot", "-overwrite_ml", path], text=True, capture_output=True)
            output = proc.stdout+proc.stderr
            if expected is None:
                assert proc.returncode and "Type mismatch" in output, output
                return
            assert proc.returncode == 0, output
            runtime = subprocess.check_output(["ocaml", "-noinit", path.with_suffix(".ml")], text=True)
            assert runtime == expected, runtime
            if scheme:
                check_scheme(path.with_suffix(".gadti").read_text(), captured)
            return [event for event in proc.stderr.splitlines() if event.startswith("KEY ")]
        if trace:
            events = run(simple, "0\n1\n", scheme=True)
            prefix = ["KEY TRIAL probes"]*3 if trace == "before" else []
            assert events == prefix+["KEY TRIAL all", "KEY ACCEPT"], events
            print(f"Verified the {trace} diagnostic sequence of length {len(events)-1}.")
            return
        run(source, "0\n1\n", scheme=True)
        run(simple, "0\n1\n", scheme=True)
        remembered = source.replace("∃l[l≤1", "∃l[l=i ∧ l≤1").replace("lo <= r", "r <= (-1)")
        run(remembered, "0\n1\n", scheme=True, captured=True)
        # At input zero, the first successor can really open one.
        neighbor = simple[:simple.index("test (")].replace("k+l + -1", "k+l + -2")
        neighbor = neighbor.replace("∃l[l≤1", "∃l[l=1").replace("| Z -> x", "| Z -> 1")
        neighbor = neighbor.replace("| _ -> x)", "| _ -> 1)")
        neighbor += "test (let p=run 0 1 (S Z) in observe p)\n"
        run(neighbor, None)
        run(neighbor.replace("lo <= r -> True", "lo <= r -> r"), "1\n")
    print("Checked three exported schemes and executions, the reachable guard and its numeric result.")


if __name__ == "__main__":
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--driver", type=Path)
    cli.add_argument("--compiler", type=Path)
    cli.add_argument("--trace", type=Path)
    cli.add_argument("--before-trace", type=Path)
    args = cli.parse_args()
    changing_admission()
    check_updates()
    check_binary()
    if args.driver:
        check_driver(args.driver.resolve(strict=True))
    if args.compiler:
        check_source(args.compiler.resolve(strict=True))
    for driver, revision in ((args.trace, "after"), (args.before_trace, "before")):
        if driver:
            check_source(driver.resolve(strict=True), trace=revision)
