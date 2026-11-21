"""Compile typed tiling arrays to two input-only branches over one binary constructor."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location("tiling", Path(__file__).with_name("round-45-tiling.py"))
tiling = module_from_spec(spec)
spec.loader.exec_module(tiling)
V, f, anchor = tiling.V, tiling.f, tiling.anchor
trees, verify = tiling.binary.t, tiling.binary.verify


class PairInstance:
    def __init__(self, typed):
        self.typed = typed
        self.branches = [([],[]), ([],[])]
        self.row, self.bodies, self.right = {}, {}, {}
        for name,(alpha,depth) in typed.types.items():
            self.right[name] = self.vertex(1,name,name,alpha,depth)
        for j in range(typed.n):
            src = ("packed",j)
            dest = tiling.board(j)
            old, new = tiling.tile_alphabet(j), tiling.tile_alphabet(j+1)
            pairs = typed.alphabets[typed.types[src][0]][0]
            self.link(src,dest,{p:f(self.color(1,old,p[0]),self.color(1,old,p[1])) for p in pairs})
            for i in (0,1):
                self.link(src,("half",j,i),{p:self.color(1,new,p[i]) for p in pairs})
        for src,j,left,right in typed.edges:
            pairs = typed.alphabets[typed.types[src][0]][0]
            for i,path in enumerate((left,right)):
                self.link(src,typed.cut(j,path)[1],{p:self.color(1,tiling.tile_alphabet(j),p[i]) for p in pairs})
        # Remaining statements are structural equations in stored right arrays.
        env = {**self.right,**{tiling.letter(alpha,t)[1]:self.color(1,alpha,t)
                              for alpha,(labels,_) in typed.alphabets.items() for t in labels}}
        for lhs,rhs in typed.expand[1]:
            if trees.is_var(lhs) and lhs[1][0] == "packed":
                continue
            self.branches[1][1].append((trees.once(lhs,env),trees.once(rhs,env)))

    def color(self, side, alpha, label):
        name = ("color",side,alpha,label)
        lookup = alpha if side==1 else self.typed.types[alpha[0]][0]
        self.row[name] = anchor(self.typed.alphabets[lookup][1])
        return V(name)

    def output(self, key, source, alpha, depth, observations):
        labels,rank = self.typed.alphabets[alpha]
        mapping = {}
        for t in labels:
            port = ("port",key,t)
            mapping[tiling.letter(alpha,t)[1]] = V(port)
            self.row[port] = anchor(rank)
            for side,image in enumerate(observations(t)):
                self.branches[side][0].append((V(port),image))
        name = ("out",key)
        self.row[name] = anchor(rank+depth)
        self.bodies[name] = source,mapping
        return V(name)

    def vertex(self, side, key, source, alpha, depth):
        opposite = 1-side
        labels,rank = self.typed.alphabets[alpha]
        color_set = alpha if side==1 else key
        copies = []
        for copy in (0,1):
            tag = ("check",side,key,copy)
            regs = [("register",tag,i) for i in range(depth+1)]
            for i,reg in enumerate(regs):
                self.row[reg] = anchor(rank+i)
                if i:
                    last = V(regs[i-1])
                    self.branches[opposite][0].append((V(reg),f(last,last)))
            def views(t):
                color, marker = self.color(side,color_set,t), V(regs[0])
                return (color,marker) if side==0 else (marker,color)
            checker = self.output(tag,source,alpha,depth,views)
            self.branches[opposite][1].append((checker,V(regs[-1])))
            copies.append(checker)
        self.branches[side][1].append(tuple(copies))
        return copies[0]

    def link(self, source, target, images):
        alpha,depth = self.typed.types[source]
        # A distinct left alphabet for this occurrence distinguishes the
        # two projections even when both targets have the same tile alphabet.
        key = (source,target)
        left = self.vertex(0,key,source,alpha,depth)
        for kind,dest in (("copy",source),("map",target)):
            def views(t):
                right = self.color(1,alpha,t) if kind=="copy" else images[t]
                return self.color(0,key,t),right
            value = self.output((kind,key),source,alpha,depth,views)
            self.branches[0][1].append((value,left))
            self.branches[1][1].append((value,self.right[dest]))

    def lift(self, answer):
        original = {lhs[1]:rhs for lhs,rhs in answer}
        return [(V(name),trees.once(original[source],mapping))
                for name,(source,mapping) in self.bodies.items()]


def pointwise_feasible(compiled):
    """Check first-order feasibility at each individual and joint generic input."""
    outputs = set(compiled.bodies)
    inputs = set(compiled.row)-outputs
    rigid = {name: (("rigid",name),) for name in inputs}
    for active in ((0,), (1,), (0,1)):
        ds = [eq for i in active for eq in compiled.branches[i][0]]
        mu = trees.unify(ds)
        if mu is None:
            continue
        obs = {h:trees.once(trees.apply(V(h),mu),rigid) for h in inputs}
        cs = [(trees.once(l,obs),trees.once(r,obs)) for i in active for l,r in compiled.branches[i][1]]
        if trees.unify(cs) is None:
            return False
    return True


def check_diagonal(n):
    tiles = tuple(product(range(2),repeat=2))
    h = [(l,r) for l,r in product(tiles,repeat=2) if l[0]==r[1]]
    v = [(l,r) for l,r in product(tiles,repeat=2) if l[1]==r[0]]
    typed = tiling.Instance(n,tiles,h,v,[])
    compiled = PairInstance(typed)
    # Define the whole first row with only three doubling recurrences.
    # These extra existential coordinates occur solely in the right conclusion.
    facts, bodies = [], []
    previous = {}
    for i in range(n):
        current = {}
        for t in [(0,0),(1,0),(0,1)]:
            name = ("initial",t,i)
            current[t] = V(name)
            rhs = compiled.color(1,tiling.tile_alphabet(n),t) if i==0 else f(previous[t],previous[0,0])
            facts.append((V(name),rhs))
            bodies.append((V(name),trees.once(rhs,{l[1]:r for l,r in bodies})))
            compiled.row[name] = anchor(n+i)
        previous = current
    first = compiled.right[typed.cut(n,(0,)*n)[1]]
    facts.append((first,f(previous[1,0],previous[0,1])))
    compiled.branches[1][1].extend(facts)
    size = 2**n
    grid = [[(int(x==y),int((x-1)%size==y)) for x in range(size)] for y in range(size)]
    actual = typed.candidate(grid)
    assert verify([*compiled.lift(actual),*bodies],compiled.branches)
    blank = typed.candidate([[(0,0)]*size for _ in range(size)])
    assert not verify([*compiled.lift(blank),*bodies],compiled.branches)
    assert verify([(V(k),v) for k,v in compiled.row.items()],compiled.branches)
    word = dict((l[1],r) for l,r in actual)[tiling.board(0)]
    row_subtrees = [word]
    for _ in range(n):
        row_subtrees = [c for t in row_subtrees for c in t[1:]]
    assert len(set(row_subtrees)) == size


def check():
    allpairs = tuple(product(range(2),repeat=2))
    equal,flip = ((0,0),(1,1)),((0,1),(1,0))
    count = 0
    for n,h,v in [(1,flip,equal),(1,((0,1),),allpairs),(2,equal,flip),(3,flip,equal)]:
        typed = tiling.Instance(n,(0,1),h,v,[0])
        compiled = PairInstance(typed)
        ground = [(V(name),t) for name,t in compiled.row.items()]
        assert len(compiled.branches)==2 and verify(ground,compiled.branches)
        assert pointwise_feasible(compiled)
        side = 2**n
        boards = (product(range(2),repeat=4) if n==1 else
                  (tuple(((y if h==equal else x)%2) ^ (bad and x==2 and y==1)
                         for y in range(side) for x in range(side)) for bad in (False,True)))
        for raw in boards:
            grid = [raw[y*side:(y+1)*side] for y in range(side)]
            expected = grid[0][0]==0 and all(
                (grid[y][x],grid[y][(x+1)%side]) in h and (grid[y][x],grid[(y+1)%side][x]) in v
                for x,y in product(range(side), repeat=2))
            ans = compiled.lift(typed.candidate(grid))
            assert verify(ans,compiled.branches) == expected
            assert verify(ground,[([],ans)])
            count += 1
        # A checker returning its available depth register passes the shape
        # observation but disagrees with its independent twin in the other one.
        tag = ("check",1,tiling.board(0),0)
        src = V(("out",tag))
        cheat = [(l,V(("register",tag,2*n)) if l==src else r) for l,r in ans]
        lrow,rrow = compiled.branches
        assert verify(cheat,[(lrow[0],[(src,V(("register",tag,2*n)))])])
        twin = V(("out",("check",1,tiling.board(0),1)))
        assert not verify(cheat,[(rrow[0],[(src,twin)])])
    for n in (1,2,3):
        check_diagonal(n)
    print(f"Verified three forced diagonals and the two-branch encoding on {count} tori, its common rows, and the rejected register shortcut.")


if __name__ == "__main__":
    check()
