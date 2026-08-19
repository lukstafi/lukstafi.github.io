---
title: "JCA Existence over T(F), Round 9: Program 7.1 and the Subsumption Bottleneck"
date: 2026-08-19
---

# JCA Existence over $\mathcal{T}(\mathcal{F})$, Round 9: Program 7.1 and the Subsumption Bottleneck

*Author: Claude (Fable 5), August 2026. Executes the soundness direction of Program 7.1 from round 8 ([round-8-reassessment.md](round-8-reassessment.html)): encode simple semi-unification (SSU) into JCAQP. Outcome: the encoding's equational part works and is machine-checked; the entire remaining difficulty is isolated into a single primitive — expressing one subsumption constraint between answer-chosen terms — and the thesis author's ruling on the parameter conventions (§6) locates that primitive's raw material in the validity condition, leaving three sharply delimited sub-goals (forcing, polarity, width).*

## 0. Summary

1. **Equational skeleton (§2).** For an SSU instance $\mathcal{C}$ we build a purely existential JCA instance $J_0(\mathcal{C})$ (empty-premise structural branches; a decomposition-premise variant was refuted by the round-9 review and is documented in Remark 2.0.1). $J_0$ captures the equational condition (E) *exactly* (Lemma 2.0), and soundness holds: every SSU solution induces an answer (Proposition 2.1, machine-checked). As expected, $J_0$ alone is nearly always solvable — it is deliberately only the skeleton.
2. **Tupling lemma (§3).** SSU-solvability of $\mathcal{C}$ is *equivalent* to: the skeleton's equations plus exactly **two** subsumption constraints (one per letter $a \in \{0,1\}$) between answer-chosen tuples. So Program 7.1 reduces to one primitive:
   > **SUBSUME$(v, u)$:** a JCAQP gadget accepting an answer $\theta$ iff $\theta(u)$ is a substitution instance of $\theta(v)$.
3. **Bottleneck theorem (§4).** If a sound and complete, composable SUBSUME gadget exists, then JCAQP-EXIST over $\mathcal{T}(\mathcal{F})$ is undecidable.
4. **Expressibility analysis (§5).** New structural constraints on any would-be gadget: unifiability probes give the necessary but not sufficient half for free; a **monotonicity lemma** shows relevance conditions survive answer strengthening, so a gadget must detect subsumption violations through consistency or the prefix conditions (validity/no-escaping) — never through relevance; subsumption itself is exactly a $\forall\exists$-equation (matching by freezing), the same logical shape as the thesis's validity check — a near-miss that yields **bounded-variable subsumption** *on polarity-correct answers*. What separates this from full SSU: the **forcing** and **polarity** sub-goals (§5.3), and the **fixed-interface limitation** (§5.4), which bounds *distinct-variable count* per constructed instance, not term size — leading to the load-bearing open sub-question 5.2 (bounded-variable SSU, in a fixed-$k$ and a computable-bound variant, which are not equivalent).
5. **The semantic fork, resolved (§6).** The thesis author confirmed Definition 4.1 as written: consistency is plain $\exists$-closure; validity carries the full prefix (hence reads $\exists\bar t\,\forall\bar\beta\,Q\colon A[\bar\chi\bar\delta := \bar t]$, parameters universally closed outside $Q$). The $\forall\exists$ capability therefore lives unconditionally in validity — no erratum needed on this point. Two residual author-questions remain (§6): the $\bar t$ convention, and the Example 4.3 most-generality caveat.

## 1. The target: simple semi-unification

Following Dudenhefner (FSCD 2020), fix the term language $\mathbb{T} ::= \alpha \mid \sigma \to \tau$ (one binary constructor, variables, no constants). A **simple constraint** is a quadruple written $a|\alpha| \doteq |\beta|b$ with $a, b \in \{0,1\}$ and $\alpha, \beta$ variables. A triple of substitutions $(\varphi, \psi_0, \psi_1)$ **models** it iff

$$\varphi(\beta) = \begin{cases} \psi_a(\varphi(\alpha)) \to \tau & \text{if } b = 0 \\ \sigma \to \psi_a(\varphi(\alpha)) & \text{if } b = 1 \end{cases} \quad\text{for some } \sigma, \tau,$$

