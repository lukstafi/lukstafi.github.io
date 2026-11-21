"""Compile exponential torus tiling to five equational implications sharing one row."""
from functools import cache
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location("binary", Path(__file__).with_name("round-25-binary.py"))
binary = module_from_spec(spec)
spec.loader.exec_module(binary)
V, a = binary.t.V, ("a",)


def f(l, r):
    return ("f", l, r)


@cache
def anchor(depth):
    return a if depth == 0 else f(anchor(depth-1), anchor(depth-1))


def tile_alphabet(level):
    return ("tiles", level)


def letter(alphabet, label):
    return V(("letter", alphabet, label))


def board(level):
    return ("board", level)


def place(address, bits):
    return sum(bit << i for i,bit in enumerate(address[:bits]))


def bits_lsb(x, count):
    return tuple((x >> i) & 1 for i in range(count))


def neighboring_prefixes(count):
    for j in range(count):
        yield (1,)*j+(0,), (0,)*j+(1,)
    yield (1,)*count, (0,)*count  # The torus also has a wraparound edge.


class Instance:
    def __init__(self, n, tiles, horizontal, vertical, initial):
        self.n, self.tiles = n, tuple(tiles)
        self.types, self.alphabets, self.row = {}, {}, {}
        self.shape = [([],[]), ([],[])]
        self.expand, self.proj = ([],[]), [([],[]), ([],[])]
        self.branches = [*self.shape, self.expand, *self.proj]
        self.cuts, self.edges = {}, []
        d = 2*n
        for j in range(n+1):
            alpha = tile_alphabet(j)
            self.alphabet(alpha, tiles, j)
            self.output(board(j), alpha, d)
        for j in range(n):
            old, new, pairs = tile_alphabet(j), tile_alphabet(j+1), ("pairs",j)
            self.alphabet(pairs, product(tiles, repeat=2), j+1)
            packed = self.output(("packed",j), pairs, d-1)
            halves = [self.output(("half",j,i), new, d-1) for i in range(2)]
            for (l,r) in self.alphabets[pairs][0]:
                p = letter(pairs,(l,r))
                self.expand[0].append((p, f(letter(old,l),letter(old,r))))
                for i,t in enumerate((l,r)):
                    self.proj[i][0].append((p,letter(new,t)))
            self.expand[1].extend([(packed,V(board(j))), (V(board(j+1)),f(*halves))])
            for i,half in enumerate(halves):
                self.proj[i][1].append((packed,half))
        for label,j,relation in [("horizontal",0,horizontal), ("vertical",n,vertical)]:
            edges = ("edges",label)
            self.alphabet(edges, relation, j)
            for pair in self.alphabets[edges][0]:
                for i,t in enumerate(pair):
                    self.proj[i][0].append((letter(edges,pair),letter(tile_alphabet(j),t)))
            for i,(left,right) in enumerate(neighboring_prefixes(n)):
                key = ("neighbors",label,i)
                self.edges.append((key, j, left, right))
                edge = self.output(key, edges, d-len(left))
                for k,path in enumerate((left,right)):
                    self.proj[k][1].append((edge,self.cut(j,path)))
        for x,t in enumerate(initial):
            path = bits_lsb(x,n)+(0,)*n
            self.expand[1].append((self.cut(0,path),letter(tile_alphabet(0),t)))
        self.add_shape_tests()

    def alphabet(self, key, labels, rank):
        labels = tuple(labels)
        self.alphabets[key] = labels,rank
        for label in labels:
            self.row[letter(key,label)[1]] = anchor(rank)

    def output(self, name, alphabet, depth):
        self.types[name] = alphabet,depth
        self.row[name] = anchor(self.alphabets[alphabet][1]+depth)
        return V(name)

    def cut(self, level, path):
        if not path:
            return V(board(level))
        parent = path[:-1]
        if (level,parent) not in self.cuts:
            root = self.cut(level,parent)
            names = [("subtree",level,parent+(i,)) for i in (0,1)]
            self.cuts[level,parent] = names
            children = [self.output(name,tile_alphabet(level),2*self.n-len(path)) for name in names]
            self.expand[1].append((root,f(*children)))
        return V(self.cuts[level,parent][path[-1]])

    def add_shape_tests(self):
        for alpha,(labels,rank) in self.alphabets.items():
            for copy,(premise,conc) in enumerate(self.shape):
                names = [("shape",alpha,copy,i) for i in range(2*self.n+1)]
                for i,name in enumerate(names):
                    self.row[name] = anchor(rank+i)
                    if i:
                        child = V(names[i-1])
                        premise.append((V(name),f(child,child)))
                premise.extend((letter(alpha,t),V(names[0])) for t in labels)
                for name,(kind,depth) in self.types.items():
                    if kind == alpha:
                        conc.append((V(name),V(names[depth])))

    def candidate(self, grid):
        """Fill typed bodies from one grid. An illegal edge uses a legal fallback."""
        n, d = self.n, 2*self.n
        values = {}
        def grid_tree(path, order):
            if len(path)==d:
                address = dict(zip(order,path))
                x = place([address[i] for i in range(n)],n)
                y = place([address[n+i] for i in range(n)],n)
                return grid[y][x]
            return (grid_tree(path+(0,),order),grid_tree(path+(1,),order))
        def at(t, path):
            for i in path:
                t = t[i]
            return t
        def zip_tree(left, right, depth, allowed):
            if not depth:
                pair = (left,right)
                return pair if pair in allowed else allowed[0]
            return tuple(zip_tree(l,r,depth-1,allowed) for l,r in zip(left,right))
        order = list(range(d))
        for j in range(n+1):
            values[board(j)] = grid_tree((),order)
            if j:
                for i in (0,1):
                    values["half",j-1,i] = values[board(j)][i]
            if j<n:
                # At depth d-1 each bottom sibling pair is one alphabet label.
                values["packed",j] = values[board(j)]
                order = [order[-1],*order[:-1]]
        for (j,parent),children in self.cuts.items():
            for i,name in enumerate(children):
                values[name] = at(values[board(j)],parent+(i,))
        for key,j,left,right in self.edges:
            alpha,depth = self.types[key]
            values[key] = zip_tree(at(values[board(j)],left),at(values[board(j)],right),
                                   depth,self.alphabets[alpha][0])
        def encode(t, depth, alpha):
            if depth == 0:
                return letter(alpha,t)
            return f(*(encode(c,depth-1,alpha) for c in t))
        return [(V(name),encode(values[name],depth,alpha)) for name,(alpha,depth) in self.types.items()]


