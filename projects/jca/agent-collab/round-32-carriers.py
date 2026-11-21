"""Decide leading validity of a supplied answer with arbitrary carrier permissions."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations, product
from pathlib import Path

spec = spec_from_file_location("leading",Path(__file__).with_name("round-31-leading.py"))
leading = module_from_spec(spec)
spec.loader.exec_module(leading)
inp,V,F,a,b = leading.inp,leading.V,leading.F,leading.a,leading.b


def valid(atoms,moves,permissions,base=a,*,singleton=False):
    """Fresh leading names can be supplied as additional initial universal moves."""
    if singleton:
        return True
    read = set().union(*permissions.values()) if permissions else set()
    game,ordinary,letters,requests = {},{},[],[]
    for q,x in moves:
        if q == 'all':
            game[x] = F(('rigid input',x))
            letters.append(game[x])
        elif x in permissions and (x not in read or not letters):
            # An unused original move can be fixed; an initial ground move
            # read only by witnesses can be inlined into their terms.
            game[x] = base
        else:
            game[x] = V(('move',x))
            requests.append((game[x],list(letters)))
        ordinary[x] = V(('replacement',x)) if x in permissions else game[x]
    for x,allowed in permissions.items():
        requests.append((ordinary[x],[game[z] for z in allowed]))
    matrix = inp.map_eqs(atoms,ordinary)
    mu = inp.unify(matrix)
    if mu is None:
        return False
    requests = [(inp.apply(t,mu),[inp.apply(s,mu) for s in sources]) for t,sources in requests]
    terms = [t for value,sources in requests for t in [value,*sources]]
    observed = {base,*letters}
    for eq in matrix:
        for term in eq:
            normalized = inp.apply(term,mu)
            terms.append(normalized)
            observed.update(u for u in inp.subterms(normalized) if not inp.trees.is_var(u))
    residuals = sorted(inp.collect(terms),key=repr)
    # Every unknown is the base or the value of one explicit constructor
    # node in a compressed solution. Guess its pointer, then unify the graph.
    choices = [[s for s in observed if x not in inp.vars_in(s)] for x in residuals]
    rigid = set(letters)
    def generated(t,sources):
        return t in sources or (t not in rigid and all(generated(c,sources) for c in t[1:]))
    for pointers in product(*choices):
        defs = inp.unify(list(zip(map(V,residuals),pointers)))
        if defs is None:
            continue
        def value(t):
            return inp.apply(t,defs)
        if all(generated(value(t),{value(s) for s in sources}) for t,sources in requests):
            return True
    return False


def sat_system(variables,clauses):
    h0,h1 = "false input","true input"
    moves = [('all',h0),('all',h1)]
    atoms,permissions = [],{}
    def request(name,letter,leaves):
        moves.append(('some',name))
        permissions[name] = set(leaves)
        atoms.append((V(name),V(letter)))
    for i in range(1,variables+1):
        moves.extend([('some',i),('some',-i)])
    for i in range(1,variables+1):
        request(('false',i),h0,[i,-i])
        request(('true',i),h1,[i,-i])
    for i,c in enumerate(clauses):
        request(('clause',i),h1,c)
    return atoms,moves,permissions


def one_missing(variables,clauses):
    f = lambda l,r:F("f",l,r)
    r,k = "hidden","request"
    moves = [('some',i) for i in range(1,variables+1)]+[('some',k),('all',r)]
    truth_b = f(a,a)
    ident = a
    targets,atoms = [],[]
    for j,clause in enumerate(clauses):
        def cell(lft,rgt):
            return f(V(r),f(ident,f(lft,rgt)))
        targets.append(cell(a,truth_b))
        for pos,lit in enumerate(clause):
            name = ("occ",j,pos)
            moves.append(('some',name))
            body = cell(V(lit),truth_b) if lit>0 else cell(a,V(-lit))
            atoms.append((V(name),body))
        ident = f(ident,a)
    target = a
    for value in reversed(targets):
        target = f(value,target)
    atoms.append((V(k),target))
    return atoms,moves,{k:{x for _,x in moves if x!=r}}


def check():
    names = ('h','e','k')
    h,e,k = map(V,names)
    moves = [('all','h'),('some','e'),('all','k')]
    choices = [a,b,h,e,k]
    count = 0
    for n in range(4):
        for allowed in combinations(names,n):
            permissions = {'k':set(allowed)}
            for eq1,eq2 in combinations(combinations(choices,2),2):
                atoms = [eq1,eq2]
                assert valid(atoms,moves,permissions) == leading.ground_game(atoms,moves,permissions)
                count += 1
    f = lambda l,r:F('f',l,r)
    assert valid([(e,f(h,a)),(k,e)],moves,{'k':{'e'}})
    assert not valid([(e,f(h,a)),(k,h)],moves,{'k':{'e'}})
    assert valid([(e,h),(k,f(e,e))],moves,{'k':{'e'}})
    # Every conjunction of this six-clause collection, including inconsistent ones.
    catalog = [(1,),(-1,),(2,),(-2,),(1,-2),(-1,2)]
    for flags in product((False,True),repeat=len(catalog)):
        clauses = [cl for cl,flag in zip(catalog,flags) if flag]
        expected = any(all(any(bits[abs(lit)-1] == (lit > 0) for lit in cl) for cl in clauses)
                       for bits in product((False,True),repeat=2))
        atoms,moves,masks = sat_system(2,clauses)
        assert valid(atoms,moves,masks) == expected
        early = [m for m in moves if m[1] in masks]+[m for m in moves if m[1] not in masks]
        assert valid(atoms,early,masks) == expected
        assert valid(*one_missing(2,clauses)) == expected
    print(f"{count} direct game comparisons, 64 clause sets under three SAT reductions, and three binary carrier cases passed.")


if __name__ == '__main__':
    check()
