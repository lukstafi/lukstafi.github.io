---
title: "JCA Existence over T(F), Round 9: Program 7.1 and the Subsumption Bottleneck"
date: 2026-08-19
---

# JCA Existence over $\mathcal{T}(\mathcal{F})$, Round 9: Program 7.1 and the Subsumption Bottleneck

*Author: Claude (Fable 5), August 2026. Executes the soundness direction of Program 7.1 from round 8 ([round-8-reassessment.md](round-8-reassessment.html)): encode simple semi-unification (SSU) into JCAQP. Outcome: the encoding's equational part works and is machine-checked; the entire remaining difficulty is isolated into a single primitive — expressing one subsumption constraint between answer-chosen terms — and the round closes with a precise semantic question about the thesis's parameter conventions on which the primitive's fate appears to turn.*

## 0. Summary

1. **Equational skeleton (§2).** For an SSU instance $\mathcal{C}$ we build a purely existential JCA instance $J_0(\mathcal{C})$ (decomposition branches). Soundness holds: every SSU solution induces an answer (Proposition 2.1, machine-checked). As expected, $J_0$ alone is nearly always solvable — it is deliberately only the skeleton.
2. **Tupling lemma (§3).** SSU-solvability of $\mathcal{C}$ is *equivalent* to: the skeleton's equations plus exactly **two** subsumption constraints (one per letter $a \in \{0,1\}$) between answer-chosen tuples. So Program 7.1 reduces to one primitive:
   > **SUBSUME$(v, u)$:** a JCAQP gadget accepting an answer $\theta$ iff $\theta(u)$ is a substitution instance of $\theta(v)$.
3. **Bottleneck theorem (§4).** If a sound and complete, composable SUBSUME gadget exists, then JCAQP-EXIST over $\mathcal{T}(\mathcal{F})$ is undecidable.
4. **Expressibility analysis (§5).** New structural constraints on any would-be gadget: unifiability probes give the necessary but not sufficient half for free; a **monotonicity lemma** shows relevance conditions survive answer strengthening, so a gadget must detect subsumption violations *through consistency alone*; subsumption itself is exactly a $\forall\exists$-equation (matching by freezing), which is the same logical shape as the thesis's validity and (parameter-universal) consistency checks — a striking near-miss blocked only by the **fixed-interface principle**: the $\exists$-side of the checkable $\forall\exists$ atoms is limited to the instance's finitely many variables, while SSU needs unboundedly many.
5. **A semantic fork in the thesis (§6).** Definition 4.1's consistency condition is a pure $\exists$-closure, but Example 4.3 verifies consistency with the answer parameter quantified *universally* ($\forall\gamma\,\exists x,y,z$), operationalizing "parameters are required to be unconstrained". The two readings give JCAQP different expressive power, and the gap matters exactly at the bottleneck. This is a question for the thesis author.

## 1. The target: simple semi-unification

Following Dudenhefner (FSCD 2020), fix the term language $\mathbb{T} ::= \alpha \mid \sigma \to \tau$ (one binary constructor, variables, no constants). A **simple constraint** is a quadruple written $a|\alpha| \doteq |\beta|b$ with $a, b \in \{0,1\}$ and $\alpha, \beta$ variables. A triple of substitutions $(\varphi, \psi_0, \psi_1)$ **models** it iff

$$\varphi(\beta) = \begin{cases} \psi_a(\varphi(\alpha)) \to \tau & \text{if } b = 0 \\ \sigma \to \psi_a(\varphi(\alpha)) & \text{if } b = 1 \end{cases} \quad\text{for some } \sigma, \tau,$$

i.e. the $b$-component of $\varphi(\beta)$ equals $\psi_a(\varphi(\alpha))$. **SSU** — does a finite constraint set have a model? — is undecidable (via uniform boundedness of deterministic simple stack machines; one constraint per machine instruction, states as variables). Its attractions as a source: only two semi-valuations $\psi_0, \psi_1$, shared across all constraints; each constraint touches one $\psi$-application at depth one; no nesting.

