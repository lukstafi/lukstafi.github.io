"""Decide monadic supplied-answer validity by propagating one-letter word tails."""
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path
from random import Random

spec = spec_from_file_location("generic",Path(__file__).with_name("round-32-carriers.py"))
generic = module_from_spec(spec)
spec.loader.exec_module(generic)
inp,V,F,a,b = generic.inp,generic.V,generic.F,generic.a,generic.b


def split(t):
    word = []
    while not inp.trees.is_var(t) and len(t)>1:
        if len(t)!=2:
            raise ValueError("A monadic signature is required")
        word.append(t[0])
        t = t[1]
    return tuple(word),t


def valid(atoms,moves,permissions,*,singleton=False):
    if singleton:
        return True
    mu = inp.unify(atoms)
    if mu is None:
        return False
    public = {x:split(inp.apply(V(x),mu)) for _,x in moves}
    universal = {x for q,x in moves if q=="all" and x not in permissions}
    before,earlier = {},set()
    for q,x in moves:
        before[x] = set(earlier)
        if x in universal:
            earlier.add(x)
    assigned = {}
    for h in universal:
        prefix,leaf = public[h]
        if prefix or not inp.trees.is_var(leaf) or leaf in assigned:
            return False
        assigned[leaf] = ((),h)
    scopes = {}
    def require(leaf,allowed):
        if inp.trees.is_var(leaf):
            scopes[leaf] = scopes.get(leaf,universal) & allowed
    exceptions = []
    # Parameters for original substituted existentials belong to a separate
    # namespace from mgu leaves, even if the public coordinate has the same name.
    game = {}
    for q,x in moves:
        if x not in permissions:
            game[x] = public[x]
            if x not in universal:
                require(public[x][1],before[x])
            continue
        direct = permissions[x] & universal
        if any(y in permissions[x] and not before[y]<=direct for quant,y in moves if quant=="some"):
            exceptions.append(x)
        else:
            require(public[x][1],direct)
        if q=="all":
            game[x] = ((),a)
        else:
            leaf = V(object())
            game[x] = ((),leaf)
            require(leaf,before[x])
    if any(h not in scopes.get(leaf,universal) for leaf,(_,h) in assigned.items()):
        return False

    def search(restrictions,pending):
        for x in pending:
            outer,leaf = public[x]
            if leaf not in restrictions:
                continue
            inner,h = restrictions[leaf]
            rest = [y for y in pending if y!=x]
            if h in permissions[x]:
                return search(restrictions,rest)
            target = outer+inner
            for y in permissions[x]:
                prefix,source = game[y]
                if not inp.trees.is_var(source) or h not in scopes.get(source,universal):
                    continue
                for start in range(len(target)-len(prefix)+1):
                    end = start+len(prefix)
                    if target[start:end]!=prefix:
                        continue
                    value = target[end:],h
                    if source in restrictions and restrictions[source]!=value:
                        continue
                    if search({**restrictions,source:value},rest):
                        return True
            return False
        return True
    return search(assigned,exceptions)


def check():
    g = lambda v:F("g",v)
    k = lambda v:F("k",v)
    h,x,e,z,w = map(V,"hxezw")
    moves = [('all','h'),('some','e'),('some','z'),('some','x'),('some','w')]
    # x must recover a rigid suffix through e, forcing the previously
    # unconstrained z. That makes the second request w nonground as well.
    atoms = [(x,g(k(h))),(e,g(z)),(w,z)]
    assert valid(atoms,moves,{'x':{'e'},'w':{'h'}})
    assert not valid(atoms,moves,{'x':{'e'},'w':set()})
    assert valid([(x,g(h))],moves,{'x':{'z'},'z':set()})
    assert not valid([(x,g(h)),(e,k(h))],moves,{'x':{'e'}})
    # Two targets sharing an original substituted move can force conflicting letters.
    prefix = [('all','a'),('all','b'),('some','e'),('some','p'),('some','q')]
    formulas = [(V('p'),V('a')),(V('q'),V('b'))]
    assert not valid(formulas,prefix,{'e':set(),'p':{'e'},'q':{'e'}})
    # Compare with the independent general-signature NP search and, on the
    # finite two-constant algebra, direct quantification over all witness terms.
    rng = Random(41)
    names = ['h','e','x','z']
    checked = 0
    finite = 0
    for i in range(320):
        qs = [(rng.choice(['all','some']),v) for v in names]
        terms = [*map(V,names),a,b]
        if i%2:
            terms += [g(v) for v in terms]+[k(g(h))]
        eqs = [(rng.choice(terms),rng.choice(terms)) for _ in range(rng.randrange(1,4))]
        masks = {v:{u for u in names if rng.randrange(2)} for v in names if rng.randrange(2)}
        result = valid(eqs,qs,masks)
        assert result==generic.valid(eqs,qs,masks),(eqs,qs,masks)
        checked+=1
        if i%2==0:
            assert result==generic.leading.ground_game(eqs,qs,masks)
            finite+=1
    print(f"Verified carrier propagation and conflicts, {checked} independent decisions, and {finite} exact finite games.")


if __name__=='__main__':
    check()