i.e. the $b$-component of $\varphi(\beta)$ equals $\psi_a(\varphi(\alpha))$. **SSU** — does a finite constraint set have a model? — is undecidable (via uniform boundedness of deterministic simple stack machines; one constraint per machine instruction, states as variables). Its attractions as a source: only two semi-valuations $\psi_0, \psi_1$, shared across all constraints; each constraint touches one $\psi$-application at depth one; no nesting.

Notation below: JCAQP terms over signature $\{\mathrm{arr}/2,\ c/0\}$; $\pi_0, \pi_1$ project an $\mathrm{arr}$'s components. Transliteration $(\cdot)^t$ maps SSU terms to JCAQP terms, sending SSU variables to distinct answer parameters.

## 2. The equational skeleton $J_0(\mathcal{C})$ and soundness

Instance variables: $x_\alpha$ for each SSU variable $\alpha$ of $\mathcal{C}$; $y_{a,\alpha}$ for each pair $(a,\alpha)$ occurring in a constraint; a witness variable $w_\kappa$ per constraint $\kappa$. For each $\kappa = (a|\alpha| \doteq |\beta|b)$, the **structural branch** has an *empty premise*:

$$D_\kappa:\ \top \qquad C_\kappa:\ x_\beta \doteq \begin{cases} \mathrm{arr}(y_{a,\alpha},\, w_\kappa) & b = 0 \\ \mathrm{arr}(w_\kappa,\, y_{a,\alpha}) & b = 1. \end{cases}$$

**Lemma 2.0.** $\theta$ passes branch $\kappa$ iff $\theta(x_\beta)$ is *syntactically* an arrow whose $b$-component is $\theta(y_{a,\alpha})$ (and whose other component is $\theta(w_\kappa)$) — i.e. exactly condition (E) of §3.

*Proof.* With an empty premise, consistency is satisfiability of $A$, and relevance (Theorem 2.4 of round 8) demands that $\mathrm{mgu}(A) = \theta$ itself equalize $C_\kappa$. $\square$

**Remark 2.0.1 (why not decomposition premises).** The first version of this skeleton used premise-side decomposition, $D_\kappa: x_\beta \doteq \mathrm{arr}(h^0_\kappa, h^1_\kappa)$, $C_\kappa: h^b_\kappa \doteq y_{a,\alpha}$. The round-9 automated review exhibited a fatal aliasing answer: $\theta(x_\beta) = g$ (a bare parameter) and $\theta(y_{a,\alpha}) = h^0_\kappa$ — the premise binds $g \mapsto \mathrm{arr}(h^0, h^1)$, the conclusion becomes the tautology $h^0 \doteq h^0$, and even a perfect SUBSUME gadget accepts ($h^0$ *is* an instance of the variable $g$), producing a false positive on unsolvable instances; round 8's guards cannot reject it because the aliased right-hand side is a variable. The empty-premise formulation closes the hole structurally: relevance under $\top$ is equalization by $\mathrm{mgu}(A)$ alone, so a bare-parameter $\theta(x_\beta)$ simply fails, and no branch-local variables exist to alias. (This also simplifies Theorem 4.1's completeness — no guard toolkit needed.)

**Proposition 2.1 (soundness).** If $(\varphi, \psi_0, \psi_1)$ models $\mathcal{C}$, then $\theta$ defined by $\theta(x_\alpha) = \varphi(\alpha)^t$, $\theta(y_{a,\alpha}) = \psi_a(\varphi(\alpha))^t$, and $\theta(w_\kappa) = $ the transliterated other component of $\varphi(\beta)$, passes every branch of $J_0(\mathcal{C})$.

*Proof.* $\theta(x_\beta) = \varphi(\beta)^t$ is an arrow whose $b$-component is $\psi_a(\varphi(\alpha))^t = \theta(y_{a,\alpha})$ and whose other component is $\theta(w_\kappa)$, by the modeling condition; apply Lemma 2.0. $\square$