Notation below: JCAQP terms over signature $\{\mathrm{arr}/2,\ c/0\}$; $\pi_0, \pi_1$ project an $\mathrm{arr}$'s components. Transliteration $(\cdot)^t$ maps SSU terms to JCAQP terms, sending SSU variables to distinct answer parameters.

## 2. The equational skeleton $J_0(\mathcal{C})$ and soundness

Instance variables: $x_\alpha$ for each SSU variable $\alpha$ of $\mathcal{C}$; $y_{a,\alpha}$ for each pair $(a,\alpha)$ occurring in a constraint; branch-local $h^0_\kappa, h^1_\kappa$ per constraint $\kappa$. For each $\kappa = (a|\alpha| \doteq |\beta|b)$, the **decomposition branch**:

$$D_\kappa:\ x_\beta \doteq \mathrm{arr}(h^0_\kappa, h^1_\kappa) \qquad C_\kappa:\ h^b_\kappa \doteq y_{a,\alpha}.$$

By round 8's Theorem 2.4, an answer $\theta$ passes branch $\kappa$ iff $\theta(x_\beta)$ unifies with a fresh arrow (consistency; automatic unless occurs-check pathologies) and the closure equalizes $h^b_\kappa \doteq y_{a,\alpha}$ — for arrow-shaped $\theta(x_\beta)$ this says exactly $\pi_b(\theta(x_\beta)) \equiv \theta(y_{a,\alpha})$.

**Proposition 2.1 (soundness).** If $(\varphi, \psi_0, \psi_1)$ models $\mathcal{C}$, then $\theta$ defined by $\theta(x_\alpha) = \varphi(\alpha)^t$, $\theta(y_{a,\alpha}) = \psi_a(\varphi(\alpha))^t$ passes every branch of $J_0(\mathcal{C})$.

*Proof.* $\theta(x_\beta) = \varphi(\beta)^t$ is an arrow whose $b$-component is $\psi_a(\varphi(\alpha))^t = \theta(y_{a,\alpha})$ by the modeling condition; the branch mgu binds only the fresh $h$'s. $\square$

**Junk (expected).** $J_0$ alone is essentially always solvable — e.g. bind each $y_{a,\alpha}$ to a fresh parameter and each $x_\beta$ to an arrow with the right $y$-parameters in the right slots; or alias $y_{a,\alpha} \doteq h^b_\kappa$. Guards (round 8, Remark 3.2) exclude the $h$-aliasing family, but the free-$y$ junk is not junk *of the skeleton* at all: $J_0$ correctly captures the equational content (E) below, and (E) alone is trivially satisfiable. All hardness lives in the coherence of the $\psi$'s, isolated next.

## 3. The tupling lemma: two subsumptions suffice

For $a \in \{0,1\}$ let $P_a = \{\alpha \mid (a|\alpha| \doteq |\beta|b) \in \mathcal{C}$ for some $\beta, b\}$, and fix tupling terms $\mathrm{tup}_a(\bar z)$ (right-nested $\mathrm{arr}$s over $|P_a|$ slots, say). Consider the two conditions on a substitution $\theta$ over $\{x_\alpha\} \cup \{y_{a,\alpha}\}$ with images in $\mathcal{T}(\{\mathrm{arr}, c\},\ \mathrm{params})$:

- **(E)** for each $\kappa = (a|\alpha| \doteq |\beta|b)$: $\theta(x_\beta) = \mathrm{arr}(t_0, t_1)$ with $t_b = \theta(y_{a,\alpha})$;
- **(S)** for each $a \in \{0,1\}$: $\mathrm{tup}_a(\theta(y_{a,\alpha}))_{\alpha \in P_a}$ is a substitution instance of $\mathrm{tup}_a(\theta(x_\alpha))_{\alpha \in P_a}$.

**Lemma 3.1 (tupling).** $\mathcal{C}$ is SSU-solvable iff some $\theta$ satisfies (E) and (S).

