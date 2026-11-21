"""Two ordinary branches over f/2 and a/0. Reuse the Round 17 opaque parser."""
from importlib.util import module_from_spec,spec_from_file_location
from pathlib import Path

def sibling(name,file):
    spec=spec_from_file_location(name,Path(__file__).with_name(file))
    mod=module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod

chains=sibling('chains','round-24-two-branches.py')
codec=sibling('codec','round-17-three-branches.py')
t,f,A,V,F=chains.t,codec.f,codec.A,chains.V,chains.F
SITE=(0,1,0)
def patch(term,path,new):
    return chains.rigid.context(term,path,new)

def spine(ts):
    result=A
    for u in reversed(ts):
        result=f(u,result)
    return result


class Compiler:
    def __init__(self,systems,sides):
        assert len(systems)==len(sides)
        self.systems,self.sides=systems,sides
        self.data=chains.rigid.data_names(systems)
        rules=list(dict.fromkeys(rule for E,_ in systems for rule in E))
        assert all(not t.variables(s) for rule in rules for s in rule)
        arity={}
        def collect(term):
            if not t.is_var(term):
                op=term[0]
                assert arity.setdefault(op,len(term)-1)==len(term)-1
                for c in term[1:]:
                    collect(c)
        # Assign the fixed ground theories' tags before inspecting the goals.
        # Changing an input word then leaves every existing tag in place.
        for eqs,_ in systems:
            for s,r in eqs:
                collect(s)
                collect(r)
        for i,(_,goal) in enumerate(systems):
            for term in goal:
                collect(term)
            arity[self.cons(i)]=2
        self.enc=codec.OneConstantEncoding(rules,arity)
        self.modes={eq:j+1 for j,eq in enumerate(rules)}
        self.templates=[]
        for i,(eqs,(_,target)) in enumerate(systems):
            bodies=[self.enc.encode(term,self.modes[eq]) for eq in eqs for term in eq]
            bodies.append(self.enc.encode(F(self.cons(i),target,codec.NIL)))
            self.templates.append(bodies)
        for row in (0,1):
            prev=set()
            for (eqs,_),side in zip(systems,sides):
                if side==row:
                    assert prev<=set(eqs)
                    prev=set(eqs)

    @staticmethod
    def cons(i):
        return f'list/{i}'

    @staticmethod
    def slot(i,j,k):
        return V(('slot',i,j,k))

    def marker(self,tag,payload):
        # The tag is literal and injective. The two outer child states are 0,E.
        return f(A,f(self.enc.generator,f(tag,spine(payload))))

    def branches(self):
        rows=[]
        for row in (0,1):
            prem,conc=[],[]
            tag=A
            for i,templates in enumerate(self.templates):
                protected=[k for k,side in enumerate(self.sides)
                           if side==row or (side!=row and k<i)]
                payload=[*map(V,self.data),*(V((p,k)) for k in protected for p in ('Y','Z'))]
                for j,body in enumerate(templates):
                    assert body[1][2][1]==A
                    mark=self.marker(tag,payload)
                    tag=f(tag,A)
                    for k,value in enumerate((mark,patch(body,SITE,mark))):
                        prem.append((self.slot(i,j,k),A if self.sides[i]==row else value))
                y,z=V(('Y',i)),V(('Z',i))
                s=self.systems[i][1][0]
                expr=self.enc.encode(F(self.cons(i),s,z)) if self.sides[i]==row else z
                conc.append((y,expr))
            rows.append((prem,conc))
        return rows

    def certificate(self,theta,paths):
        data={x:self.enc.encode(theta[x]) for x in self.data}
        ans=[(V(x),v) for x,v in data.items()]
        for i,((eqs,(s,target)),steps) in enumerate(zip(self.systems,paths)):
            end=len(self.templates[i])-1
            tail=t.once(self.templates[i][end],data)
            y,z=patch(tail,SITE,self.slot(i,end,0)), self.slot(i,end,1)
            heads=[]
            value=t.once(s,theta)
            for path,j,sign in steps:
                l,r=eqs[j]
                old,new=(l,r) if sign==1 else (r,l)
                redex=value
                for k in path:
                    redex=redex[k+1]
                assert redex==old
                outer=self.enc.encode(patch(value,path,V('gap')))
                for side in ((0,1) if sign==1 else (1,0)):
                    idx=2*j+side
                    c=self.templates[i][idx]
                    active=patch(c,SITE,self.slot(i,idx,0))
                    collapsed=self.slot(i,idx,1)
                    pair=(active,collapsed) if (sign==1)==(side==0) else (collapsed,active)
                    heads.append(tuple(t.once(outer,{'gap':self.enc.wrappers(1,self.modes[(l,r)],u)})
                                       for u in pair))
                value=patch(value,path,new)
            assert value==t.once(target,theta)
            for h,k in reversed(heads):
                y=self.enc.wrappers(1,self.enc.m,self.enc.macro(self.cons(i),h,y))
                z=self.enc.wrappers(1,self.enc.m,self.enc.macro(self.cons(i),k,z))
            ans.extend([(V(('Y',i)),y),(V(('Z',i)),z)])
        return ans


