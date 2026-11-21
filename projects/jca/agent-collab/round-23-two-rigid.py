"""Compile two simultaneous rigid equations into two ordinary JCA branches.
Python standard library. Source constructors and variables use strings.
Positions in rewrite paths use zero-based child indices.
"""
from importlib.util import module_from_spec, spec_from_file_location
from pathlib import Path

spec = spec_from_file_location('trees', Path(__file__).with_name('round-10-experiments.py'))
t = module_from_spec(spec)
spec.loader.exec_module(t)
V,F = t.V,t.F
WRAP, CONS, NIL = ('wrap',), ('cons',), F(('nil',))


def encoded(term):
    if t.is_var(term):
        return F(WRAP, term)
    return F(WRAP,F(term[0],*(encoded(k) for k in term[1:])))


def data_names(systems):
    return sorted(set().union(*(t.variables(term) for rules,goal in systems
                                for eq in [*rules,goal] for term in eq)))


def list_symbols(i, private):
    return (('cons',i), F(('nil',i))) if private else (CONS,NIL)


def tracks(systems, *, private_lists=False):
    """Each edge gives its two values on the checking row. Both slots take
    the same marker on the opposite row, including for the special tail."""
    data = list(map(V,data_names(systems)))
    result = []
    for i,(rules,(_,target)) in enumerate(systems):
        edges = []
        for j,(l,r) in enumerate(rules):
            mid = F(('mid',i,j),*data)
            edges.extend([(encoded(l),mid),(mid,encoded(r))])
        cons,nil = list_symbols(i,private_lists)
        edges.append((F(cons,encoded(target),nil),nil))
        result.append(edges)
    return result


def slot(i, edge, side):
    return ('slot',i,edge,side)


def branches(systems, *, protected=True):
    assert len(systems)==2
    edges = tracks(systems)
    data = list(map(V,data_names(systems)))
    rows = []
    for row in range(2):
        premise,conclusion = [],[]
        for i,values in enumerate(edges):
            y,z = V(('Y',i)),V(('Z',i))
            payload = [*data,V(('Y',1-i)),V(('Z',1-i))] if protected else []
            for j,pair in enumerate(values):
                marker = F(('mark',i,j),*payload)
                premise.extend((V(slot(i,j,k)),val if row==i else marker)
                               for k,val in enumerate(pair))
            rhs = F(CONS,encoded(systems[i][1][0]),z) if row==i else z
            conclusion.append((y,rhs))
        rows.append((premise,conclusion))
    return rows


def context(tree, path, value):
    if not path:
        return value
    i,*suffix = path
    result = list(tree)
    result[1+i] = context(result[1+i],suffix,value)
    return tuple(result)


def certificate(systems,theta,paths, *, private_lists=False):
    """paths[i] lists (position, rule number, direction), +1 forward, -1 back."""
    data = {x:encoded(theta[x])[1] for x in data_names(systems)}
    ans = [(V(x),v) for x,v in data.items()]
    for i,((rules,(start,end)),path) in enumerate(zip(systems,paths)):
        n = 2*len(rules)
        head_pairs = []
        value = t.once(start,theta)
        for pos,j,sign in path:
            lhs,rhs = rules[j] if sign==1 else reversed(rules[j])
            p = list(pos)
            here = value
            for k in p:
                here = here[1+k]
            assert here == t.once(lhs,theta)
            # Each source node acquired one unary wrap. At each step cross
            # the wrapper, then the requested original constructor child.
            addr = [z for k in p for z in (0,k)]
            old = encoded(value)
            hops = [(2*j,0,1),(2*j+1,0,1)] if sign==1 else [(2*j+1,1,0),(2*j,1,0)]
            for edge,before,after in hops:
                head_pairs.append(tuple(context(old,addr,V(slot(i,edge,k))) for k in (before,after)))
            value = context(value,p,t.once(rhs,theta))
        assert value == t.once(end,theta)
        cons,_ = list_symbols(i,private_lists)
        y,z = V(slot(i,n,0)),V(slot(i,n,1))
        for h,k in reversed(head_pairs):
            y,z = F(cons,h,y),F(cons,k,z)
        ans.extend([(V(('Y',i)),y),(V(('Z',i)),z)])
    return ans


