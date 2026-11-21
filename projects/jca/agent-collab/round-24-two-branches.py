"""Two chains of rigid constraints, and ground-hypothesis SREU, to two ordinary branches.

The input to color_instance is a list of (ground equations, goal equation)
over one binary constructor f and the declared source constants. A source
conversion is a list of (zero-based child path, equation index, ±1).
"""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location('rigid',Path(__file__).with_name('round-23-two-rigid.py'))
rigid = module_from_spec(spec)
spec.loader.exec_module(rigid)
t,V,F = rigid.t,rigid.V,rigid.F


def compile_chains(systems,sides):
    if len(systems)!=len(sides) or any(r not in (0,1) for r in sides):
        raise ValueError('one checking row per constraint is required')
    for side in (0,1):
        prev = set()
        for (rules,_),row in zip(systems,sides):
            if row==side:
                if not prev <= set(rules):
                    raise ValueError('the hypotheses on each side must form an inclusion chain')
                prev = set(rules)
    data = list(map(V,rigid.data_names(systems)))
    values = rigid.tracks(systems,private_lists=True)
    rows=[]
    for row in range(2):
        premise,conclusion = [],[]
        for i,edges in enumerate(values):
            scoped = [j for j,side in enumerate(sides) if side==row or (side!=row and j<i)]
            payload = [*data,*(V((p,j)) for j in scoped for p in ('Y','Z'))]
            for edge,pair in enumerate(edges):
                marker=F(('mark',i,edge),*payload)
                premise.extend((V(rigid.slot(i,edge,k)),v if sides[i]==row else marker)
                               for k,v in enumerate(pair))
            y,z = V(('Y',i)),V(('Z',i))
            cons,_ = rigid.list_symbols(i,True)
            conclusion.append((y,F(cons,rigid.encoded(systems[i][1][0]),z) if sides[i]==row else z))
        rows.append((premise,conclusion))
    return rows


def shade(i,term):
    if t.is_var(term):
        return V(f'v{i}:{term[1]}')
    if len(term)==1:
        return F(f'c{i}:{term[0]}')
    assert term[0]=='f' and len(term)==3
    return F('f',*(shade(i,c) for c in term[1:]))


def color_instance(source,constants):
    assert source and constants
    assert all(not t.variables(u) for rules,_ in source for eq in rules for u in eq)
    names = rigid.data_names(source)
    check,types,sync = [],[],[]
    starts,ends = [],[]
    data,representatives,shadows = [],[],[]
    for i,(rules,(s,g)) in enumerate(source):
        check.extend((shade(i,l),shade(i,r)) for l,r in rules)
        starts.append(shade(i,s))
        ends.append(shade(i,g))
        shade_const = lambda c:shade(i,F(c))
        base=shade_const(constants[0])
        types.extend((shade_const(c),base) for c in constants[1:])
        types.append((F('f',base,base),base))
        for x in names:
            data.append(shade(i,V(x)))
            representatives.append(base)
            shadows.append(shade(0,V(x)))
        if i:
            sync.extend((shade_const(c),shade(0,F(c))) for c in constants)
    def pack(label,values):
        return F(label,*values)
    return [(check,(pack('goals',starts),pack('goals',ends))),
            (check+types,(pack('types',data),pack('types',representatives))),
            (sync,(pack('sync',data),pack('sync',shadows)))]


def colored_proof(source,constants,theta,paths):
    systems=color_instance(source,constants)
    data={shade(i,V(x))[1]:shade(i,theta[x]) for i in range(len(source))
          for x in rigid.data_names(source)}
    conversions=[[],[],[]]
    offset=0
    for i,((rules,_),steps) in enumerate(zip(source,paths)):
        conversions[0].extend((tuple([i,*path]),offset+j,k) for path,j,k in steps)
        offset+=len(rules)
    def reduce_leaf_tree(tree,path,i,typing):
        rules=systems[1 if typing else 2][0]
        rewrites=conversions[1 if typing else 2]
        if len(tree)==1:
            target=shade(i,F(constants[0])) if typing else shade(0,F(tree[0].split(':',1)[1]))
            if tree!=target:
                rewrites.append((path,rules.index((tree,target)),1))
            return target
        result=F('f',*(reduce_leaf_tree(c,path+(j,),i,typing) for j,c in enumerate(tree[1:])))
        if typing:
            base=shade(i,F(constants[0]))
            rewrites.append((path,rules.index((result,base)),1))
            return base
        return result
    for k,x in enumerate(systems[1][1][0][1:]):
        i=int(x[1].split(':',1)[0][1:])
        for typing in (False,True):
            reduce_leaf_tree(data[x[1]],(k,),i,typing)
    return systems,data,conversions


