"""Check the single literal occurrence in two fixed JCA templates."""
from importlib.util import module_from_spec, spec_from_file_location
from itertools import product
from pathlib import Path

spec = spec_from_file_location("binary", Path(__file__).with_name("round-25-binary.py"))
binary = module_from_spec(spec)
spec.loader.exec_module(binary)
chains = binary.chains
F, V, f = binary.F, binary.V, binary.f
alphabet = ["end", "b", "c"]
end = F("end")
z = V("z")


def compile_word(word, in_conclusion):
    literal = end
    for letter in reversed(word):
        literal = f(F(letter), literal)
    pin = (literal, z) if in_conclusion else (z, literal)
    # The fixed ground rule deletes a terminal b. Pinning z to the word
    # makes the resulting source system solvable precisely on b*.
    source = [([(f(F("b"), end), end)], (z, end)), ([], pin)]
    systems = chains.color_instance(source, alphabet)
    compiler = binary.Compiler(systems, [0, 0, 1])
    rows = compiler.branches()
    packed = {}
    for row, parts in enumerate(rows):
        for part, equations in enumerate(parts):
            for side in (0, 1):
                packed[row, part, side] = binary.spine([eq[side] for eq in equations])
    return literal, source, compiler, packed


def locate(old, new, before, after, path=()):
    if old == new:
        return []
    if old == before and new == after:
        return [path]
    assert old[0] == new[0] == "f"
    return [p for j in (0, 1)
            for p in locate(old[1+j], new[1+j], before, after, path+(j,))]


def check(in_conclusion):
    _, _, base_compiler, template = compile_word("", in_conclusion)
    literal, _, _, one = compile_word("b", in_conclusion)
    def code(term):
        return base_compiler.enc.encode(chains.shade(1, term))
    empty = code(end)
    pos, = (pos for pos in template if template[pos] != one[pos])
    assert pos == ((0, 1, 1) if in_conclusion else (1, 0, 1))
    path, = locate(template[pos], one[pos], empty, code(literal))
    words = ["".join(letters) for n in range(4) for letters in product("bc", repeat=n)]
    for word in words:
        literal, source, compiler, actual = compile_word(word, in_conclusion)
        expected = template.copy()
        expected[pos] = binary.patch(template[pos], path, code(literal))
        assert actual == expected
        accepts = chains.congruent(source[0][0], literal, end)
        assert accepts == ("c" not in word)
        if accepts:
            rewrites = [(tuple([1]*depth), 0, 1) for depth in reversed(range(len(word)))]
            _, data, proofs = chains.colored_proof(source, alphabet, {"z":literal}, [rewrites, []])
            answer = compiler.certificate(data, proofs)
            packed_rows = [([(actual[r,0,0], actual[r,0,1])],
                            [(actual[r,1,0], actual[r,1,1])]) for r in (0,1)]
            assert binary.verify(answer, packed_rows)
    return len(words)


if __name__ == "__main__":
    count = check(False) + check(True)
    print(f"Verified one literal occurrence in {count} compiled instances across both placements.")