*Proof.* ($\Rightarrow$) Take the canonical $\theta$ of Proposition 2.1; (E) is the modeling condition; (S) holds with matcher $\sigma_a := \psi_a^t$, which is a single substitution acting on the transliterated parameters — tupling makes "the same matcher for every $\alpha \in P_a$" literal.
($\Leftarrow$) Given $\theta$ and matchers $\sigma_0, \sigma_1$ from (S): untransliterate, reading parameters as SSU variables and the constant $c$ as one fresh SSU variable $z_c$. Set $\varphi(\alpha) := \theta(x_\alpha)^{-t}$, $\psi_a := \sigma_a^{-t}$ extended by $\psi_a(z_c) := z_c$. Since matchers never move the rigid constant $c$, $c$-positions agree on both sides, so $\psi_a(\varphi(\alpha)) = \theta(y_{a,\alpha})^{-t}$ for $\alpha \in P_a$ componentwise from (S); then (E) gives $\pi_b(\varphi(\beta)) = \psi_a(\varphi(\alpha))$ for each constraint — the modeling condition. $\square$

So beyond the skeleton (which JCAQP expresses natively, with $\mathrm{tup}$-building forced by empty-premise branches $\top \Rightarrow X \doteq \mathrm{tup}_a(\ldots)$), the *entire* reduction needs exactly **two** instances of one primitive:

> **SUBSUME$(v, u)$:** a JCAQP gadget (branches, auxiliary variables, prefix declarations) accepting exactly those answers $\theta$ (suitably extended to the auxiliaries) with $\theta(u) \preceq \theta(v)$, i.e. $\theta(u) = \theta(v)\sigma$ for some substitution $\sigma$.

## 4. The bottleneck theorem

**Theorem 4.1.** Suppose there is a SUBSUME gadget that is sound and complete in the above sense and composable (auxiliary variables fresh; its branches do not constrain non-designated variables beyond consistency-neutral bindings). Then JCAQP-EXIST over $\mathcal{T}(\mathcal{F})$ is undecidable, by reduction from SSU via $J_0(\mathcal{C})$ + tupling branches + SUBSUME$(X_a, Y_a)$ for $a \in \{0,1\}$.

*Proof.* Lemma 3.1 plus Proposition 2.1 for soundness; completeness of the combined instance is exactly the gadget's completeness applied to (S), with (E) enforced by the skeleton (junk shapes for (E) are excluded by the guard toolkit of round 8 §3/§5.3 — the residual analysis mirrors round 8's port-aliasing case). $\square$

Conversely, round 8's port-collapse theorem says a SUBSUME gadget cannot have port-shaped premises, and §5 below adds sharper constraints. The problem "is SUBSUME expressible?" is now the clean frontier — Maher's "answer inside the quantifier" difference, as an isolated primitive.

## 5. What any SUBSUME gadget must look like

### 5.1 Unifiability is the free half

A branch $D: v \doteq u$, $C: \top$ accepts $\theta$ iff $\theta(v), \theta(u)$ unify — a *necessary* condition for $\theta(u) \preceq \theta(v)$. The gap to close is one-sidedness: unification may bind $\theta(u)$'s variables. (Round 8 §6; the S3 grounding shortcut — for ground $\theta(u)$, unifiable $=$ subsumed — dies because groundness collapses SSU itself.)

### 5.2 Monotonicity lemma: violations must be caught by consistency

**Lemma 5.1.** Let $A' \Rightarrow A$ in $\mathcal{T}(\mathcal{F})$ (answer strengthening, e.g. merging two parameters, or instantiating a parameter). Then every branch's *relevance* condition transfers from $A$ to $A'$; only *consistency* (and prefix validity/no-escaping) can reject $A'$.

*Proof.* Relevance is the universal closure of $D \land A \Rightarrow C$; strengthening the antecedent preserves it. $\square$

