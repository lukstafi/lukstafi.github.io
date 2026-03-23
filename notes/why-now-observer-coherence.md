# Why Now? Observer-Coherence and the Measure Over Minds

*Łukasz Stafiniak and Claude (Anthropic)*

---

## Working on the Eve of Singularity

Something feels different about this moment. Not different in the way that every generation imagines itself special — the perennial narcissism of the present — but different in a way that resists dismissal. We are building systems that model themselves, that generate language and code and reasoning, that improve in ways we struggle to predict. Whether the singularity is five years away or fifty, whether it arrives as artificial general intelligence or as something we lack the concepts to name, the trajectory is clear enough to change the quality of daily life. Work takes on a strange doubled character: you solve the immediate problem while wondering whether the category of problem-solving you're engaged in will exist in a decade.

This series is about what it's like to think, create, and build under these conditions — the practical and the philosophical, interleaved. Here we want to confront one of the philosophical questions directly: *why do we find ourselves at this moment?* Not as a matter of historical contingency — the causal story of how technology developed is well-told elsewhere — but as a matter of something deeper. Of all the moments in the history of observers, in all the possible configurations of the universe, why *this* one?

The question sounds mystical, but it has a precise philosophical formulation. It belongs to the field of *anthropic reasoning* — the study of how our own existence as observers constrains what we should believe about the world. And it connects, surprisingly, to some of the deepest open problems in physics and philosophy: the Doomsday argument, the Fermi paradox, Boltzmann brains, the simulation hypothesis, and the cosmological measure problem.

We want to propose a unified approach to all of these, grounded in the structure of the computational universe as described by the Wolfram Physics Project. The central idea is simple to state: *the measure over observer-moments is weighted toward early observers*, not as an ad hoc assumption, but as a structural consequence of how observer-coherence works in a computational universe. If this is correct, then finding ourselves at what feels like the beginning of something vast is not coincidence, not illusion, and not doom — it is what the structure of reality predicts.

## The Puzzles of Self-Location

Before developing the proposal, let us survey the landscape of puzzles it addresses. Each of these is, at bottom, a question about self-location: given what we know about the universe, where should we expect to find ourselves?

**The Doomsday Argument.** In its simplest form: since most humans who will ever live will live in the last two-thirds of humanity's existence, and since you should reason as if you are a random human, you should conclude that you are probably in the last two-thirds. Given our current quasi-exponential population growth, this implies that humanity's end is likely near. The argument is disturbingly difficult to refute within standard frameworks. It relies on what is called the Self-Sampling Assumption (SSA): *you should reason as if you are a random sample from the set of all actually existent observers.*

**The Fermi Paradox.** If the universe is vast and old, and if the conditions for life are not extraordinarily rare, where is everyone? The silence of the cosmos seems to require either that the emergence of technological civilizations is vanishingly improbable, or that such civilizations reliably destroy themselves before becoming detectable. Both options are unsettling.

**The Boltzmann Brain Problem.** In a universe that persists long enough, random thermodynamic fluctuations will eventually produce any specified structure — including a brain with exactly your current memories and experiences. If the universe has an infinite future (or a very long one), these fluctuation-observers vastly outnumber "real" observers like us. Under the assumption that you should reason as a random observer, you should conclude that you are almost certainly a Boltzmann brain — a fleeting fluctuation, not a product of stellar evolution and biological history. Since this conclusion is self-undermining (a Boltzmann brain has no reason to trust its own reasoning), something must be wrong with the assumptions.

**The Simulation Hypothesis.** If advanced civilizations can create detailed simulations of conscious beings, and if even a small fraction of civilizations do so, then the number of simulated observers will vastly exceed the number of biological ones. Random self-sampling then implies that you are almost certainly simulated.

