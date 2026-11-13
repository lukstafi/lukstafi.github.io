---
title: "Study notes: The Bookmaker Is a Learner: The Mathematics"
essay: the-bookmaker-is-a-learner-mathematics
track: learners-and-uncertainty
reviewed-against: "4eeb594"
requires:
  - {at: the-bookmaker-is-a-learner, for: what the mechanisms are for, strength: helpful}
exercises: exercises
introduces:
  - {term: sequential convex pari-mutuel mechanism, at: three-automated-market-makers, related: ["cost-function market and the LMSR"]}
  - {term: shadow price, at: convex-duality-toolkit, related: ["temperature as a Lagrange multiplier", "flow conservation", "momentum as the price of a constraint", "temperature as an exchange rate"]}
  - {term: conjugate representation of a cost function, at: market-scoring-rules-and-cost-functions-are-one-family, related: ["follow the regularized leader", "proper scoring rule", "free energy"]}
see-also:
  - {term: Lagrange multipliers and complementary slackness, at: how-does-a-policy-improve#improving-a-distribution-without-throwing-away-the-prior}
uses:
  - {term: proper scoring rule, from: the-bookmaker-is-a-learner}
  - {term: subset betting and pair betting, from: the-bookmaker-is-a-learner}
  - {term: market scoring rule, from: the-bookmaker-is-a-learner}
  - {term: cost-function market and the LMSR, from: the-bookmaker-is-a-learner}
  - {term: Hedge as a bookmaker, from: the-bookmaker-is-a-learner}
  - {term: follow the regularized leader, from: the-bookmaker-is-a-learner}
---

These questions cover the spine of the page: three market makers and the equivalences among them.

### Proper and strictly proper {kind=state at=three-automated-market-makers}

Define a proper scoring rule and a strictly proper one. Give the logarithmic rule.

::: answer
A scoring rule pays $s_i(p)$ for a reported distribution $p$ when outcome $i$ occurs. It is proper if $\mathbb E_{i\sim r}s_i(r)\ge\mathbb E_{i\sim r}s_i(p)$ for all $r,p$: reporting one's belief maximizes expected score. It is strictly proper if equality holds only at $p=r$. The logarithmic rule is $s_i(p)=b\log p_i$.
:::

### What the operator can lose {kind=derive at=three-automated-market-makers}

In a market scoring rule each trader pays the previous score and receives the new one. Bound the operator's loss for the logarithmic rule started at the uniform distribution.

::: answer
The payments telescope: the operator pays $s_k(p^T)-s_k(p^0)$ when the outcome is $k$. For the logarithmic rule this is $b\log p^T_k-b\log\frac1n\le b\log n$, since $\log p^T_k\le0$.
:::

### One trade in the LMSR {kind=compute at=three-automated-market-makers}

Take two outcomes, $b=1$ and no shares outstanding. A trader buys one share of outcome 1. What does it cost, what is the new price of outcome 1, and what does the bookmaker lose if outcome 1 occurs?

::: answer
$C(q)=\log(e^{q_1}+e^{q_2})$. The cost is $C(1,0)-C(0,0)=\log\frac{e+1}{2}\approx0.620$. The new price is $\frac{e}{e+1}\approx0.731$. If outcome 1 occurs the bookmaker pays $1$ and has collected $0.620$, a loss of $0.380$, within the bound $\log 2\approx0.693$.
:::

### Valid cost functions {kind=state at=market-scoring-rules-and-cost-functions-are-one-family}

A cost function is valid if its prices are nonnegative and sum to one. Give the equivalent three properties, and say what translation invariance means for a trader.

::: answer
Differentiable, monotone, and translation-invariant: $C(q+k\mathbf 1)=C(q)+k$ (Lemma 5). Translation invariance says that $k$ shares of every outcome cost exactly $k$, as they must, since they pay $k$ whatever happens. Differentiating it in $k$ gives prices that sum to one.
:::

### The LMSR is Hedge {kind=explain at=the-lmsr-is-hedge}

State the dictionary between the LMSR and Hedge, and the resulting bound on the bookmaker's loss.

::: answer
Outcomes are experts. The shares outstanding $q_{i,t}$ are expert $i$'s cumulative gains. The learning rate is $\eta=1/b$, and Hedge's weights are the LMSR prices. By convexity of $C$ the bookmaker's revenue is at least $\sum_tw_t\cdot r_t$, and it pays at most $\max_iG_{i,T}$, so its loss is at most Hedge's regret: $b\log n+T\varepsilon^2/(2b)$ for trades of size at most $\varepsilon$. For fixed volume the second term vanishes as trades become small, leaving $b\log n$.
:::

### From a bookmaker to a learner {kind=derive at=from-a-bookmaker-to-a-learner}

Given a valid cost function with worst-case loss $B$ and $\varphi$-stable prices, build a learner and bound its regret. Then specialize to the LMSR.

::: answer
Play $w_t=p(-\varepsilon L_{t-1})$: the market's state is $q_t=-\varepsilon L_t$, so step $t$ trades $r_t=-\varepsilon l_t$. Bounded loss gives $\max_i\sum_tr_{i,t}-\sum_t(C(q_t)-C(q_{t-1}))\le B$, and the Taylor bound of Lemma 3 replaces each cost difference by $w_t\cdot r_t$ with error $\varepsilon^2\varphi/2$. Dividing by $\varepsilon$: regret $\le B/\varepsilon+\varepsilon\varphi T/2$, minimized at $\varepsilon=\sqrt{2B/(\varphi T)}$ with value $\sqrt{2B\varphi T}$ (Theorem 4). For the LMSR, $\partial p_i/\partial q_j=p_i(\delta_{ij}-p_j)/b$ gives $\varphi=2/b$, and $B=b\log n$, so the bound is $2\sqrt{T\log n}$, independent of $b$.
:::

### The conjugate representation {kind=state at=market-scoring-rules-and-cost-functions-are-one-family}

Write a valid convex cost function as a supremum. What are the prices in that representation, and what bounds the bookmaker's loss? Check the bound for the LMSR.

::: answer
$C(q)=\sup_{p\in\Delta_n}\bigl(p\cdot q-\alpha(p)\bigr)$ for a convex lower semicontinuous $\alpha$ (Lemma 6). The prices $\nabla C(q)$ are the maximizers (Lemma 7). The worst-case loss from $q=0$ is at most $\sup_{p,p'}(\alpha(p)-\alpha(p'))$ (Lemma 8). For the LMSR $\alpha(p)=b\sum_ip_i\log p_i$, which ranges from $-b\log n$ at the uniform distribution to $0$ at a vertex, so the bound is $b\log n$.
:::