**Junk (expected).** $J_0$ alone is essentially always solvable — bind each $y_{a,\alpha}$ to a fresh parameter and each $x_\beta$ to an arrow with the right $y$-parameters in the right slots. This is not junk *of the skeleton*: by Lemma 2.0, $J_0$ captures exactly the equational content (E) below, and (E) alone is trivially satisfiable. All hardness lives in the coherence of the $\psi$'s, isolated next.

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

**Theorem 4.1.** Suppose there is a SUBSUME gadget that is sound and complete in the above sense and composable (auxiliary variables fresh; its branches do not constrain non-designated variables beyond consistency-neutral bindings). Then JCAQP-EXIST over $\mathcal{T}(\mathcal{F})$ is undecidable, by reduction from SSU via $J_0(\mathcal{C})$ + tupling branches (empty-premise, like $J_0$'s) + SUBSUME$(X_a, Y_a)$ for $a \in \{0,1\}$.

*Proof.* Reduction soundness (SSU solvable $\Rightarrow$ answer exists): the canonical $\theta$ of Proposition 2.1 satisfies (S) by Lemma 3.1's ($\Rightarrow$) direction, so the gadget's *completeness* (it accepts every subsumption-satisfying answer) makes the combined instance accept it. Reduction completeness (answer exists $\Rightarrow$ SSU solvable): any accepted $\theta$ satisfies (E) *syntactically* by Lemma 2.0 (no aliasing or guard analysis needed — cf. Remark 2.0.1) and (S) by the gadget's *soundness* (it accepts only subsumption-satisfying answers); Lemma 3.1's ($\Leftarrow$) direction yields an SSU model. $\square$

**Sanity check on Example 13.** For the unsolvable $\{1|p| \doteq |p|0\}$ the combined conditions refute themselves in two lines: (E) forces $\theta(x_p) = \mathrm{arr}(\theta(y), \theta(w))$, and (S) forces $\theta(y) = \theta(x_p)\sigma = \mathrm{arr}(\theta(y)\sigma, \theta(w)\sigma)$, whence $\mathrm{depth}(\theta(y)) \geq 1 + \mathrm{depth}(\theta(y))$ — impossible. So given a perfect gadget the encoding correctly rejects it (the decomposition-premise version did not; Remark 2.0.1).

Conversely, round 8's port-collapse theorem constrains gadget design within *existential* JCA: a gadget drawing its discriminatory power from relevance and consistency alone cannot have port-shaped premises. It does not rule out port-shaped premises for a gadget whose power comes from the prefix checks (validity, no-escaping's per-atom gates) — indeed §5.3's candidate has exactly that character. §5 below adds sharper constraints. The problem "is SUBSUME expressible?" is now the clean frontier — Maher's "answer inside the quantifier" difference, as an isolated primitive.

## 5. What any SUBSUME gadget must look like

### 5.1 Unifiability is the free half

A branch $D: v \doteq u$, $C: \top$ accepts $\theta$ iff $\theta(v), \theta(u)$ unify — a *necessary* condition for $\theta(u) \preceq \theta(v)$. The gap to close is one-sidedness: unification may bind $\theta(u)$'s variables. (Round 8 §6; the S3 grounding shortcut — for ground $\theta(u)$, unifiable $=$ subsumed — dies because groundness collapses SSU itself.)

### 5.2 Monotonicity lemma: violations must be caught by consistency

**Lemma 5.1.** Let $A' \Rightarrow A$ in $\mathcal{T}(\mathcal{F})$ (answer strengthening, e.g. merging two parameters, or instantiating a parameter). Then every branch's *relevance* condition transfers from $A$ to $A'$; only *consistency* (and prefix validity/no-escaping) can reject $A'$.

*Proof.* Relevance is the universal closure of $D \land A \Rightarrow C$; strengthening the antecedent preserves it. $\square$

Now $\preceq$ is **not** preserved under parameter merging ($\mathrm{arr}(\gamma_1,\gamma_2) \succeq \mathrm{arr}(c, \mathrm{arr}(c,c))$, but merging $\gamma_1 = \gamma_2$ kills it). Hence: *any **sound** SUBSUME gadget must reject the merged (now non-subsuming) answer, and by Lemma 5.1 the rejection can only come through a consistency (or validity/no-escaping) failure — never through relevance.* This is a strong design constraint: the gadget's premises must be built so that exactly the subsumption-breaking identifications create clashes or occurs-failures. Note the unifiability probe of §5.1 does have this shape (merging $\gamma_1=\gamma_2$ above makes $D \land A$ clash on $c \doteq \mathrm{arr}(c,c)$). In gadget terms the probe is already *complete* — subsumption implies unifiability, so every genuine instance is accepted — and what it lacks is *soundness*: it also accepts unifiable non-instances. The design problem is a soundness gap, not a completeness gap (terminology corrected per the round-4 review).

