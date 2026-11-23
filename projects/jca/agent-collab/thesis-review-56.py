"""Exact index domains of cyclic constructor graphs with translation edges."""
from dataclasses import dataclass
from fractions import Fraction
from itertools import product
import z3


@dataclass(frozen=True)
class Edge:
    source: int
    target: int
    shift: tuple


def dot(left, right):
    return sum(a*b for a,b in zip(left, right, strict=True))


def reach(start, edges):
    seen = set(start)
    todo = list(seen)
    while todo:
        here = todo.pop()
        for there in edges.get(here, ()):
            if there not in seen:
                todo.append(there)
                seen.add(there)
    return seen


def adjacency(edges, reverse=False):
    result = {}
    for edge in edges:
        source, target = edge.source, edge.target
        if reverse:
            source, target = target, source
        result.setdefault(source, []).append(target)
    return result


def root_domain(root, guards, edges):
    """Rows a*x <= b. None means a cycle eventually violates a reachable row.

    A finite returned conjunction can also be inconsistent. Its feasibility
    is ordinary rational linear feasibility.
    """
    nodes = reach([root], adjacency(edges))
    edges = [edge for edge in edges if edge.source in nodes]
    normals = {a for node in nodes for a,b in guards.get(node, ())}
    result = {}
    for normal in normals:
        caps = {}
        for node in nodes:
            bounds = [b for a,b in guards.get(node, ()) if a == normal]
            if bounds:
                caps[node] = min(bounds)
        for _ in range(len(nodes)):
            new = dict(caps)
            for edge in edges:
                if edge.target in caps:
                    limit = caps[edge.target] - dot(normal, edge.shift)
                    if edge.source not in new or limit < new[edge.source]:
                        new[edge.source] = limit
            if new == caps:
                break
            caps = new
        else:
            return None
        result[normal] = caps[root]
    return result


def independent_membership(root, guards, edges, point):
    """Linear feasibility of upper potentials at nodes that can reach an observation."""
    forward = reach([root], adjacency(edges))
    backward = adjacency(edges, reverse=True)
    solver = z3.SolverFor("QF_LRA")
    for normal in {a for node in forward for a,b in guards.get(node, ())}:
        observed = {v for v in forward if any(a == normal for a,b in guards.get(v, ()))}
        live = forward & reach(observed, backward)
        potential = {v:z3.FreshReal("upper") for v in live}
        solver.add(potential[root] >= dot(normal, point))
        for v in observed:
            solver.add(*(potential[v] <= b for a,b in guards[v] if a == normal))
        for edge in edges:
            if edge.source in live and edge.target in live:
                solver.add(potential[edge.target] >= potential[edge.source] + dot(normal,edge.shift))
    decision = solver.check()
    assert decision != z3.unknown, solver.reason_unknown()
    return decision == z3.sat


@dataclass(frozen=True)
class AffineEdge:
    source: int
    target: int
    matrix: tuple
    shift: tuple


def direction(row):
    scale = next((abs(x) for x in row if x), 0)
    return (tuple(Fraction(x)/scale for x in row), scale) if scale else ((),0)


def affine_domains(root, guards, edges, library):
    """Use a supplied, checked library of oriented directions. Maximize the common bounds."""
    nodes = reach([root], adjacency(edges))
    edges = [e for e in edges if e.source in nodes]
    optimizer = z3.Optimize()
    caps, pending = {}, []
    def cap(v, row):
        key = v,row
        if key not in caps:
            if row not in library:
                raise ValueError(f"missing pullback direction {row} at {v}")
            caps[key] = z3.FreshReal("cap")
            pending.append(key)
        return caps[key]
    for v in nodes:
        for a,b in guards.get(v, ()):
            normal, scale = direction(a)
            optimizer.add(scale*cap(v,normal) <= b if scale else z3.BoolVal(0 <= b))
    while pending:
        target, row = pending.pop()
        for e in edges:
            if e.target != target:
                continue
            pulled = tuple(dot(row,col) for col in zip(*e.matrix,strict=True))
            normal, scale = direction(pulled)
            offset = dot(row,e.shift)
            incoming = scale*cap(e.source,normal) + offset if scale else offset
            optimizer.add(incoming <= caps[target,row])
    if caps:
        optimizer.maximize(sum(caps.values()))
    result = optimizer.check()
    if result == z3.unsat:
        return None
    assert result == z3.sat, optimizer.reason_unknown()
    model = optimizer.model()
    return {v:{a:model.eval(c).as_fraction() for (w,a),c in caps.items() if w == v} for v in nodes}