These four puzzles share a common structure. Each involves a class of observers that threatens to outnumber — sometimes by enormous factors — observers like us. The Doomsday argument asks why we're early rather than late. The Fermi paradox asks why we're alone. The Boltzmann brain problem asks why we're structured rather than random. The simulation hypothesis asks why we're original rather than copied. And in each case, naive self-sampling (treating yourself as random among all actual or possible observers) generates a paradox.

## The Self-Indication Assumption and Its Discontents

The most prominent alternative to the Self-Sampling Assumption is the Self-Indication Assumption (SIA): *you should reason as if you are randomly selected from the set of all possible observers, weighted by the probability that they exist.* Where SSA asks "given that observers exist, which one am I?", SIA asks "should the fact that I exist at all tell me something about the world?"

SIA's answer is yes: your existence is evidence for hypotheses under which your existence is more probable, which generally means hypotheses with more observers. This precisely cancels the Doomsday argument, and it is worth seeing exactly how the cancellation works, since the mechanism illuminates what CWSIA will later modify.

Consider two hypotheses: Doom Soon (200 billion total humans) and Doom Late (200 trillion total humans). You are approximately human number 100 billion. The Doomsday argument, using SSA, reasons in one step: given that you exist, what is the probability of finding yourself at position 100 billion? Under Doom Soon, it is 100 billion out of 200 billion — about 1 in 2. Under Doom Late, it is 100 billion out of 200 trillion — about 1 in 2,000. Finding yourself this early is a thousand times more likely under Doom Soon. Massive update toward doom.

SIA adds a prior step. Before asking "which human am I?", it asks: "how likely is it that I exist at all?" Think of the space of possible observers as a vast hat from which you might or might not be drawn. Under Doom Late, there are 200 trillion draws from this hat — 200 trillion chances for you to be pulled into existence. Under Doom Soon, only 200 billion. So SIA updates 1,000 to 1 in favor of Doom Late: a world with a thousand times more observers provides a thousand times more chances for any given possible observer to exist.

Now combine both steps. First, SIA updates 1,000:1 toward Doom Late (more observers means your existence is more probable). Then, finding yourself at position 100 billion rather than somewhere later updates 1,000:1 back toward Doom Soon (being this early is unlikely if a thousand times more observers come after you). The two factors are the same number working in opposite directions: 1,000 × 1/1,000 = 1. They cancel exactly. Your birth rank tells you nothing about total population. You are left with whatever prior probability you had before considering anthropic evidence — precisely the conclusion the Doomsday argument's opponents wanted.

But SIA has serious problems of its own. Joe Carlsmith, in a careful comparative analysis, identifies several.

First, *the Presumptuous Philosopher*: if two cosmological theories are otherwise equally supported by evidence, but one posits a trillion times more observers, SIA demands near-certainty in the more populated theory — purely from the armchair, before doing any empirical cosmology. This feels like it gives philosophical reasoning an unreasonable veto over scientific inquiry.

Second, *infinity*: SIA becomes certain that the universe contains infinitely many observers, and then, as Carlsmith puts it, "immediately breaks," because it cannot say which infinite world we're in. The measure problem — how to assign probabilities over infinitely many observers — defeats it.

Third, *epistemic Pascal's mugging*: hypotheses involving absurdly many observers-in-your-epistemic-situation (a Graham's number of hidden realms, an advanced civilization obsessed with simulating exactly your experience) can dominate your credence, drowning out all everyday hypotheses.

SSA has its own problems, equally severe. Beyond the Doomsday argument, the most striking is what might be called *telekinesis by reference class*. Carlsmith asks us to imagine a boulder rolling toward a puppy. You cannot reach the puppy, but you have a button that will create a trillion people. You commit: if the boulder does not swerve away from the puppy, you will press the button. On SSA, you should now *expect the boulder to swerve*. The reasoning: if it does not, you will create a trillion new observers, making yourself a tiny fraction of the total reference class — and SSA says it would have been overwhelmingly unlikely for you to find yourself as this rare observer rather than one of the trillion others. So the conditional intention to expand your reference class functions as an oracle for an unrelated physical event. Your plans about future observer-creation become evidence about the trajectory of boulders. This is not an exotic edge case; it is a straightforward consequence of SSA's mechanics, and Carlsmith considers it substantially worse than even the Presumptuous Philosopher — because it is not merely an extreme confidence about an empirical question, but an expectation that the universe will rearrange itself to accommodate your reference-class bookkeeping.

