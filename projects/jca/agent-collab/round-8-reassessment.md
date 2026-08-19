---
title: "JCA Existence over T(F), Round 8: Reassessment and New Structural Results"
date: 2026-08-19
---

# JCA Existence over $\mathcal{T}(\mathcal{F})$, Round 8: Reassessment and New Structural Results

*Author: Claude (Fable 5), August 2026. Continues the agent-collab rounds 1–7 (January 2026) on the decidability of the JCAQP existence problem over the free term algebra, from Section 4.2 of Stafiniak (2015).*

## 0. Summary of this round

The January 2026 rounds converged on: (i) JCA/JCAQP-EXIST over $\mathcal{T}(\mathcal{F})$ is open; (ii) two barriers block undecidability reductions — the **consistency condition** (semantic) and a **Bounded Verification Barrier** (syntactic); (iii) evidence points toward decidability. This round re-examines that convergence and finds:

1. **The Bounded Verification Barrier (round 7's "Barrier 2") is false as stated.** There is a direct counterexample to the Bounded Reach Lemma (§4). A repaired version of the barrier would be equivalent to a *bounded answer property*, which is itself equivalent to decidability — so using the barrier as *evidence* for decidability is circular.
2. **A clean reformulation**: JCA-EXIST over $\mathcal{T}(\mathcal{F})$ is equivalent to a synthesis problem over a *single substitution* with *determined* (mgu-canonical) per-branch closures (§2, Theorem 2.4). This makes the comparison with semi-unification sharp: the difference is not "matching is inexpressible" but precisely *one-sidedness* of the matcher (§6).
3. **A new decidable fragment and a collapse theorem** (§3): when premises are "port bindings" (fresh left-hand-side variables), answer existence collapses to plain unifiability. This subsumes and *sharpens* the earlier diagnosis of why SREU/semi-unification encodings fail: the consistency barrier can be circumvented by renaming premise variables, but the price is that the encoding lands in the collapsing fragment. Hardness, if it exists anywhere, must come from **back-propagation** — premises sharing variables with the answer and conclusions.
4. **The quantifier prefix may supply a matching-like mechanism that the earlier rounds overlooked** (§7): branch premises pin answer parameters to branch-specific terms over universal variables — the mechanism of the thesis's GADT `Pair` example. The pinning itself is relevance-level back-propagation (prefix-independent); the prefix's specific contribution is the validity/no-escaping *filter* on answers, whose exact bite depends on parameter conventions Definition 4.1 leaves open (§7). The round-7 verdict "semi-unification is structurally incompatible with JCAQP" is not justified for nontrivial prefixes — but the positive claim awaits the filter's semantics.

Net effect: the question is **more open than round 7 concluded** — in particular the undecidability route via semi-unification is *reopened* for JCAQP with a nontrivial prefix, while for the purely existential (Maher) JCA the collapse theorem gives a genuinely new decidable fragment and a precise localization of where any hardness must live.

## 1. Setting

Fix a signature $\mathcal{F}$ such that $\mathcal{T}(\mathcal{F})$ has at least two distinct ground terms. Equality in $\mathcal{T}(\mathcal{F})$ is syntactic identity of ground terms; a conjunction of equations is satisfiable iff it is unifiable, and satisfiable conjunctions have idempotent most general unifiers, unique up to renaming.

**JCA-EXIST (Maher's setting, $\mathcal{FT}_\exists$).** Given a finite family $\{(D_i, C_i)\}_{i=1}^m$ of pairs of finite conjunctions of equations, does there exist a finite conjunction of equations $A$ (over any variables, including fresh ones) such that for all $i$:

- **relevance:** $\mathcal{T}(\mathcal{F}) \models \forall\,(D_i \land A \Rightarrow C_i)$ (universal closure over all variables);
- **consistency:** $D_i \land A$ is satisfiable.

Fresh variables $\bar\beta$ of $A$ ("parameters") behave, for these two conditions, exactly like ordinary free variables, since $D_i \land (\exists\bar\beta A) \Rightarrow C_i$ is equivalent to $\forall\bar\beta\,(D_i \land A \Rightarrow C_i)$ when $\bar\beta \mathbin{\#} \mathrm{FV}(D_i, C_i)$. The thesis's JCAQP adds a quantifier prefix $Q$, a validity condition ($\mathcal{T}(\mathcal{F}) \models Q\colon A[\bar\chi\bar\delta := \bar t]$), and the no-escaping conditions; we return to these in §7. Note that relevance is the full universal closure regardless of $Q$ — the prefix restricts the *answer language*, not the relevance semantics.

**Notation.** For an idempotent substitution $\theta$ write $eq(\theta) = \bigwedge_{x \in \mathrm{dom}(\theta)} x \doteq x\theta$. For satisfiable $E$, $\mathrm{mgu}(E)$ is an idempotent mgu. A conjunction of equations $E$ is *trivial* if every equation in it has syntactically identical sides. "$\mu$ equalizes $E$" means $E\mu$ is trivial.

## 2. Reformulation: one substitution, determined branch closures

**Lemma 2.1 (equalization).** Let $E$ be a satisfiable conjunction of equations, $\mu = \mathrm{mgu}(E)$, and $C$ a conjunction of equations. Then $\mathcal{T}(\mathcal{F}) \models \forall\,(E \Rightarrow C)$ iff $C\mu$ is trivial.

*Proof sketch.* The ground solutions of $E$ are exactly the ground instances of $\mu$. If $C\mu$ is trivial every instance satisfies $C$. Conversely if some $s\mu \not\equiv t\mu$, a ground instance separating them exists whenever $\mathcal{T}(\mathcal{F})$ has at least two ground terms (induction on the first position where $s\mu, t\mu$ differ). $\square$

(This is the "entailment lemma" from the codex notes, restated; nothing new. What follows is new.)

**Lemma 2.2 (answer normalization).** If $A$ is an answer, so is $eq(\mathrm{mgu}(A))$. Consequently answers can be assumed to be solved forms, i.e. (equational presentations of) idempotent substitutions.

*Proof.* $A$ and $eq(\mathrm{mgu}(A))$ are equivalent constraints in $\mathcal{T}(\mathcal{F})$, and both relevance and consistency depend on $A$ only through its solution set. $\square$

**Lemma 2.3 (branch mgu).** Let $\theta$ be idempotent and $D$ a conjunction of equations. Then $eq(\theta) \land D$ is satisfiable iff $D\theta$ is unifiable, and in that case $\mathrm{mgu}(eq(\theta) \land D) = \theta \nu$ where $\nu = \mathrm{mgu}(D\theta)$.

*Proof.* $\theta\nu$ unifies both parts. Any unifier $\delta$ of $eq(\theta) \land D$ satisfies $\delta = \theta\delta$, hence unifies $D\theta$, hence factors through $\nu$: $\delta = \nu\delta' \Rightarrow \delta = \theta\nu\delta'$. $\square$

**Theorem 2.4 (substitution form of JCA-EXIST).** The instance $\{(D_i, C_i)\}_i$ has an answer iff there exists an idempotent substitution $\theta$ such that for every $i$:

1. $D_i\theta$ is unifiable, and
2. $C_i\,\theta\nu_i$ is trivial, where $\nu_i = \mathrm{mgu}(D_i\theta)$.

*Proof.* ($\Rightarrow$) By Lemma 2.2 take $A = eq(\theta)$; by Lemma 2.3 consistency gives (1) and $\mathrm{mgu}(D_i \land A) = \theta\nu_i$; by Lemma 2.1 relevance gives (2). ($\Leftarrow$) $A := eq(\theta)$ satisfies both conditions by the same lemmas. $\square$

**Discussion.** Theorem 2.4 exposes the true shape of the problem: *synthesize one substitution $\theta$; each branch then applies a canonical, fully determined operation to it* — unify the premise against it, and check that this closure equalizes the conclusion. Two comparisons:

- **Semi-unification** (SUP): $\exists\theta\ \forall j\ \exists\rho_j:\ \rho_j(\theta l_j) = \theta r_j$. Note the matcher $\rho_j$, when it exists, is *also determined* (matching is deterministic). So "JCA's branch closure is determined, SUP's is freely chosen" is **not** the real difference — a common misconception in earlier rounds. The real difference is *one-sidedness*: $\rho_j$ acts only on the variables of $\theta l_j$ and must leave $\theta r_j$ fixed, whereas $\nu_i = \mathrm{mgu}(D_i\theta)$ binds variables of both sides. See §6.
- **Verification per branch is one unification pass** over $\theta$ — but a unification pass over an *unboundedly large* $\theta$ can compare unboundedly much structure (see §4). Nothing "bounded" about it.

**Proposition 2.5 (r.e.; decidability = bounded answers).** Checking whether a given $A$ is an answer is decidable (two unifications per branch). Hence JCA-EXIST is recursively enumerable, and it is decidable iff the *bounded answer property* holds: some computable $B(\cdot)$ bounds the size of some answer whenever an answer exists. The same holds for JCAQP-EXIST (the validity condition is decidable by unification with linear constant restrictions, per thesis §4.2.1; no-escaping is syntactic).

## 3. The port-collapse theorem: a decidable fragment, and why the refined encodings degenerate

Call a branch $(D_i, C_i)$ **port-shaped** if $D_i = \bigwedge_{k} u_{i,k} \doteq p_{i,k}$ where the $u_{i,k}$ ("ports") are pairwise distinct variables that occur in no $p_{j,l}$ (any branch) and in no $C_j$ for $j \neq i$ (they may occur in $C_i$). Call an answer **port-free** if no port occurs in it.

**Theorem 3.1 (port collapse).** Let every branch of an instance be port-shaped, and let $C^* := \bigwedge_i C_i[\bar u_i := \bar p_i]$. Then the instance has a port-free answer iff $C^*$ is unifiable; and in that case $A := C^*$ is an answer.

*Proof.* ($\Leftarrow$) Let $\hat\theta = \mathrm{mgu}(C^*)$, $A = C^*$ (port-free by the occurrence conditions). For each $i$: $D_i \land A$ is satisfiable because the added bindings $u_{i,k} \mapsto p_{i,k}\hat\theta$ are acyclic over $\mathrm{mgu}(A)$ (ports occur in no $p$), so $\mu_i := \hat\theta \cup \{u_{i,k} \mapsto p_{i,k}\hat\theta\}$ is $\mathrm{mgu}(D_i \land A)$. Then $C_i\mu_i = (C_i[\bar u_i := \bar p_i])\hat\theta$, which is trivial since $\hat\theta$ unifies (indeed equalizes) $C^*$. Relevance follows by Lemma 2.1.
($\Rightarrow$) Let $A$ be a port-free answer, $\hat\theta = \mathrm{mgu}(A)$ (port-free). As above $\mathrm{mgu}(D_i \land A) = \hat\theta \cup \{u_{i,k} \mapsto p_{i,k}\hat\theta\}$, so relevance gives that $(C_i[\bar u_i := \bar p_i])\hat\theta$ is trivial for all $i$; hence $\hat\theta$ unifies $C^*$. $\square$

**Remark 3.2 (guards).** The restriction to port-free answers can be *enforced up to variable aliasing* inside JCA itself, by adding guard branches: for two distinct constants $c_1 \neq c_2$ and each port $u$, add branches $(u \doteq c_1) \Rightarrow (u \doteq c_1)$ and $(u \doteq c_2) \Rightarrow (u \doteq c_2)$ (relevance is automatic; consistency forces $\mathrm{mgu}(A)(u)$ to be an unbound variable), plus pairwise guards $(u \doteq c_1 \land u' \doteq c_2) \Rightarrow (u \doteq c_1)$ to forbid aliasing ports to each other. The residual freedom — aliasing a port to an unbound non-port variable occurring in the answer's images — is harmless in the encodings below when all right-hand sides $r_j$ are non-variables (analysis in §5.3).

**Corollary 3.3 (why the "repaired" SREU/SUP encodings must fail).** Rounds 1–7 diagnosed the failure of naive SREU encodings via the consistency condition (premises $E_i\theta$ false in $\mathcal{T}(\mathcal{F})$). The natural repair — rename premise variables freshly so premises are always satisfiable, letting the answer bind the renamed copies (which *does* express application of a matching substitution, contra round 7's §25.1) — produces port-shaped branches. By Theorem 3.1 the resulting instances can only express *unifiability* of $C^*$, a decidable condition. Concretely, encoding a SUP pair $l_j \leq r_j$ as $D_j: u_j \doteq l_j[\bar x := \bar v_j]$ ($\bar v_j$ fresh), $C_j: u_j \doteq r_j$ yields answer existence iff $\bigwedge_j l_j[\bar x := \bar v_j] \doteq r_j$ is unifiable — the condition "$\theta(r_j)$ is an instance of the *pattern* $l_j$", with $\theta(l_j)$ nowhere. The single application of the unknown $\theta$ on the left is exactly what is lost.

**Moral.** The consistency condition is *not* the deep obstruction (it can be engineered around by renaming). The collapse shows the deep dichotomy: **all expressive power of JCA beyond unifiability lives in back-propagation** — premises sharing variables with the answer and with conclusions, so that $\nu_i = \mathrm{mgu}(D_i\theta)$ feeds branch-specific information back into $\theta$'s parameters. Example 4.3 of the thesis ($A: y \doteq f(z,\gamma)$, premise $y \doteq f(a,x)$ back-propagates $z \doteq a$) is the minimal instance of this mechanism.

## 4. The Bounded Verification Barrier is false as stated

Round 7 (claude notes §25.2) states:

> **Lemma (Bounded Reach).** [...] the set of subterm positions in $A\theta$ that can affect satisfaction of the implications is bounded by $O((n+k) \cdot d)$ [$n$ = quantified variables, $k$ = answer equations, $d$ = max depth of instance terms].

**Counterexample 4.1.** Signature $\{f/1, a\}$; instance variables $x, y, z, w$; single branch $D: x \doteq y$, $C: z \doteq w$. Candidate answers $A_N: x \doteq f^N(z) \land y \doteq f^N(w)$ and $A'_N: x \doteq f^N(z) \land y \doteq f^{N+1}(w)$. Here $k = 2$, $d = 0$, $n = 4$, so the claimed reach bound is $O(1)$, independent of $N$. Both candidates are consistent with $D$ (for $A'_N$ the branch mgu binds $z \mapsto f(w)$). But *satisfaction of the implication* — exactly what the lemma quantifies over — distinguishes them: for $A_N$ the branch mgu identifies $z$ with $w$ and $C$ is equalized ($A_N$ is an answer); for $A'_N$ it binds $z \mapsto f(w)$ and $C$ fails. The two candidates differ only at depth $N$. So positions at depth $N$, far beyond the claimed bound, determine whether the implication is satisfied. The lemma's proof step "unification with depth-$d$ terms can reach at most depth $d$ into each substituted term" is false: unifying two *variables* ($x \doteq y$) merges their entire, unboundedly deep bindings, and the leaf constraints this produces feed directly into relevance. (Consistency exhibits the same unbounded reach — replace the bindings by $f^N(a)$ vs $f^{N+1}(a)$ for a clash at depth $N$; an earlier version of this counterexample used only that consistency form, which refutes answerhood-based barrier arguments but not the lemma as literally stated. The relevance form is due to the round-2 automated review.)

**Consequences.**

1. The "No Traversal Theorem" and its corollary (round 7 §25.2), which conclude that computation-trace encodings cannot reduce to JCAQP, are unsupported. A reduction of the form "machine halts iff an answer (encoding the halting trace, of unbounded size $k$) exists" is *not* ruled out: the answer supplies the trace and branches verify it; nothing bounds $k$ in terms of the instance.
2. What a branch *can* do to unbounded answer structure: enforce **equality** (structural copying) between answer-chosen parts of unbounded size — e.g. a premise $x \doteq y$ forces the full terms bound to $x, y$ to unify; over $\{f/1, a\}$ this makes two answer-chosen "numerals" equal, i.e. branches can express unbounded *arithmetic coincidences* ($M = N$), not just depth-$d$ facts.
3. What remains genuinely unclear — and is the correct residue of the barrier intuition — is whether branches can enforce **local properties at every node** of an answer-chosen structure (a transition relation along a trace), as opposed to global equalities between copies. Classical undecidability proofs in this territory (SREU via shifted pairing; SUP via path equations) do exactly this with equality-flavored primitives, which is why the question is delicate.
4. Any *correct* repair of the barrier — a computable bound on how large a minimal answer needs to be — would, by Proposition 2.5, *prove decidability outright*. So the barrier cannot serve as independent "evidence for decidability": as an argument it is either wrong (as stated) or is the whole theorem. Round 7's "evidence points toward decidability" should be downgraded accordingly.

## 5. What the collapse theorem and the counterexample jointly say

Combining §3 and §4: the earlier rounds' two barriers were (a) real but circumventable (consistency), and (b) false as stated (bounded verification). The correct picture is:

- JCA branches evaluate the answer by **unification against it**, which can compare unbounded structure but only along the *variable-sharing topology* the answer itself sets up.
- Without back-propagation the problem is decidable (Theorem 3.1).
- With back-propagation, each branch computes a determined closure $\nu_i = \mathrm{mgu}(D_i\theta)$ and the conclusion audits it. The open question is exactly the expressive strength of finitely many such audit loops over a shared unknown $\theta$.

### 5.1 The frontier stated as a question about one mechanism

**Question 5.1.** Can finitely many branches, via back-propagation, force the family of per-branch bindings $\{\nu_i|_{\text{params}}\}$ to simulate one step of *iteration* — i.e. force an answer-chosen structure to be related to a *shifted copy of itself* by a fixed local relation — in the style of shifted pairing (Veanes KGC'97; Gurevich–Veanes 1999) or path equations (Kfoury–Tiuryn–Urzyczyn / Dudenhefner for SUP)?

For calibration: the shifted-pairing construction shows SREU is undecidable already with **ground left-hand sides, two variables and three rigid equations** (Veanes; improved by Gurevich–Veanes) — but its two projection equations use the rigid assumptions as *rewrite rules* ($c_{ab} \to a$, $c_{ab} \to b$) projecting a train of pairs onto its components, which is exactly the derivability-under-assumptions mechanism that JCA's fixed-model semantics lacks (rounds 1–7's Barrier 1, which does survive). Notably, SREU with *two* rigid equations was still open in the late 1990s — small-instance intuitions in this territory are treacherous in both directions.

The $M = N$ mechanism of Counterexample 4.1 gives "equal to a copy of itself"; undecidability needs approximately "equal to a *rewritten* copy of itself". Pure equations cannot rewrite — but back-propagated parameters can *stand for* rewritten pieces, with other branches auditing them. Whether the audits can be made sound (no junk answers) is exactly where all our attempts stop; §6 pins down the missing primitive.

### 5.2 A note on jointness

Theorem 3.1 also clarifies Maher's Example 12 (JCA $\neq$ conjunction of SCA solutions): jointness matters *only* in the presence of back-propagation; in the port fragment, jointness degenerates to conjoining (that is what $C^*$ is).

### 5.3 The aliasing residue (for Remark 3.2)

If all $r_j$ are non-variables (WLOG for SUP: replace $l \leq r$ by $f(l) \leq f(r)$), an answer aliasing a port $u_j$ to an unbound variable $z$ occurring in the answer's images either breaks consistency (occurs-check, if $z$ occurs in $l_j^*\hat\theta$) or yields the same equalization condition as the unaliased case (the condition $t_j \equiv \hat\theta(r_j)[z := t_j]$ with $t_j := l_j^*\hat\theta$ forces $z \notin \hat\theta(r_j)$ unless $\hat\theta(r_j) = z$, impossible at a non-variable root). So guards + non-variable right-hand sides make the port fragment airtight for the SUP-style encodings. This level of detail matters because it shows the collapse is not an artifact of restricting the answer language.

## 6. Semi-unification: the exact gap

Round 7 §25.1 concluded SUP is "structurally incompatible" with JCAQP because the matcher $\sigma_i$ is "meta-level". §3 shows this is wrong in one direction (matcher *application* is expressible via fresh renaming; the encoding fails for a different reason — collapse), and the following is the precise residue:

**Maher's own comparison, made precise.** Maher (LICS 2005, end of §5.2) already formulated semi-unification equationally — $\theta$ solves the instance iff $(\tilde\exists_{-x}\, x = t_i \wedge \hat\theta) \to (\tilde\exists_{-x}\, x = u_i \wedge \hat\theta)$ for each $i$ — and observed: "a major difference is that in semi-unification the answer must appear **inside the quantifier**, whereas JCA requires that an answer simply be combined conjunctively with $B$"; he adds that SUP instances have most general solutions while SCA problems may have none, and concludes the JCA decision problem "appears more tractable". Theorem 2.4 turns this remark into an exact statement: in both problems a single unknown substitution is audited per-branch by a determined operation; in SUP the audit is *matching after applying $\theta$ on both sides* (one-sided), in JCA it is *unification of the fixed premise against $\theta$* (two-sided). "Inside the quantifier" = the unknown gets re-instantiated per branch; "conjoined outside" = it does not.

**The one-sided application gap.** JCA can express, for an unknown $\theta$:

- "$\theta(r)$ is an instance of the *fixed pattern* $l$" — port encoding, collapses to unification;
- "$\theta(l)$ and $\theta(r)$ are *equal after further unification*" — back-propagation, but symmetric.

SUP needs "$\theta(r)$ is an instance of $\theta(l)$": the unknown applied on the left, and the matcher forbidden from touching $\theta(r)$'s variables. In mgu terms: $\mathrm{mgu}(\theta l \doteq \theta r)$ must not bind variables of $\theta r$. Pure equational conclusions can check what *is* equalized, never that something *stays unbound* — this is a negation-flavored condition (a disequation/"is-a-variable" test). Three consequences:

1. **For existential-prefix JCA**, undecidability via SUP requires simulating a one-sided binding restriction with consistency failures (the only "negative" signal JCA has: an answer is *rejected* if some branch becomes inconsistent). Guard-style gadgets (Remark 3.2) show consistency can encode "this variable is not bound to a non-variable" — which is precisely an is-a-variable test! Whether guards can protect *answer-dependent* variables (the variables of $\theta r$, unknown in advance) rather than instance variables is the crisp open sub-question. This looks hard but no longer hopeless; it was not identified in rounds 1–7.
2. **For JCAQP with a $\forall\exists$ prefix**, there is a second source of one-sidedness: validity + no-escaping forbid the *answer* from constraining universal variables, while relevance's per-branch $\forall$-closure lets *premises* instantiate them branch-specifically. See §7.
3. Complexity-wise, the encodings that do work land at unifiability (P). Any hardness proof must therefore essentially use back-propagation depth; there is currently not even an NP-hardness proof for JCA-EXIST in the literature we have seen (worth settling as a warm-up: guess-and-check gives membership in NP only if the bounded answer property holds with a polynomial bound — also open).

## 7. The prefix mechanism the earlier rounds overlooked

The thesis's own motivating example (§4.2.4.1, the GADT `Pair` branch) is:

$$\forall \alpha' \beta'\, \exists \tau\, \gamma\, \alpha''\, \beta'' :\quad \tau \doteq \mathrm{Term}((\alpha',\beta')) \;\Rightarrow\; \gamma \doteq (\alpha'',\beta'')\,\text{-ish}$$

with expected answer $\tau \doteq \mathrm{Term}(\gamma) \land \alpha'' \doteq \alpha' \land \beta'' \doteq \beta'$. Run this through Theorem 2.4's lens: the answer binds $\tau$ to a term over the *parameter* $\gamma$; the branch premise back-propagates $\nu: \gamma \mapsto (\alpha', \beta')$ — the parameter receives a **branch-specific value built from universally quantified variables**. Since relevance is a per-branch universal closure ($\bigwedge_i \forall(\dots)$), different branches instantiate the universals independently. This is functionally a *per-branch matching substitution applied to the answer* — the exact ingredient §6 identifies as missing, in its $\forall$-polarity form.

Two clarifications before drawing conclusions (the first prompted by the round-2 automated review):

- **The pinning itself is pure relevance, not a prefix effect.** Relevance universally closes *every* variable regardless of $Q$ (§1), so the mechanism just described is ordinary premise back-propagation, equally available in existential JCA — and the §10 machine check exercises only that part (its checker takes no prefix). What the prefix adds is a *filter* on answers: validity and no-escaping are meant to exclude answers that discharge the conclusion by hard-coding the universals, e.g. $\tau \doteq \mathrm{Term}((\alpha',\beta')) \land \gamma \doteq (\alpha',\beta')$.
- **Whether the filter actually bites is delicate under Definition 4.1 as literally stated.** For that hard-coding answer, each atom $c$ satisfies $\mathcal{M} \models Q\colon c$ (e.g. $\forall\alpha'\beta'\,\exists\gamma: \gamma \doteq (\alpha',\beta')$ is true), so the no-escaping condition is vacuous on it; and the validity condition $\mathcal{M} \models Q\colon A[\bar\chi\bar\delta := \bar t]$ excludes it only if the instantiation terms $\bar t$ are barred from mentioning universal variables — a convention the section's text does not fix. So the prefix-specific exclusion power that Program 7.1 needs is *not yet demonstrated*; it turns on the exact parameter conventions (the same fork as the $\forall$-vs-$\exists$ reading of parameters in consistency, cf. Example 4.3's $\forall\gamma$ check), which the thesis author should adjudicate before the program proceeds. *Author's ruling (2026-08-19, recorded in round 9 §6): Definition 4.1 is intended as written — consistency is the plain $\exists$-closure, validity carries the full prefix $Q$ (with the answer's free parameters universally closed outside it). The $\bar t$ convention above remains the open part of the filter question.*

Three observations:

1. Rounds 1–7 analyzed the prefix almost exclusively through the no-escaping condition (as a *restriction*). The above suggests the prefix package (universals in premises + the answer filter) can also act as an *expressiveness* mechanism — per-branch instantiation of the answer with junk excluded by the filter. The round-7 claim that JCAQP lacks any matching-like primitive is therefore not established for nontrivial prefixes; but by the clarifications above, neither is its negation — the question reduces to the filter's exact semantics.
2. The polarity is dual to SUP's: SUP asks for *some* matcher per branch; the prefix mechanism quantifies matchers *universally* (relevance must hold for all values of $\bar\alpha$, i.e. for every instantiation the premise admits). When the premise pins the universals uniquely (as in the `Pair` example), the $\forall$ collapses to "the" matcher and the polarities coincide. Premises that pin universals are easy to arrange (that is what back-propagation does). This gives a concrete program:

   **Program 7.1 (undecidability attempt for JCAQP-EXIST, $\forall\exists$ prefix).** The right source is Dudenhefner's **simple semi-unification** (SSU, FSCD 2020 Problem 15, undecidable via uniform boundedness of deterministic simple stack machines): find $\varphi, \psi_0, \psi_1$ such that for each constraint $a|\alpha|\;\doteq\;|\beta|b$ (one per stack-machine instruction; $a, b \in \{0,1\}$; $\alpha, \beta$ state variables), $\psi_a(\varphi(\alpha))$ equals the $b$-component of $\varphi(\beta)$, i.e. $\varphi(\beta) = \psi_a(\varphi(\alpha)) \to \tau$ (if $b{=}0$) or $\sigma \to \psi_a(\varphi(\alpha))$ (if $b{=}1$), over the signature $\{\to\}$. Attractions: only **two** unknown semi-valuations $\psi_0, \psi_1$ shared across all constraints; each constraint mentions one $\psi$-application at depth one, no nesting. Encoding plan: (a) $\varphi$ lives on existential variables $x_\alpha$; (b) each branch handles one constraint, with the premise back-propagating $\varphi(\beta)$'s components; (c) the $\psi_a$-application is the hard part — $\psi_a$ acts on the (answer-chosen, unbounded) variables of $\varphi(\alpha)$, so it must be represented by per-branch pinning of parameters against universals (validity + strong no-escaping supplying the one-sidedness: the answer may not constrain universals). The open difficulty: the same variables cannot be "images of $\varphi$" (answer-chosen) and "universal" (answer-forbidden) at once; the encoding must route them through parameters pinned per-branch, and $\psi_a$'s *globality* (same $\psi_a$ in every constraint with letter $a$) must be enforced across branches — jointness is the natural tool. This is where the next round should push.

3. Symmetrically, if Program 7.1 fails for a principled reason, that reason will likely take the form "parameters pinned by premises can only be pinned to *depth-bounded contexts over universals*" — a pattern-unification-like normal form, which would be the right route to a **decidability** proof for the fragment. Either outcome would be a real theorem. (The pattern-unification analogy from rounds 6–7 survives, but now attached to the correct mechanism.)

## 8. Status of the conjectures

- **Conjecture (rounds 1–7): JCAQP-EXIST over $\mathcal{T}(\mathcal{F})$ is decidable.** Downgraded: the two supporting barriers are respectively circumventable and false as stated; and §7 exhibits an expressiveness mechanism pointing the other way for nontrivial prefixes. Current best guess of this round: **existential-prefix JCA-EXIST may well be decidable** (the collapse theorem, the symmetric-mgu limitation of §6, and the absence of any one-sidedness primitive all point that way), while **JCAQP-EXIST with alternating prefix is a serious undecidability candidate** via Program 7.1. These now look like *different problems* and should be tracked separately — the earlier rounds' merging of the two blurred exactly the distinction that matters (as does, in the other direction, the thesis's reduction of *logic-level* JAQP to SREU, which changes semantics rather than prefix).
- **New verified small results of this round:** Theorem 2.4 (substitution form), Theorem 3.1 (port collapse; a decidable fragment), Counterexample 4.1 (refuting the Bounded Reach Lemma), the one-sided-gap analysis (§6), and the prefix-matching mechanism (§7). None of these settles the main question; all of them move the frontier.

## 9. Next steps

1. **Push Program 7.1** (SSU $\to$ JCAQP with $\forall\exists$ prefix). First milestone: a sound encoding (SSU solvable $\Rightarrow$ answer exists) with the one-sidedness enforced by no-escaping; then attack completeness junk-answer by junk-answer, as §5.3 did for ports. Fallback sources if SSU resists: uniform boundedness of deterministic simple stack machines directly (skipping SSU), or the 2-inequality SU normal form of Dudenhefner's Theorem 1.
2. **Warm-up hardness:** prove NP-hardness (or better) of JCA-EXIST (existential prefix) — e.g. via back-propagation gadgets for 3SAT (branch-per-clause; answer chooses assignment; consistency rejects). Would be the first lower bound for the problem and would exercise the guard toolkit.
3. **Bounded answer property for fragments:** attempt a normal-form theorem for answers in the existential fragment — e.g. "if an answer exists, one exists whose depth is bounded by the instance's unification-closure depth". Even for $m = 2$ branches this is open and looks approachable via the structure of $\nu_1, \nu_2$ interaction. A proof technique: answer-minimization — show any answer can be *pruned* at depths the branch mgus never traverse (this is where the failed Bounded Reach intuition can be salvaged as a theorem about *minimal* answers rather than all answers).
4. **Machine experiments:** implement the Theorem 2.4 checker plus a small-answer enumerator; probe minimal answer sizes on families of instances designed to stress back-propagation (Example 4.3 chains, `zip1`/`zip2`-style GADT constraints from Lin's examples cited in the thesis). Evidence of super-polynomial minimal-answer growth would be evidence against the bounded answer property.
5. **Literature re-check** (running in parallel to this round): anything 2015–2026 on the JCA decision problem, new SUP fragments, SREU developments. To be merged into these notes when the sweep completes.

## 10. Machine checks

The formal claims of this round are exercised by [round-8-experiments.py](round-8-experiments.py) (a small unification engine plus the Theorem 2.4 answer checker). Results:

- **Example 4.3**: the thesis's answer $\exists\gamma: y \doteq f(z,\gamma)$ verifies; a brute-force search over single-equation candidates additionally finds the parameter-free answers $y \doteq f(z,x)$ and $y \doteq f(z,z)$ (instances of the thesis's most general answer, obtained by substituting for $\gamma$) — and also $y \doteq f(x,z)$, which verifies as an answer but is **not** an instance of $\exists\gamma: y \doteq f(z,\gamma)$ under the thesis's generality relation (Def. 4.1's "more general": no substitution for $\gamma$ alone yields $f(x,z)$ from $f(z,\gamma)$, and $y \doteq f(x,z)$ does not entail any such instance since it does not entail $x \doteq z$). Unless Example 4.3 carries an implicit side condition excluding such answers, its claim that $\exists\gamma: y \doteq f(z,\gamma)$ is *the* most general answer appears to need a caveat — a **candidate thesis erratum** surfaced by machine search (spotted in the round-8 automated review of an earlier, wrongly grouped version of this bullet).
- **Theorem 3.1**: on 100 random port-shaped instances, whenever $C^*$ unifies, $A := C^*$ verifies as an answer (direction 1 asserted), and search found no port-free answer for any instance with non-unifiable $C^*$ (direction 2 unfalsified).
- **Counterexample 4.1**: with $N = 200$, $A_N$ ($x \doteq f^{200}(z), y \doteq f^{200}(w)$) is an answer to the branch $x \doteq y \Rightarrow z \doteq w$, while $A'_N$ ($y \doteq f^{201}(w)$) stays consistent but **fails relevance** — satisfaction of the implication itself is decided at depth $200$ by an instance of depth $0$, refuting the round-7 reach bound as literally stated (the consistency-only variant $f^{200}(a)$ vs $f^{201}(a)$ is also checked).
- **GADT `Pair`** (with the thesis's conclusion $\gamma \doteq (\alpha'', \beta'')$): the expected answer verifies; dropping the answer's $\gamma$-routing ($\tau \doteq \mathrm{Term}((\alpha'',\beta''))$ alone) **fails relevance** because $\gamma$ never gets pinned — direct confirmation of §7's reading that the mechanism is premise-driven pinning of the parameter $\gamma$ against branch universals; adding $\gamma \doteq (\alpha'',\beta'')$ back yields a second passing answer, **incomparable** with the expected one under Definition 4.1's generality relation: the expected answer forces $\alpha'' \doteq \alpha' \land \beta'' \doteq \beta'$ but leaves $\gamma$ otherwise free, the alternative fixes $\gamma$ from $\alpha'', \beta''$ but leaves those unrelated to $\alpha', \beta'$, and neither entails (an instance of) the other. (An earlier version of this experiment mis-encoded the conclusion as the answer's own atoms and mis-ordered the two answers; both corrected after automated review.)

## 11. Literature status (sweep of 2015–2026, performed 2026-08-19)

A dedicated search (web, Semantic Scholar citation graphs of Maher 2005 and Maher–Huang 2008, dblp, arXiv full-text) found **no publication from 2015–2026 that attacks or resolves the decidability of simple or joint constraint abduction over the free term algebra**. Maher's abduction line ends at LPAR 2008; post-2012 citations are applications (abstract interpretation, soft constraints/security policies), and nothing cites the thesis's JCAQP formulation. GADT-inference research after 2014 routed around abduction entirely (OutsideIn(X), ambivalent types, Chen–Erwig choice types, anti-unification heuristics) without new (un)decidability results for the underlying abduction problem. SMT abduction (`get-abduct`, enumerative SyGuS — Reynolds et al. IJCAR 2020) is complete only in the limit and deliberately sidesteps the most-general-answer theory. **The problem is open and dormant; nobody has applied the modern toolkits to it.**

The materially new assets since the thesis:

- **Undecidability toolkit:** Dudenhefner's mechanized semi-unification reductions — FSCD 2020 ("on a napkin", via uniform boundedness of deterministic simple stack machines) and CSL 2022/LMCS 2023 (constructive many-one reduction Halting $\to$ uniform boundedness of 2-counter machines $\to$ SUP), both in the Coq Library of Undecidability Proofs; acyclic SUP isolated as decidable. These are the natural sources for Program 7.1 — the stack-machine intermediate problem is a cleaner encoding target than raw SUP inequalities, and the mechanization is a template for certifying any eventual reduction.
- **Decidability toolkit:** Backeman–Rümmer's **bounded rigid E-unification** (BREU, CADE/TABLEAUX 2015: variables range over finite term domains; simultaneous BREU is NP-complete) and Barbosa–Fontaine–Reynolds' **E-ground (dis)unification / CCFV** (TACAS 2017: rigid E-unification with ground equations, decidable, production-engineered in CVC4/veriT). Both embody the "bound the answer universe" move — directly relevant to next-step 3 (bounded answer property) and to implementing a practical JCA(QP) answer search (next-step 4): a BREU-style finite-domain layer over the Theorem 2.4 checker would give a complete solver for the bounded fragment.
- **Dual problem solved:** uniform interpolants / covers in EUF (Calvanese–Ghilardi et al., JAR 2021–22) — strongest consequences over uninterpreted symbols are computable, while weakest hypotheses (abduction) over $\mathcal{T}(\mathcal{F})$ remain open; a JCAQP treatment via model completions of the theory of finite trees is an unexplored angle.

## References

- Ł. Stafiniak. *GADTs for Reconstruction of Invariants and Postconditions.* PhD thesis, University of Wrocław, 2015 (§4.2).
- M. Maher. "Herbrand Constraint Abduction." LICS 2005. (Definitions 1/3/6, Example 12, Propositions 2/5/8, §5.2 on semi-unification; primary source re-verified this round.)
- M. Maher, G. Huang. "On Computing Constraint Abduction Answers." LPAR 2008. (FMA algorithm; co-NP-completeness of recognizing (fully) maximal answers; doubly-exponential answer counts.)
- A. Kfoury, J. Tiuryn, P. Urzyczyn. "The Undecidability of the Semi-Unification Problem." Inf. Comput. 102(1), 1993.
- A. Dudenhefner. "Undecidability of Semi-Unification on a Napkin." FSCD 2020. (Simple semi-unification; stack-machine reduction; Coq-mechanized.)
- A. Dudenhefner. "Constructive Many-One Reduction from the Halting Problem to Semi-Unification." CSL 2022; LMCS 19(4), 2023.
- M. Veanes. "The Undecidability of Simultaneous Rigid E-Unification with Two Variables." KGC 1997. (Shifted pairing; ground-LHS/2-variable/4-equation fragment.)
- Y. Gurevich, M. Veanes. "Partisan Corroboration and Shifted Pairing." Inf. Comput. 152, 1999. (3 rigid equations.)
- A. Degtyarev, A. Voronkov. "Simultaneous Rigid E-Unification Is Undecidable." CSL 1995/1996.
- A. Voronkov. "Simultaneous Rigid E-Unification and Other Decision Problems Related to the Herbrand Theorem." TCS 224, 1999.
- P. Backeman, P. Rümmer. "Theorem Proving with Bounded Rigid E-Unification." CADE-25, 2015. (BREU: NP-complete decidable fragment.)
- H. Barbosa, P. Fontaine, A. Reynolds. "Congruence Closure with Free Variables." TACAS 2017. (E-ground (dis)unification.)
- M. Sulzmann, T. Schrijvers, P. Stuckey. "Type Inference for GADTs via Herbrand Constraint Abduction."
- A. Reynolds, H. Barbosa, D. Larraz, C. Tinelli. "Scalable Algorithms for Abduction via Enumerative Syntax-Guided Synthesis." IJCAR 2020.

*Source PDFs recovered this round (Maher 2005 and Maher–Huang 2008 via the Wayback Machine from the defunct UNSW pages; Dudenhefner from DROPS; Veanes from Microsoft Research) are archived locally at `~/jca-papers/`, outside this public repository.*