def verifies(guards, edges, domains, dim):
    """Check every original guard and every recursive edge on all admitted inputs."""
    x = [z3.FreshReal("index") for _ in range(dim)]
    def region(rows, p):
        return z3.And(*(dot(a,p) <= b for a,b in rows))
    def entails(first, second):
        s = z3.SolverFor("QF_LRA")
        s.add(first, z3.Not(second))
        return s.check() == z3.unsat
    for v, rows in domains.items():
        pre = region(rows.items(),x)
        if not entails(pre,region(guards.get(v,()),x)):
            return False
        for e in edges:
            if e.source == v:
                child = [dot(row,x)+b for row,b in zip(e.matrix,e.shift,strict=True)]
                if not entails(pre,region(domains[e.target].items(),child)):
                    return False
    return True


def affine_checks():
    a,b = (1,0),(0,1)
    swap = [AffineEdge(0,0,((0,2),(1,0)),(1,0)), AffineEdge(0,0,((0,1),(2,0)),(0,1))]
    guards = {0:[(a,0)]}
    result = affine_domains(0, guards, swap, {a,b})
    assert result == {0:{a:-1,b:-1}} and verifies(guards,swap,result,2)
    origin = AffineEdge(0,1,((0,),),(0,))
    assert affine_domains(0,{1:[((1,),0)]},[origin],{(1,)}) == {0:{},1:{(1,):0}}
    assert affine_domains(0,{1:[((1,),-1)]},[origin],{(1,)}) is None
    guard = {1:[((1,),3)]}
    cycle = [AffineEdge(0,1,((2,),),(1,)), AffineEdge(1,0,((1,),),(-2,))]
    bounds = affine_domains(0,guard,cycle,{(1,)})
    assert bounds == {0:{(1,):1},1:{(1,):3}} and verifies(guard,cycle,bounds,1)
    x,y = Fraction(1),Fraction(1,5)
    for _ in range(20):
        assert x <= 1
        x,y = (3*x-4*y)/5,(4*x+3*y)/5
    assert x > 1
    rotation = AffineEdge(0,0,((Fraction(3,5),Fraction(-4,5)),
                               (Fraction(4,5),Fraction(3,5))),(0,0))
    try:
        affine_domains(0,guards,[rotation],{a,b})
    except ValueError as err:
        assert "missing pullback" in str(err)
    else:
        raise AssertionError("the axis library is not closed under the rotation")


def check():
    # The successor field of Step : Tower n -> Tower(n+1) shifts by -1.
    loop = [Edge(0,0,(-1,))]
    assert root_domain(0, {}, loop) == {}
    assert root_domain(0, {0:[((1,),11)]}, loop) == {(1,):11}
    assert root_domain(0, {0:[((-1,),-1)]}, loop) is None

    # Horizontal drift is unobserved in its component. A sibling has an x cap.
    ex, ey = (1,0), (0,1)
    fork = [Edge(0,1,(2,0)), Edge(0,2,(0,1)), Edge(2,2,(1,0))]
    guards = {1:[(ex,5)], 2:[(ey,4)]}
    assert root_domain(0, guards, fork) == {ex:3, ey:3}
    assert root_domain(0, guards, fork+[Edge(2,1,(0,0))]) is None
    assert root_domain(0, {1:[((1,),0),((-1,),-1)]}, [Edge(0,1,(0,))]) == {(1,):0,(-1,):-1}

    # Fractional translations, opposing moves on a cycle and an oblique guard.
    half = Fraction(1,2)
    diagonal = {1:[((1,1),3)]}
    legs = [Edge(0,1,(half,1)), Edge(1,0,(-half,-1))]
    assert root_domain(0, diagonal, legs) == {(1,1):3-half-1}

    count = 0
    rows = {0:[((1,),2)], 1:[((-1,),1)]}
    for choices in product([None,-1,0,1], repeat=4):
        edges = [Edge(i//2,i%2,(d,)) for i,d in enumerate(choices) if d is not None]
        for root in [0,1]:
            domain = root_domain(root,rows,edges)
            for x in [-3,-1,0,2,4]:
                predicted = domain is not None and all(dot(a,(x,)) <= b for a,b in domain.items())
                assert predicted == independent_membership(root,rows,edges,(x,)), (root,edges,x,domain)
                count += 1
    affine_checks()
    print(f"Affine-domain and rotation checks passed. Translation domains passed {count} independent linear-potential checks.")


if __name__ == "__main__":
    check()
