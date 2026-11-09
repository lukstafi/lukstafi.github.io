# Prompts for Before the Search Settles

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted.*

## Starting the essay

What approaches are there to logical uncertainty other than Scott Garrabrant's and MIRI?

And including Garrabrant, but also other approaches, what would you suggest for an essay on logical uncertainty if we build on prior essays? E.g. notes/the-demon-is-a-learner.md , notes/the-bookmaker-is-a-learner.md , and maybe notes/an-ontology-that-pays-for-itself.md

## Shaping the angle

"Presumed independent" -- we have notes/presumed-normal.md . Do paraconsistent logics have any benefit to logical uncertainty?

Can you remind me what the importance of logical uncertainty is to MIRI?

Is there anything special about markets, or would any truth maintenance system work for logical induction?

How important is the angle of improvement without external evidence? That could be connected to self-distillation, as in here: https://arxiv.org/html/2610.32770v1

We mention AlphaZero in notes/how-does-a-policy-improve.md

Are there game-theoretic semantics approaches to logical uncertainty?

Is the difference between adversary and debate or a smarter oracle more than framing?

## The personal connection

The personal connection is that I was friends with Abram Demski in the early 2010s... He had a logical prior theory

Attached a draft Abram shared with me. Some correspondence: [the July 2012 draft of "Logical Prior Probability" and the 2012 email threads, which stay private]

## Decisions on the outline

I downloaded notes/private/LogicalInduction.pdf (Scott Garrabrant, Andrew Critch et al.) Can we say what Abram is up to judging from https://www.lesswrong.com/posts/gS5skwXeeQdStwsPu/what-comes-with-cheap-math ? I'm not sure how to answer Q1 and Q2 at the moment, I'll let you draft first to inspire me. Q3: I won't contact Abram for confirmation, we lost touch. The outline's level of detail is fine. We also discussed working on a neural net Turing machine at that time (trained with RL to recognize non-regular languages) but haven't gotten around to it. Q4: no companion, math as part of the article. Q5: a section. Q6: maybe as now. Q7: no need.

https://arxiv.org/html/1609.03543v5 is the Logical Induction paper as html

## Revising the draft

How do reason and the latent structure relate?

Go ahead, thanks!

Maybe we should replace "my friend" by "my friend at the time" or "a colleague"?

"Fourteen years later the threads of that correspondence look like a table of contents." This maybe implies too much prescience to that correspondence. It's a table of contents for the blog because recently I've been recapitulating the highlights of my intellectual life on the blog, in parallel to inspirations from the latest AI developments.

Let's do another iteration on notes/before-the-search-settles.md . Start by committing the existing changes to keep continuity, since later essays are already committed.

"The last part of the essay asks what they imply for machines that improve themselves without new evidence, which turns out to be the same question." -- this probably overclaims, but I'll need to read to the end to see if the hook is justified.

What's "the problem of old evidence"?

Is it worth adding a box for the problem of old evidence? Could that problem of old evidence be related to cognitive biases among sophisticated people, where they are not empiricist enough despite believing themselves to be empiricist?

Right, maybe there's a bias for what I had in mind but it's in lack of sophistication: refusing to bracket what turns out to be true and see what the hypothesis indicates about that and the alternative.

## Tightening and the final passes

Let's try tightening the presentation in notes/before-the-search-settles.md , keeping the information but maybe rearranging if there's redundancy. A couple other points:

"It enumerates every polynomial-time trader, gives trader k with budget b a fixed weight 2^{−k−b} , and cuts off any trader whose losses exceed its budget." -- Is this meant to be polynomial time? If yes let's show it. Or is it the whole process of the inductor? Does this construction itself show the no-exploitation result?

Might be worthwhile to flesh out the “five-and-ten” example.

I think this article is a great fit to explain Solomonoff induction too, in a box. Let's add it, then give me an overview of concepts presented and wordcounts.

For what "Learning without new evidence" uniquely sheds light on, given prior articles (policy improvement, continual learning...), would it have a better home after the LLM deep dive (part 1 architectures and part 2 training)?

"which reads its program one bit at a time and writes its output one bit at a time" -- this reads nice but I feel is imprecise. A possible reading is it reads and writes a bit at each tick of some clock. Is the actual condition that the input head and the output head only advance, with reading/writing and advancing being one operation?

And also there's an internal tape for computations.

Is there value in doing one more editorial pass before we publish on the blog website?