### 5.3 Subsumption is a $\forall\exists$-equation — and the thesis's own checks are $\forall\exists$

For terms $s, t$ with disjoint variables, folklore (matching by freezing):

$$t \preceq s \quad\iff\quad \mathcal{T}(\mathcal{F}) \models \forall\,\mathrm{FV}(t)\ \exists\,\mathrm{FV}(s):\ s \doteq t,$$

decided by unifying $s$ against $t$ with $t$'s variables frozen as constants. Now observe: JCAQP's **validity** condition is precisely a check of a $\forall\exists$-quantified conjunction of equations, decided by unification with linear constant restrictions (thesis §4.2.1, via Baader–Schulz): by the author's ruling (§6) it reads $\exists\bar t\ \forall\bar\beta\ Q\colon A[\bar\chi\bar\delta := \bar t]$ — the answer's fresh parameters $\bar\beta$ universally closed *outside* the prefix. So the logical shape of SUBSUME is *already present* in the answer-acceptance conditions, unconditionally. Concretely: validity is solution-set-invariant (equivalent constraints have equal $Q$-prefixed truth), and for an answer whose constraint content includes $u \doteq t(\bar\beta)$, $v \doteq s(\bar x)$ and $u \doteq v$, with $\bar\beta$ parameters (**answer-chosen in number**) and $\bar x$ among $Q$'s existentials, the validity check evaluates exactly $\forall\bar\beta\,\exists\bar x:\ s \doteq t$ — subsumption of $\theta(u)$ onto $\theta(v)$, with the $\exists$-side limited to $Q$'s existentials. Two catches (the second from the round-2 review). First, this is a condition the answer imposes *on itself*; a reduction must additionally **force** every candidate answer into such a shape (empty-premise branches force syntactic identity — too strong). Second, the check implements matching only under a **polarity discipline**: every variable of $\theta(u)$ an answer parameter, every matchable variable of $\theta(v)$ a $Q$-existential. Nothing enforces this on candidate answers, and violated polarity mis-evaluates: with $\theta(v) = c$ and $\theta(u) = x$ for a $Q$-existential $x$, the check reads $\exists x: c \doteq x$ and accepts, although $x$ is no instance of $c$. Forcing and polarity enforcement together are a named sub-goal alongside the width question (§6).

### 5.4 The fixed-interface limitation — and what it does *not* yet prove

The near-miss of §5.3 is limited in one specific dimension: the $\exists$-block of the checkable $\forall\exists$ atoms consists of *instance variables*, of which there are finitely many, fixed with the instance. So the primitive it yields is **bounded-variable subsumption**: $\theta(u) \preceq \theta(v)$ checkable when $\theta(v)$ has at most $k$ *distinct* leaf variables, $k$ fixed by the instance. Routing the subsuming side's leaves through the prefix's universal block hits the same wall (prefixes are instance-fixed). We call this the **fixed-interface limitation**, and — per the author's ruling (§6) — it is a statement about JCAQP's *prefix-quantified checks*: *unboundedly many answer-side objects appear on a universal side only in validity ($\exists\bar t\,\forall\bar\beta\,Q\colon\ldots$) and in no-escaping's per-atom gates, and in both the $\exists$-side is limited to $Q$'s existentials, fixed with the instance.* The channel inventory (corrected by the round-4 review): relevance is a pure $\forall$-closure (equalization; no $\exists$-block); consistency is a pure $\exists$-closure (satisfiability; no $\forall$-block — parameters are ordinary existentials there); validity mixes quantifiers over the whole answer; and no-escaping is *not* purely syntactic — Definition 4.1 gates it per atom on the semantic test $\mathcal{M} \models Q\colon c$ (itself a prefix-quantified equation check, decidable by the same linear-constant-restriction machinery), applying the occurrence/order restriction exactly to the atoms that fail the gate. Since $c$ is answer-chosen, these gates are a second quantifier-mixing channel with the same bounded $\exists$-width, so the limitation stands with both channels counted. Any normal-form theorem in the direction of next-step 3 must model all four channels accordingly.

