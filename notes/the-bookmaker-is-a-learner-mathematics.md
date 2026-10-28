---
title: "The Bookmaker Is a Learner: The Mathematics"
subtitle: "A corrected English rendering of my 2010 lecture notes on prediction markets, with sources, the two sections the notes left empty, and the original exercises"
author: "Łukasz Stafiniak and Claude (Anthropic)"
date: 2026-10-28
header-includes:
  - |
    <style>
    .katex-display { overflow-x: auto; overflow-y: hidden; padding: 0.3em 0; }
    .katex-display > .katex { width: max-content; min-width: 100%; }
    article table { display: block; max-width: 100%; overflow-x: auto; }
    </style>
---

*This page accompanies [The Bookmaker Is a Learner](https://lukstafi.github.io/notes/the-bookmaker-is-a-learner.html). It renders the mathematics of my lecture on prediction markets for Sebastian Bala's Algorithmic Game Theory course at the University of Wrocław (spring 2010), in English, with the sources the notes did not cite. Errors in the original are corrected silently except where the correction is instructive; a list is at the end. Sections 6.3–6.4 were headings without text in 2010 and are written here for the first time. The numbering of theorems follows the original notes.*

Notation: $n$ outcomes $\omega\in\{1,\dots,n\}$; $\Delta_n$ is the probability simplex; $\mathbf 1$ the all-ones vector; $e_i$ the $i$-th unit vector.

## 1. Market types and wagering mechanisms

Three kinds of prediction market:

1. **Order matching.** Traders submit orders, and the market executes trades among a set of traders whenever their orders match.
2. **Pari-mutuel pools.** Each bettor puts a chosen stake into a pool, and the pool is divided among the winners.
3. **Market makers.** Each trader deals immediately with a bookmaker, at a payout fixed at the time of the trade and depending only on the outcome.

An order is *divisible* if the trader accepts partial execution (with a proportional price limit) and *indivisible* if it is all-or-nothing. In combinatorial markets, orders are stated in a bidding language, and several orders can match jointly although no pair of them matches (bets $A>B$, $B>C$, $C>A$).

**Wagering mechanisms** (type 2). Player $i$ wagers $m_i\ge 0$ and reports a distribution $r_i\in\Delta_n$; after the outcome $\omega$ the mechanism pays $\Pi_i(\bar r,\bar m,\omega)$. [Lambert, Langford, Wortman, Chen, Reeves, Shoham and Pennock](https://doi.org/10.1145/1386790.1386820) (EC 2008) consider:

- *Budget balance*: $\sum_i\Pi_i=\sum_i m_i$.
- *Anonymity*: payouts do not depend on the players' identities.
- *Truthfulness*: a player maximizes expected profit by reporting their true belief.
- *Normality*: under any distribution over outcomes, when one player changes their report, every other player's expected payout either stays the same or moves opposite to that player's own expected payout.
- *Sybilproofness*: replacing a group of players who make the same report by any other group with the same report and the same total wager leaves the other players' payouts unchanged, and the new group's total payout equals the old group's.
- *Individual rationality*: every player, whatever their belief and wager, has a report that gives nonnegative expected profit whatever the other players report and wager.
- *Monotonicity*: the magnitude of a player's expected profit strictly increases with their wager.

**Theorem 1** (Lambert et al. 2008, their Thm 3). Under smoothness and nonnegativity assumptions on payouts, a wagering mechanism is budget-balanced, anonymous, truthful, normal and sybilproof if and only if it is a *weighted-score wagering mechanism*:

$$
\Pi_i(\bar r,\bar m,\omega)=m_i+m_i\Bigl(s(r_i,\omega)-\frac{\sum_j m_j\,s(r_j,\omega)}{M}\Bigr),
\qquad M=\sum_j m_j,
$$

where $s$ is a strictly proper scoring rule with values in $[0,1]$ (in the general statement it may depend on the total wager $M$). Weighted-score mechanisms are also individually rational and monotone; those two properties are not part of the characterization.

Each player is paid their own score relative to the wager-weighted mean score, scaled by their wager. [Chen, Devanur, Pennock and Wortman Vaughan](https://dl.acm.org/doi/10.1145/2600057.2602876) (EC 2014) later showed that these mechanisms admit arbitrage and proposed no-arbitrage variants.

**Myopic truthfulness.** Dynamic mechanisms (types 3, and type 2 with orders taken in stages) are built on properness, which makes them only *myopically* incentive compatible: a trader maximizes expected profit by reporting their estimate, if they ignore the effect of their report on later traders. Under some information structures a trader gains by bluffing. See [Chen, Dimitrov, Sami, Reeves, Pennock, Hanson, Fortnow and Gonen](https://doi.org/10.1007/s00453-009-9323-2), *Algorithmica* 58(4), 2010, and [Ostrovsky](https://doi.org/10.3982/ECTA8479), *Econometrica* 80(6), 2012, for when information is aggregated in every equilibrium.

## 2. Three automated market makers

**Scoring rules.** A scoring rule $s=(s_1,\dots,s_n)$ maps a reported distribution $p$ to a payment $s_i(p)$ when outcome $i$ occurs. It is *proper* if $\mathbb E_{i\sim r}s_i(r)\ge\mathbb E_{i\sim r}s_i(p)$ for all $r,p$, and *strictly proper* if equality holds only for $p=r$. Two standard rules:

$$
s_i(p)=b\log p_i\quad\text{(logarithmic)},\qquad
s_i(p)=b\Bigl(2p_i-\sum_j p_j^2\Bigr)\quad\text{(quadratic)}.
$$

**Market scoring rules** ([Hanson 2003, 2007](https://mason.gmu.edu/~rhanson/mktscore.pdf)). The market starts at $p^0$. A trader who moves it from $p$ to $p'$ pays $s_k(p)$ and receives $s_k(p')$ when the outcome is $k$. The operator's total payout telescopes to $s_k(p^T)-s_k(p^0)$. For the logarithmic rule with uniform $p^0$, this is at most $b\ln n$.

**Cost-function markets** ([Chen and Pennock](https://arxiv.org/abs/1206.5252), UAI 2007). The operator sells shares; a share in $i$ pays \$1 if $i$ occurs. With $q$ shares outstanding, buying a bundle $a$ costs $C(q+a)-C(q)$. Instantaneous prices are $p_i(q)=\partial C(q)/\partial q_i$. $C$ is a *valid* cost function if $p_i(q)\ge0$ and $\sum_i p_i(q)=1$ for all $q$. The logarithmic market scoring rule (LMSR) is

$$
C(q)=b\log\sum_{i=1}^n e^{q_i/b},\qquad p_i(q)=\frac{e^{q_i/b}}{\sum_j e^{q_j/b}}.
$$

**Sequential convex pari-mutuel mechanism (SCPM)** ([Peters, So and Ye](https://doi.org/10.1007/978-3-540-77105-0_23), WINE 2007; [Agrawal, Delage, Peters, Wang and Ye](https://doi.org/10.1287/opre.1110.0922), EC 2009 and *Operations Research* 59(3), 2011). An order consists of a limit price $\pi$ (the most the trader will pay per unit), a quantity limit $l$, and a 0–1 vector $a$ of the outcomes the order covers. The operator solves

$$
\max_{x,z,s}\ \pi x-z+u(s)\quad\text{subject to}\quad a x+s+q=z\mathbf 1,\quad 0\le x\le l.
$$

Here $q$ is the vector of shares outstanding before the order, $z$ is an upper bound on the shares of any single outcome after the order (so $\pi x-z$ is the operator's worst-case profit, up to the revenue already collected), $s$ are slack variables, and $u$ is a concave regularizer that damps price swings; the logarithmic variant has $u(s)=\sum_i\theta_i\log s_i$. The price vector $p$ is the optimal dual solution for the equality constraints: $p_i$ is the gain in the optimal objective from relaxing $a_ix+s_i+q_i=z$ to $a_ix+s_i+q_i=z+1$. In the original mechanism the trader pays $p^\top a$ per unit, at the dual prices of the optimal solution $x^*$.

## 3. Convex duality toolkit

**Lagrangian duality.** For the problem

$$
\min_x f_0(x)\quad\text{s.t.}\quad f_i(x)\le0\ (i=1..m),\quad h_i(x)=0\ (i=1..p)
$$

with optimum $p^*$, the Lagrangian is $L(x,\lambda,\nu)=f_0(x)+\sum_i\lambda_if_i(x)+\sum_i\nu_ih_i(x)$ and the dual function is $g(\lambda,\nu)=\inf_xL(x,\lambda,\nu)$. For $\lambda\ge0$ and feasible $x$, $\sum_i\lambda_if_i(x)+\sum_i\nu_ih_i(x)\le0$, so $g(\lambda,\nu)\le p^*$ (weak duality). The dual problem maximizes $g$ over $\lambda\ge0$; it is always a convex problem. *Strong duality* means the two optima are equal. It holds for convex problems ($f_0,f_i$ convex, $h_i$ affine) under Slater's condition: some feasible $x$ has $f_i(x)<0$ for every nonlinear $f_i$. The proof separates the convex set $\{(u,v,t)\mid\exists x:\ f_i(x)\le u_i,\ h_i(x)=v_i,\ f_0(x)\le t\}$ from $\{(0,0,s)\mid s<p^*\}$ by a hyperplane, whose normal vector gives the optimal multipliers ([Boyd and Vandenberghe](https://web.stanford.edu/~boyd/cvxbook/), ch. 5).

**Zero-sum games.** For a game with loss matrix $P$ for player 1, player 1 choosing a mixed strategy $u$ known to player 2 solves $\min t$ s.t. $u\ge0$, $\mathbf 1^\top u=1$, $P^\top u\le t\mathbf 1$. The Lagrangian dual of this linear program, after eliminating the multiplier of $u\ge0$, is $\max\nu$ s.t. $v\ge0$, $\mathbf 1^\top v=1$, $Pv\ge\nu\mathbf 1$: player 2's problem, with player 2's mixed strategy $v$ as the multiplier vector. Strong duality gives the minimax theorem.

**Price interpretation.** If $x$ is a firm's plan, $f_0$ its cost minus revenue, and $f_i(x)\le0$ its resource limits, imagine that limits may be exceeded at unit price $\lambda_i$ and surplus sold at the same price. The firm's total cost is then $L(x,\lambda)$, and $g(\lambda^*)$ is its cost under the least favourable prices. Under strong duality, $\lambda^*$ are the prices at which the firm gains nothing by buying or selling resources.

**KKT conditions.** Under strong duality, $f_0(x^*)=g(\lambda^*,\nu^*)\le L(x^*,\lambda^*,\nu^*)\le f_0(x^*)$, so $\sum_i\lambda^*_if_i(x^*)=0$, and since each term is nonpositive, $\lambda^*_if_i(x^*)=0$ (complementary slackness). For differentiable problems, $x^*$ minimizes $L(\cdot,\lambda^*,\nu^*)$, so its gradient vanishes there. Together with feasibility:

$$
f_i(x^*)\le0,\quad h_i(x^*)=0,\quad\lambda^*_i\ge0,\quad\lambda^*_if_i(x^*)=0,\quad
\nabla f_0(x^*)+\sum_i\lambda^*_i\nabla f_i(x^*)+\sum_i\nu^*_i\nabla h_i(x^*)=0.
$$

These are necessary under strong duality, and sufficient for convex problems: $L(\cdot,\lambda^*,\nu^*)$ is then convex and minimized at $x^*$, so $g(\lambda^*,\nu^*)=L(x^*,\lambda^*,\nu^*)=f_0(x^*)$.

**Sensitivity.** Let $p^*(u,v)$ be the optimum of the problem with constraints relaxed to $f_i(x)\le u_i$, $h_i(x)=v_i$. Under strong duality, for every feasible $x$ of the perturbed problem, $p^*(0,0)=g(\lambda^*,\nu^*)\le f_0(x)+\sum_i\lambda_i^*f_i(x)+\sum_i\nu^*_ih_i(x)\le f_0(x)+\lambda^{*\top}u+\nu^{*\top}v$, hence

$$
p^*(u,v)\ge p^*(0,0)-\lambda^{*\top}u-\nu^{*\top}v.
$$

If $p^*$ is differentiable at the origin, taking one-sided limits along each coordinate gives $\lambda^*_i=-\partial p^*/\partial u_i$ and $\nu^*_i=-\partial p^*/\partial v_i$. The optimal multipliers are *shadow prices*: the marginal value of relaxing each constraint.

**The Eisenberg–Gale program.** In Fisher's market with linear utilities there are goods $j=1..n$ (one unit of each) and buyers $i=1..n'$ with budgets $e_i$ and utilities $u_{ij}$ per unit; buyer $i$'s total utility is $u_i=\sum_ju_{ij}x_{ij}$. Market-clearing prices, at which every buyer spends their whole budget on utility-maximizing bundles and every good with a positive price sells out, are the shadow prices of

$$
\max\ \sum_{i}e_i\log u_i\quad\text{s.t.}\quad\sum_ix_{ij}\le1\ \forall j,\qquad x_{ij}\ge0.
$$

The objective is the logarithm of the budget-weighted geometric mean of utilities. The geometric mean is chosen because rescaling one buyer's utilities, or splitting one buyer's budget between two identical buyers, should not change the solution. Optimality is equivalent to: (1) $p_j\ge0$; (2) $p_j>0\Rightarrow\sum_ix_{ij}=1$; (3) $u_{ij}/p_j\le u_i/e_i$ for all $i,j$; (4) $x_{ij}>0\Rightarrow u_{ij}/p_j=u_i/e_i$. In standard form, $f_0=-\sum_ie_i\log u_i$, the supply constraints are $f_j=\sum_ix_{ij}-1$ for $j=1..n$, and the nonnegativity constraints are $f_k=-x_{ij}$ for $k=n+1,\dots,n+nn'$, so $m=n+nn'$, and there are no equality constraints (exercise 1). [Eisenberg and Gale](https://doi.org/10.1214/aoms/1177706369) published the program in 1959 as "Consensus of subjective probabilities: the pari-mutuel method": the goods were horses, $u_{ij}$ was bettor $i$'s probability that horse $j$ wins, and the prices were the consensus probabilities, which fix the pool's odds.

**The ellipsoid method.** Assume the feasible set $K$ satisfies $S(a_0,r)\subseteq K\subseteq S(a_0,R)$ for known $a_0,r,R$. Starting from the ball $S(a_0,R)$, the method maintains an ellipsoid containing every point better than the best found so far, and shrinks it by cutting. It needs three subroutines: a feasibility test; a *separation oracle* that, given an infeasible point, returns a hyperplane separating it from $K$; and the computation of the smallest ellipsoid containing the intersection of an ellipsoid with a half-space ([Khachiyan 1979](https://doi.org/10.1016/0041-5553(80)90061-0); Grötschel, Lovász and Schrijver, *Geometric Algorithms and Combinatorial Optimization*, 1988). The method runs in polynomial time whenever the separation oracle does, even if the constraints are too many to list.

## 4. The SCPM's optimality conditions

To study prices as the order is filled, cap the order at $\varepsilon$:

$$
\max_{x,z,s}\ \pi x-z+u(s)\quad\text{s.t.}\quad ax+s+q=z\mathbf 1,\quad 0\le x\le\varepsilon. \tag{8}
$$

With multipliers $p$ (equality), $\xi$ for $-x\le0$ and $y$ for $x-\varepsilon\le0$, the KKT conditions give

$$
p^{*\top}\mathbf 1=1,\qquad p^*=\nabla u(s^*),\qquad y^*+p^{*\top}a\ge\pi,\qquad y^*\ge0,\qquad y^*(\varepsilon-x^*)=0,\qquad ax^*+q+s^*=z^*\mathbf 1.
$$

**Lemma 2** (Agrawal et al. 2009). (1) $\mathbf 1^\top p(\varepsilon)=1$. (2) Prices are nonnegative if $u$ is nondecreasing. (3) The total instantaneous price $p(\varepsilon)^\top a$ is nondecreasing in $\varepsilon$. (4) The price function is integrable. (The source also states a consistency property omitted here.)

*Proof of (3).* Let $(x_k,z_k,s_k)$ be optimal for $\varepsilon_k$, $k=1,2$, with $s_k=z_k\mathbf 1-q-x_ka$. Concavity of $u$ gives two inequalities whose sum is

$$
\bigl(\nabla u(s_1)-\nabla u(s_2)\bigr)^\top\bigl((z_2-z_1)\mathbf 1-(x_2-x_1)a\bigr)\ge0.
$$

By (1), $\nabla u(s_k)^\top\mathbf 1=1$ for both $k$, so the $\mathbf 1$ term vanishes and $(p_2-p_1)^\top a\,(x_2-x_1)\ge0$, i.e. $p^\top a$ moves in the same direction as $x$, which is nondecreasing in $\varepsilon$. Integrability follows from boundedness and monotonicity on a closed interval. $\square$

## 5. Equivalences

### 5.1 The LMSR is Hedge

This section follows [Chen, Fortnow, Lambert, Pennock and Wortman](https://arxiv.org/abs/0802.1362) (EC 2008, §6.2), in a cleaner form than the 2010 notes.

Split all trades into small steps $r_t\in[-\varepsilon,\varepsilon]^n$ and let $q_t=q_0+\sum_{\tau\le t}r_\tau$ with $q_0=0$. Treat outcomes as experts and $r_{i,t}$ as expert $i$'s gain at step $t$, so $G_{i,t}=q_{i,t}$. Hedge with learning rate $\eta$ plays

$$
w_{i,t}=\frac{e^{\eta G_{i,t-1}}}{\sum_je^{\eta G_{j,t-1}}},
$$

which for $\eta=1/b$ equals the LMSR price $p_i(q_{t-1})$. The bookmaker's revenue is $\sum_t\bigl(C(q_t)-C(q_{t-1})\bigr)\ge\sum_tp(q_{t-1})\cdot r_t=\sum_tw_t\cdot r_t$ by convexity of $C$. If the outcome is $\omega$, it pays $q_{\omega,T}\le\max_iG_{i,T}$. Its loss is therefore at most Hedge's regret, $\max_iG_{i,T}-\sum_tw_t\cdot r_t$. The standard bound for gains in an interval of width $2\varepsilon$ (by Hoeffding's lemma) is

$$
\max_iG_{i,T}-\sum_tw_t\cdot r_t\le\frac{\ln n}{\eta}+\frac{\eta T(2\varepsilon)^2}{8}=b\ln n+\frac{T\varepsilon^2}{2b}.
$$

For a fixed trading volume $V=T\varepsilon$, the second term is $V\varepsilon/(2b)\to0$ as trades become small, and the bookmaker's worst-case loss is $b\ln n$, matching the telescoping bound of §2.

### 5.2 From a bookmaker to a learner

This section follows [Chen and Wortman Vaughan](https://arxiv.org/abs/1003.0034) (EC 2010).

A cost function has *$\varphi$-stable* prices if they are continuous and piecewise differentiable with $\sum_{i,j}\lvert\partial p_i(q)/\partial q_j\rvert\le\varphi$ (taking 0 where a derivative does not exist).

**Lemma 3.** For a valid cost function with $\varphi$-stable prices, any $q$, and any $r$ with $\lvert r_i\rvert\le\varepsilon$:
$\bigl\lvert C(q+r)-C(q)-\sum_ip_i(q)r_i\bigr\rvert\le\varepsilon^2\varphi/2$.

*(Second-order Taylor bound.)*

**Theorem 4.** Let $C$ be a valid cost function with $\varphi$-stable prices whose worst-case loss is at most $B$. Define a learner that, facing losses $l_{i,t}\in[0,1]$, plays weights $w_{i,t}=p_i(-\varepsilon L_{t-1})$, where $L_{t-1}$ is the vector of cumulative losses. With $\varepsilon=\sqrt{2B/(\varphi T)}$, its regret after $T$ rounds is at most $\sqrt{2B\varphi T}$.

*Proof.* Let $r_{i,t}=-\varepsilon l_{i,t}$ be the shares of $i$ bought at step $t$ and $q_t=\sum_{\tau\le t}r_\tau$, so $w_t=p(q_{t-1})$. Bounded loss means $\max_i\sum_tr_{i,t}-\sum_t\bigl(C(q_t)-C(q_{t-1})\bigr)\le B$. By Lemma 3,

$$
\max_i\sum_tr_{i,t}-\sum_t\Bigl(\sum_iw_{i,t}r_{i,t}+\frac{\varepsilon^2\varphi}{2}\Bigr)\le B.
$$

Substituting $r_{i,t}=-\varepsilon l_{i,t}$ and dividing by $\varepsilon$:

$$
\sum_t w_t\cdot l_t-\min_i\sum_tl_{i,t}\le\frac B\varepsilon+\frac{\varepsilon\varphi T}{2},
$$

which is minimized at $\varepsilon=\sqrt{2B/(\varphi T)}$ with value $\sqrt{2B\varphi T}$. $\square$

For the LMSR, $\partial p_i/\partial q_j=p_i(\delta_{ij}-p_j)/b$, so $\varphi=2/b$ suffices, and with $B=b\ln n$ the regret bound is $2\sqrt{T\ln n}$, independent of $b$.

### 5.3 Market scoring rules and cost functions are one family

**Lemma 5.** $C$ is a valid cost function iff it is (1) differentiable, (2) monotone ($q\ge q'\Rightarrow C(q)\ge C(q')$), and (3) translation-invariant: $C(q+k\mathbf 1)=C(q)+k$.

*Proof.* Differentiability gives the prices, and monotonicity is equivalent to their nonnegativity. If prices sum to one, then with $v(a)=q+a\mathbf 1$,

$$
C(q+k\mathbf 1)-C(q)=\int_0^k\sum_i\frac{\partial C(v(a))}{\partial v_i}\,da=\int_0^k\sum_ip_i(v(a))\,da=k.
$$

Conversely, differentiating $C(q'+k\mathbf 1)=C(q')+k$ in $k$ gives $\sum_ip_i(q)=1$. $\square$

**Lemma 6.** $C$ is a valid **convex** cost function iff it is differentiable and

$$
C(q)=\sup_{p\in\Delta_n}\Bigl(\sum_ip_iq_i-\alpha(p)\Bigr)
$$

for a convex lower semicontinuous $\alpha:\Delta_n\to(-\infty,\infty]$. (Lemma 5's properties plus convexity are the axioms of a convex risk measure, up to sign, and this is their representation theorem; Föllmer and Schied, *Stochastic Finance*, 2002. The 2010 notes omitted "convex".)

**Lemma 7.** The prices $p(q)=\nabla C(q)$ are the maximizers of $\sum_ip_iq_i-\alpha(p)$.

*Proof.* Let $f(q,p)=\sum_ip_iq_i-\alpha(p)$ and $p^*(q)$ its maximizer. For $q'$ differing from $q$ in coordinate $i$, $f(q',p^*(q))-f(q,p^*(q))\le C(q')-C(q)$ by maximality of $C(q')$. The left side is $p^*_i(q)(q'_i-q_i)$. Dividing by $q'_i-q_i$ and taking one-sided limits gives $p^*_i(q)\le\partial_iC(q)$ from one side and $\ge$ from the other. $\square$

**Lemma 8.** The worst-case loss of the bookmaker started at $q=0$ is at most $\sup_{p,p'\in\Delta_n}\bigl(\alpha(p)-\alpha(p')\bigr)$.

*Proof.* If the outcome is $\omega$ and the final state is $q$, the bookmaker pays $q_\omega$ and has collected $C(q)-C(0)$. From the representation, $C(q)\ge q_\omega-\alpha(e_\omega)$ and $C(0)=-\inf\alpha$. So the loss $q_\omega-C(q)+C(0)\le\alpha(e_\omega)-\inf\alpha$. $\square$

**Definition 9.** A market scoring rule and a cost-function market are *equivalent* on a set $D$ of price vectors if a trader who moves the MSR from $r$ to $r'$ receives the same payout in every outcome as a trader who moves the cost-function market from $q$ to $q'$ with $p(q)=r$, $p(q')=r'$, for all $r,r'\in D$.

**Theorem 10** (Chen and Wortman Vaughan 2010). There is a one-to-one correspondence between cost-function markets with strictly convex differentiable $\alpha_C$ and market scoring rules with strictly proper, regular, differentiable scoring rules, given by

$$
\alpha_C(p)=\sum_ip_is_i(p),\qquad
s_i(p)=\alpha_C(p)-\sum_j\frac{\partial\alpha_C(p)}{\partial p_j}p_j+\frac{\partial\alpha_C(p)}{\partial p_i}.
$$

On the set of strictly positive prices the correspondence is an equivalence in the sense of Definition 9, and every probability vector reachable in the MSR is a reachable price vector of the cost-function market. (Regular: $\sum_ip_is_i(p')\in[-\infty,\infty)$ and $\sum_ip_is_i(p)\in(-\infty,\infty)$.) The proof combines three facts: a scoring rule is strictly proper only if its expected score $\sum_ip_is_i(p)$ is strictly convex; the Savage/Gneiting–Raftery representation $s_i(p)=G(p)-\sum_jp_j\dot G_j(p)+\dot G_i(p)$ of regular strictly proper rules, with $\dot G$ a subgradient of a convex $G$ ([Gneiting and Raftery](https://doi.org/10.1198/016214506000001437), 2007); and the KKT conditions of the maximization in Lemma 7.

*Check.* For the LMSR, $\alpha_C(p)=b\sum_ip_i\log p_i$ and $\partial_i\alpha_C=b(\log p_i+1)$, so $\sum_jp_j\partial_j\alpha_C=\alpha_C+b$ and $s_i(p)=b\log p_i$.

### 5.4 Follow the regularized leader

A broad class of no-regret algorithms chooses weights

$$
w_t=\arg\min_{w\in\Delta_n}\Bigl(\sum_iw_iL_{i,t-1}+\frac1\eta R(w)\Bigr).
$$

With $R$ the negative entropy this is Hedge. By Lemma 7, the prices of the cost-function market with $\alpha_C=R/\eta$ at $q=-L_{t-1}$ are exactly these weights.

**Theorem 11.** Let $C$ be a valid convex cost function with $\varphi$-stable prices and $\alpha_C=R$ for an FTRL algorithm with normalized weights. Setting $\varepsilon$ (respectively $\eta$) to $\sqrt{2\sup_{p,p'}(\alpha_C(p)-\alpha_C(p'))/(\varphi T)}$, the learner of Theorem 4 (respectively FTRL) has regret at most

$$
\sqrt{2T\varphi\sup_{p,p'\in\Delta_n}\bigl(\alpha_C(p)-\alpha_C(p')\bigr)}.
$$

*(Theorem 4 with $B$ from Lemma 8.)*

### 5.5 Cost-function markets and the SCPM

**The flaw and its repair.** The original SCPM charges the dual price of the final solution for the whole filled quantity: $p(x^*)^\top a\,x^*$. This is not truthful (exercise 3). It can be repaired in two ways, which coincide: by charging the integral of the marginal prices as the order is filled (Agrawal et al., EC 2009), and by VCG pricing (the *Operations Research* version, exercise 5). Let $p(\varepsilon)$ be the dual prices of (8) and $x^*$ the solution for $\varepsilon=l$. Charge

$$
\Bigl(\int_0^{x^*}p(\varepsilon)\,d\varepsilon\Bigr)^\top a
$$

instead. Splitting an order into parts, with $q$ updated after each part, then does not change the payment.

**Lemma 12.** For $0\le\varepsilon\le x^*$, the optimal duals $p(\varepsilon)$ of (8) are also optimal for

$$
\max_{z,s}\ \pi\varepsilon-z+u(s)\quad\text{s.t.}\quad a\varepsilon+s+q=z\mathbf 1. \tag{16}
$$

*Proof.* Maximizing out $z$ and $s$ leaves an objective concave in $x$, maximized over $[0,l]$ at $x^*$. So for $\varepsilon\le x^*$ the cap binds and $x(\varepsilon)=\varepsilon$. Program (16) is (8) with $x$ fixed at $\varepsilon$. Its KKT conditions, $\mathbf 1^\top p=1$, $p=\nabla u(s)$ and feasibility, are among those of (8), so the optimal $(z,s)$ and $p(\varepsilon)$ of (8) satisfy them. Since (16) is convex, they are optimal. $\square$

**Theorem 13.** If $q$ shares are outstanding in an SCPM and a new order $(\pi,l,a)$ is filled to $x^*$, the repaired payment is

$$
\Bigl(\int_0^{x^*}p(\varepsilon)\,d\varepsilon\Bigr)^\top a=C(q+ax^*)-C(q),\qquad
C(q)=\min_t\bigl(t-u(t\mathbf 1-q)\bigr),
$$

and $C$ is convex with $\mathbf 1^\top\nabla C(q)=1$ for $q\ge0$.

*Proof.* The optimum of (16) is $V(q,\varepsilon)=\pi\varepsilon-\min_z\bigl(z-u(z\mathbf 1-q-a\varepsilon)\bigr)=\pi\varepsilon-C(q+a\varepsilon)$. By sensitivity analysis, $p_i(\varepsilon)=-\partial V/\partial q_i=\partial C(q+a\varepsilon)/\partial q_i$. Integrating, $\int_0^{x^*}p(\varepsilon)^\top a\,d\varepsilon=\int_0^{x^*}\frac{d}{d\varepsilon}C(q+a\varepsilon)\,d\varepsilon=C(q+ax^*)-C(q)$. The prices sum to one by Lemma 2. $\square$

**Theorem 14.** Every convex cost-function market is an SCPM with concave utility $u(s)=-C(-s)$, and the two charge the same for every order.

*Proof.* By translation invariance, $u(s)=z-C(z\mathbf 1-s)$ for any $z$, and the SCPM program becomes $\max\pi x-C(z\mathbf 1-s)$ s.t. $z\mathbf 1-ax-s=q$, $0\le x\le l$. Its KKT conditions are $p^\top a+y\ge\pi$, $x(p^\top a+y-\pi)=0$, $p_i=\partial C(q+ax)/\partial q_i$, $y(l-x)=0$, $y\ge0$, $0\le x\le l$. So $x$ grows until the price $p^\top a$ reaches the limit $\pi$ or $x$ reaches $l$. Theorem 13's cost function for this $u$ is $\min_t\bigl(t-u(t\mathbf 1-q)\bigr)=\min_t\bigl(t+C(q-t\mathbf 1)\bigr)=C(q)$, by translation invariance, so the repaired SCPM charges $C(q+ax^*)-C(q)$, as the cost-function market does. $\square$

**Theorem 15.** If $\nabla u$ ranges over the whole simplex $\{r\mid\mathbf 1^\top r=1,\ r\ge0\}$, the cost function of the corresponding SCPM defines a cost-function market whose equivalent MSR is proper.

*Proof.* For cost-function markets, the implicit scoring rule is $s_i(p)=q_i-C(q)+K$ with $p=\nabla C(q)$ (exercise 2). Properness requires $\nabla C(q^*)=r$ at any $q^*\in\arg\max_{q\ge0}\sum_ir_i(q_i-C(q))$: the trader's interest coincides with reporting $r$. Writing the maximization through $u$, with $s=t\mathbf 1-q$,

$$
\max_{q\ge0}\ r^\top q-\min_t\bigl(t-u(t\mathbf 1-q)\bigr)
=\max_{q\ge0,t}\ r^\top q-t+u(t\mathbf 1-q)
=\max_s\ u(s)-r^\top s,
$$

using $r^\top\mathbf 1=1$. For a solution $s^*$, $t^*$ can be taken large enough that $q^*>0$, so the KKT multipliers of $q\ge0$ vanish and $\nabla C(q^*)=r$ because $\nabla u(s^*)=r$. $\square$

## 6. Combinatorial markets

Outcomes are permutations $\sigma$ of $n$ candidates ($\sigma(\alpha)$ is $\alpha$'s position), so $\lvert\Omega\rvert=n!$. Two bidding languages, following [Chen, Fortnow, Nikolova and Pennock](https://doi.org/10.1145/1250910.1250957), "Betting on permutations," EC 2007:

- **Subset betting.** $\langle\alpha\mid\Phi\rangle$ pays \$1 if $\sigma(\alpha)\in\Phi$; $\langle\Psi\mid j\rangle$ pays \$1 if the candidate in position $j$ is in $\Psi$.
- **Pair betting.** $\langle\alpha>\beta\rangle$ pays \$1 if $\sigma(\alpha)<\sigma(\beta)$.

### 6.1 Matching orders (market type 1)

An order $(b_i,q_i,\phi_i)$ offers price $b_i$ per share for up to $q_i$ shares of security $\phi_i$; $I_i(\sigma)\in\{0,1\}$ says whether $\phi_i$ pays in outcome $\sigma$. The *matching decision problem* asks for $x\ne0$ with $\sum_i(b_i-I_i(\sigma))q_ix_i\ge0$ for all $\sigma$; the *optimal matching problem* maximizes $c$ subject to $\sum_i(b_i-I_i(\sigma))q_ix_i\ge c$ for all $\sigma$. Orders are indivisible if $x_i\in\{0,1\}$ and divisible if $0\le x_i\le1$.

**Theorem 16.** Optimal divisible matching for subset betting is solvable in polynomial time.

*Proof.* Solve the linear program by the ellipsoid method; it suffices to find a violated constraint $\sum_iI_i(\sigma)q_ix_i>\sum_ib_iq_ix_i-c$ when one exists. Build a bipartite graph between candidates and positions, giving edge $(\alpha,j)$ the weight $\sum q_ix_i$ over orders $i$ that pay when $\alpha$ is in position $j$. Each outcome $\sigma$ is a perfect matching, and its weight is the bookmaker's payout $\sum_iI_i(\sigma)q_ix_i$. A maximum-weight perfect matching finds the worst outcome in polynomial time, and the right side does not depend on $\sigma$. $\square$

**Pair betting is NP-hard.** Pair betting has only $n(n-1)$ securities, but both its indivisible and divisible matching problems are NP-hard. A set of accepted pair bets is a directed graph on the candidates. Let $k(H)$ be the size of a minimum feedback arc set of $H$ (unweighted) and $l(H)$ its weighted version, with edge weights $x_e$.

- **Lemma 17.** If the bookmaker accepts every edge of $H$ at price $1-\varepsilon$ and quantity 1, its worst-case revenue is $k(H)-\varepsilon\lvert E\rvert$. (The worst outcome agrees with all edges except a minimum feedback arc set. The 2010 notes wrote "weighted"; it is the unweighted problem.)
- **Theorem 18.** Finding the optimal worst-case revenue in indivisible pair betting is NP-hard.
- **Lemma 19.** Removing edge $e$ of weight $x_e$ decreases $l(H)$ by at most $x_e$ and $k(H)$ by at most 1.
- **Theorem 20.** Finding the optimal matching in indivisible pair betting is NP-hard.
- **Lemma 21.** If the bookmaker accepts edges with weights $x_e$, its worst-case revenue is $c(H)=\sum_e(b_e-1)x_e+l(H)$.
- **Lemma 22.** $l(G^*)\le k(G^*)\le k(G)$, where $G$ is the graph of all orders and $G^*$ the graph of an optimal matching.
- **Lemma 23.** There is an $\varepsilon$ such that when every edge price is $1-\varepsilon$, $l(G^*)=k(G)$.
- **Theorem 24.** Finding the optimal worst-case revenue in divisible pair betting is NP-hard.
- **Lemma 25.** If $l(H)=k(H)$ and an edge of weight $x_e<1$ is removed, $k(H-e)=k(H)$.
- **Theorem 26.** Finding the optimal matching in divisible pair betting is NP-hard.

**A polynomial sufficient condition.**

**Lemma 27.** A match exists (divisible or indivisible) if some cycle $C$ in the order graph has $\sum_{e\in C}b_e\ge\lvert C\rvert-1$.

*Proof.* The left side is the bookmaker's revenue from the cycle. A cycle of pair bets is contradictory by transitivity and antisymmetry, so at least one of its bets loses, and the payout is at most $\lvert C\rvert-1$. $\square$

**Lemma 28.** A cycle maximizing $\sum_{e\in C}b_e-(\lvert C\rvert-1)$ can be found in polynomial time.

*Proof.* $\sum_{e\in C}b_e-(\lvert C\rvert-1)=1-\sum_{e\in C}(1-b_e)$, so it suffices to find a shortest cycle with edge weights $1-b_e$: for each vertex, a shortest path from it back to itself. $\square$

A greedy method that repeatedly finds and removes the best cycle cannot find matches made of interleaved cycles, each unprofitable alone but profitable together. Even when the optimal match consists of disjoint cycles, a short cycle can block several slightly longer ones.

**Lemma 29.** The greedy algorithm that repeatedly removes a shortest cycle can be off by a factor of $\sqrt n/2$ from the maximum number of disjoint cycles. (This is a lower bound on greedy's error, not a guarantee. An $O(\sqrt n)$-approximation for edge-disjoint cycle packing is due to [Krivelevich, Nutov, Salavatipour, Verstraete and Yuster](https://doi.org/10.1145/1273340.1273347), 2007.)

### 6.2 Pricing is #P-hard (market type 3)

Following [Chen, Fortnow, Lambert, Pennock and Wortman](https://arxiv.org/abs/0802.1362), EC 2008. Let $\Theta$ be a set of compound securities; $S\in\Theta$ pays \$1 if any outcome $\omega\in S$ occurs. With $Q=(q_S)_{S\in\Theta}$ shares outstanding, define for each outcome $q_\omega=\sum_{S\ni\omega}q_S$, the shares that pay in $\omega$. The LMSR cost function is

$$
C(Q)=b\log\sum_{\omega\in\Omega}e^{q_\omega/b}=b\log\sum_{\omega\in\Omega}\prod_{S\in\Theta:\,\omega\in S}e^{q_S/b},
$$

and the price of a compound security is the sum of its outcomes' prices:

$$
p_S(Q)=\frac{\partial C(Q)}{\partial q_S}=\frac{\sum_{\omega\in S}e^{q_\omega/b}}{\sum_{\tau\in\Omega}e^{q_\tau/b}}.
$$

**Subset betting.** It suffices to price the securities $\langle i\mid j\rangle$ ("candidate $i$ in position $j$"), since $\langle i\mid\Phi\rangle$ and $\langle\Psi\mid j\rangle$ are sums of them. Then

$$
p_{ij}(Q)=\frac{\sum_{\sigma:\sigma(i)=j}\prod_{k=1}^ne^{q_{k,\sigma(k)}/b}}{\sum_\tau\prod_{k=1}^ne^{q_{k,\tau(k)}/b}},\qquad
C(Q)=b\log\sum_\sigma\prod_{k=1}^ne^{q_{k,\sigma(k)}/b}.
$$

**Theorem 30.** Computing $p_{ij}(Q)$ and $C(Q)$ for subset betting is #P-hard. *(Reduction from the permanent of a 0–1 matrix, $\sum_{\sigma}\prod_ia_{i\sigma(i)}$, which is #P-hard by Valiant 1979.)*

**Pair betting.** With $q_{ij}$ the shares of $\langle i>j\rangle$,

$$
p_{ij}(Q)=\frac{\sum_{\sigma:\sigma(i)<\sigma(j)}\prod_{i',j':\,\sigma(i')<\sigma(j')}e^{q_{i'j'}/b}}{\sum_\tau\prod_{i',j':\,\tau(i')<\tau(j')}e^{q_{i'j'}/b}},\qquad
C(Q)=b\log\sum_\sigma\prod_{i,j:\,\sigma(i)<\sigma(j)}e^{q_{ij}/b}.
$$

**Theorem 31.** Computing $p_{ij}(Q)$ and $C(Q)$ for pair betting is #P-hard. *(Reduction from counting the linear extensions of a partial order, which is #P-hard.)*

The same paper proves analogous hardness results for Boolean betting, with outcomes in $\{0,1\}^n$ and securities given by Boolean formulas; the 2010 notes omitted them.

### 6.3 Learning that minimizes regret against the best permutation *(new)*

The 2010 notes left this section empty. It is §6.3 of Chen et al. 2008, which uses the learner of [Helmbold and Warmuth](https://jmlr.org/papers/v10/helmbold09a.html), "Learning permutations with exponential weights" (COLT 2007; *JMLR* 10, 2009).

The comparison class is the $n!$ permutations, with a loss matrix $\mathcal L_t$ each round, where a permutation $\sigma$ suffers $\sum_k\mathcal L_{t,k\sigma(k)}$. Running Hedge over permutations directly needs $n!$ weights. PermELearn instead keeps an $n\times n$ doubly stochastic matrix $W_t$, whose entry $(k,j)$ plays the role of the probability that $k$ is mapped to $j$. Each round it multiplies entries by $e^{-\eta\mathcal L_{t,kj}}$ and then applies *Sinkhorn balancing*: alternately rescale rows and columns to sum to one, which converges to a doubly stochastic matrix. To act, it decomposes $W_t$ into a convex combination of at most $n^2-2n+2$ permutation matrices (Birkhoff–von Neumann) and samples one. Its regret against the best fixed permutation is of order $\sqrt{L^*n\ln n}+n\ln n$, where $L^*$ is the best permutation's loss.

### 6.3.1 Approximate subset-betting prices in polynomial time *(new)*

Chen et al. 2008, §6.4, turn PermELearn into a bookmaker by the equivalence of §5.1. Start from the uniform matrix $P^1$ with all entries $1/n$. After a trade in securities $\langle k\mid j\rangle$, multiply entry $(k,j)$ by $e^{q_{kj}/b}$ for the shares bought and Sinkhorn-balance. The resulting matrices coincide with PermELearn's weights for the corresponding loss sequence (their Lemma 10), and the bookmaker quotes $P_{kj}$ as the price of $\langle k\mid j\rangle$. Every step is polynomial, with Sinkhorn balancing run to a fixed precision. Translating the learner's regret bound gives a worst-case loss of at most $b\,n\ln n$ in the limit of small trades (their Theorem 11 and Corollary 12; for a fixed step size $\varepsilon>0$, the paper notes that the bound "can grow arbitrarily large" as the number of steps grows). The exact LMSR over permutations would have worst-case loss $b\ln n!$.

Two remarks. First, this bookmaker is not the exact LMSR over permutations. The exact LMSR's matrix of runner-by-position prices is also doubly stochastic, but computing it requires permanents; Sinkhorn balancing of the matrix $e^{q_{kj}/b}$ gives a different doubly stochastic matrix. Second, the approximation is not the Jerrum–Sinclair–Vigoda approximation of the permanent. The bookmaker is designed as a learner, and its guarantee is a regret bound, not an approximation ratio for LMSR prices.

### 6.4 Polynomial pricing for tournaments *(new)*

[Chen, Goel and Pennock](https://doi.org/10.1145/1374376.1374421), "Pricing combinatorial markets for tournaments," STOC 2008. In a single-elimination tournament of $n=2^k$ teams there are $n-1$ games, and the outcome space has $2^{n-1}$ elements. Pricing arbitrary bets on it with the LMSR is #P-hard. For a natural bet language it is tractable (their Theorem 3.3, $O(n^3)$ operations per trade):

- "team $i$ wins game $k$";
- "team $i$ wins game $k$, given that it reaches that game";
- "team $i$ beats team $j$, given that they meet."

An LMSR trade on an event $E$ multiplies the probability of every outcome in $E$ by a common factor and renormalizes. Starting from the uniform distribution, the market's distribution is a Bayesian network on the bracket with edges directed away from the final: each game's winner conditions the winners of its two feeder games, the reverse of the causal direction. A trade on any of these bets preserves that structure, because the factor can be absorbed into the conditional probability tables of at most one game per round, along a path of the bracket. Prices remain exact, and each trade costs polynomial time. If only "team $i$ beats team $j$, given that they meet" is allowed, the causal orientation (feeder games to later games) is preserved instead, and a trade updates a single parameter.

## 7. After 2010

- [Abernethy, Chen and Wortman Vaughan](https://doi.org/10.1145/2465769.2465777), "Efficient market making via convex optimization, and a connection to online learning," *ACM TEAC* 1(2), 2013, derive the duality-based cost function from axioms (path independence, no arbitrage, information incorporation) for arbitrary securities, identify trading with FTRL, and subsume most of §5. They also give an efficient pair-betting market maker by relaxing the no-arbitrage set.
- Frongillo, Della Penna and Reid, NIPS 2012: price dynamics as stochastic mirror descent. Abernethy, Kutty, Lahaie and Sami, EC 2014: exponential-family markets, with the cost function a log-partition function.
- Combinatorial market making as optimization over the marginal polytope: Dudík, Lahaie and Pennock, EC 2012 (constraint generation); [Kroer, Dudík, Lahaie and Balakrishnan](https://doi.org/10.1145/2940716.2940767), EC 2016 (Frank–Wolfe projection with an integer-programming oracle, on a $2^{63}$-outcome market for a 64-team tournament); Hossain, Wang and Yu, SODA 2025 (a geometric view, with pricing as range queries).
- [Frongillo, Papireddygari and Waggoner](https://arxiv.org/abs/2302.00196), ITCS 2024: constant-function market makers with concave potentials, such as Uniswap, are equivalent to cost-function prediction markets and define proper scoring rules.

## 8. Exercises

### Prediction markets (May 2010)

1. Show that the four optimality conditions of the Eisenberg–Gale program (§3) are equivalent to the KKT conditions with $\lambda^*_k=p_k$ for the supply constraints $k=1..n$, and $\lambda^*_k=\lambda_{ij}(x,p)$ for the nonnegativity constraints.
2. Show that the implicit formula $s_i(p)=q_i-C(q)+K$ (for any constant $K$) and the explicit formula of Theorem 10 describe the same scoring rule, i.e. the explicit formula satisfies the implicit one.
3. Show that the original SCPM is not truthful: build an example in which a client earns more by buying a portfolio of shares that does not match their probability distribution over outcomes.
4. Show, without the theorems about cost-function markets, that follow the regularized leader is equivalent to the SCPM market model.
5. Justify Theorem 1 of the *Operations Research* version of "A unified framework for dynamic prediction market design": whatever the utility function $u$, the SCPM with Vickrey–Clarke–Groves pricing is truthful. (The paper's theorem says *myopically* truthful.) Also show that under VCG pricing the client pays $\chi(0)-\chi(x^*)$, where
$$
x^*=\arg\max_{0\le x\le l}\ \pi x+\chi(x),\qquad
\chi(x)=\max_{z,s}\ -z+u(s)\quad\text{s.t.}\quad ax+s+q=z\mathbf 1.
$$

*Solution sketch for 1* (from my worked solution of June 2010). Use multipliers $p_j$ for the supply constraints and $q_{ij}$ for the nonnegativity constraints:

$$
L(x,p,q)=-\sum_ie_i\log u_i+\sum_jp_j\Bigl(\sum_ix_{ij}-1\Bigr)-\sum_{i,j}q_{ij}x_{ij}.
$$

The KKT conditions are complementary slackness, $p_j\bigl(\sum_ix_{ij}-1\bigr)=0$ (a) and $q_{ij}x_{ij}=0$ (b); stationarity, $-e_iu_{ij}/u_i+p_j-q_{ij}=0$ (c), since $\partial(e_i\log u_i)/\partial x_{ij}=e_iu_{ij}/u_i$; and feasibility, $x\ge0$, $\sum_ix_{ij}\le1$, $p\ge0$, $q\ge0$. *Necessity:* condition 1 is $p\ge0$; condition 2 follows from (a); moving $q_{ij}\ge0$ to the other side of (c) gives $p_j\ge e_iu_{ij}/u_i$, which rearranges to condition 3; and when $x_{ij}>0$, (b) forces $q_{ij}=0$, so (c) holds with equality, which is condition 4. *Sufficiency:* given conditions 1–4 and a feasible $x$ ($x\ge0$, $\sum_ix_{ij}\le1$), define $q_{ij}=p_j-e_iu_{ij}/u_i$. Condition 3 makes $q\ge0$, and (c) holds by definition. Condition 4 gives (b), by cases on $x_{ij}>0$ or $x_{ij}=0$, and condition 2 gives (a), by cases on $p_j>0$ or $p_j=0$. So $L(x,p,q)=f_0(x)$ with the gradient of $L$ vanishing, and since the program is convex, $x$ is optimal and $p$ are its shadow prices.

*Hint for 2.* At $q$ with interior prices $p=p(q)$, the maximization of Lemma 7 has the first-order condition $q_i=\partial_i\alpha_C(p)+\lambda$ for a multiplier $\lambda$ of $\sum_ip_i=1$. Then $C(q)=p\cdot q-\alpha_C(p)=\sum_jp_j\partial_j\alpha_C+\lambda-\alpha_C$, and $q_i-C(q)=\alpha_C-\sum_jp_j\partial_j\alpha_C+\partial_i\alpha_C$, the explicit formula, with $K=0$.

*Hint for 3.* Under final-price charging, the price paid for the first units of an order is the marginal price after the last unit. Compare a client who buys the bundle matching their beliefs with one who first buys a cheap outcome to shift the duals and then buys the rest.

### Regret minimization and the multi-armed bandit (April 2010)

The second sheet I wrote for the course, on the chapter of Nisan, Roughgarden, Tardos and Vazirani's *Algorithmic Game Theory* (2007) on learning and regret (Blum and Mansour), and on the papers it cites.

1. Prove theorem 4.12 or 4.13 of the book.
2. Extend the Polynomial Weights algorithm and theorem 4.6 of the book to maximizing arbitrary payoffs bounded from below, and outline the changes needed in the proof. Remove the dependence on knowing an upper bound on (the sums of squares of) the payoffs. See Cesa-Bianchi, Mansour and Stoltz, ["Improved second-order bounds for prediction with expert advice"](https://arxiv.org/abs/math/0602629), Lemma 2 and §3.1.
3. The loss of an algorithm $H$ in the full-information model is an expectation, $L^H_T=\sum_t\sum_ip^t_il^t_i$. Define instead the random variable $\hat L^H_T=\sum_tl^t_{\hat\imath_t}$ with $\hat\imath_t\sim p^t$. Find a nontrivial high-probability bound $P\{\hat L^H_T>f(T,\delta)\}<\delta$ for Polynomial Weights, or a modification of it that reduces the variance of its losses. (See §4.3 of the second-order bounds paper; §6 of Auer, Cesa-Bianchi, Freund and Schapire, ["The non-stochastic multi-armed bandit problem"](https://cseweb.ucsd.edu/~yfreund/papers/bandits.pdf), gives such a bound for the partial-information algorithm Exp3.P.)
4. Prove theorem 4.17 of the book (the bound for the partial-information regret-minimization algorithm MAB).
5. Present Exp3 (§3 of the bandit paper). Justify its form by comparing it with MAB, citing the relevant parts of the proofs.
6. Partial-information algorithms are sensitive to the number of actions, because they must estimate each action's losses separately. Suppose many experts $i=1..N$ each supply a probability distribution $\xi^i(t)$ over a few actions $j=1..K$. Following Exp4, modify MAB and derive an upper bound on expected regret against the experts that depends only logarithmically on $N$.
7. The *hardness* of a strategy choosing $j_1,\dots,j_T$ is the number of action switches, $1+\lvert\{1\le t<T: j_t\ne j_{t+1}\}\rvert$. Derive a nontrivial regret bound for MAB, or a modification, against an arbitrary strategy, depending on that strategy's hardness. (See §8 of the bandit paper, Exp3.S.)
8. Following the best expert deterministically in the full-information model has regret of the order of the number of leader changes, $T/2$ in the worst case for losses in $[0,1]$. *Follow the perturbed leader* stores each expert's cumulative loss $L_{i,t}$ and plays $\arg\min_i(L_{i,t-1}+Z_{i,t})$ for random perturbations $Z_{i,t}$. With $Z_{i,t}$ independent and uniform on $[0,\Delta]$, expected regret is at most $\Delta+NT/\Delta$. Build an environment (depending on $\Delta$) in which this algorithm's loss is as large as possible, i.e. a nontrivial, perhaps matching, lower bound. Concentrating the perturbations around the best actions reduces the sensitivity to the number of experts: is this visible in your environment? With perturbation density $f(z)=(\eta/2)^Ne^{-\eta\lVert z\rVert_1}$, the upper bound depends only logarithmically on the number of experts (Cesa-Bianchi and Lugosi, *Prediction, Learning, and Games*, §4.3).

## Corrections to the 2010 notes

The instructive ones, applied above:

1. §2 (now §1): the "if and only if" of Theorem 1 covers five properties, not seven; individual rationality and monotonicity are consequences. Individual rationality concerns nonnegative expected *profit* (the notes said "nonzero payout"), and monotonicity concerns the magnitude of expected profit.
2. §5.1: the Weighted Majority bound has $\ln n/\eta$, not $\ln\eta/\eta$, and the bookmaker's loss bound has $4\varepsilon^2T/b$, not $4\varepsilon^2Tb$. The second slip is already in the 2008 source paper. (§5.1 above uses a gains formulation instead, with the Hoeffding constant.)
3. Theorem 4: the proof's last line dropped the factor 2 in $\varepsilon=\sqrt{2B/(\varphi T)}$.
4. Lemma 6 needs "convex"; Theorem 10 needs "differentiable" scoring rules.
5. §5.3 (now §5.5): the original SCPM charges $p(x^*)^\top a\,x^*$, not $p(l)$.
6. Lemma 17 concerns the unweighted feedback arc set; Lemma 29 is a lower bound on greedy's error, not an approximation guarantee.
7. §6.2: $q_\omega$ was never defined.
8. Eisenberg–Gale standard form: the nonnegativity constraints are indexed $k=n+1..n+nn'$, and $m=n+nn'$.
9. Lemma 2(3)'s proof (§4): summing the two concavity inequalities gives $(\nabla u(s_1)-\nabla u(s_2))^\top(s_2-s_1)\ge0$; the notes had $s_1-s_2$, which as written would make prices fall as the order grows. Agrawal et al.'s appendix has the correct sign.
10. Slater's condition needs a *feasible* point with $f_i(x)<0$ for the nonlinear constraints.

*This page was co-authored by Łukasz Stafiniak and Claude (Opus 5.5), from Łukasz's 2010 notes.*