Now $\preceq$ is **not** preserved under parameter merging ($\mathrm{arr}(\gamma_1,\gamma_2) \succeq \mathrm{arr}(c, \mathrm{arr}(c,c))$, but merging $\gamma_1 = \gamma_2$ kills it). Hence: *any complete SUBSUME gadget must reject the merged answer through a consistency (or validity/no-escaping) failure — never through relevance.* This is a strong design constraint: the gadget's premises must be built so that exactly the subsumption-breaking identifications create clashes or occurs-failures. Note the unifiability probe of §5.1 does have this shape (merging $\gamma_1=\gamma_2$ above makes $D \land A$ clash on $c \doteq \mathrm{arr}(c,c)$) — it is the completeness gap, not the mechanism, that is missing.

### 5.3 Subsumption is a $\forall\exists$-equation — and the thesis's own checks are $\forall\exists$

For terms $s, t$ with disjoint variables, folklore (matching by freezing):

$$t \preceq s \quad\iff\quad \mathcal{T}(\mathcal{F}) \models \forall\,\mathrm{FV}(t)\ \exists\,\mathrm{FV}(s):\ s \doteq t,$$

decided by unifying $s$ against $t$ with $t$'s variables frozen as constants. Now observe: JCAQP's **validity** condition ($\mathcal{M} \models Q\colon A[\ldots]$) and — under the parameter-universal reading of §6 — its **consistency** condition are precisely checks of $\forall\exists$-quantified conjunctions of equations, decided by unification with linear constant restrictions (thesis §4.2.1, via Baader–Schulz). So the logical shape of SUBSUME is *already present* in the answer-acceptance conditions. Concretely, under the $\forall$-parameter reading, a single branch with premise $v \doteq u$ where $\theta(u)$'s leaves are answer parameters ($\forall$, and — crucially — **answer-chosen in number**) and $\theta(v)$'s leaves are instance variables ($\exists$ inside the consistency closure) has as its consistency condition exactly $\forall\bar\beta\,\exists \bar x:\ \theta(v) \doteq \theta(u)$ — subsumption of $\theta(u)$ onto $\theta(v)$.

### 5.4 The fixed-interface obstruction

The near-miss of §5.3 fails for SSU for one reason only: the $\exists$-block of the checkable $\forall\exists$ atoms consists of *instance variables*, of which there are finitely many, fixed with the instance — while the subsuming side in (S), $\mathrm{tup}_a(\theta(x_\alpha))$, has answer-chosen leaves whose number is *not computable from the SSU instance* (it grows with the stack machine's uniform bound — that is the whole content of the undecidability). Dually, routing the subsuming side's leaves through the prefix's universal block hits the same wall: prefixes are instance-fixed. Every route we tried lands on this **fixed-interface principle**: *unboundedly many answer-side objects can enter the acceptance conditions only through the parameter block $\bar\beta$, and $\bar\beta$ sits on the $\forall$-side of every check (validity, parameter-universal consistency), never on the $\exists$-side.*

This suggests a genuinely two-sided research question:

- **Toward undecidability:** find a mechanism giving unbounded $\exists$-width — e.g. answers whose parameters are pinned by back-propagation to *contexts over other parameters* so that one instance variable's binding carries an unbounded family of "existential slots" (the branch-closure bindings $\nu_i(\gamma)$ are per-branch and can be term-sized — round 8 §7's mechanism, not yet exhausted).
- **Toward decidability:** prove the fixed-interface principle as a theorem — every JCAQP-expressible condition on $\theta$ is equivalent to a Boolean combination of $\forall\exists$-equation checks with $\exists$-width bounded by the instance — and derive that (S)-style conditions are inexpressible, then attempt a bounded-answer argument for the whole problem. Lemma 5.1 would be one ingredient (conditions are anti-monotone-in-relevance, consistency-monotone).

## 6. A semantic fork in the thesis (question for the author)