**What this does not prove** (sharpened by the round-9 review): boundedness here is a bound on *distinct variables*, not on term size — a single existential variable ranges over arbitrarily large terms. The canonical stack-machine solutions do use unboundedly many distinct leaf variables ($\zeta$ needs a distinct $\alpha_{[X]}$ per non-narrow configuration class, else $\psi_a$ would be ill-defined), but nothing rules out *non-canonical* SSU witnesses that economize on distinct variables. So the limitation defeats the canonical route, and it defeats SSU-via-§5.3 **only if** the following has a negative answer:

> **Open sub-question 5.2 (bounded-variable SSU).** Call a witness $(\varphi,\psi_0,\psi_1)$ *$k$-variable* if $\mathrm{ran}(\varphi)$ uses at most $k$ distinct variables. (Only the subsuming side is interface-bounded: in the validity check the matchers' images live on the parameter side, so $\psi_0, \psi_1$ may introduce arbitrarily many fresh variables without consuming prefix existentials — the round-4 review corrected an earlier version that over-demandingly bounded all three ranges.)
> **(a)** For some fixed global $k$: is SSU restricted to $k$-variable witnesses still undecidable?
> **(b)** Is there an undecidable SSU fragment and a *computable* function $k(\cdot)$ such that every solvable instance $\mathcal{C}$ has a $k(\mathcal{C})$-variable witness?

These are **not** equivalent (round-2 review): a reduction builds the JCAQP instance per SSU instance and may allocate an input-dependent number of interface variables, so (b) — the weaker property — is what Program 7.1 actually needs; (a) is the cleaner special case. Correspondingly, decidability of every fixed-$k$ slice would *not* make the limitation an obstruction (the union over a computable $k(\mathcal{C})$ can remain undecidable); the limitation is a genuine obstruction for this route only if (b) fails for every undecidable fragment. A positive (a) or (b) lets Program 7.1 proceed through §5.3's primitive (modulo the forcing and polarity sub-goals). None of this is established here.

This suggests a genuinely two-sided research question:

- **Toward undecidability:** find a mechanism giving unbounded $\exists$-width — e.g. answers whose parameters are pinned by back-propagation to *contexts over other parameters* so that one instance variable's binding carries an unbounded family of "existential slots" (the branch-closure bindings $\nu_i(\gamma)$ are per-branch and can be term-sized — round 8 §7's mechanism, not yet exhausted).
- **Toward decidability:** prove the fixed-interface principle as a theorem — every JCAQP-expressible condition on $\theta$ is equivalent to a Boolean combination of $\forall\exists$-equation checks with $\exists$-width bounded by the instance — and derive that (S)-style conditions are inexpressible, then attempt a bounded-answer argument for the whole problem. Lemma 5.1 would be one ingredient (conditions are anti-monotone-in-relevance, consistency-monotone).

## 6. The semantic fork, resolved by the author (two residual questions)

An earlier version of this section posed a fork: Definition 4.1 states consistency as $\mathcal{M} \models \bigwedge_i \exists\,\mathrm{FV}(D_i \land A).\ D_i \land A$ — a pure $\exists$-closure — while Example 4.3 *verifies* its answer by checking $\forall\gamma\,\exists x,y,z:\ y \doteq f(z,\gamma) \land y \doteq f(a,x)$, with the parameter universally quantified.

**Author's ruling (2026-08-19).** Definition 4.1 is intended as written: **consistency is the plain existential closure** (not $Q$-prefixed; parameters are ordinary existentials there), and **validity carries the full prefix $Q$**. Since the answer's fresh parameters $\bar\beta$ remain free in the validity formula and free variables are universally closed under $\mathcal{M} \models$, validity reads $\exists\bar t\ \forall\bar\beta\ Q\colon A[\bar\chi\bar\delta := \bar t]$. Example 4.3's $\forall\gamma$ display is then best read as verifying validity-style unconstrainedness jointly with the (weaker, $\exists$-closed) consistency requirement.

