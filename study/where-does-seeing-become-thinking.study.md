---
title: "Study notes: Where Does Seeing Become Thinking?"
essay: where-does-seeing-become-thinking
track: which-intelligence
reviewed-against: "2fd78b8"
requires:
  - {at: which-world-model, for: "structured representation can coexist with unreliable use: a model can possess a map and lose its position"}
  - {at: concept_theories#the-format-question-crystallized-block-and-quilty-dunn, for: "Block's border by format and Quilty-Dunn's perceptual pluralism"}
  - {at: concept_theories#synthesis-questions-for-artificial-minds, for: "concepts characterized by role so that format can be investigated, and the closing conjecture that perceptual engagement calibrates abstract reasoning", strength: helpful}
introduces:
  - {term: "source, format and operations", at: what-visual-reasoning-requires, gloss: "where information comes from, how it is represented internally, and which operations are available over the representation; none determines the others"}
  - {term: iconic representation, at: which-perceptioncognition-boundary, gloss: "Block's sense, stated more exactly than in the concept survey: analog tracking and mirroring, in which degrees of difference in what is represented correspond to degrees of difference in the representation"}
  - {term: three levels of evidence, at: when-geometry-does-computational-work, gloss: "recovering a variable from internal states, showing by intervention that it affects the answer, and explaining the transformation the model performs"}
  - {term: recoverability and learned operation, at: from-representations-to-reliable-operations, gloss: "information that could in principle answer a question, against a procedure that makes it available at a particular cost and reliability"}
  - {term: efference copy, at: what-architectural-differences-change}
  - {term: epistemic action, at: thinking-with-the-environment, gloss: "Kirsh and Maglio's term for a move that makes information easier to obtain or compute, as against one that directly advances the objective"}
  - {term: revisable abstraction, at: thinking-with-the-environment, gloss: "keeping access to the source and revising an abstraction when the task changes"}
uses:
  - {term: "process, deployment and lineage", from: which-agi}
  - {term: possessing versus using a representation, from: which-world-model}
  - {term: functional characterization of concepts, from: concept_theories}
  - {term: format turn, from: concept_theories}
  - {term: iconic and discursive formats, from: concept_theories}
  - {term: perceptual pluralism, from: concept_theories}
  - {term: Language of Thought, from: concept_theories}
  - {term: prototype and exemplar theories, from: concept_theories}
  - {term: meta-epistemic grounding, from: concept_theories}
---

The essay reports no new experiments. Several questions ask about experiments it proposes, and the answers say so.

### The crowded room {kind=case}

An assistant shown a photograph of a room recommends a wheelchair route through a gap that is too narrow. List the places where the failure could have occurred. Which boundary do these possibilities cross?

::: answer
- It never extracted the relevant dimensions.
- It represented them and lost track of which distance belonged to which gap.
- It knew the dimensions and failed to work out how rotating the wheelchair changes its clearance.
- It reasoned correctly about a room assembled from its expectations and not the one in the photograph.
- The image lacked the information: a perspective view is not a measured floor plan.

They concern different achievements, and they cross the boundary between seeing a situation and thinking about it.
:::

### What counting needs {kind=explain at=what-visual-reasoning-requires}

Why is recognizing an apple insufficient for counting the apples in a bowl? Which of Dai's stronger claims does the essay set apart from his diagnosis, and on what grounds? Which three things does the essay say must be distinguished?

::: answer
Counting must individuate candidates, resolve ambiguous boundaries, avoid counting one object twice, and maintain progress. Dai also claims that reasoning is fundamentally visual and that visual reasoning should be the foundation for linguistic reasoning. The essay replies that the evolutionary priority of vision does not establish an engineering order, and that a textual reasoning trace does not show that every computation behind it has a linguistic format. Manning's counterweight is that language supplies cognitive tools as well as descriptions: a phrase can organize a sequence of visual comparisons. The three things are the source of information, the format of its internal representation, and the operations available over that representation. None uniquely determines the others, and modality is too coarse: a photograph, a line drawing and a coordinate table of one scene make different operations easy.
:::

### Two accounts of the border {kind=distinguish at=which-perceptioncognition-boundary}

State Block's conception of iconic representation and his claim about perception and cognition. How does Quilty-Dunn's perceptual pluralism differ, and where does he put the boundary? What follows for a boundary defined by format alone?

::: answer
For Block an iconic representation tracks and mirrors in an analog way: degrees of difference in what is represented correspond to degrees of difference in the representation, and relevant relations are preserved. It need not be a literal picture, continuous, or without parts. Block argues that perception is constitutively iconic, while cognition can also employ iconic representations. Quilty-Dunn allows both iconic and discursive representations within perception, with object representations structured like an individual bearing separately represented properties. He defends a boundary based on encapsulation and stimulus control instead of format. So finding compositional structure in perception would undermine a boundary defined exclusively by iconic against discursive format, and it would leave other boundaries available.
:::

### Four distinctions that may not coincide {kind=recall at=which-perceptioncognition-boundary}

Name the four distinctions the essay unbundles, with the question each asks of an AI system. Why does a module boundary not settle the matter?

::: answer
- Architectural: which component computes what, and how information flows between an image encoder, a connector and a backbone.
- Representational: does a computation preserve spatial relationships in relationships among internal states, separate an object from its properties, and apply a relation to new participants?
- What governs the representation: the photograph, for the room as shown, or a proposed intervention, for the room as it could be.
- Access and control: which processes can use the information for deliberate comparison, retention or report.

Divisions between components locate computations and constrain information flow. They do not show that the first component only perceives or the last only thinks. A common architecture does not show the absence of functional divisions either. The result might be one boundary or several partially overlapping ones.
:::

### Three levels of evidence {kind=state at=when-geometry-does-computational-work}

Why is locating an activation in a geometric space not yet an explanation? State the three levels of evidence, using orientation as the example. What does the linebreaking study add about features and manifolds?

::: answer
Any activation pattern can be treated as a point in a mathematical space. One has to establish which relationships in the world the geometry captures and how the model's computations use them. The levels: recovering a variable from internal states; intervening on those states to show they affect the answer; explaining the transformation, which means identifying how the state changes, what stays invariant, and how the operation behaves on new combinations. Decoding orientation, causally altering an orientation-sensitive judgment, and establishing a general rotation procedure are progressively more demanding. In the linebreaking study the same representation can be described through discrete features or through a continuous manifold. So discrete features do not by themselves establish a language of thought, and a smooth manifold does not establish a wholly different kind of cognition. What matters may be the operations an organization supports.
:::

### Days on a circle {kind=compute at=when-geometry-does-computational-work}

Put the seven weekdays at equal steps around a circle. What day falls four days after Friday, and what rotation is that in degrees? Why would distance along a line fail here? What makes the circular representations found in language models evidence about computation and not only about decoding?

::: answer
Number the days from Monday as $0$. Friday is $4$, and $4+4=8\equiv1\pmod 7$, which is Tuesday. Each day is $360/7\approx51.4$ degrees, so four days is about $206$ degrees. On a line, four steps past Friday run off the end of the week: the wraparound is what a circle preserves. Engels and colleagues intervened on the circular states while models solved calendar arithmetic, and changing the state changed the answer. The input is entirely linguistic, so geometric structure can do computational work on a task with no visual input.
:::

### What a verbal trace shows {kind=explain at=from-representations-to-reliable-operations}

Two evaluations found that chain-of-thought can hurt spatial and counting tasks, and one replaced the image with a gray field and still got detailed visual claims. What does the essay conclude from them, and what does it decline to conclude? What do the internal interventions add?

::: answer
The evidence supports concern about particular reasoning procedures and training regimes. It does not support a universal claim that more verbal reasoning damages vision: the proprietary-model results were mixed, and chain-of-thought helped mathematical, scientific and multi-image reasoning. The findings do not locate a perception–cognition boundary. A fabricated description leaves open whether the model failed to extract the evidence, lost it, outweighed it with expectations, or answered through a pathway insufficiently constrained by it. "A verbal trace is behavior to explain, including when the trace claims to report what the system saw." Causal tracing of visual object information, and an intervention that reinforces intermediate object representations, show that some failures can be addressed in how the decoder handles visual information. ReFT's interventions are themselves trained, so their success is not simply an uncovered capacity.
:::

### Recoverable is not usable {kind=distinguish at=from-representations-to-reliable-operations}

Distinguish recoverability from a learned operation, with the essay's examples. Give the three ways a verbal description can fail to help the next step. What does "clearance" illustrate about concepts?

::: answer
Two systems can both retain enough information to answer a question and differ greatly in the computation needed. An adjacency list and a drawing encode the same graph, and a coordinate sequence and an image describe the same arrangement. Recoverability establishes an informational possibility. A learned operation makes it available at a particular cost and reliability. A description can discard the relationships the next operation needs. It can preserve them and make their use expensive. It can be locally accurate and leave a global arrangement to be reconstructed from many statements. Clearance is a concept characterized by its role: it connects object dimensions, possible movement and obstruction across situations, and it may draw on a geometric estimate, a remembered rule or a measured diagram. No single format need be its sole vehicle.
:::

### Testing object identity {kind=explain at=three-ways-to-test-the-boundary}

The first proposed experiment tracks objects that move, change properties and pass behind occluders. Why would decoding color and shape with separate probes be insufficient? What would a successful intervention do, and what would it still not establish? Which further questions bring it to bear on the boundary?

::: answer
Separate probes can recover variables that the model's own computation never treats as independently reusable constituents. A successful intervention would selectively change which property belongs to which tracked object. It would produce the predicted changes in tracking, comparison and transfer to unfamiliar combinations, and preserve unrelated assignments and object continuity. Controls would separate this from general damage. That would establish an object–property association used by the system, not yet perceptual binding in the narrower philosophical sense. For the boundary one asks when the association is constructed, what maintains it, and which processes can modify it. Is it present before an explicit question is asked, does it arise only under an instruction to track, and does it persist when the image is gone?
:::

### Expectation and supposition {kind=state at=three-ways-to-test-the-boundary}

Describe the second and third proposed experiments. In the second, why does it matter where a caption's influence enters? In the third, what must an agent do beyond producing a plausible transformed picture?

::: answer
Second: keep the stimulus fixed and change a caption or prior instruction, then the converse, keeping the instruction fixed and changing a small decisive visual detail. A caption may alter the selection of image regions, the representation of the object, later interpretation, or the final decision. These are different influences with different implications for perceptual encapsulation. Sensitivity to context is not automatically corruption, so the question is how reliance on prior information is controlled. Third: show an arrangement, ask about moving one object, then ask separately about the hypothetical and the original. Vary access to the image, an external scratchpad, and the number of transformations, and measure contamination of answers about the observed scene. The agent must keep object identity across two situations while attributing different properties, know which situation a question concerns, and recover when the distinction is lost.
:::

### Routes for task information {kind=distinguish at=what-architectural-differences-change}

What do the two biological examples show about routing and timing? Within a fixed-depth feedforward pass, what can an instruction do and not do to visual processing? Why does the essay separate revising an encoding from refining a representation built from it?

::: answer
In macaque primary visual cortex, neurons responded differently to an identical stimulus depending on the discrimination being performed, so task dependence reached the processing of visual information itself. An efference copy carries information about an outgoing motor command, and the visual system can prepare for a change in input before it arrives. In a fixed-depth pass a later activation cannot return to change an earlier one. An instruction present at the start can shape later processing, and later layers can build refined representations. With a separate, task-independent image encoder, the instruction cannot alter the encoder's representation without an additional route, though it can affect downstream handling. The difference matters especially when the original encoding discarded information. Neither "feedforward" nor "multimodal" alone says how much task-directed perceptual processing is available.
:::

### Unrolling and recirculation {kind=argue at=what-architectural-differences-change}

A bounded recurrent computation can be unrolled into a feedforward one. Why does that not make a trained feedforward stack equivalent? How does the Recirculation result qualify the essay's own argument? What does the essay refuse to infer about frontier models?

::: answer
Unrolling preserves the recurrent circuit's parameter sharing. An independently trained stack need not acquire the same organization: its layers meet different inputs and gradients and can specialize in different stages, while recurrent circuitry must work across successive states with shared parameters. The essay's hypothesis is that these learning constraints affect the acquisition of reusable refinement procedures. Recirculation mixes deep-layer activations into shallower processing across input steps with pretrained weights unchanged, and it helps. So feedforward training can produce resources that benefit from a feedback route absent during training. Those were language and reasoning experiments and do not establish feedback-driven visual refinement. The public system cards of frontier models do not specify feedback pathways, and speculation that a model loops cannot establish which representations are revisited.
:::

### Thinking with the environment {kind=explain at=thinking-with-the-environment}

What is an epistemic action, and what are its counterparts for an AI assistant? What should be measured about a tool's contribution? How can an external representation hurt, and what does "revisable abstraction" ask of an agent?

::: answer
Kirsh and Maglio distinguish moves that directly advance the objective from moves that make information easier to obtain or compute, such as rotating a Tetris piece. For an assistant: marking counted objects, cropping an image, drawing a route, running a geometric calculation. One should measure whether the tool revealed information, preserved intermediate state, performed a transformation, or supplied a result the model could not compute, and whether the agent chose and used it without an experimenter preparing the solution. A drawing can make an error durable: an agent that mistakes its own sketch for an observation has a persistent source of misinformation. No summary is sufficient independently of the questions it must support. Revisable abstraction means retaining access to the source, detecting when the present representation is inadequate, locating the missing evidence, and integrating it without losing what was established.
:::

### What is open {kind=limits}

Why does the evidence not support a single verdict about frontier multimodal systems? Which developmental finding does the essay mark as contested? Which possibilities does it leave open, and what is its working hypothesis?

::: answer
Some of the strongest mechanistic results concern smaller or older models with accessible internals, and the behavioral evaluations cover other systems, procedures and dates. They cannot be combined into one hypothetical model that has every demonstrated mechanism and every reported failure. The essay asks for linked levels of evidence, with conclusions kept attached to the model and experiment they came from. The contested finding is abstraction-first learning: Jian and Manning's ordering of verb-class differences was reproduced in simulation by learners without shared class representations. Open possibilities: perception and cognition might be separated by a change of format; they might share formats and differ in control and access; some distinctions might exist only within tasks, with coordination supplied by the deployment. The working hypothesis is that they share representational resources while differing in how those resources answer to evidence and become available for flexible use. The experiments are proposals, and the essay reports no new model experiments.
:::
