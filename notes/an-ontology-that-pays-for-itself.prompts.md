# Prompts for An Ontology That Pays for Itself

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted.*

## Starting point

What do you think of this paper? The "Unsupervised Semantic Parsing" line of work lies somewhere in its scope. Can this be used for large-scale machine learning via learning-as-compression?

https://arxiv.org/html/1901.01341v1

## Scoring and search

Yes, USP's lambdas are a red herring, it's about structural clustering with probabilistically motivated scoring (compression in the sense of maximizing the corpus probability under the hypothesis)

Can compose be helped by a parameterized amortized approach, if we draw on neural grammar induction research?

Can q_φ be fine-tuned from a pretrained LLM, by leveraging in-context learning?

## The goal

The goal here is not to build a specific parser, but to build an ontology which could serve in something like a neurosymbolic Cyc.

What about an LLM-inspired fix direction? Don't model absolute P(corpus), model probabilities conditioned on provenance

## The representation

Is the following format a good direction for the ontology? IS-A asymetric relations;  <A, R, S, B> symmetric relations i.e. it's the same as <B, S, R, A> and A, R, S, B are concepts; the relations are also concepts and <A, R, S, B> IS-A <R, R, S, S>.

Q1: yest to Davidsonian semantics. Q2: yes to fine-grained roles required. Q3: note the symmetry implies ∀∃ and ∃∀; so only <Dog, whole, part, DogLeg> is valid. Q4: conflate and pursue something like term logic, without individual-class distinction. This might lead to contradictions / paradoxes, but is the spirit of this approach. Q5: this wouldn't work because non-roles couldn't participate in relations. Also <Role, Role, Role, Role> = Role so that reification works. Q6: yes IS-A is primitive.

Maybe we need a separate meta-relation for provenance? This third meta-relation wouldn't need distinguishing stetement from assertion, because it would only be valid when asserted. Does that make sense? Then asserting of IS-A and <....> would factor through the provenance relation.

## Turning it into an essay

Sounds good! Is this setup and your findings worth turning into an essay?

Commit and draft the essay, thanks! You can assume the Adaptive Reasoning essay goes first / together with this one.