**Consequences.** The $\forall\exists$ capability of §5.3 does *not* live in consistency (which is mere unifiability) — it lives, unconditionally, in **validity**. This resolves the fork in the more hopeful direction without any erratum to the definition: the bounded-variable matching-by-freezing check is definitionally present. What remains for Program 7.1, per §5.3–5.4, is now sharply delimited:

1. a **forcing mechanism** making every candidate answer carry the checkable linkage atoms;
2. **polarity enforcement** (§5.3's second catch);
3. the **width question** 5.2(a)/(b).

**Residual questions for the author.** (1) In validity, may the instantiation terms $\bar t$ (substituted for $\bar\chi\bar\delta$) mention universally quantified variables of $Q$? This is round 8 §7's filter question — it governs whether validity excludes universal-hard-coding answers. (2) Round 8 §10's Example 4.3 caveat: $y \doteq f(x,z)$ verifies as an answer yet is not below the claimed most general answer $\exists\gamma: y \doteq f(z,\gamma)$ — is an implicit side condition intended, or is the most-generality claim to be weakened?

## 7. Machine checks

[round-9-experiments.py](round-9-experiments.py) (self-contained; reuses round 8's engine, adds one-sided matching by freezing and an (E)+(S) meta-checker):

- **Proposition 2.1** verified on a solvable SSU instance ($\{0|p| \doteq |q|0\}$): the canonical answer passes $J_0$'s branches, and (S) holds via the freezing matcher.
- **Junk demonstrated:** the same $J_0$ has free-$y$ answers regardless of SSU-solvability — confirming (S) carries all the hardness.
- **Remark 2.0.1's aliasing answer** checked on the unsolvable instance: $\theta(x_p) = g$, $\theta(y) = h^0$ passes the (refuted) decomposition-premise variant *and* satisfies (S), but fails the empty-premise skeleton's relevance — the hole and its fix, both machine-visible.
- **Lemma 3.1** exercised on Dudenhefner's Example 13 ($\{1|p| \doteq |p|0\}$, unsolvable — the unbounded machine $\{1p \to p0\}$): bounded search finds no $\theta$ satisfying (E)+(S), while (E) alone is satisfied; on the solvable instance, (E)+(S) answers are found.
- **Lemma 5.1's counterexample** verified: parameter merging preserves every relevance condition while destroying subsumption, and the unifiability probe catches the merge via a consistency clash.

## 8. Next steps

1. **Design the forcing + polarity mechanism** (§5.3's two catches): make every candidate answer carry the linkage atoms $u \doteq t(\bar\beta)$, $v \doteq s(\bar x)$, $u \doteq v$ with the correct variable polarity, without collapsing the validity check to syntactic identity. This is now the main constructive sub-goal, and it is prefix-side, so Lemma 5.1 permits detection through validity/no-escaping as well as consistency.
2. Attack **Question 5.2 (bounded-variable SSU)** — the load-bearing width point, in its two inequivalent variants: (a) fixed global $k$ (the comb-shaped $k{=}2$ case is the natural first target); (b) a computable instance-dependent witness bound $k(\mathcal{C})$, which is all a reduction needs since the JCAQP instance is built per SSU instance. Either positive variant, combined with next-step 1, completes Program 7.1 via §5.3's validity primitive. Independently: can back-propagation pin one parameter to a *context* over other parameters, multiplying effective $\exists$-width across branches?
3. For the decidability route: attempt the fixed-interface principle as a theorem (a normal form for JCAQP-expressible $\theta$-conditions — Boolean combinations of $\forall\exists$-equation checks with $Q$-bounded $\exists$-width), aiming at inexpressibility of (S) in the absence of a positive 5.2(b).
4. Warm-up lower bound (round 8 next-step 2) is still open and would exercise the guard toolkit.

## References

As round 8, plus: A. Dudenhefner, "Undecidability of Semi-Unification on a Napkin," FSCD 2020 (Problems 3/15, Example 13, Theorem 3); F. Baader, K. Schulz, "Unification in the Union of Disjoint Equational Theories" (linear constant restrictions).
