"""Decide existence of a greatest polyhedral typing for the signed isometric class."""
from argparse import ArgumentParser
from fractions import Fraction as F
from itertools import combinations
from pathlib import Path
import runpy

HERE = Path(__file__).resolve().parent
SIGNED = runpy.run_path(str(HERE/'thesis-review-63.py'))
BASE = SIGNED['BASE']
identity, mv, transpose, coordinates, span = (BASE[k] for k in ('identity','mv','transpose','coordinates','span'))


def in_cone(v, columns):
    if not any(v):
        return True
    # A minimal conic representation uses an independent subset.
    for k in range(1, min(len(v), len(columns))+1):
        for subset in combinations(columns, k):
            sol = BASE['linear_solutions'](transpose(subset), v, k)
            if sol is not None and not sol[1] and min(sol[0]) >= 0:
                return True
    return False


def strictly_expanding(maps, guards):
    """The cone of augmented guard normals also includes the public half-space lambda>=0."""
    n = len(maps[0])+1
    unit = identity(n)
    normals = [(*a, -c) for a,c in guards]+[(F(0),)*(n-1)+(F(-1),)]
    actions = [tuple((*row, F(0)) for row in transpose(m))+(unit[-1],) for m in maps]
    fixed_eq = [tuple(x-y for x,y in zip(row,e)) for m in actions for row,e in zip(m,unit)]
    _, fixed = BASE['linear_solutions'](fixed_eq, [0]*len(fixed_eq), n)
    differences = [tuple(x-y for x,y in zip(col,e)) for m in actions for col,e in zip(transpose(m), unit)]
    moving = span(differences, [])
    decomposition = [*fixed, *moving]
    projections = [coordinates(a, decomposition)[:len(fixed)] for a in normals]
    reversible_flags = [in_cone(tuple(-x for x in f), projections) for f in projections]
    reversible = [a for a, included in zip(normals, reversible_flags) if included]
    lineality = span(reversible, actions)
    basis = list(lineality)
    for e in unit:
        if coordinates(e, basis) is None:
            basis.append(e)
    k = len(lineality)
    def quotient(v):
        return coordinates(v, basis)[k:]
    induced = [transpose(tuple(quotient(mv(m,b)) for b in basis[k:])) for m in actions]
    finite = all(BASE['finite_orbit'](quotient(a), induced) is not None for a in normals)
    return finite, any(reversible_flags[:-1])


def greatest(metric, fields, guards):
    _, maps, rates, factored, _, primal = BASE['observable'](metric, fields, guards)
    if min(rates) < 1 or max(rates) == 1:
        return True
    if min(rates) == 1:
        _, metric, moves, factored = SIGNED['neutral_reduction'](maps, rates, factored, primal)
        return greatest(metric, moves, factored)
    return strictly_expanding(maps, factored)[0]


def examples():
    rot = ((F(3,5), F(-4,5)), (F(4,5), F(3,5)))
    for c, expected in ((1,False), (0,True), (-1,True)):
        assert greatest(identity(2), [(rot,2)], [((1,0),c)]) == expected
        assert greatest(identity(2), [(rot,2)], [((1,0),c), ((0,0),-1)])
    block = ((*rot[0],0), (*rot[1],0), (0,0,1))
    guards = [((1,0,1),1), ((0,1,-1),-1)]
    for guard in guards:
        assert not greatest(identity(3), [(block,2)], [guard])
    assert greatest(identity(3), [(block,2)], guards)
    assert not greatest(identity(3), [(block,2)], [(guards[0][0],1), (guards[1][0],2)])
    assert greatest(identity(3), [(block,1),(identity(3),2)], guards[:1])
    assert greatest(identity(2), [(rot,0),(identity(2),2)], [((1,0),1)])
    finite = ((0,-1),(1,0))
    assert greatest(identity(2), [(finite,2)], [((1,0),1)])
    # Two independent dense planes, with only the first killed by lineality.
    both = ((*rot[0],0,0), (*rot[1],0,0), (0,0,*rot[0]), (0,0,*rot[1]))
    some = [((1,0,0,0),0), ((0,0,1,0),1)]
    assert not greatest(identity(4), [(both,2)], some)
    assert greatest(identity(4), [(both,2)], [*some,((0,0,0,1),0)])
    finite, sign = strictly_expanding([rot], [((1,0), 1)])
    assert not finite and not sign
    assert strictly_expanding([rot], [((1,0), 0)]) == (True, True)
    assert strictly_expanding([identity(2)], [((1,0), 1)]) == (True, False)
    assert strictly_expanding([both], some) == (False, True)
    assert strictly_expanding([block], guards) == (True, True)
    print('The two fixed-axis guards each lack a greatest typing. Their conjunction has one.')
    return block, guards


