"""Replay the public and lifted parabola typings and optionally try them in InvarGenT."""
from argparse import ArgumentParser
from itertools import product
from pathlib import Path
import runpy
from tempfile import TemporaryDirectory

import z3

HERE = Path(__file__).resolve().parent


def public(z, x, n):
    return z3.And(z <= n, *(x >= 2*k*z-k*k for k in range(n+1)))


def folded(z, x, n, *, tight=False):
    rows = [z <= n]
    aux = []
    while n > 1:
        c = n//2
        d = z-c
        u = z3.If(d>=0,d,-d) if tight else z3.FreshReal('fold')
        rows.extend([u>=d, u>=-d])
        x,z,n = x-2*c*z+c*c,u,c
        if not tight:
            aux.append(u)
    return z3.And(*rows,x>=0,x>=2*z-1), aux


def unsat(*formula):
    solver = z3.SolverFor('QF_LRA')
    solver.add(*formula)
    assert solver.check()==z3.unsat, solver.model()


def fold_checks():
    z,x = z3.Reals('z x')
    for m in range(8):
        n = 2**m
        projected = public(z,x,n)
        lifted,_ = folded(z,x,n)
        opened,_ = folded(z,x,n,tight=True)
        child,_ = folded(z-1,x-2*z+1,n,tight=True)
        unsat(lifted,z3.Not(projected))
        unsat(projected,z3.Not(opened))
        unsat(lifted,z3.Not(child))
        unsat(z==n,x==n*n,z3.Not(opened))
        unsat(z==n,x==n*n-1,lifted)
    print('For N = 1 through 128 at powers of two, Z3 checked projection, fresh child openings and both boundary callers.')


def source(m):
    n = 2**m
    z, x = 'i','j'
    variables = [z,x]
    rows = [f'{z}≤{n}']
    # x minus the affine parts accumulated by all folds.
    offset = []
    while n>1:
        c = n//2
        u = 'i'+str(len(variables))
        variables.append(u)
        rows += [f'{z} + {-c}≤{u}', f'{c} + -1 {z}≤{u}']
        offset.extend([f'{2*c} {z}',str(-c*c)])
        z,n = u,c
    base = ' + '.join(offset) or '0'
    rows.extend([base+'≤'+x,base+' + 2 '+z+' + -1≤'+x])
    n = 2**m
    head = ('datatype Curve : num * num\n'
            'datacons Step : ∀i,j[0≤j]. Curve (i + -1,j + -2 i + 1) ⟶ Curve (i,j)\n')
    binding = 'let rec curve : ∀'+','.join(variables)+'['+' ∧ '.join(rows)+']. Curve (i,j) = Step curve\n'
    return head,binding,f'let root : Curve ({n},{n*n}) = curve\n',f'let wrong : Curve ({n},{n*n-1}) = curve\n'


def graph_checks():
    # For every graph on <=3 vertices and singleton start/end, compute the exact
    # ultimately periodic support. Any finite last gap obeys the shortening bound.
    count = 0
    for m in (1,2,3):
        for rows in product(range(1<<m), repeat=m):
            for start in range(m):
                state = 1<<start
                seen = {}
                while state not in seen:
                    seen[state] = len(seen)
                    successor = 0
                    for i,edges in enumerate(rows):
                        if state & (1<<i):
                            successor |= edges
                    state = successor
                cycle = list(seen)[seen[state]:]
                for end in range(m):
                    if all(v & (1<<end) for v in cycle):
                        assert all(i<2*m*m for v,i in seen.items() if not v & (1<<end))
                    count += 1
    print(f'Checked the finite-gap bound on {count} small graph/start/end combinations.')


def native(exe):
    lib = runpy.run_path(str(HERE/'thesis-review-61.py'))
    with TemporaryDirectory() as folder:
        p = Path(folder)/'curve.gadt'
        for m in (1,4,10,18):
            head,binding,root,wrong = source(m)
            alias = 'let alias = curve\n'
            demand = root.replace('= curve','= alias')
            bare = head+'let rec curve = Step curve\n'+alias
            text = lib['native'](exe,p,bare+demand)
            expected = binding.split(' : ',1)[1].split(' = Step',1)[0]
            def lifted(scheme):
                vs = [v.strip() for v in scheme[1:].split('[',1)[0].split(',')]
                public, rows = lib['scheme'](scheme)
                assert public == vs[:2] and len(vs)==m+2 and len(rows)==2*m+3
                return lib['constraints'](rows,dict(zip(vs,z3.RealVector('p',len(vs)))))
            for name in ('curve','alias'):
                unsat(z3.Xor(lifted(expected),lifted(lib['signature'](text,name))))
            lib['native'](exe,p,head+binding+root)
            lib['native'](exe,p,bare+wrong,ok=False)
        head,binding,root,wrong = source(2)
        damaged = binding.rsplit(' ∧ ',1)[0]+']. Curve (i,j) = Step curve\n'
        lib['native'](exe,p,head+damaged+wrong,ok=False)
    print('Native binding and alias equal the written lift at N=2,16,1024,262144; all four late violations were rejected.')


if __name__ == '__main__':
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=int, metavar='M', help='emit the folded program for N=2^M')
    parser.add_argument('--compiler', type=Path)
    args = parser.parse_args()
    if args.source is not None:
        if args.source < 0:
            parser.error('M must be nonnegative')
        print(''.join(source(args.source)[:3]),end='')
    else:
        fold_checks()
        graph_checks()
        if args.compiler:
            native(args.compiler.resolve())
