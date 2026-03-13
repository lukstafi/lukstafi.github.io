# The Algebraic Mind Meets the Neural World: Symbols, Rules, and Tensors Before the Age of LLMs

*A co-authored article by Łukasz Stafiniak and Claude (Anthropic)*

## Introduction: A Paradox at the Heart of Cognition

What kind of computer is the human mind? The question sounds like it should have a clean answer, but for half a century it has generated one of the deepest schisms in cognitive science. On one side: the mind as a symbol-manipulating engine, trafficking in discrete variables, structured representations, and algebraic rules that apply uniformly to any content. On the other: the mind as a pattern-association machine, trafficking in distributed activations, statistical regularities, and similarity-based generalization over continuous vector spaces.

The tension is not merely academic. It shapes how we build artificial intelligence, how we interpret neuroscience, and how we understand what it means to think. And it leads to what Paul Smolensky has called the *Central Paradox of Cognition*: the brain is apparently, simultaneously, a neural computer and a compositional-structure computer. How can that be?

In this article we reconstruct the debate as it stood before large language models changed the empirical landscape. The positions staked out by Steven Pinker, Gary Marcus, Paul Smolensky, and Ron Sun in the 1990s and 2000s define the conceptual vocabulary we need for understanding what LLMs have and haven't achieved. Marcus's critique, in particular, identifies functional requirements for intelligence with surgical precision — requirements that we will later argue LLMs meet in ways Marcus considered impossible. But to see *why* that's surprising, we first need to see *why* he had good reasons for his skepticism.

---

## Pinker's Words and Rules: The Empirical Backbone

### Two Tricks Behind Language

