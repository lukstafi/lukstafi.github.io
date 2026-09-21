"""Finite checks for the three-variable equality-only result in Round 11.

Enumerate every depth-one tuple over a,b and three parameters, compare its
entire equality-premise profile with all canonical constructor-free profiles,
and check the constructive normalization used in the proof. Optional random
samples exercise deeper terms; neither experiment replaces the proof.

Run:
    python3 projects/jca/agent-collab/round-11-flat-profiles.py
    python3 projects/jca/agent-collab/round-11-flat-profiles.py --random 100000

Python standard library only. The Round 10 unifier supplies the term algebra.
"""

import argparse
from functools import lru_cache
import importlib.util
from itertools import combinations, product
from pathlib import Path
import random
from time import perf_counter


ROUND10_PATH = Path(__file__).with_name('round-10-experiments.py')
SPEC = importlib.util.spec_from_file_location('round10', ROUND10_PATH)
round10 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(round10)

V, F = round10.V, round10.F
A, B = F('a'), F('b')
NAMES = ('x', 'y', 'z')
COORDINATES = tuple(map(V, NAMES))
LEAVES = (A, B, V('p'), V('q'), V('r'))
ATOMS = tuple(combinations(COORDINATES + (A, B), 2))


def equality_mask(substitution):
    """All equalities between coordinates and constants entailed by an mgu."""
    return sum(1 << index for index, (left, right) in enumerate(ATOMS)
               if round10.apply(left, substitution)
               == round10.apply(right, substitution))


def all_flat_premises():
    """The 37 partitions of x,y,z,a,b in which a and b remain distinct."""
    premises = {}
    for pattern in product(LEAVES, repeat=3):
        mu = round10.unify(round10.pattern_answer(NAMES, pattern))
        mask = equality_mask(mu)
        premises[mask] = tuple(atom for index, atom in enumerate(ATOMS)
                               if mask & (1 << index))
    assert len(premises) == 37
    return tuple(premises.values())


PREMISES = all_flat_premises()


def profile(pattern):
    """For each premise: None if inconsistent, otherwise its consequence mask."""
    equations = round10.pattern_answer(NAMES, pattern)
    result = []
    for premise in PREMISES:
        mu = round10.unify(equations + list(premise))
        result.append(None if mu is None else equality_mask(mu))
    return tuple(result)


def dominates(candidate, original):
    """Candidate passes every equality-only branch passed by original."""
    return all(old is None or new is not None and old & ~new == 0
               for new, old in zip(candidate, original))


def normalize_three_coordinates(pattern):
    """The constructor-free replacement in the three-variable proof."""
    compounds = [index for index, term in enumerate(pattern)
                 if term[0] == 'f']
    fresh = V('normalization_fresh')
    if not compounds:
        return pattern
    if len(compounds) == 3:
        return (fresh, fresh, fresh)
    result = list(pattern)
    if len(compounds) == 1:
        result[compounds[0]] = fresh
        return tuple(result)

    first, second = compounds
    other = next(index for index in range(3) if index not in compounds)
    remaining = pattern[other]
    result[first] = result[second] = fresh
    if round10.is_var(remaining):
        mu = round10.unify([(pattern[first], pattern[second])])
        if mu is not None:
            value = round10.apply(remaining, mu)
            if value in (A, B):
                result[first], result[second] = remaining, value
    return tuple(result)


@lru_cache(maxsize=None)
def flat_profile(pattern):
    return profile(pattern)


def run(random_samples=0, random_depth=3, seed=47535):
    start = perf_counter()
    flat_profiles = {profile(pattern)
                     for pattern in product(LEAVES, repeat=3)}
    assert len(flat_profiles) == 37
    seen = set()

    def check(pattern):
        original = profile(pattern)
        if original not in seen:
            assert any(dominates(candidate, original)
                       for candidate in flat_profiles), pattern
            seen.add(original)
        normalized = normalize_three_coordinates(pattern)
        assert dominates(flat_profile(normalized), original), (
            pattern, normalized)

    terms = LEAVES + tuple(F('f', left, right)
                           for left, right in product(LEAVES, repeat=2))
    exhaustive_count = 0
    for pattern in product(terms, repeat=3):
        check(pattern)
        exhaustive_count += 1
    assert exhaustive_count == 27000
    assert len(seen) == 198
    print('PASS: 27,000 depth-one tuples; 198 profiles; each dominated by a '
          'flat pattern and by the constructive normalization; '
          '37 premises and 37 flat profiles', flush=True)

    if random_samples:
        rng = random.Random(seed)

        def random_term(depth):
            if depth == 0 or rng.random() < 0.3:
                return rng.choice(LEAVES)
            return F('f', random_term(depth - 1), random_term(depth - 1))

        for _ in range(random_samples):
            check(tuple(random_term(random_depth) for _ in range(3)))
        print(f'PASS: {random_samples:,} random tuples of maximum depth '
              f'{random_depth}; seed {seed}; {len(seen)} profiles in total',
              flush=True)
    print(f'Elapsed: {perf_counter() - start:.2f}s', flush=True)


def nonnegative(value):
    parsed = int(value)
    if parsed < 0:
        raise argparse.ArgumentTypeError('must be nonnegative')
    return parsed


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--random', type=nonnegative, default=0,
                        help='number of additional seeded random tuples')
    parser.add_argument('--depth', type=nonnegative, default=3,
                        help='maximum depth of random terms (default: 3)')
    parser.add_argument('--seed', type=int, default=47535)
    args = parser.parse_args()
    run(args.random, args.depth, args.seed)