### Scoring rules and cost functions {kind=state at=market-scoring-rules-and-cost-functions-are-one-family}

Theorem 10 pairs cost-function markets with market scoring rules. What is $\alpha_C$ in terms of the scoring rule? Verify the reverse formula for the LMSR.

::: answer
$\alpha_C(p)=\sum_ip_is_i(p)$, the expected score of a truthful report. In reverse, $s_i(p)=\alpha_C(p)-\sum_jp_j\partial_j\alpha_C(p)+\partial_i\alpha_C(p)$. For the LMSR $\partial_i\alpha_C=b(\log p_i+1)$, so $\sum_jp_j\partial_j\alpha_C=\alpha_C+b$ and $s_i(p)=b\log p_i$.
:::

### Regularized leaders are markets {kind=explain at=follow-the-regularized-leader}

Follow the regularized leader plays $w_t=\arg\min_{w\in\Delta_n}\bigl(w\cdot L_{t-1}+R(w)/\eta\bigr)$. Which market quotes these weights as prices, and at which state?

::: answer
The cost-function market with $\alpha_C=R/\eta$, at $q=-L_{t-1}$: by Lemma 7 its prices maximize $p\cdot q-\alpha_C(p)$, which is the same problem. With $R$ the negative entropy this is Hedge and the LMSR.
:::

### The SCPM's flaw and its repair {kind=explain at=cost-function-markets-and-the-scpm}

What does the original SCPM charge, why is that a flaw, and what does the repaired mechanism turn out to be?

::: answer
It charges the dual price of the final solution for the whole filled quantity, $p(x^*)^\top a\,x^*$, which is not truthful. The repair charges the integral of the marginal prices as the order is filled, which coincides with VCG pricing. The repaired payment is $C(q+ax^*)-C(q)$ with $C(q)=\min_t\bigl(t-u(t\mathbf 1-q)\bigr)$: a convex cost-function market (Theorem 13). Conversely every convex cost-function market is an SCPM with $u(s)=-C(-s)$ (Theorem 14). The step from duals to a cost function is sensitivity analysis: optimal multipliers are shadow prices.
:::

### The combinatorial wall {kind=recall at=combinatorial-markets}

For bets on permutations, say which of these is polynomial and which is hard, with the reason: matching divisible subset bets; matching pair bets; LMSR pricing of subset bets; LMSR pricing of pair bets.

::: answer
- Divisible subset-bet matching: polynomial. The ellipsoid method needs only a separation oracle, and the worst outcome is a maximum-weight perfect matching between candidates and positions (Theorem 16).
- Pair-bet matching: NP-hard, divisible or not, through minimum feedback arc set.
- LMSR pricing of subset bets: #P-hard, by reduction from the permanent.
- LMSR pricing of pair bets: #P-hard, by reduction from counting linear extensions.
:::

### A learner in place of the exact price {kind=explain at=approximate-subset-betting-prices-in-polynomial-time-new}

How does a bookmaker quote subset-betting prices in polynomial time, what does it give up, and what kind of guarantee does it keep?

::: answer
It keeps an $n\times n$ doubly stochastic matrix, multiplies entry $(k,j)$ by $e^{q_{kj}/b}$ after a trade, and restores double stochasticity by Sinkhorn balancing; these are PermELearn's weights. It is not the exact LMSR over permutations, whose prices need permanents. Its worst-case loss is at most $b\,n\log n$ in the limit of small trades, against $b\log n!$ for the exact LMSR. The guarantee is a regret bound, not an approximation ratio for LMSR prices.
:::

### Only myopically truthful {kind=limits at=market-types-and-wagering-mechanisms}

Market makers are built on proper scoring rules. What does properness not guarantee?

::: answer
It makes a dynamic mechanism only myopically incentive compatible: reporting one's estimate is optimal for a trader who ignores the effect of the report on later traders. Under some information structures a trader gains by bluffing.
:::
