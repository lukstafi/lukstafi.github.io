"""Complete one-branch reference search using the proved witness-depth bound.

Pass (constructor name, arity) pairs, initial data names, ordered ('all' or
'some', name) moves, and two lists of equations. The exhaustive search is
intended for small examples. None means that no permitted strategy exists.
"""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location("one", Path(__file__).with_name("round-20-one-branch.py"))
one = module_from_spec(spec)
spec.loader.exec_module(one)
V, F = one.V, one.F


def markings(tree, allowed, row):
    for h in allowed:
        if tree == row[h]:
            yield V(h)
    for args in product(*(markings(t,allowed,row) for t in tree[1:])):
        yield F(tree[0],*args)


def solve(signature,data,moves,premise,conclusion):
    names = [*data,*(x for _,x in moves)]
    if len(set(names)) != len(names):
        raise ValueError("the prefix must bind each coordinate once")
    arities = dict(signature)
    pool = [F(op) for op,n in arities.items() if n == 0]
    if not pool or any(n < 0 for n in arities.values()):
        raise ValueError("a ground constructor and nonnegative arities are required")
    equations = premise+conclusion
    syntax = {t for eq in equations for s in eq for t in one.subterms(s)}
    for t in syntax:
        if one.trees.is_var(t):
            if t[1] not in names:
                raise ValueError("undeclared coordinate")
        elif arities.get(t[0]) != len(t)-1:
            raise ValueError("constructor outside the supplied signature")
    scopes, inputs = {}, []
    for q,x in moves:
        if q == "all":
            inputs.append(x)
        elif q == "some":
            scopes[x] = tuple(inputs)
        else:
            raise ValueError("unknown quantifier")
    if all(n == 0 for n in arities.values()) and len(pool) == 1:
        return dict.fromkeys([*data,*scopes],pool[0])

    joint = one.unify(equations)
    if joint is None:
        return None
    patterns = {x:one.apply(V(x),joint) for x in names}
    residuals = sorted(one.collect(patterns.values()),key=repr)
    limit = (len(names)+len(syntax))*max(1,len(inputs))
    newest = set(pool)
    for depth in range(limit+1):
        for values in product(pool,repeat=len(residuals)):
            if depth and not newest.intersection(values):
                continue
            subst = dict(zip(residuals,values))
            row = {x:one.once(term,subst) for x,term in patterns.items()}
            options = [markings(row[y],scope,row) for y,scope in scopes.items()]
            for bodies in product(*options):
                strategy = {**{x:row[x] for x in data}, **dict(zip(scopes,bodies))}
                active = one.map_eqs(premise,strategy)
                need = one.map_eqs(conclusion,strategy)
                if one.trees.answer([],[(active,need)]):
                    return strategy
        if not residuals or depth == limit:
            break
        next_layer = [F(op,*args) for op,n in arities.items() if n
                      for args in product(pool,repeat=n) if newest.intersection(args)]
        if not next_layer:
            break
        pool.extend(next_layer)
        newest = set(next_layer)
    return None


def check():
    a,b = F("a"),F("b")
    h,k,y,z = map(V,"hkyz")
    f = lambda l,r:F("f",l,r)
    moves = [("all","h"),("all","k"),("some","y"),("some","z")]
    binary = [("a",0),("f",2)]
    # Both joint patterns have independent residuals. The premise must
    # enforce the relation between the two inputs on its active family.
    assert solve(binary,[],moves,[(y,z)],[(h,k)]) is not None
    assert solve(binary,[],moves,[(y,z)],[(y,a),(h,a),(k,a)]) is None
    assert solve(binary,[],moves,[(y,z)],[(y,f(h,k)),(h,k)]) is not None
    assert solve([("a",0)],[],moves,[],[(h,k)]) is not None
    count = 0
    moves = [moves[i] for i in (0,2,1,3)]
    atoms = list(product([a,b,h,k,y,z],repeat=2))
    for de,ce in product(atoms,repeat=2):
        found = solve([("a",0),("b",0)],[],moves,[de],[ce])
        exists = any(one.trees.answer([],[(one.map_eqs([de],{"y":u,"z":v}),
                                         one.map_eqs([ce],{"y":u,"z":v}))])
                     for u,v in product((a,b,h),(a,b,h,k)))
        assert (found is not None) == exists
        count += 1
    print(f"General decision search agreed with all {count:,} exact finite-algebra comparisons.")


if __name__ == "__main__":
    check()