def congruent(rules,l,r):
    """Ground congruence closure on the subterms of the queried instance."""
    terms=set()
    def visit(node):
        assert not t.is_var(node)
        if node not in terms:
            terms.add(node)
            for c in node[1:]:
                visit(c)
    for p,q in [*rules,(l,r)]:
        visit(p)
        visit(q)
    parent={s:s for s in terms}
    def root(x):
        while x!=parent[x]:
            x=parent[x]
        return x
    def merge(x,y):
        a,b=root(x),root(y)
        if a==b:
            return False
        parent[a]=b
        return True
    for p,q in rules:
        merge(p,q)
    while True:
        seen={}
        changed=False
        for s in terms:
            key=(s[0],*(root(c) for c in s[1:]))
            changed|=merge(s,seen.setdefault(key,s))
        if not changed:
            return root(l)==root(r)


def check():
    a,b=F('a'),F('b')
    x=V('x')
    f=lambda l,r:F('f',l,r)
    source=[([(a,b)],(f(x,a),f(b,b))), ([],(x,a)), ([(a,f(a,b))],(x,f(a,b)))]
    theta={'x':a}
    paths=[[((0,),0,1),((1,),0,1)],[],[((),0,1)]]
    systems,data,proofs=colored_proof(source,['a','b'],theta,paths)
    ans=rigid.certificate(systems,data,proofs,private_lists=True)
    rows=compile_chains(systems,[0,0,1])
    assert t.answer(ans,rows)
    assert rigid.binary_check(ans,rows)
    # An actual unification check on the two single-equation implications.
    pack=lambda terms: F('bundle',*terms)
    def bundle(eqs):
        return [(pack([l for l,_ in eqs]),pack([r for _,r in eqs]))]
    assert t.answer(ans,[(bundle(p),bundle(c)) for p,c in rows])
    # Independently check the intermediate equivalence on pure, mixed, and
    # mismatched data. Some witnesses mix colors inside a constructor.
    choices=[shade(i,v) for i in range(3) for v in (a,b,f(a,b))]
    choices.extend([f(shade(0,a),shade(2,b)),F('rogue')])
    def strip(v):
        if len(v)==1:
            return F(v[0].split(':',1)[-1])
        return F(v[0],*(strip(c) for c in v[1:]))
    def pure(v,i):
        if len(v)==1:
            return v[0].startswith(f'c{i}:')
        return v[0]=='f' and all(pure(c,i) for c in v[1:])
    size=0
    for vals in product(choices,repeat=3):
        data={shade(i,x)[1]:v for i,v in enumerate(vals)}
        actual=all(congruent(rules,t.once(l,data),t.once(r,data)) for rules,(l,r) in systems)
        same=all(pure(v,i) and strip(v)==strip(vals[0]) for i,v in enumerate(vals))
        src=all(congruent(rules,t.once(l,{'x':strip(vals[0])}),t.once(r,{'x':strip(vals[0])}))
                for rules,(l,r) in source)
        assert actual==(same and src)
        size+=1
    # A test before the larger theory matters. Its color recognizer alone
    # identifies every pair of leaves of one color.
    impossible=[([],(a,b)),([],(a,a))]
    (small,(l,r)),(large,_),_=color_instance(impossible,['a','b'])
    assert not congruent(small,l,r) and congruent(large,l,r)
    print(f'{size:,} independent congruence comparisons passed.')
    print('A three-constraint conversion certificate passes both ordinary JCA branches,')
    print('including over the fixed binary/unary signature. The theory-order counterexample passed.')


if __name__=='__main__':
    check()
