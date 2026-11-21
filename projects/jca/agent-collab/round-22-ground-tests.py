"""One branch whose premise fixes every asymmetrically tested output to a ground tree."""
import importlib.util
from itertools import combinations, permutations, product
from pathlib import Path

spec = importlib.util.spec_from_file_location('one_input', Path(__file__).with_name('round-21-one-input.py'))
prior = importlib.util.module_from_spec(spec)
spec.loader.exec_module(prior)
inp = prior.inp
V, F, apply, unify = inp.V, inp.F, inp.apply, inp.unify


def sites(tree, path=()):
    yield path, tree
    for i, child in enumerate(tree[1:], 1):
        yield from sites(child, path+(i,))


def replace_sites(tree, replacements, path=()):
    if path in replacements:
        return V(replacements[path])
    return F(tree[0], *(replace_sites(child, replacements, path+(i,))
                        for i, child in enumerate(tree[1:], 1)))


def antichains(tree, names):
    choices = list(sites(tree))

    def extend(i, used):
        if i == len(names):
            yield used
            return
        yield from extend(i+1, used)
        for path, _ in choices:
            if all(p[:len(path)] != path and path[:len(p)] != p for p in used):
                yield from extend(i+1, {**used, path:names[i]})
    yield from extend(0, {})


def solve(data, moves, premise, conclusion, base=('a',), *, singleton=False):
    outputs = {y: [h for q, h in moves[:i] if q == 'all']
               for i, (q0, y) in enumerate(moves) if q0 == 'some'}
    if singleton:
        return dict.fromkeys([*data, *outputs], base)
    mu = unify(premise)
    if mu is None:
        return None
    pins = {}
    for y in outputs:
        if any(set(prior.positions(l, y)) != set(prior.positions(r, y)) for l, r in premise):
            pins[y] = apply(V(y), mu)
            if inp.vars_in(pins[y]):
                raise ValueError(f'premise does not ground asymmetric output {y!r}')
    # Symmetric leaves can be erased from D. At every active input a pinned
    # output has its known value in C, even if its body varies off that set.
    reduced = inp.map_eqs(premise, {y:pins.get(y, base) for y in outputs})
    need = inp.map_eqs(conclusion, pins)
    remaining = [(q, x) for q, x in moves if x not in pins]
    ordered = list(pins)
    def markings(i, chosen):
        if i == len(ordered):
            yield chosen
            return
        y = ordered[i]
        for mark in antichains(pins[y], outputs[y]):
            yield from markings(i+1, [*chosen, mark])
    for marks in markings(0, []):
        tests, bodies = [], {}
        for (y, tree), mark in zip(pins.items(), marks):
            positions = dict(sites(tree))
            tests.extend((V(h), positions[p]) for p,h in mark.items())
            bodies[y] = replace_sites(tree, mark)
        strategy = inp.solve(data, remaining, reduced + tests, need, base)
        if strategy is not None:
            strategy.update(bodies)
            witness = unify(inp.map_eqs(premise, strategy))
            assert witness is not None
            assert all(apply(l,witness) == apply(r,witness)
                       for l,r in inp.map_eqs(conclusion, strategy))
            return strategy
    return None


def check_coloring_family():
    a, f = F('a'), lambda x,y:F('f',x,y)
    colors = [a,f(a,a),f(f(a,a),a)]
    marker = a
    for _ in range(6):
        marker = f(marker,a)
    def entry(x,y):
        return f(marker,f(x,y))
    def lst(items):
        tail = a
        for item in reversed(items):
            tail = f(item,tail)
        return tail
    palette = lst([entry(x,y) for x,y in permutations(colors,2)])
    # Read the relation out of the actual pin, including all nested subterms.
    table = {(s[2][1],s[2][2]) for s in inp.subterms(palette)
             if s[0]=='f' and s[1]==marker and s[2][0]=='f'}
    assert table == set(permutations(colors,2))
    edges = list(combinations(range(4),2))
    for flags in product((False,True),repeat=len(edges)):
        selected = [e for e,take in zip(edges,flags) if take]
        pin = lst([palette]*len(selected))
        vars_ = [V(f'h{i}') for i in range(len(selected))]
        for values in product(colors, repeat=4):
            if not all((values[i],values[j]) in table for i,j in selected):
                continue
            blocks = [prior.insert(palette,entry(values[i],values[j]),h)
                      for h,(i,j) in zip(vars_,selected)]
            body = lst(blocks)
            active = unify([(body,pin)])
            assert active is not None
            assert all(apply(h,active) == entry(values[i],values[j])
                       for h,(i,j) in zip(vars_,selected))
            break
        else:
            assert all(flags)  # K4


def check():
    a,b = F('a'),F('b')
    h,k,y,z = map(V,('h','k','y','z'))
    f = lambda l,r: F('f',l,r)
    moves = [('all','h'),('all','k'),('some','y'),('some','z')]
    # A duplicated occurrence of h needs only one retained hole.
    answer = solve([],moves,[(y,f(a,a)),(z,z)],[(h,a),(z,k)])
    assert answer is not None and answer['z']==k
    assert solve([],moves,[(y,f(a,b))],[(h,a),(k,b)]) is not None
    assert solve([],moves,[(y,f(a,b))],[(h,a),(k,a)]) is None
    # The two data-pin examples after choosing the exhibited or forced datum.
    assert solve([],moves,[(y,f(f(a,a),a))],[(h,f(a,a)),(k,a)]) is not None
    assert solve([],moves,[(y,f(a,a))],[(h,f(a,a)),(k,a)]) is None
    # The pin can follow from several atoms. A symmetric output can still vary.
    assert solve([],moves,[(y,f(a,z)),(z,b)],[(h,a),(k,b)]) is not None
    assert solve([],moves,[(f(y,z),f(a,z))],[(h,a),(z,k)]) is not None
    # Exhaust the two-constant algebra, two inputs and two outputs. One pin
    # has exactly three viable bodies: its own value, h or k.
    terms = [a,b,h,k,y,z]
    cases = 0
    for lit, (l,r) in product((a,b),product(terms,repeat=2)):
        premise, conclusion = [(y,lit)],[(l,r)]
        found = solve([],moves,premise,conclusion)
        exists = False
        for by,bz in product((a,b,h,k),repeat=2):
            active = unify([(by,lit)])
            eq, = inp.map_eqs(conclusion,{'y':by,'z':bz})
            if active is not None and apply(eq[0],active)==apply(eq[1],active):
                exists = True
                break
        assert (found is not None)==exists
        cases += 1
    check_coloring_family()
    print(f'{cases} exact two-input comparisons, pin examples and 64 encoded graphs passed.')


if __name__ == '__main__':
    check()