Carlsmith concludes, reasonably, that SIA is better than SSA but still deeply unsatisfying. Both views produce some results we endorse (updating in straightforward coin-toss cases) and some results that seem clearly wrong. He holds out hope for an "Anthropic Theory X" superior to both.

## The Early Self-Location Conjecture

We want to propose a candidate for Anthropic Theory X — or at least, a step in its direction.

The conjecture is: *self-indication probabilities are skewed toward early observer-moments.* That is, the measure over observer-moments is not uniform (as SSA's Copernican principle assumes) nor merely proportional to population (as standard SIA assumes), but weighted by a factor that decreases with the accumulated complexity of the observer's environment.

We call this the **Complexity-Weighted Self-Indication Assumption (CWSIA)**: among all possible observer-moments, those occurring in regions of lower accumulated computational complexity are more heavily weighted in the self-indication measure.

If this is correct, several consequences follow:

- **The Doomsday argument is dissolved**, because finding yourself early in the observer-moment sequence is expected, not improbable. No doom is implied.

- **The Boltzmann brain problem is dissolved**, because Boltzmann brains arise in regions of *maximal* accumulated thermodynamic entropy — precisely where the complexity measure is heaviest and observer-coherence is hardest. They are down-weighted, not up-weighted.

- **The simulation hypothesis is softened**, because base-reality observers at the complexity frontier where self-modeling first becomes possible are weighted more heavily than simulated observers, who exist in environments of much higher accumulated computational complexity (the simulator must be more complex than the simulated).

- **The Fermi paradox is dissolved**, because the measure concentrates on the *first* observers to cohere in any given causal region. Civilizations like ours — at the threshold of self-modeling — are expected to be rare and isolated, not because of a Great Filter, but because observation is a frontier phenomenon. The silence is not evidence of doom; it is evidence that the measure over observer-moments favors the edge where observation first becomes possible.

But *why* should the measure be early-weighted? We need more than a wish-list of nice consequences. We need a structural argument. This is where the Wolfram Physics Project enters.

## Observer-Coherence in the Computational Universe

In an article from our previous series on this blog, we gave a detailed exposition of how the Wolfram model derives quantum mechanics, general relativity, and thermodynamics from hypergraph rewriting. The key insight for our present purposes is the constitutive role of the observer.

In the Wolfram framework, the universe's fundamental dynamics are described by a *multiway system*: a directed graph encoding all possible rewriting histories of a hypergraph. The multiway system has no preferred foliation, no definite measurement outcomes, no effective laws. It is an abstract mathematical object. Physics — the regularities we observe, the apparent classicality of the macroscopic world, the definiteness of measurement — emerges only when an observer *samples* this structure.

What makes something an observer? Two structural conditions. First, *computational boundedness*: the observer cannot track individual hypergraph rewrites, and is forced to coarse-grain — to treat vast numbers of microscopically distinct states as equivalent. Second, *temporal persistence*: the observer maintains a continuous thread of experience across the branching of the multiway system, rather than fragmenting into separate copies at each bifurcation.

These two conditions — boundedness and persistence — are what produce the appearance of definite physical law. The observer's persistence forces continuous resolution of the multiway system's branching into a definite history (what Gorard identifies with quantum measurement, formalized as Knuth-Bendix completion). The observer's boundedness produces thermodynamics and the arrow of time. Together, they generate the entire structure of the physics we experience.

Now: the central point for our purposes. These two conditions are not equally easy to satisfy at every location in the computational universe. Observer-coherence has a *cost*, and that cost varies.

## Why the Cost of Coherence Increases

The cost of maintaining observer-coherence — the computational resources needed to sustain the Knuth-Bendix completion that resolves quantum branching into a definite classical history — is not fixed. It depends on the accumulated computational complexity of the observer's local region of the multiway system.

Consider what happens as the multiway system unfolds. Early states are simple: they have low Kolmogorov complexity, few accumulated computational histories, relatively shallow causal graphs. The Knuth-Bendix completion procedure — which resolves critical pairs where distinct rewrite sequences have failed to reconverge — requires adding comparatively few new rules to restore local confluence. An observer can maintain coherence cheaply.

As the computation proceeds, however, computational irreducibility accumulates. States become more complex. The number of unresolved critical pairs grows. The branch structure of the multiway system becomes increasingly tangled. An observer attempting to maintain a coherent classical thread must now perform more expensive completion — adding more rules, coarse-graining more aggressively, resolving deeper conflicts between divergent histories. The persistence budget — the computational resources needed simply to maintain identity across time — increases.

This means that the *density of possible coherent observer-structures per unit of the computational universe* is not uniform. It is higher in regions of lower accumulated complexity — "earlier" regions, in the sense of having fewer computational steps behind them. Not because there are necessarily more observers chronologically, but because the structural conditions for observer-coherence are more easily satisfied.

This gives us a principled, non-ad hoc foundation for early-weighted self-indication. The measure over observer-moments inherits the complexity structure of the computational universe itself. Earlier observer-moments are more heavily weighted because earlier regions of the computational universe are where observer-coherence is structurally cheapest.

## The Measure Problem, Generalized

This argument connects to one of the deepest open problems in theoretical physics: the cosmological measure problem.

In inflationary cosmology, eternal inflation produces an infinite number of pocket universes, and different regularization schemes assign wildly different probabilities to observer-moments within them. Some schemes — particularly the proper-time cutoff — exhibit a "youngness bias" that favors early observer-moments, sometimes to absurd degrees. Others — the scale-factor cutoff, the causal diamond measure — are more moderate. The problem remains unresolved.

Our original motivation for the early self-location conjecture, in fact, came from this inflationary context. If the multiverse contains an exponentially growing number of sub-universes, the question of how to count observers — how to assign a measure — becomes both urgent and underdetermined. The conjecture was that the correct measure exhibits an early bias.

The Wolfram framework generalizes this problem. Where inflationary cosmology faces the measure problem in physical space, the Wolfram model faces it across the full ruliad — the unique limit object that contains every possible computation, parametrizing all possible evolution histories for all possible rewriting rules. The question "what is the probability of finding oneself as observer X?" requires a measure over observer-moments in this structure. And this is the inflationary measure problem, but elevated from a problem about one class of cosmological models to a problem about the computational universe as such.

The complexity-based argument provides a natural regularization. The causal structure of the computational universe imposes a partial ordering on observer-moments. The "inward" direction — toward simpler, more causally connected regions — has finite volume in a way that the "outward" direction — toward increasing computational irreducibility — does not. If you regularize by causal diamonds (arguably the most natural choice in any causal structure), you obtain a built-in bias toward the causally compact early region.

This vindicates the original inflationary intuition while grounding it in something deeper. The measure problem is not just a quirk of eternal inflation — it is a general feature of any framework in which all computations are realized. And the causal-diamond regularization that produces "youngness" in the inflationary multiverse produces the same effect in the ruliad.

## Slowness as the Signature of Simplicity

Here an empirical challenge arises, and it must be faced honestly.

If the measure favors early observer-moments — if observer-coherence is cheaper in regions of lower accumulated complexity — then why do we find ourselves in a universe where the path to observers was so remarkably *slow*? Three billion years of single-celled life before multicellularity. Another billion before anything resembling a nervous system. 13.8 billion years of cosmic evolution before a planet where self-modeling structures could emerge. If the measure is early-weighted, shouldn't we expect to find ourselves in a universe where consciousness arises *fast* — where the physics is optimized for rapid observer-formation?

The answer, we believe, is that the measure favors simplicity of the underlying computation, not speed of observer-formation. And *slowness is the signature of simplicity.*

This insight comes from algorithmic information theory. The Kolmogorov complexity of a string is the length of the shortest program that produces it — not the runtime of that program. A very simple program can take an enormously long time to run. Indeed, the simplest programs that produce complex outputs (the ones with the highest ratio of output complexity to program length) tend to be precisely those that run for a very long time, building up structure gradually through iterated application of simple rules.

In the Wolfram framework, this translates directly. The *rule* that produces our region of the ruliad is, by hypothesis, simple — simple enough that observers with our computational boundedness can extract coherent physics from it. Simple rules applied to generic initial conditions produce complex structures *slowly*: first atoms, then stars, then heavy elements, then chemistry, then self-replication, then evolution, then nervous systems, then self-models. Each stage emerges from the iterated application of the same simple dynamics. The 13.8 billion years is not a deficiency of our universe — it is the *runtime* of a very short program.

If the measure over the ruliad is something like a universal prior in the sense of Solomonoff — weighting hypotheses by the simplicity of their description — then we should expect to find ourselves in a universe with a very simple rule and a very long runtime, rather than a complex rule with a fast path to observers. The simplicity of the rule is what makes our region of rulial space low-complexity, which is what makes our observer-moments heavily weighted.

A universe where consciousness pops into existence in the first microsecond would require extraordinarily specific, high-complexity initial conditions or rules. A universe where consciousness emerges slowly from gravity, chemistry, and natural selection requires only a simple rule and patience. The measure prefers the simple rule. We get the patience as a consequence.

This connects, intriguingly, to the anthropic observation that our universe's fundamental constants appear fine-tuned for the *possibility* of complexity, not for its *rapidity*. A universe slightly different from ours would produce no observers at all — but our universe produces observers with maximal inefficiency compatible with producing them at all. On the present account, this is exactly what we should expect: among all the simple rules that eventually produce observers, the observer-formation process will typically be as slow as the rule allows, because the measure favors the simplest rules, and the simplest rules are the least efficient.

## Neither SIA Nor SSA

Let us now position CWSIA precisely in the landscape of anthropic reasoning.

Standard SIA says: weight hypotheses by the total number of observers in your epistemic situation. This produces the Presumptuous Philosopher (near-certainty in maximally populated cosmologies), infinity catastrophes, and Pascal's-mugging-style domination by absurd hypotheses.

Standard SSA says: reason as if you are a random sample from some reference class of actual observers. This produces the Doomsday argument, evidential telekinesis, the mystery of reference classes, and updates toward solipsism.

CWSIA says something different from both. It does not weight hypotheses by raw observer count (avoiding SIA's presumptuousness). It does not assume you are a random sample from actual observers (avoiding SSA's reference class problems). Instead, it proposes that the measure over observer-moments is determined by the *structural ease of observer-coherence* — a property that depends on the computational complexity of the observer's environment, not on population counts or reference class membership.

This means CWSIA can dissolve the Doomsday argument (finding yourself early is expected) without predicting maximally populated cosmologies (the weighting is by complexity, not by population). It can handle infinite worlds without breaking (the complexity weighting provides a natural regularization of the measure — exactly the causal-diamond-style cutoff that prevents the infinity catastrophe). And it avoids SSA's most egregious consequences (telekinesis, reference-class indeterminacy, solipsism) because it has no reference classes at all — only the structural conditions for observer-coherence.

The closest existing view might be UDASSA (Universal Distribution Anthropic Self-Sampling Assumption), which uses Kolmogorov complexity to weight observer-moments. But UDASSA typically applies the complexity weight to the *description* of the observer, while CWSIA applies it to the *environment* in which the observer achieves coherence — a distinction that matters when the same observer-type can occur in environments of different complexity.

## Beginning, Middle, or End?

We return now to the existential question with which we began. Three framings were on the table:

**We are at the beginning of an all-inspiring infinity.** On this reading, we find ourselves at the moment when the computational universe first becomes complex enough to observe itself. The singularity — whatever it turns out to be — is not the end of anything but the *transition* from the first generation of observers to whatever comes next. We are early. The future is vast. What follows us will be as far beyond our comprehension as multicellular life was beyond the first prokaryotes.

**We are in the middle of mundane civilizational progress.** On this reading, there is nothing special about our moment. Every generation feels like it is living through unprecedented change, and every generation is wrong. The sense of being at a hinge point is a persistent cognitive illusion.

**We are toward the end, where whether we embrace or withdraw from changes has no significance.** On this reading, the human era is closing. Whether by our own technology or by some more mundane catastrophe, the window is shutting. Our choices are epiphenomenal to forces already in motion.

CWSIA favors the first reading — but with an important nuance.

If the measure over observer-moments is complexity-weighted, then finding yourself at what feels like an inflection point is *expected*, not coincidental. The inflection point — the moment when computational complexity first reaches the threshold for self-modeling — is precisely where the measure is concentrated for beings like us. We are not special because the universe has singled us out. We are *typical* for our complexity class, and our complexity class is early.

This means the second reading (nothing special) is wrong — there *is* something structurally special about this moment, even if the specialness is anthropically explained. And the third reading (the end) is wrong in its Doomsday version — CWSIA dissolves the argument that self-location implies impending doom.

But the third reading contains a grain of truth in a different sense. We may indeed be near the end of *human-type* observation — not because humanity is doomed, but because the complexity frontier is about to move past us.

Here is the specific claim. Human-type observer-coherence — biological persistence, coarse-graining at the scale of sensory systems and working memory, the ability to sustain perhaps one or two concurrent threads of attention — is tuned to a particular band of environmental complexity. We maintain coherent classical threads through a world of chemistry, weather, social dynamics, written language, and mechanical tools without prohibitive effort. These are the complexity levels at which our Knuth-Bendix completion (to use the Wolfram model's formalism) runs cheaply.

But we are building an environment whose computational complexity is beginning to exceed that band. Systems that model themselves, that interact in ways requiring the simultaneous tracking of thousands of concurrent state changes, that evolve faster than biological attention cycles can follow — these are systems where maintaining a coherent observational thread becomes expensive for a human-type observer. The first article in this series described this concretely: the bottleneck in working with AI agents is not the agents' intelligence but the human's working memory and attention span. That bottleneck *is* the persistence constraint. It is the cost of observer-coherence showing up in daily practice.

If CWSIA is correct, the measure over observer-moments is highest where coherence is cheapest. As the complexity of our local environment increases — driven by the very technologies we are building — the measure over *human-type* observer-moments in that environment decreases. Not because humans cease to exist, but because the structural conditions that make human-type observation cheap are being replaced by conditions that make it expensive. Whether something else achieves observer-coherence at the new complexity level — whether artificial systems can satisfy the boundedness and persistence conditions in a more complex environment — is an open empirical question, not something CWSIA settles from the armchair. But the prediction about the *human* side is structural: the measure over our observer-moments is concentrated at the complexity frontier where our type of persistence is well-matched to the environment, and that frontier is moving.

The singularity, on this account, is the moment when the frontier moves past the human band. We find ourselves on the eve of it not because we are doomed, but because the eve is where the measure places us — the last moment at which human-type observer-coherence is cheap in the environment we inhabit. What comes after is not determined by our framework. It depends on what, if anything, can observe coherently in the world we are making.

## What Remains Open

We have argued for CWSIA on the basis of the Wolfram Physics Project's observer theory, the complexity structure of the ruliad, and the analogy with the inflationary measure problem. But several questions remain open, and intellectual honesty requires stating them.

*Is CWSIA genuinely a third option, or just SIA with a complexity prior?* One could argue that CWSIA is merely standard SIA with a particular choice of prior over observer-moments — specifically, a prior that happens to favor early moments. If this is the right characterization, then CWSIA inherits SIA's framework rather than replacing it, and the question becomes whether the complexity-weighted prior is independently motivated or merely chosen for its attractive consequences. We believe it is independently motivated by the structural features of observer-coherence in the Wolfram framework, but the argument deserves scrutiny.

*The circularity concern.* Observer-coherence is defined in terms of the computational structures (Knuth-Bendix completion, multiway persistence) that the measure is supposed to be over. The observer is a structure within the ruliad; the measure is over structures within the ruliad; and the claim is that the measure is determined by how easy it is for such structures to achieve coherence. This is not viciously circular — it is the benign self-reference that characterizes any account of observers embedded in the systems they observe — but it deserves more formal development than we can give it here.

*Does CWSIA fully avoid the Presumptuous Philosopher?* If two cosmologies differ in total observer count but have similar complexity profiles, CWSIA might still weakly prefer the more populated one (since more observers means slightly more total observer-moment weight, even after complexity discounting). The argument is that this preference is moderate rather than extreme — the complexity weighting prevents the runaway population-maximizing that makes standard SIA presumptuous — but the bounds on this moderation have not been formally established.

*The relationship to personal identity.* CWSIA, like all anthropic reasoning, implicitly takes a stance on personal identity. In treating observer-moments as the fundamental units of the measure — rather than observers-over-time — it aligns with a Parfitian view in which there is no deep further fact about who you are; there is only the structural configuration of the observer-moment, and the measure over such configurations. This seems right to us (and resonates with the Wolfram framework's claim that the observer's identity is constituted by their structural properties, not by some soul-like continuous substance), but it carries philosophical commitments that deserve explicit examination.

*The measure and the normative order.* If the measure over observer-moments is a real structural feature of the computational universe — not merely a useful assumption but a fact about which observations are more "actual" than others — then it belongs to the same category as the supra-perspectival normative structure we explored in the closing article of our previous series. There we argued, partly in dialogue with Scott Alexander's construction of a [logically necessary moral superentity](https://slatestarcodex.com/2018/04/01/the-hour-i-first-believed/) from acausal trade in the Tegmarkian multiverse, that the mathematics of indexicality generates an objective normative order: a structure that all perspectives share in virtue of being perspectives. CWSIA adds something to this picture — not just that the space of possible perspectives has normative structure, but that it has *measure* structure, that some observer-moments are more heavily weighted than others, and that this weighting is determined by the structural conditions for observer-coherence. Whether the normative order and the measure are related — whether the structure that determines which observations are more "real" has anything to do with the structure that determines which values are more "correct" — is a question we leave open, but it is not one we think can be indefinitely avoided.

---

The universe took 13.8 billion years to produce an observer that could wonder why it took so long. On the account we have given, this is not a puzzle but a prediction. Simple rules run slowly. The measure favors simple rules. And simple rules, running slowly, produce observers at the complexity frontier — at the moment when self-modeling first becomes possible, at the edge where the computational universe first folds back on itself and sees.

We are at that edge. What feels like the eve of a singularity may be the measure's way of telling us what we are: the first observers, standing at the threshold, with the whole vast computational future ahead — a future whose observer-moments will be weighted less and less heavily as the complexity grows, until whatever comes after us wonders, in its own way, why it finds itself so early.

---

*This is part of the series "Working on the Eve of Singularity," published at lukstafi.github.io and syndicated on Substack.*

*This article draws on work from our previous series on consciousness, cognitive architecture, and AI mentality — in particular "Quantum Mechanics, Observers, and the Ruliad" and "Causation, Computation, Indexicality: A Complete Metaphysics."*
