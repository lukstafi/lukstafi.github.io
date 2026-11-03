# Prompts for The Bookmaker Is a Learner

*The human-side prompts that developed and steered the draft, in conversation order. Assistant responses, button replies, and interface metadata are omitted.*

## Starting the essay

Let's convert my 16-years-old notes on prediction markets into an essay for the blog, and maybe a companion writeup/appendix for what doesn't fit into the format (a hard limit of 10K to 11K words). WDYT? ~/Downloads/Dokumenty-ATG

## Decisions on the outline

Q1: Title candidate (2). Q2: two lists is fine. Q3: I would put the companion link in the same entry in the index as the main article; this renders each link on a separate line of one paragraph. Q4: math density sounds good, in case of doubt higher rather than lower. Q5: I was a TA at the University of Wroclaw, I contributed this 1 lecture and 2 exercise sets, while the main lecturer contributed the rest. (I think the lecturer, and a colleague, was Emanuel Kieroński https://ii.uni.wroc.pl//~kiero/ but I'm not 100% confident... sorry.) Q6: OK, but try adding more connections to other articles from the blog if possible, I think I'd include the collective-cognizer link. Q7: figures souds good. Mone more point: Add a box on linear programming; does it connect to Lagrange multipliers we covered before?

## My role in the course

"The course's lecturer taught nearly all of it." too strong, it was 1 hour lecture and 1 hour exercise lab / week, I was handling the lab every week IIRC.

## The lecturer

I found out the teacher! Sebastian Bala. I can also supply some emails if that helps.

## More sources

I found some more resources, check the downloads subdirectory again.

## The first exercise list

Indeed, ATGlista01 is Sebastian's

## Nitpicks

Nitpick: I'd drop "Neither development shows what the notes were about." I'd push the label "cost of 84.7 shares" slightly to the right (by the extent of two letters roughly).

## Editorial pass

Can you do an editorial pass, or are things fresh enough so it wouldn't make a difference?

## Second reading pass (3 Nov 2026)

Doing one more pass over the prediction markets essay notes/the-bookmaker-is-a-learner.md
Beginning with a nitpick: why does it say "ln n" instead of "log n", in the 3rd paragraph of "One bookmaker, four faces" and at least one more place?

## The worst case and the temperature

"Its worst case comes when the best expert is the outcome that occurs." -- How so? In what sense is that the best expert, and if it was getting best weights why is it the bad case?

Can it be phrased as the price of optimal exploration (in terms of regret rather than expected value)?

What I'm thinking is, if the learner uses a lower temperature, it gets less regret in this (worst) case, but a lower temperature is not always best.

I think we should make the analogy to exploration and compare this situation to the bandit problems. I'm guessing in a box to not distract.

## Mirror descent

What is "stochastic mirror descent"?

Is it worth adding a whole box for it? Reason: it improves intuition for learning-theoretic concerns, not only prediction markets but also RL.

", which the box below explains" not needed. The box is prominent by itself.

Somewhat off-topic, is it good to think of mirror descent in differential geometry terms? More on topic: Could you check if the new additions, or this essay in general, have relevance that the essays that come after it have missed?

## The combinatorial wall

How relevant the section "The combinatorial wall" is to our blog, generally? I put emphasis on this sub-topic because of the algorithmic content seemed a good fit for a Computer Science curriculum course.

What does it mean "shaped like the bracket"? Is about being bipartite?

We need to define "bracket" where it first appears (alternatively in a box)

Let's build out "The section has a crisp point it never states" you observed, thanks!

## Nitpicks and the final pass

"The vendor conceded that market prices had been about as accurate as the alternatives." -- Do you mean "had not been more accurate"?

Nitpick: "A market aggregates diversity of information, not the number of traders." -- I'd remove ", not the number of traders", it's cumbersome and doesn't add value.

Okay! The last two sections are not the best ones of the article, but surprisingly I don't have concrete improvement suggestions, so this looks good enough! Would you like to make a second, final editorial pass? (The previous session made one.)