def exact_unfolding(block, guards):
    import z3
    xs = z3.Reals('x y z')
    t = z3.Real('slack')
    def atom(row):
        a,c,r = row
        return sum(z3.RealVal(str(x))*v for x,v in zip(a,xs)) <= z3.RealVal(str(c))+z3.RealVal(str(r))*t
    retained = []
    rows = [(a,c,F(1)) for a,c in guards]
    for depth in range(30):
        solver = z3.SolverFor('QF_LRA')
        solver.add(t >= 0, *(atom(w) for w in retained), z3.Not(z3.And([atom(w) for w in rows])))
        if solver.check() == z3.unsat:
            break
        retained.extend(rows)
        rows = [(mv(transpose(block),a), c, r*2) for a,c,r in rows]
    else:
        raise AssertionError('No closure in thirty layers')
    assert depth >= 2
    domain = z3.And(t >= 0, *(atom(w) for w in retained))
    nxt = [sum(z3.RealVal(str(v))*x for v,x in zip(row,xs)) for row in block]+[2*t]
    solver = z3.SolverFor('QF_LRA')
    solver.add(domain,z3.Not(z3.substitute(domain,*zip([*xs,t],nxt))))
    assert solver.check() == z3.unsat
    solver = z3.SolverFor('QF_LRA')
    solver.add(*(atom(w) for w in retained), t < 0)
    assert solver.check() == z3.unsat
    solver = z3.SolverFor('QF_LRA')
    solver.add(t >= 0, *(atom(w) for w in retained[:-len(guards)]),
               z3.Not(z3.And([atom(w) for w in retained[-len(guards):]])))
    assert solver.check() == z3.sat
    outside = (-11,-5,-5,1)
    solver.add(*(v == x for v,x in zip([*xs,t],outside)))
    assert solver.check() == z3.sat
    print(f'Exact unfolding closes after {depth} layers ({len(retained)} word guards already imply nonnegative slack).')
    return retained, outside


def differential(block):
    """Compare both predictions with literal rational word guards through depth 16."""
    import z3
    p = z3.Reals('d1 d2 d3')
    t = z3.Real('dt')
    atoms = [((a,b,z),c) for (a,b) in ((1,0),(0,-1)) for z,c in ((0,0),(1,-1),(-1,-1),(1,1),(-1,1))]
    count = closed = signs = 0
    for gs in combinations(atoms,2):
        finite, sign = strictly_expanding([block],gs)
        assume = z3.SolverFor('QF_LRA')
        raw = z3.SolverFor('QF_LRA')
        assume.add(t >= 0)
        todo = list(gs)
        gain = 1
        stable = derived = False
        for _ in range(16):
            layer = z3.And([sum(z3.RealVal(str(k))*x for k,x in zip(a,p)) <= c+gain*t for a,c in todo])
            assume.push()
            assume.add(z3.Not(layer))
            stable = assume.check() == z3.unsat
            assume.pop()
            assume.add(layer)
            raw.add(layer)
            raw.push()
            raw.add(t < 0)
            derived = raw.check() == z3.unsat
            raw.pop()
            if stable and derived:
                break
            gain *= 2
            todo = [(mv(transpose(block),a), c) for a,c in todo]
        assert (stable,derived) == (finite,sign), (gs, finite, sign, stable, derived)
        count += 1
        closed += stable
        signs += derived
    print(f'{count} two-guard systems agreed through 16 layers: {closed} closures with the sign, {signs} signs derived.')


def native(exe, retained, outside):
    from tempfile import TemporaryDirectory
    lib = runpy.run_path(str(HERE/'thesis-review-61.py'))
    def guard(a,c,r):
        return ' + '.join(f'{v} {x}' for v,x in zip(a,'ijk') if v)+f'≤{c} + {r} n'
    rows = ' ∧ '.join(guard(a,c,r) for a,c,r in retained)
    source = ('datatype Node : num * num * num * num\n'
              'datacons Step : ∀i,j,k,n[i+k≤1+n ∧ j + -1 k≤-1+n]. '
              'Node (3/5 i + -4/5 j,4/5 i + 3/5 j,k,2 n) ⟶ Node (i,j,k,n)\n'
              f'let rec node : ∀i,j,k,n[{rows}]. Node (i,j,k,n) = Step node\n'
              'let centre : Node (0,0,1,0) = node\n')
    with TemporaryDirectory() as folder:
        p = Path(folder)/'fixed.gadt'
        lib['native'](exe,p,source)
        lib['native'](exe,p,source+'let wrong : Node ('+','.join(map(str,outside))+') = node\n',ok=False)
        # Check binding and alias over every public tuple, also without a caller annotation.
        direct = source.split('let rec node')[0]
        demand = f'let whole : ∀i,j,k,n[{rows}]. Node (i,j,k,n) = node\n'
        binding = direct+'let rec node = Step node\n'
        import z3
        x,y,z,t = z3.Reals('ix iy iz it')
        exact = z3.And([sum(lib['z'](v)*u for v,u in zip(a,(x,y,z))) <= lib['z'](c)+lib['z'](r)*t
                        for a,c,r in retained])
        for alias in ('let whole = node\n', demand):
            inferred = lib['native'](exe,p,binding+alias+'let needed : Node (1,-1,1,1) = whole\n')
            for name in ('node','whole'):
                pub, actual = lib['scheme'](lib['signature'](inferred,name))
                domain = lib['constraints'](actual,dict(zip(pub,(x,y,z,t))))
                lib['check'](z3.unsat, z3.Xor(domain,exact))
        lib['native'](exe,p,binding+'let wrong : Node ('+','.join(map(str,outside))+') = node\n',ok=False)
    print(f'Both unannotated exports equal the ten word guards. The late caller {outside} is rejected.')


if __name__ == '__main__':
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--unfold', action='store_true', help='verify the exact closure with z3-solver')
    parser.add_argument('--compiler', type=Path)
    args = parser.parse_args()
    m, guards = examples()
    if args.unfold or args.compiler:
        differential(m)
        retained, outside = exact_unfolding(m, guards)
        if args.compiler:
            native(args.compiler.resolve(), retained, outside)