Definition 4.1 states consistency as $\mathcal{M} \models \bigwedge_i \exists\,\mathrm{FV}(D_i \land A).\ D_i \land A$ — a pure $\exists$-closure, under which answer parameters $\bar\beta$ are ordinary existentials. But Example 4.3 *verifies* its answer $\exists\gamma: y \doteq f(z,\gamma)$ by checking $\forall\gamma\,\exists x,y,z:\ y \doteq f(z,\gamma) \land y \doteq f(a,x)$ — the parameter universally quantified, operationalizing the surrounding prose "the variables $\bar\beta$ … are free parameters of the answer, they are required to be unconstrained". The two readings differ:

- **$\exists$-reading (Def. 4.1 as written):** parameters are plain fresh variables; consistency is unification; §5.3's gadget has no $\forall$-side at all and expresses nothing beyond unifiability.
- **$\forall$-reading (Example 4.3 as practiced):** consistency per branch is a $\forall\bar\beta\exists$-check — matching by freezing — and JCAQP acquires a *bounded-$\exists$-width subsumption primitive* natively. Program 7.1 then needs only the width barrier broken, not the primitive built from scratch.

A second instance of the same fork (surfaced by the round-8 review exchange): the validity condition $\mathcal{M} \models Q\colon A[\bar\chi\bar\delta := \bar t]$ excludes universal-hard-coding answers (e.g. $\gamma \doteq (\alpha',\beta')$ in the GADT `Pair` example, on which no-escaping is vacuous since each atom is $Q$-valid) only if the instantiation terms $\bar t$ are barred from mentioning universals — also not fixed by the section's text.

Which readings are intended (and which does InvarGenT implement)? The answer determines whether the bottleneck is "build a one-sided primitive from two-sided parts" (hard, maybe impossible) or "amplify the width of an existing one-sided primitive" (a different, more hopeful game). If the intended reading is the $\forall$ one, Definition 4.1's consistency clause should be restated with the parameter block quantified universally in front, and the $\bar t$ convention made explicit — worth an erratum either way.

## 7. Machine checks

[round-9-experiments.py](round-9-experiments.py) (self-contained; reuses round 8's engine, adds one-sided matching by freezing and an (E)+(S) meta-checker):

- **Proposition 2.1** verified on a solvable SSU instance ($\{0|p| \doteq |q|0\}$): the canonical answer passes $J_0$'s branches, and (S) holds via the freezing matcher.
- **Junk demonstrated:** the same $J_0$ has free-$y$ answers regardless of SSU-solvability — confirming (S) carries all the hardness.
- **Lemma 3.1** exercised on Dudenhefner's Example 13 ($\{1|p| \doteq |p|0\}$, unsolvable — the unbounded machine $\{1p \to p0\}$): bounded search finds no $\theta$ satisfying (E)+(S), while (E) alone is satisfied; on the solvable instance, (E)+(S) answers are found.
- **Lemma 5.1's counterexample** verified: parameter merging preserves every relevance condition while destroying subsumption, and the unifiability probe catches the merge via a consistency clash.

## 8. Next steps

1. Resolve the §6 semantic fork with the thesis author; restate Definition 4.1 accordingly.
2. Under the $\forall$-reading: attack the width barrier — can back-propagation pin one parameter to a *context* over $k$ other parameters, effectively multiplying $\exists$-width across branches? A concrete micro-goal: express SUBSUME$(v,u)$ where $\theta(v)$ is restricted to right-combs of unbounded length but only two distinct leaf variables (the SSU instances from stack machines are not far from comb-shaped).
3. Under the $\exists$-reading: attempt the fixed-interface principle as a theorem (a normal form for JCAQP-expressible $\theta$-conditions), aiming at inexpressibility of (S) — the decidability route.
4. Warm-up lower bound (round 8 next-step 2) is still open and would exercise the guard toolkit.

## References

As round 8, plus: A. Dudenhefner, "Undecidability of Semi-Unification on a Napkin," FSCD 2020 (Problems 3/15, Example 13, Theorem 3); F. Baader, K. Schulz, "Unification in the Union of Disjoint Equational Theories" (linear constant restrictions).
