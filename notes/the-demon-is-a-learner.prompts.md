# Prompts for The Demon Is a Learner

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted. The same conversation planned and drafted the preceding essay, [The Standard of Motion](the-standard-of-motion.html), whose prompts page has the shared early prompts in full. Later sections come from later sessions.*

## The seed

Do you think the following article is a good seed for a blog essay about physics, information, and AI? https://arxiv.org/html/2609.15897v1

## Algorithmic information and thermodynamics

Some other angles. I had a seminar which unified the different mechanics (classical mechanics, statistical mechanics, and quantum mechanics) into one picture. What's the connection between algorithmic information theory and thermodynamics?

I don't remember but it wasn't particularly fancy, it was putting them in a single Lagrangian / Hamiltonian framework.

## Planning

Would you like to work out the essay here, though? Would we also need to introduce Lie algebras?

## The qualitative theory

Does the qualitative theory of differential equations have any relevance to this discussion?

This was the seminar's opening chapter IIRC, before introducing Largangian (? I don't quite remember) and Hamiltonian (definitely) pictures.

## Drafting

Can you draft essay B while I read essay A?

## The shared mathematics page

Does "The Demon Is a Learner" share the mathematics supplement with "The Standard of Motion"? Does it not need additions there yet?

Yes, add B's details where they help to the existing companion.

## The geometry of Aristotle's law (3 Nov 2026)

From a revision session for *The Bookmaker Is a Learner*, which added boxes on bandits and on mirror descent:

What is "stochastic mirror descent"?

Somewhat off-topic, is it good to think of mirror descent in differential geometry terms? More on topic: Could you check if the new additions, or this essay in general, have relevance that the essays that come after it have missed?

## A mathematics page of its own (5 Nov 2026)

Let's continue working on notes/the-demon-is-a-learner.md . Let's split off the mathematics page from the previous essay's one (section 7) into a standalone companion article, but let's mark it as a clear continuation of the previous companion article keeping Liouville in the previous article. I want to make the new companion article more expository, similar to how the old companion article grew more exposition. Maybe we can brainstorm on giving the main essay some more personal touch and more insights. One thing we did in that Piotr Biler's seminar is we derived the non-decreasing entropy theorem from the mechanistic equations of ideal gas, where gas particles were balls. Where the arrow of time entered into the theorem was by assuming independence for balls before collision. One avenue for extra exposition is that I would like to introduce some of the most useful tools of statistical mechanics and/or classical thermodynamics with applications in machine learning.

## Reading the primer on entropy and temperature

"keeps the formula and replaces the frequencies of balls with the probabilities of an ensemble" is unclear. "applies Shannon entropy to ...", actually not sure WDYT?

"a fact about one system" -> "a fact about one (actual) state", and then "the (potential) states of the whole system", WDYT?

"Temperature is an exchange rate" starts using functions S without announcing what they refer to.

Didn't you mean to take derivative wrt. E_A for both sides of the equation that follows?

Ah right, dE_B is what survives since dE_B / dE_A is -1

## A Carnot cycle for learners

Is there something like a Carnot engine cycle for machine learning?

"I know of no such cycle for training a network." Not literally, but I like your Boltzmann-machines analogy.

## Friston

Inference is part of machine learning, broadly speaking (or maybe of AI). Would it be worthwhile to bring up Friston's free energy principle, or would it crowd the essay unnecessarily?

## Usable information

Learning maximally compressed representations might not be beneficial because the information might be less usable. Is there a notion of usable information in this sense that would fit in the essay?

## Coarse graining

Do we have a good enough account of coarse graining? Is there anything to be told about that concept?

## How long a companion may be

The hard limit does not apply to the companion page, because companion pages do not go out on Substack. (It's still good as a soft limit to not make articles overwhelming.)

## Review and editorial pass

I'd say we're "ideas-complete" for this essay and companion, but I haven't done a thorough reading. Would you like to do a review and an editorial pass now?

## Why systems seem to minimize energy

Where does the intuition that systems minimize energy come from? Is it an Aristotelian intuition I guess? Is minimizing free energy a thermodynamical law?

But in "$F = E - TS$ for the system alone", E is the total energy, or is it the system's?

Ah, so the minus sign goes from maximizing entropy to minimizing free energy, thanks.

## Regularized objectives

Are we actually making a connection between free energy and a regularized objective?

## JEPA

Is the recent-ish result about JEPA and Bayesian prior IIRC relevant for us?

Ah sorry was recalling it very vaguely, I meant the "isotropic Gaussian" one so you found it.

## The Polyak–Łojasiewicz condition

Let's work on notes/the-demon-is-a-learner.md . "Boris Polyak’s condition of the same year, now called the Polyak–Łojasiewicz condition, says that the squared gradient bounds the height of the loss above its minimum." -- it's unclear but sounds valuable, let's add more detail.

That looks suspicious, doesn't it say L has no local maxima?

## Drag from the Fisher information

"In the limit of small steps it is a gradient flow under the Fisher information metric, whose inverse is diag(p)" -- I wonder if we could give it a bit more exposition? It's just this one sentence leading to this equation, and `diag` is unclear. We can assume the Fisher information box, lines 45 to 54 of who-teaches-the-weights.md

## The seminar

"A seminar I attended, run by Piotr Biler around 2003, took this on directly." -- it's "the" seminar because it was introduced in the previous essay (The Standard of Motion)

## Erasing the digits of π

"A demon that recognizes the digits as π compresses them reversibly into a short program first, and erases that." -- The pragmatics here are confusing, what's the benefit of compressing if you need to spend on the erasure of the difference anyway?

## Ω as a partition function

"John Baez and Mike Stay treated the halting programs of a universal computer as the microstates of a gas, with log running time as energy and program length as volume (Baez and Stay 2012). Gregory Chaitin’s halting probability Ω is then a partition function, the normalizing sum of a Gibbs distribution, evaluated where the analogue of temperature is infinite." -- This is too pithy to be useful. We say "the analogue of temperature is infinite" but then analogize to the bookmaker with temperature b. We also don't learn why the energy and volume "homologues" make sense.

## Levin search

This brings up a nice opportunity: we could add a box about Levin search. WDYT?

The other option is to add it to the next essay, which is otherwise already finalized. It contains Solomonoff induction.

The next essay is overly long. We could move Solomonoff induction out of it if comparison with Levin search justifies it.

## Bottleneck and generalization

"Minimizing the bound on the engine’s dissipation gives the information bottleneck, a standard method of compressing data for prediction, with the ratio of the two temperatures as its trade-off parameter." The information bottleneck technique is meant to drive generalization. Can we relate generalization to either of the two ratios?

"Since [...] the bottleneck pays up to α−1 irrelevant bits for each relevant one." This explanation is not clarifying, I don't see how the implication works and what's the meaning behind the equality in the premise

## The Boltzmann machine as an engine

Is the analogizing for the Boltzmann machine based on: the work that it does being the learning improvement? Intuitively, clamping the inputs lowers the temperature, and the greater the differential, the more learning happens in the dream phase.

## Depth

Is there any thermodynamic reading to the layeredness of deep learning models? Either strict as in deep restricted Boltzmann machines, or with residuals (which also has dynamic system interpretation in the limit)

## Final editorial pass

Do a final editorial pass, thanks!