Steven Pinker opens his *Words and Rules* argument with a deceptively simple observation. Language has two tricks, identified by 19th-century continental linguists: the *arbitrary sound-meaning pairing* underlying words (Saussure), and the *discrete combinatorial system* underlying grammar (Humboldt's "infinite use of finite media"). These are not just different linguistic phenomena — they implicate distinct cognitive mechanisms. Words call for associative memory: you learn that "duck" means a bird that quacks by forming an arbitrary association shared with your community. Grammar calls for symbolic computation: you can produce and understand a potentially infinite set of sentences because you possess a finite algorithm that combines abstract symbols like "Noun" and "Verb" regardless of their content.

The deep question is whether these really are *two* mechanisms, or whether a single, sufficiently powerful associative system could handle both. Pinker argues that English morphology provides a natural experiment: regular and irregular inflection express the *same* grammatical content (pastness of an event) using forms of the *same* complexity (single words), but they display categorically different psychological profiles.

### Regulars as Rule Products

Regular inflection — walk→walked, jog→jogged, fax→faxed — is productive, open-ended, and fully predictable. Children generalize it spontaneously to novel forms (wug→wugged). They overextend it to irregulars (breaked, comed), demonstrating that they possess an active rule rather than merely parroting parental input. The class is indefinitely expandable: any new verb entering the language (to google, to mosh, to smurf) automatically receives regular inflection.

Pinker proposes the rule has the form of standard grammatical computation:

> V_past → V_stem + d

It concatenates a suffix to a *symbol* for verbs — not to any particular verb, but to anything bearing the abstract category label "Verb."

### Irregulars as Memorized Words

Irregular verbs — ring→rang, go→went, think→thought — are idiosyncratic, unpredictable from their sounds, and form a closed class (about 180 in modern English, with no recent additions). They display family-resemblance patterns (string/strung, sting/stung, swing/swung) that are occasionally generalized (children say bring→*brang*; adults offer splang/splung for novel spling), but these generalizations are graded by similarity to known exemplars and never freely productive.

Pinker argues this profile matches an enriched associative memory — not a flat list, but a pattern-associator in which similar forms reinforce each other's shared features. This accounts for the family-resemblance structure of irregular subclasses and for the occasional analogical extension to new forms.

### The Twelve Circumstances: Where the Two Systems Part Company

The heart of Pinker's empirical case is a set of diverse situations in which memory access is compromised, for one reason or another, and where the two systems consequently diverge: irregular inflection suffers, but regular inflection applies freely. The heterogeneity is deliberate — the circumstances share nothing except failure to retrieve stored forms.

**1. Rare words.** All ten of the most frequent English verbs are irregular (be, have, do, say, make, go, take, come, see, get). Among the lowest-frequency verbs, 98.2% are regular. The explanation: irregular forms must be memorized generation after generation to survive, and rare forms eventually fail to be memorized often enough. When memory fails, the regular rule fills the gap. This is why irregulars have been steadily regularizing over centuries — Old English had roughly twice as many as Modern English.

**2. Unusual-sounding verbs.** The Rumelhart-McClelland pattern associator reproduces the human generalization gradient for irregular-sounding novel verbs (spling→splang works, vin→*van doesn't). But for regular inflection, humans apply the suffix to *any* novel verb — even phonologically bizarre ones like ploamph→ploamphed — while the pattern associator collapses, producing chimeric outputs like "smairf→sprurice." The failure is principled: without a variable mechanism, the model must activate output features based on trained input features, and radically novel inputs activate nothing coherent.

**3–9. Headless and rootless derivations.** This is where the argument becomes syntactically precise. Some derived words are "headless" — they don't inherit properties from their morphological head in the normal way. A *low-life* is not a kind of life but a kind of person; a baseball player who *flies out* is not performing the action denoted by the root verb *fly* but hitting a fly ball. In these constructions, the pipeline that normally passes stored irregular forms from the root upward is disabled. The irregular form is, as Pinker puts it, "trapped in memory," and the regular rule steps in as the default:

- *low-lifes* (not *low-lives*) — "has-a" compound
- *Mickey Mouses* (not *Mickey Mice*) — eponym converted back to common noun
- *flied out* (not *flew out*) — denominal verb from the noun "a fly"
- *high-sticked* (not *high-stuck*) — denominal in hockey
- three *"man"s* (not *"men"*) — quotation

Children as young as four show sensitivity to this pattern in experiments, providing regular plurals for headless compounds (snaggletooths) at significantly higher rates than for ordinary compounds with irregular heads.

**10. Childhood overregularization.** Children produce errors like *breaked* and *holded* in about 5% of opportunities — not because they are overgeneralizing from a sudden influx of regular verbs (the proportion of regulars in parental input doesn't change at the right time), but because they have acquired the regular rule and occasionally fail to retrieve the stored irregular. The onset of overregularization errors coincides with mastery of the regular rule, as shown by children beginning to consistently mark regular verbs at the same developmental point.

**11–12. Neural dissociations.** Patients with anomic aphasia (impaired word retrieval, intact grammar) show the predicted pattern: worse on irregulars than regulars, frequent overregularization errors, and reasonable performance on novel verbs. Patients with agrammatic aphasia (impaired grammatical combination, less impaired word retrieval) show the mirror image: worse on regulars than irregulars, no overregularization errors, and grave difficulty with novel verbs. Alzheimer's patients (memory degradation exceeding grammatical impairment) pattern with the anomics; Parkinson's patients (frontal/basal-ganglia circuit degradation) pattern with the agrammatics.

### The Crosslinguistic Coup de Grâce

Connectionists had maintained that the default status of English -ed could be explained by its sheer numerical dominance — regular verbs are the majority, so the pattern associator learns them most strongly. Pinker seals the case by comparing English to German.

German weak -t applies to only about 45% of the most common verbs (versus ~85% for English -ed), yet it behaves identically as the default across every circumstance: applied to unusual-sounding verbs, to onomatopoeia, to denominals, overregularized by children. German -s plurals apply to a mere ~7% of nouns (versus >99% for English -s), yet they too behave as defaults in all the same contexts — names, eponyms, foreignisms, truncations, quotations. Even the constraint against regular plurals inside compounds holds in both languages despite their vastly different frequency profiles.

Pinker draws the historical moral: proto-Germanic had a majority of strong (irregular) verbs. The dental suffix applied to borrowings and derived forms — contexts where the default rule was needed on *grammatical* grounds. English subsequently borrowed massively from French and Latin (about 60% of verb roots), and all those borrowings were regular because they were rootless. The majority status of regulars is the *consequence* of default suffixation, not its cause.

Pinker's evidence powerfully supports a two-mechanism account. But what exactly does this imply about the architecture of the mind? That is the question Gary Marcus takes up.

---

## Marcus's Algebraic Mind: The Theoretical Sharpening

### What Symbol-Manipulation Actually Means

Gary Marcus takes Pinker's empirical program and distills it into a precise theoretical framework. His contribution is a *clarification of what is at stake*. Marcus is emphatic — and frequently misunderstood — on a crucial point: he is not anti-connectionist. He is not arguing that the mind isn't implemented in neurons. He is arguing that certain connectionist models, specifically multilayer perceptrons (MLPs) trained by backpropagation, lack computational properties that cognition requires, and that other connectionist architectures — ones that implement symbol manipulation in neural hardware — are needed.

Marcus decomposes "symbol manipulation" into three separable hypotheses:

1. **Relations between variables.** The mind can represent and generalize abstract relationships (like identity or concatenation) that apply uniformly to all instances of a class, not just to memorized exemplars.

2. **Structured representations.** The mind can represent recursive compositions of elements — distinguishing *the book on the table* from *the table on the book* — with separate representational resources for distinct propositions.

3. **Individuals versus kinds.** The mind distinguishes between representations of particular individuals (Felix) and representations of categories (cats), tracking them with different mechanisms.

These can stand or fall independently. A system might handle variable relations without recursion, or recursion without an individual/kind distinction. By teasing them apart, Marcus avoids the false dichotomy of "symbols versus no symbols" and asks instead which *specific* computational properties are needed and which models provide them.

### The Training Independence Argument

Marcus's sharpest technical contribution is the concept of *training independence*, which explains precisely why standard MLPs cannot freely generalize operations over variables.

Consider the identity function: given input [1010], output [1010]. Humans, shown a few examples, freely generalize to novel inputs like [1111]→[1111]. But an MLP with distributed representations (multiple nodes per variable), trained by backpropagation only on inputs where the rightmost digit is 0, will output [1110] for input [1111]. It cannot generalize the identity relation to the untrained node.

The reason is mathematical, not merely empirical. Backpropagation's weight update for the connection from input node *i* to hidden node *h* is proportional to the activation of *i* multiplied by an error signal. If node *i* is never activated (always 0), the connections from *i* never change. Marcus calls this *input independence*. Similarly, the weight updates feeding output node *j* depend on the error for *j* but not on the errors of any other output node — *output independence*. Together, these guarantee that what the network learns about one node is mathematically independent of what it learns about another.

This is not a flaw in the algorithm — it's a feature that makes backpropagation tractable. But it means that an MLP cannot discover that "all columns should be treated uniformly." Free generalization of a universally quantified one-to-one mapping (UQOTOM) — identity, concatenation, reduplication — is impossible outside the training space.

Marcus demonstrates that this limitation is not solved by:

- **Distributed representations.** Switching from localist to phonetically distributed input representations doesn't help, because the superposition catastrophe prevents the output from unambiguously representing category-level predictions.
- **Recurrent architectures.** Elman's simple recurrent network inherits the same training independence because its context units don't overcome the localism of the node-to-node learning.
- **More hidden layers or longer training.** Training independence follows from the backpropagation equations themselves, regardless of network depth or training duration.

### Seven-Month-Olds versus Pattern Associators

Marcus's most striking empirical demonstration involves infants. Seven-month-olds listen for two minutes to three-syllable "sentences" from an artificial grammar — either ABA (ga ti ga, li na li) or ABB (ga ti ti, li na na). In test, they hear sentences composed of *entirely novel syllables* and discriminate consistent from inconsistent patterns — showing they have extracted and freely generalized an abstract relational structure after minimal exposure.

This is a UQOTOM: the identity relation between positions 1 and 3 (in ABA) must be generalized to syllables never heard during habituation. Marcus shows that no standard MLP can capture this, precisely because of training independence: each novel test syllable activates nodes whose connections were never trained, so no learned relation transfers to them.

### What Marcus Thinks Is Needed

Marcus's positive proposal centers on *registers* — rapidly updatable, stable storage devices that can hold the current instantiation of a variable. In a register-based system, variables are represented by the registers themselves, instances by their contents, and operations are defined uniformly over all possible contents. He proposes that registers could be implemented neurally via autaptic cells (self-stimulating neurons), Hebbian cell assemblies, or intracellular mechanisms like modulation of ion channels.

For structured representations, Marcus proposes *treelets* — pre-organized hierarchical arrangements of register sets, analogous to LISP data structures. A treelet has a fixed branching structure with slots that can be filled by simple encodings (words, concepts) or by pointers to other treelets, enabling recursion.

Marcus evaluates and finds wanting several alternative proposals for neural implementation of compositional structure: Churchland's geometrical conception (falls to the superposition catastrophe), Elman's recurrent-network approximation of recursion (fails the unique-encoding requirement), Pollack's RAAM (demands implausible precision from individual nodes), and Smolensky's tensor products (which Marcus acknowledges as the most principled approach but worries about exponential dimension growth).

---

> ### Technical Sidebar: Smolensky's Tensor Product Representations
>
> A Tensor Product Representation (TPR) maps a symbolic structure to a vector (technically, a tensor) in a continuous space. The key ingredients:
>
> **Filler/role decomposition.** Every compositional structure *s* is analyzed as a set of filler/role bindings: *s* = {f₁/r₁, f₂/r₂, ...}. For example, the ordered pair [lock, able] decomposes into {lock/L, able/R}, where L and R are the structural roles "left" and "right."
>
> **Vector encoding.** Each filler fₖ is encoded by a vector **fₖ** ∈ V_F, and each role rₖ by a vector **rₖ** ∈ V_R. These vectors are drawn from separate vector spaces.
>
> **Binding via tensor product.** The binding of filler to role is realized as the tensor product: **fₖ** ⊗ **rₖ**. For vectors, this produces a matrix whose (i,j) entry is simply fₖᵢ · rₖⱼ.
>
> **Aggregation via summation.** The full TPR of the structure is the sum of all bindings: **s** = Σₖ **fₖ** ⊗ **rₖ**.
>
> **Unbinding via inner product.** If filler and role vectors are chosen to be orthonormal (or merely linearly independent, using dual vectors), then the filler bound to a given role can be exactly recovered: **fₖ** = **s** · **rₖ** (contracting the tensor along the role dimension).
>
> **Example.** Let **a**, **j**, **k**, **f** be orthonormal vectors encoding the symbols *apple*, *John*, *kitchen*, *office*. Let **@** encode the "is-at" predicate. The proposition @(apple, John, t₁) — "the apple is at John at time t₁" — is encoded as the fourth-order tensor **@** ⊗ **a** ⊗ **j** ⊗ **t₁**.
>
> A knowledge base of multiple propositions is simply their sum: **B** = Σₖ **Pₖ** ⊗ **aₖ** ⊗ **bₖ** ⊗ **cₖ**. Because the symbol vectors are orthogonal, queries can extract specific information. To find "where is the apple?", we contract **B** with **@** ⊗ **a** along the appropriate indices, and the orthogonality ensures that only the matching proposition survives.
>
> **Inference as multilinear operations.** Smolensky shows that rules of inference can be encoded as tensor operations. The transitivity axiom — ∀x,y,z,t: @(x,y,t) ∧ @(y,z,t) ⇒ @(x,z,t) — becomes a multilinear operation V[**B**, **B**; t] that takes the knowledge-base tensor, forms its tensor product with itself, contracts along the shared variable (y = y'), and projects the result with the predicate and time vectors. The result is exact: the new proposition @(x,z,t) is added to the knowledge base.
>
> Similarly, the persistence axiom — ∀x,y,t,t': @(x,y,t) ∧ ≺(t,t') ⇒ @(x,y,t') — is implemented by a matrix **P**(t) operating on the knowledge-base tensor, using a time-increment operator **T** satisfying **T**tᵢ = tᵢ₊₁.
>
> The full reasoning algorithm processes a narrative sentence by sentence: for each new sentence, it applies persistence to propagate existing facts forward in time, adds the new sentence's logical form, and iteratively applies transitivity until no new propositions are generated. On the bAbI question-answering benchmark, this programmed-vector-procedure achieves 100% accuracy on nearly all task categories.

---

## Smolensky's Resolution: Neurocompositional Computing

### The Central Paradox

Smolensky frames the debate as a paradox rather than a dichotomy. Neural computing respects the *Continuity Principle*: information is encoded and processed using real numbers that vary continuously, enabling similarity-based generalization and gradient-based learning. Symbolic compositional-structure computing respects the *Compositionality Principle*: complex information is built from simpler parts via systematic composition, enabling strong compositional generalization to novel combinations of familiar elements.

Twentieth-century AI systems violated one principle or the other. Symbolic AI could generalize from *lock* and *-able* to *lockable* but not from *lock* to *fasten* (different discrete symbols). Neural AI could generalize from *lock* to *fasten* (nearby vectors) but not to *lockable* (no compositional encoding). Human cognition somehow does both.

The tempting compromise — a hybrid system bolting symbolic and neural components together — fails because individual cognitive encodings need to respect *both* principles simultaneously. As Smolensky argues with examples from phonology and morphology, the same representation often needs to be both continuously graded (for similarity-based generalization) and compositionally structured (for systematic combination) at the same time.

### TPRs as the Resolution

Tensor Product Representations resolve the paradox by embedding compositional structure *within* continuous vector spaces. The resulting encoding is simultaneously neural (a vector of real-valued activations) and compositional (a systematic decomposition into filler/role bindings that can be recovered and processed). The binding operation (tensor product) and unbinding operation (inner product) are continuous, differentiable operations that preserve the identity of fillers across different roles — the crucial property that Marcus demands for compositional generalization.

Smolensky's key theoretical claim is that with inputs and outputs encoded as TPRs, neural networks can be designed to *precisely compute* many complex compositional-structure processing functions, including tree adjoining (sufficient for human syntactic complexity), algebraic simplification of ratios, and chaining of logical implications. The intricate structure-sensitive processing that Fodor and Pylyshyn argued only symbolic systems could perform is, in principle, achievable by networks operating on TPR encodings.

### Generations of Neurocompositionality

Smolensky distinguishes three generations of neurocompositional computing:

**First-generation (1G)** systems incorporate compositional structure implicitly. CNNs use spatial structure (analyzing larger patches by composing analyses of smaller patches). Transformers use graph structure (attention patterns that implicitly encode inter-word relations). These architectures derive much of their power from this built-in compositionality, but the compositional structure in their data flow is not represented in activation vectors accessible to subsequent layers.

**Second-generation (2G)** systems — the NECST (Neurally-Encoded Compositionally-Structured Tensor) models — make compositional structure explicit in activation vectors. The NECSTransformer generates TPR encodings where each symbol's vector has explicit filler/role structure: roles vary across symbols, layers, and inputs, and result from deep learning. Crucially, the model *invents its own compositional structure* optimally suited to its task. On math problem solving, the invented structures implicitly exploit algebraic inference rules, assigning the same role to a denominator-of-a-denominator as to a numerator-of-a-numerator. On English processing, invented roles partially align with grammatical categories despite receiving no linguistic information.

The empirical results are systematic: increasing neurocompositionality brings faster learning, more robust compositional generalization to novel combinations, and a higher probability of learning a task perfectly. In the CopyNet experiments (reproducing five-digit sequences withheld from training in specific digit-position combinations), the pre-Transformer CopyNet-0 fails entirely on compositional generalization, the Transformer CopyNet-1G partially succeeds, and the NECSTransformer CopyNet-2G succeeds robustly.

**Third-generation (3G)** systems — still in development — would support recursive self-embedding of TPRs (structures within structures), optimization-based processing where grammatical expressions emerge as optimal satisfiers of soft constraints, and learned processing that takes full advantage of the filler/role disentanglement. Smolensky identifies these as necessary for approaching human-level compositional abilities.

---

## Interlude: What Can Networks Compute versus What Can They Learn?

The debate between Marcus and Smolensky plays out against a background of formal results about the computational power of neural networks — results that are sometimes cited as settling the question but that, on closer inspection, sharpen it. The crucial distinction is between *expressive power* (what a network can represent, given the right weights) and *learnability* (what a network can acquire from finite training data via a particular learning algorithm). Confusing these two has generated persistent misunderstandings on both sides.

### Augmenting Neural Networks with Memory: Neural Turing Machines

One direct response to Marcus's challenge was to build neural architectures that explicitly incorporate the registers he argued were needed — but within a fully differentiable framework trainable by gradient descent. Graves, Wayne & Danihelka (2014) introduced the *Neural Turing Machine* (NTM): a neural network controller coupled to an external memory matrix, with differentiable read and write heads that address memory locations via content-based or location-based attention. The entire system is trained end-to-end with backpropagation.

NTMs can learn to copy sequences, sort them, and perform associative recall — precisely the UQOTOMs Marcus showed standard MLPs couldn't learn. The key insight is that the controller doesn't need to store the input content in its weights; it reads and writes content to external memory via attention, and the attention pattern (which positions to read from) is independent of the content stored at those positions. This is, in effect, Marcus's register-based architecture — but implemented within the neural computing paradigm rather than requiring a shift away from it.

The NTM thus represents a compromise position: it vindicates Marcus's functional analysis (you *do* need something like registers with content-independent addressing) while undermining his architectural conclusion (this machinery doesn't need to be non-neural). It also directly anticipates the Transformer's use of attention over input positions, as we discuss below.

### Neural GPUs: Learning Algorithms without Being Told Them

Kaiser & Sutskever (2016) took a different approach with the *Neural GPU*, a convolutional architecture with recurrent computation steps operating on a grid-like internal state. Trained on short examples of binary number addition and multiplication, the Neural GPU generalizes to much longer inputs — learning something functionally equivalent to schoolbook arithmetic algorithms without being told what algorithm to use.

This is significant because multiplication is a systematic, position-by-position operation of exactly the kind Marcus argued requires explicit symbol manipulation. The Neural GPU succeeds not because it has dedicated symbolic machinery but because its architecture has structural biases — a grid topology with position-invariant convolutional operations and iterative refinement — that align with the structure of the target computation. The inductive bias does real work, but it is architectural rather than representational: the network has no explicit variables, registers, or rules.

The Neural GPU's limitations are equally informative. Price, Zaremba & Sutskever (2016) showed that Neural GPUs that correctly generalize to arbitrarily long numbers can still fail on highly symmetric, atypical inputs — suggesting that the learned algorithm is an approximation rather than a true implementation of formal arithmetic. The gap between "works on typical inputs" and "works on all inputs" is another manifestation of the expressiveness-learnability distinction.

### Are Transformers Turing Complete? It Depends on What You Mean

Pérez, Marinković & Barceló (2019) proved a striking result: both the Transformer and the Neural GPU are Turing complete, based *exclusively on their capacity to compute and access internal dense representations of the data*. Neither requires access to external memory to achieve this formal result. The proof constructs a Transformer that simulates an arbitrary Turing machine by encoding its tape history in the growing sequence of generated tokens, with each decoding step corresponding to one step of the machine.

However, the proof requires *hard attention* (argmax rather than softmax), which precludes gradient-based learning, and *unbounded precision* in activation values — the same unrealistic condition that plagues the Siegelmann-Sontag RNN result. The precision requirement is not incidental: when multiple positions tie for the maximum attention score, the hard-attention output produces fractions like 1/t whose representation grows with input length.

What about the *Universal Transformer* (Dehghani et al., 2018), which applies the same Transformer layer iteratively with a learned halting mechanism — effectively giving it unlimited depth with fixed parameters and bounded precision? This sounds like it should be more powerful than a fixed-depth Transformer, and it is — but it is *not* Turing complete. The reason is fundamental: with bounded-precision activations and a fixed number of dimensions, the Universal Transformer's internal state occupies a finite (though enormous) set of possible configurations. With unlimited iterations, it must eventually revisit a state, entering a cycle. It is therefore equivalent to a finite automaton — vastly more capacious than a fixed-depth Transformer, but still incapable of the unbounded memory that Turing completeness requires.

For *bounded-precision, fixed-depth* standard Transformers, the picture is even more constrained. Such Transformers correspond to restricted circuit complexity classes (roughly TC⁰ — constant-depth threshold circuits). They cannot reliably count, recognize all regular languages, or perform the systematic compositional generalization that Marcus demands. This formal limitation aligns with empirical observations of Transformer brittleness on tasks requiring systematic structure.

The picture changes dramatically with *chain-of-thought* (CoT) reasoning. When a Transformer can write intermediate results to the output sequence and re-read them on subsequent steps, the effective state space *grows with computation time* — the output sequence functions as an external tape. Recent work has shown that CoT Transformers recover Turing completeness even with softmax attention and bounded precision. Li & Wang (2025) proved that even constant-bit-size Transformers achieve Turing completeness with CoT, provided the computation description is loaded into the prompt.

This progression — from fixed-depth Transformers (weaker than finite automata in some respects) through Universal Transformers (finite automata with huge state spaces) to CoT Transformers (Turing complete via external scratchpad) — reveals a recurring theme. The computational power of neural architectures depends critically on whether they have access to *extensible memory*. Internal states alone, no matter how richly computed, are bounded. It is the ability to read from and write to a growing external store — whether an NTM's memory matrix, a Neural GPU's grid, or a Transformer's own output sequence — that bridges the gap to universal computation. This is, in architectural terms, precisely the distinction Marcus drew between pattern association (which operates over fixed-size internal states) and symbol manipulation (which requires registers that can be written, read, and extended).

### The Learnability Gap Is Where Marcus's Argument Bites

Marcus's training independence result occupies a precise location in this landscape. He is *not* claiming that MLPs lack the expressive power to represent operations over variables — indeed, he explicitly shows that one-node-per-variable networks *must* represent UQOTOMs. His claim is specifically about *multi-node-per-variable* networks trained by *backpropagation* (or Hebbian learning): these networks cannot *learn* to generalize UQOTOMs outside the training space, because the learning algorithm adjusts each node's connections independently of other nodes.

The Turing completeness results do not refute this claim. Those results say: the right weights *exist*. Marcus says: backpropagation can't *find* them from incomplete data. Both are correct — they address different questions. The NTM and Neural GPU narrow the gap by providing architectures where the right inductive biases make the target computations *learnable*, but they do so by adding structure that is absent from vanilla MLPs.

The deep question is whether there are architectures and training regimes that close the learnability gap *without* explicitly providing memory or algorithmic structure — achieving in practice what the Turing completeness proofs guarantee in principle. Training independence is a property of specific learning algorithms on specific architectures. It is not a property of neural computation in general. An architecture with attention mechanisms creating information pathways between all positions simultaneously, trained with a self-supervised objective that forces discovery of abstract structure across the full input distribution, might close the gap without any explicit symbolic machinery.

Not everyone, however, was waiting for this question to be resolved. Some researchers took the symbolic/subsymbolic distinction as an established architectural fact and built comprehensive systems around it.

---

## Sun's CLARION: The Dual-Process Commitment

Ron Sun's CLARION architecture represents a different kind of response to the symbolic/subsymbolic debate: rather than trying to dissolve the distinction or vindicate one side, it *reifies* the distinction as a core architectural commitment. CLARION is a comprehensive cognitive architecture with four subsystems — action-centered (ACS), non-action-centered (NACS, for declarative knowledge), motivational (MS), and metacognitive (MCS) — each containing *two levels* of representation.

The bottom level in each subsystem is implicit, subsymbolic, implemented via neural networks (MLPs, auto-associative networks). The top level is explicit, symbolic, implemented via rules and associative chunks. Learning can proceed in both directions: *bottom-up*, from implicit skill to explicit rule extraction (capturing the phenomenology of insight and verbalization of procedural knowledge), and *top-down*, from explicit instruction to implicit internalization (capturing the phenomenology of practice and automatization).

CLARION's dual-process commitment has a clear stake in the outcome of the debate we have been tracing. If Marcus's arguments hold — if symbolic and subsymbolic processing are genuinely distinct mechanisms requiring separate implementations — then CLARION's architecture is well-motivated. But if sufficiently powerful subsymbolic systems can develop the functional equivalent of symbolic processing (as Smolensky's mathematics suggests is possible), then CLARION's central architectural division may be reifying a distinction that is better understood as a continuum, or as different regimes of the same underlying computation. This architecture allows expressing many psychological phenomena — from procedural learning to personality — but only via manual modeling that does not scale or generalize.

There is, however, a deeper irony lurking here. If one squints at a modern LLM system with chain-of-thought reasoning, it begins to resemble CLARION's architecture from the outside: an implicit subsymbolic substrate (the Transformer weights) generating explicit reasoning traces (CoT) that constrain and correct subsequent processing, with bidirectional learning between the levels (pretraining as bottom-up, instruction tuning as top-down). CLARION's dual-process theory might yet be vindicated — not as a theory of implementation but as a theory of functional organization — with the twist that both levels turn out to be implemented subsymbolically. But this is to anticipate our next article.

---

## Transformers, Tensor Products, and an Early Empirical Test

### Attention as Approximate TPR Unbinding

Smolensky classifies Transformers as "first-generation neurocompositional" systems — they implicitly use compositional structure but don't explicitly represent it in activation vectors. This classification becomes more illuminating when we examine the mathematical relationship between multi-head attention and TPR operations.

In a TPR, unbinding recovers the filler associated with a particular role by taking the inner product of the composite representation with a role vector: **f_k** = **s** · **r_k**. The role vector acts as an address, and the inner product retrieves whatever content is bound to that address, regardless of what the content is. This content-independence is precisely the property that enables free generalization.

Multi-head attention performs a structurally parallel operation. Each attention head computes a weighted sum of value vectors, where the weights are determined by query-key dot products: Attention(Q, K, V) = softmax(Q · K^T / √d) · V. If we interpret query vectors as encoding the role being sought and key vectors as advertising the role each position occupies, then the query-key dot product is an approximate role-matching operation, and the weighted sum over value vectors is an approximate filler extraction. The result: the content of a structural position is retrieved regardless of what that content happens to be — the same content-independence that TPR unbinding provides.

The analogy is not perfect. TPR unbinding is exact (given orthonormal vectors), while attention-based retrieval is approximate and softmax-blurred. TPR structures are explicitly represented as tensors that subsequent processing can inspect and manipulate; Transformer attention graphs exist only during the forward pass of a single layer and vanish afterward. This is Smolensky's key criticism: in a Transformer, the compositional structure computed by attention is *used* within a layer but not *encoded* in the activation vectors passed to the next layer. The graph disappears. For the graph to be a genuine compositional encoding, it would need to be represented as an activation vector with recoverable internal structure — which is exactly what 2G NECST models provide.

Nevertheless, the structural parallel between attention and TPR operations means that Transformers have a *mechanism* that could, in principle, support variable-binding-like computation. The question is whether they actually use it this way — and if so, under what conditions.

> ### Technical Sidebar: Attention and TPR Unbinding
>
> In Smolensky's TPR framework, a composite structure **s** = Σ_k **f_k** ⊗ **r_k** stores multiple filler/role bindings superimposed in a single tensor. Unbinding extracts a specific filler via the inner product with the corresponding role vector: **f_j** = **s** · **r_j** = Σ_k **f_k** (**r_k** · **r_j**) = **f_j** (when role vectors are orthonormal, since **r_k** · **r_j** = δ_kj).
>
> In a Transformer attention head, the input sequence X = [**x_1**, ..., **x_n**] is projected into queries Q = X · W_Q, keys K = X · W_K, and values V = X · W_V. The output for position i is:
>
> **o_i** = Σ_j α_ij **v_j**, where α_ij = softmax_j(**q_i** · **k_j** / √d)
>
> The parallel: **q_i** functions as a role-query (analogous to **r_j** in unbinding), **k_j** functions as a role-advertisement for position j, and **v_j** carries the filler content. The dot product **q_i** · **k_j** performs approximate role matching (analogous to **r_k** · **r_j** in TPR unbinding), and the weighted sum over **v_j** extracts filler content (analogous to recovering **f_j**).
>
> Key differences: (1) Softmax normalization makes attention weights sum to 1, producing a *blend* of fillers rather than exact extraction. (2) Multiple heads provide parallel unbinding channels, each potentially implementing a different role system. (3) The resulting compositional structure exists only implicitly in the attention pattern, not explicitly in the output activation vector.

### The Gröndahl-Asokan Vocabulary Generalization Experiments

A 2022 study by Tommi Gröndahl and N. Asokan provides one of the cleanest early empirical tests of whether Transformers perform variable binding. Their experimental design is elegant: split the vocabulary into two disjoint subsets V₁ and V₂, train the model with V₁ associated with task class C₁ and V₂ with C₂, then test with the vocabularies *flipped* — V₂ for C₁ and V₁ for C₂. Success requires generalizing the task rule across vocabulary partitions never associated with that task during training. This is precisely the kind of free generalization that Marcus argues requires variable binding.

The results are strikingly split. On sequence-to-sequence tasks (copying and reversing strings, distinguished by a task-marker token), both BERT and RoBERTa achieve *perfect* vocabulary generalization — 100% accuracy even with zero vocabulary mixing during training. But on classification tasks (detecting whether two sequences are copies, detecting token repetition, distinguishing copies from reversals), both models *completely fail* to generalize across vocabularies. Test F1-scores remain at or near zero unless the training data itself mixes vocabularies across task classes.

The explanation Gröndahl and Asokan offer is revealing: in the seq2seq task, the Transformer can use the input itself as an *external memory*. Attention to input positions functions as location-based memory addressing — the task-marker token instructs the model to look up positions in a particular order (left-to-right for copying, right-to-left for reversal), and token replication at each decoding step is a vocabulary-specific one-to-one mapping learned separately for each token. The positional addressing pattern is content-independent: it works the same way regardless of which vocabulary fills the positions. This is structurally identical to TPR unbinding — extracting filler content from structural positions.

Classification tasks don't permit this strategy. There is only one decoding step, no opportunity for sequential position-by-position readout, and the judgment (copy or not? repetition or not?) must be computed entirely within the model's internal representations. Here, the models show no evidence of abstracting away from specific token identities. They learn vocabulary-specific shortcuts — mapping inputs from V₁ to one class and inputs from V₂ to another — and fail catastrophically when the vocabulary-task pairing is reversed.

### What the Split Verdict Means

This result lands precisely in the gap between Marcus and Smolensky. It *partially vindicates Marcus*: when forced to rely on purely internal computation (classification), Transformers fail at vocabulary-general rule application — the absence of internal variable binding is exactly what his theory predicts. It *partially vindicates Smolensky*: when the architecture permits iterative position-by-position readout via attention (seq2seq), the Transformer achieves content-independent slot-filling that is functionally equivalent to TPR unbinding — without any dedicated symbolic machinery. The key distinction is not between the Transformer and some "external" memory, since the input sequence is architecturally part of the model. Rather, it is between tasks where attention can iteratively address individual positions (enabling content-independent processing) and tasks where the entire input must be compressed into a single decision (forcing content-specific shortcuts). The question for the much larger Transformer-based LLMs that were about to arrive is whether scale and Chain-of-Thought can push internal representations toward genuine compositionality, closing the gap that these classification experiments expose.

---

## Setting the Stage: Where Marcus's Argument Has Load-Bearing Joints

Marcus's case against standard connectionism is one of the most carefully constructed arguments in cognitive science. It deserves to be taken seriously — which means identifying precisely where its load-bearing joints are, so that we can later assess which have held and which have cracked.

### Joint 1: The Mathematical Proof (Training Independence)

Training independence is a *theorem* about the pure backpropagation update equations applied to MLPs with binary-valued, multi-node-per-variable input representations. The proof is correct: the weight update for connections from an input node that is always 0 is always 0, and the weight update for connections feeding output node *j* is independent of the target for output node *k* ≠ *j*. Therefore, what the network learns about one input-output dimension cannot transfer to another.

But the proof's scope is far narrower than its reception suggests. It applies to a mathematical idealization — the bare backpropagation update equations in isolation — that does not correspond to any real training procedure. The distinction Marcus draws between "the learning algorithm" and supplementary techniques is not a natural joint: every practically used optimization procedure (SGD with momentum, Adam, AdamW) couples weight updates across dimensions in ways that break the independence assumption. Even L2 regularization, standard practice well before Marcus wrote, forces hidden unit sharing between outputs, defeating the proof's premise. The proof is like showing a frictionless billiard ball can't reach a certain pocket — mathematically correct, but friction isn't an optional add-on to real billiards.

What survives is a weaker and less surprising observation: UQOTOM generalization doesn't emerge from gradient descent alone without any inductive bias. Something must push the network toward treating different input dimensions uniformly — whether that something is regularization, architectural constraints, training distribution, or scale. This is true but does not motivate Marcus's architectural conclusions (dedicated registers, treelets). The question of *how much* and *what kind* of inductive bias suffices remained open — and it is this question, rather than training independence per se, that subsequent developments address. As we have seen, Gröndahl and Asokan's seq2seq results show that attention mechanisms can achieve content-independent positional addressing, while their classification results show this route is not always available.

### Joint 2: The Philosophical Argument (Architectural Necessity)

Marcus argues that free generalization of UQOTOMs *requires* a system with five specific properties: a way to distinguish variables from instances, a way to represent relationships between variables, a way to bind instances to variables, a way to apply operations to *arbitrary* instances, and a way to extract relationships from examples. He then evaluates whether MLPs possess these properties and concludes they do not (for the multi-node-per-variable case).

The argument correctly identifies *functional requirements*. But it slides from "the system must be *able to do* X" to "the system must *contain dedicated machinery for* X." A system could satisfy all five functional requirements without any component being specifically designed for variable binding — if the emergent dynamics of the system give rise to the required functionality. Marcus considers this possibility implicitly (he discusses how one-node-per-variable networks implement operations over variables without needing extra machinery) but does not pursue the question of whether large-scale distributed systems might develop analogous functional organization through training.

### Joint 3: The Empirical Gap (Absence of Evidence)

As of 2001, no connectionist model without explicit symbolic machinery had demonstrated free generalization of UQOTOMs outside the training space. Marcus's infant experiments provided a particularly clean case: seven-month-olds generalize abstract relational patterns after two minutes of exposure, and no MLP could replicate this.

But absence of evidence is not evidence of absence, especially when the models tested were tiny by later standards. Marcus tested networks with tens of nodes and hundreds of training examples. The question of what happens at scale — millions of parameters, billions of training tokens, self-supervised learning objectives that force the discovery of abstract structure — was not empirically addressable in 2001.

Marcus himself recognized this gap, at least in principle. He wrote: "I cannot possibly rule out alternatives that have not yet been proposed. The situation here is the same as elsewhere in science: disconfirmation can be decisive, but confirmation is just an invitation for further investigation." But the rhetorical force of his argument — and his subsequent public commentary — has consistently treated the limitations he identified as deep in-principle constraints on neural computation rather than as empirical observations about a particular generation of models.

---

## Conclusion: The State of Play Before LLMs

As of the early 2020s, the theoretical landscape looks like this:

**Pinker** has established, with extensive crosslinguistic and neuropsychological evidence, that human language processing involves at least two functionally distinct systems: a frequency-sensitive, similarity-driven associative memory for irregular forms, and a symbolic rule that applies as a default whenever memory fails. The default status of regular inflection is not explained by numerical dominance in the input.

**Marcus** has sharpened the theoretical stakes: the crucial issue is not whether minds use "symbols" (a definitional question) but whether they perform *operations over variables* — operations that apply uniformly to arbitrary instances of a class, including instances never encountered during learning. He has argued that standard MLPs lack this capacity, though his mathematical proof applies only to an idealized training procedure that no practitioner uses. His deeper contribution is identifying the functional requirements — variable binding, structured representations, the individual/kind distinction — that any adequate cognitive architecture must meet.

**Smolensky** has demonstrated mathematically that the functional requirements Marcus identifies can be met within continuous neural computation, via Tensor Product Representations. TPRs provide exact variable binding, exact unbinding, and inference as multilinear tensor operations — all within the framework of differentiable vector computation. Second-generation NECST models show that deep learning can *discover* appropriate compositional structure without being hand-designed for it, and that increasing neurocompositionality systematically improves compositional generalization.

**Sun** has built a comprehensive dual-process architecture, CLARION, that reifies the symbolic/subsymbolic distinction as a core design principle. If Marcus is right, this commitment is well-motivated; if subsymbolic systems can develop functional symbolic capabilities, CLARION's architecture may need reinterpretation — perhaps as a description of functional organization rather than implementation.

**Gröndahl and Asokan** have provided an early empirical test showing that Transformers occupy a genuinely intermediate position: they can perform content-independent positional addressing via attention (functionally paralleling TPR unbinding) when the task permits iterative position-by-position readout, but they fail at vocabulary-general rule application when the task requires compressing all information into a single classification decision.

The open question — the one that defines the next chapter of this story — is empirical: *Can* a system that lacks explicit symbolic machinery, but is trained at sufficient scale on sufficiently rich data, develop the functional equivalent of variable binding and compositional generalization? Marcus says no, on principled grounds. Smolensky says the mathematics allows it. The Gröndahl-Asokan results suggest the answer depends on whether the system's attention mechanisms can be leveraged for content-independent structural processing — something that seq2seq tasks permit but classification tasks do not. The experiments that would test this at scale require computational resources that didn't exist when the classical arguments were formulated.

Those experiments have now been run. But that is the subject of our next article.

*A further question, which we plan to explore in a forthcoming article, concerns the relationship between Transformer attention heads and the slots of working memory. The structural parallel between multi-head attention and Cowan's capacity-limited focus of attention is suggestive: each head provides an independent binding channel, and the number of heads may constrain the system's capacity for simultaneous variable bindings — much as working memory limits constrain human reasoning. Whether this parallel extends to the deeper connections between Chomskyan Merge, working memory pointers, and the compositional structure of thought remains an open and tantalizing question.*

---

*This article is part of a series on cognitive architecture, compositionality, and AI, co-authored by Łukasz Stafiniak and Claude (Anthropic) at lukstafi.github.io. The authors are transparent about the collaborative nature of this work: Claude contributes synthesis and exposition; Łukasz contributes philosophical direction, critical judgment, and editorial control. See our earlier articles on collaborative writing, cognitive architecture, and LLM consciousness for context.*