def decode(term,systems,base):
    """Common source projection. It evaluates every generated symbol, even
    one placed inside a data coordinate by an arbitrary answer."""
    op = term[0]
    children = [decode(c,systems,base) for c in term[1:]]
    if isinstance(op,str):
        return F(op,*children)
    if op==WRAP:
        return children[0]
    if op==CONS:
        return children[1]
    if term==NIL:
        return base
    kind,i,j = op
    rules = systems[i][0]
    if kind=='mark' and j==2*len(rules):
        return base
    rule = j if kind=='mid' else j//2
    return t.once(rules[rule][0],dict(zip(data_names(systems),children)))


def binary_encoder(rows, source_symbols=()):
    """Encode the ranked reduction into one binary constructor, one unary constructor and one atom.
    The empty list and the boxing flag have different recognizable codes."""
    atom = F('A')
    fork = lambda x,y:F('B',x,y)
    mark = lambda x:F('U',x)
    end = mark(atom)
    flag = fork(atom,end)
    symbols = set(source_symbols)
    def visit(node):
        if not t.is_var(node):
            symbols.add(node[0])
            for child in node[1:]:
                visit(child)
    for prem,conc in rows:
        for l,r in prem+conc:
            visit(l)
            visit(r)
    tags = {}
    tag = fork(atom,atom)
    for sym in sorted(symbols,key=repr):
        tags[sym] = tag
        tag = fork(tag,atom)
    def encode(node):
        if t.is_var(node):
            return node
        tail = end
        for child in reversed(node[1:]):
            tail = fork(fork(flag,encode(child)),tail)
        is_marker = isinstance(node[0],tuple) and node[0][0]=='mark'
        call = fork(tags[node[0]],tail)
        return mark(call) if is_marker else call
    return encode


def binary_check(answer,rows,source_symbols=()):
    enc = binary_encoder(rows,source_symbols)
    def equations(eqs):
        return [(enc(l),enc(r)) for l,r in eqs]
    return t.answer(equations(answer),[(equations(p),equations(c)) for p,c in rows])


def check():
    a,b,c = map(F,('a','b','c'))
    u,v = V('u'),V('v')
    f = lambda l,r:F('f',l,r)
    g = lambda x:F('g',x)
    systems = [
        ([(u,f(v,a)),(f(v,a),c)], (g(u),g(c))),
        ([(u,g(v))], (f(g(v),u),f(u,g(v))))
    ]
    theta = {'u':a,'v':b}
    paths = [[([0],0,1),([0],1,1)], [([0],0,-1),([1],0,1)]]
    answer = certificate(systems,theta,paths)
    assert t.answer(answer,branches(systems))
    assert binary_check(answer,branches(systems),['b'])
    assert t.answer(certificate(systems[::-1],theta,paths[::-1]),branches(systems[::-1]))
    empty = [([], (u,u)), ([(u,v)], (a,a))]
    assert t.answer(certificate(empty,{'u':b,'v':b},[[],[]]),branches(empty))
    # Reify the data before applying source rules, including a foreign marker
    # and a trace constructor inside otherwise unrestricted data.
    unusual = {'u':F(('mark',1,0),b,c,a,a),'v':F(CONS,c,b)}
    for term in [u,v,f(u,v),g(f(u,v)),a]:
        assert decode(t.once(encoded(term),unusual),systems,a)==t.once(
            term,{x:decode(z,systems,a) for x,z in unusual.items()})
    # Track 1 has no equation a=b. Omitting the payload lets its proof use
    # track 0's slots to go from encoded a to a marker, then to encoded b.
    leak = [([(a,b)], (a,a)), ([], (a,b))]
    good0 = certificate([leak[0],([], (a,a))],{},[[],[]])[:2]
    pa,pb,pc,pd = [V(slot(0,j,k)) for j in range(2) for k in range(2)]
    mid = F(('mid',0,0))
    # Four pairs with equal row-0 values, read their row-1 values in order.
    hs = [(encoded(a),pa),(pb,mid),(mid,pc),(pd,encoded(b))]
    y,z = V(slot(1,0,0)),V(slot(1,0,1))
    for h,k in reversed(hs):
        y,z=F(CONS,h,y),F(CONS,k,z)
    bad = good0+[(V(('Y',1)),y),(V(('Z',1)),z)]
    assert t.answer(bad,branches(leak,protected=False))
    assert not t.answer(bad,branches(leak))
    assert binary_check(bad,branches(leak,protected=False))
    assert not binary_check(bad,branches(leak))
    print('Checked both orientations, non-ground hypotheses, nested and reverse steps,')
    print('empty paths, arbitrary-data decoding, the fixed binary/unary signature, and the leakage example.')


if __name__=='__main__':
    check()