def verify(answer,rows):
    """Unify on a shared DAG, check acyclicity, and compare normalized nodes.
    Constructor arguments unify pairwise. Free classes retain distinct names.
    """
    for prem,conc in rows:
        nodes,intern,cache=[],{},{}
        def store(term):
            stack=[(term,False)]
            while stack:
                current,visited=stack.pop()
                key=id(current)
                if key in cache:
                    continue
                if t.is_var(current):
                    rep=('var',current[1])
                elif not visited:
                    stack.append((current,True))
                    stack.extend((child,False) for child in current[1:])
                    continue
                else:
                    rep=(current[0],*(cache[id(child)] for child in current[1:]))
                n=intern.get(rep)
                if n is None:
                    n=len(nodes)
                    intern[rep]=n
                    nodes.append(rep)
                cache[key]=n
            return cache[id(term)]
        pending=[(store(l),store(r)) for l,r in answer+prem]
        queries=[(store(l),store(r)) for l,r in conc]
        parent=list(range(len(nodes)))
        desc=[None if n[0]=='var' else n for n in nodes]
        def root(i):
            while i!=parent[i]:
                parent[i]=parent[parent[i]]
                i=parent[i]
            return i
        while pending:
            l,r=map(root,pending.pop())
            if l==r:
                continue
            a,b=desc[l],desc[r]
            parent[r]=l
            if a is None:
                desc[l]=b
            elif b is not None:
                if a[0]!=b[0] or len(a)!=len(b):
                    return False
                pending.extend(zip(a[1:],b[1:]))
        normal,shared={},{}
        for i in {root(i) for i in range(len(nodes))}:
            stack=[(i,False)]
            visiting=set()
            while stack:
                j,exit_node=stack.pop()
                if j in normal:
                    continue
                spec=desc[j]
                if exit_node:
                    visiting.remove(j)
                    key=(spec[0],*(normal[root(k)] for k in spec[1:])) if spec else ('var',j)
                    normal[j]=shared.setdefault(key,len(shared))
                elif j in visiting:
                    return False
                else:
                    visiting.add(j)
                    stack.append((j,True))
                    if spec:
                        stack.extend((root(k),False) for k in spec[1:])
        if any(normal[root(l)]!=normal[root(r)] for l,r in queries):
            return False
    return True


def check():
    a,b=F('a'),F('b')
    x=V('x')
    source=[([(a,b)],(f(x,a),f(b,b))),([],(x,a)), ([(a,f(a,b))],(x,f(a,b)))]
    paths=[[((0,),0,1),((1,),0,1)],[],[((),0,1)]]
    systems,data,proofs=chains.colored_proof(source,['a','b'],{'x':a},paths)
    c=Compiler(systems,[0,0,1])
    rows=c.branches()
    ans=c.certificate(data,proofs)
    assert verify(ans,rows)
    def bundle(eqs):
        return [(spine([l for l,_ in eqs]),spine([r for _,r in eqs]))]
    assert verify(ans,[(bundle(p),bundle(q)) for p,q in rows])
    corrupted=[(l,A if l==V(('Y',0)) else r) for l,r in ans]
    assert not verify(corrupted,rows)
    # A later proof may actually reuse earlier rule slots. Asking the
    # earlier proof to reuse the later ones creates a cycle in the marker row.
    chain=[([(a,b)],(a,b)), ([(a,b)],(a,b)), ([],(x,x))]
    reuse=Compiler(chain,[0,0,1])
    cert=reuse.certificate({'x':a},[[ ((),0,1) ],[ ((),0,1) ],[]])
    def borrow(who,owner):
        rename={('slot',who,j,k):reuse.slot(owner,j,k) for j in range(2) for k in (0,1)}
        return [(l,t.once(r,rename) if l in (V(('Y',who)),V(('Z',who))) else r) for l,r in cert]
    assert verify(borrow(1,0),reuse.branches())
    assert not verify(borrow(0,1),reuse.branches())
    # Compare this verifier with the independent tree unifier on a small
    # instance, including a cyclic substitution and an unforced equality.
    for eqs,checks in [([(x,f(x,a))],[]), ([],[(x,a)]), ([(x,f(a,b))],[(x,f(a,b))])]:
        assert verify([],[(eqs,checks)])==t.answer([],[(eqs,checks)])
    # Inspect the patched tag on every compiled template in every mode.
    enc=c.enc
    fixed={x:enc.encode(value) for x,value in data.items()}
    count=0
    for i,templates in enumerate(c.templates):
        for j,raw in enumerate(templates):
            body=t.once(raw,fixed)
            mark=c.marker(f(A,A),[A,f(A,A),f(f(A,A),A)])
            changed=patch(body,SITE,mark)
            assert enc.state(mark)==0 and enc.parse(mark) is None
            assert enc.state(changed)==enc.state(body)==0
            assert enc.parse(changed)==enc.parse(body)
            for mode in range(enc.m+1):
                assert enc.decode(changed,mode)==enc.decode(body,mode)
                assert enc.decode(mark,mode)==enc.decode(A,mode)
                count+=1
    print(f'Checked the two single-equation branches over f/a, rejected a corrupted proof,')
    print(f'and verified {count:,} marker substitutions across all decoder modes.')


if __name__=='__main__':
    check()