def check():
    tiles = (0,1)
    allpairs = tuple(product(tiles,repeat=2))
    equal, flip = ((0,0),(1,1)), ((0,1),(1,0))
    count = 0
    for n,h,v,initial in [(1,flip,equal,[0]),(1,equal,flip,[0,0]),
                           (1,allpairs,((0,1),),[0]),(2,flip,equal,[0,1]),(3,equal,flip,[0,0])]:
        case = Instance(n,tiles,h,v,initial)
        side = 2**n
        grids = (product(tiles,repeat=4) if n==1 else
                 (tuple(((x if h==flip else y)%2) ^ (change and x==1 and y==2)
                        for y in range(side) for x in range(side)) for change in [False,True]))
        ground = [(V(name),val) for name,val in case.row.items()]
        assert binary.verify(ground,case.branches)
        for flat in grids:
            grid = [flat[y*side:(y+1)*side] for y in range(side)]
            expected = list(grid[0][:len(initial)])==initial and all(
                (grid[y][x],grid[y][(x+1)%side]) in h and (grid[y][x],grid[(y+1)%side][x]) in v
                for x,y in product(range(side),repeat=2))
            answer = case.candidate(grid)
            assert binary.verify(answer,case.branches)==expected
            assert binary.verify(ground,[([],answer)])
            count += 1
        fake = [(l,V(("shape",tile_alphabet(0),0,2*n)) if l==V(board(0)) else r) for l,r in answer]
        assert binary.verify(fake,[case.shape[0]])
        assert not binary.verify(fake,[case.shape[1]])
    print(f"Verified the five compiled implications on {count} tori, both shape probes, and every explicit common row.")


if __name__ == "__main__":
    check()
