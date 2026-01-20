---
title: "Herbrand Constraint Abduction under Quantifier Prefixes: JCAQP over Term Algebras, Rigid E‑Unification, and Implications for GADT Inference and Invariant Synthesis"
date: 2026-01-20
---

# Herbrand Constraint Abduction under Quantifier Prefixes: JCAQP over Term Algebras, Rigid E‑Unification, and Implications for GADT Inference and Invariant Synthesis

## Note to the reader (re thesis context)

This survey is written around Section 4.2 of your thesis (“Constraint Abduction”), with emphasis on Section 4.2.4.1 (“Abduction for Terms”) and the **JCAQP over the free term algebra** \(\mathcal{T}(\mathcal{F})\) problem. It is feasible to write a coherent survey from the thesis text plus the local paper extracts you collected. However, if you want (i) precise alignment with your appendices (e.g. the referenced proofs/algorithms in Sections A.2.2 / B.2.x) and (ii) a fully accurate bibliography mapping your bracketed citations \([9],[11],[27],[29],\dots\) to concrete venues/years/pages, then yes: providing the complete PDF (including appendices + full reference list) would be helpful.

## Abstract

Constraint abduction asks for “missing hypotheses” \(A\) such that \((D \land A) \Rightarrow C\) holds in a fixed model \(\mathcal{M}\), while \(D \land A\) remains satisfiable. In verification and type inference, the missing hypotheses are not arbitrary formulas but *constraints* drawn from a solver domain (e.g. equations over a term algebra, Presburger arithmetic, or combinations thereof). Section 4.2 of the thesis extraction introduces **Joint Constraint Abduction under a Quantifier Prefix (JCAQP)**, motivated by type-inference-driven invariant generation and by implication constraints in GADT typing. This survey focuses on the hard core case where the background model is the **free term algebra** \(\mathcal{T}(\mathcal{F})\) and the abducted constraints are (existentially quantified) conjunctions of equations. We review the landscape of Herbrand constraint abduction (Maher; Maher & Huang), the jump from simple to joint abduction, the extra complications caused by quantifier prefixes, and the delicate role of Herbrandization/Skolemization in a *fixed-model* setting. We then address the thesis-motivated question of how closely the JCAQP\(_{\mathcal{T}(\mathcal{F})}\) existence problem relates to **Simultaneous Rigid \(E\)-Unification (SREU)** (Degtyarev–Voronkov; Voronkov), and what can (and likely cannot) be reduced to what. Finally, we summarize 2014–2026 follow-up work on closely related forms of abduction—especially SMT/SyGuS “abduction as a service” and verification-oriented abduction—and discuss what (if anything) this implies for inference problems more expressive than OutsideIn-style approaches to GADTs.

## 1. Problem family and motivations

### 1.1 Abduction vs constraint abduction

Classical (logical) abduction is usually phrased as: given a background theory \(\Gamma\) and a goal \(C\), find an explanation \(A\) such that \(\Gamma \cup \{A\} \models C\) and \(A\) is consistent with \(\Gamma\), subject to syntactic restrictions on \(A\). In *constraint abduction*, the background is not an abstract theory but a **fixed model** \(\mathcal{M}\) and the objects of interest are constraints interpreted in that model. A typical instance is a pair \((D, C)\) and we seek \(A\) such that:

- **relevance:** \(\mathcal{M} \models (D \land A) \Rightarrow C\),
- **consistency:** \(\mathcal{M} \models \exists \mathrm{FV}(D,A).\; D \land A\),
- and \(A\) belongs to a solver-friendly constraint language (often existentially quantified conjunctions of atoms).

The thesis extraction adopts this fixed-model stance explicitly and emphasizes that it interacts nontrivially with quantifiers (Section 4.2 intro; see also the example in Section 4.2.4.1 on why Herbrandization can be unsound for a fixed model).

### 1.2 Why joint abduction, and why quantifier prefixes?

Many applications do not present a single implication, but a *family* of implications that must all be satisfied by a *single* abducted hypothesis \(A\). This is **Joint (Simultaneous) Constraint Abduction (JCA)** in Maher’s terminology, and it already behaves differently from “just solve each implication and conjoin” (e.g. Example 12 in Maher, “Herbrand Constraint Abduction”, shows JCA cannot be reduced to SCA in general).

In verification and typing, we also routinely face quantification:

- **Type inference** introduces implicit universal quantification (polymorphism) and local existentials (existential types, GADTs).
- **Invariant synthesis** often ends up with formulas that are valid only under a quantifier prefix, and with “parameters” (e.g. invariant templates) that must not depend on certain universally quantified variables (captured in your thesis as “no escaping variables” / “strong no escaping variables” conditions).

These pressures lead to the thesis’ central formulation:

> A **JCAQP** problem is \(Q:\bigwedge_i (D_i \Rightarrow C_i)\) where \(Q\) is a quantifier prefix and \(D_i,C_i\) are conjunctions of atoms. A candidate answer is an existentially quantified conjunction of atoms \(\exists \bar\beta.\,A\) satisfying relevance/validity/consistency/no-escaping. (Your thesis, Def. 4.1)

## 2. The term-algebra setting: \(\mathcal{T}(\mathcal{F})\) and Herbrand constraints

### 2.1 The model \(\mathcal{T}(\mathcal{F})\)

The free term algebra \(\mathcal{T}(\mathcal{F})\) over signature \(\mathcal{F}\) interprets function symbols as constructors and equality as syntactic identity of ground terms. It is the canonical model underlying unification-based HM typing and the Herbrand constraint domain used in the Maher/Sulzmann lines of work.

Two distinct “hardness boundaries” are easy to conflate here:

1. **Validity/satisfiability of a *given* quantified formula** over \(\mathcal{T}(\mathcal{F})\) (a first-order decision problem). For many fragments, this is decidable (e.g. classical results by Comon and the tree-automata tradition are cited in your thesis as [9]).
2. **Abduction** over \(\mathcal{T}(\mathcal{F})\), which is a *second-order* search problem: we are not merely checking a formula, we are synthesizing a constraint \(A\) that makes multiple implications valid while remaining satisfiable.

It is the second boundary that is at the core of JCAQP\(_{\mathcal{T}(\mathcal{F})}\).

### 2.2 SCA/JCA over Herbrand domains and “fully maximal” answers

Maher’s “Herbrand constraint abduction” line, and the follow-on “On computing constraint abduction answers” (Maher & Huang), study the Herbrand constraint domains:

- \(\mathcal{FT}\): conjunctions of equations (no existentials),
- \(\mathcal{FT}_\exists\): existentially quantified conjunctions of equations.

Key takeaways (see Maher, “Herbrand Constraint Abduction”, and Maher & Huang, “On Computing Constraint Abduction Answers”):

- Maximally general answers can be infinite in number and include many “unexpected” answers (often involving irrelevant fresh variables).
- To obtain a finite and more usable set, Maher introduces **fully maximal answers** (roughly: answers \(A\) such that \(D \land A\) is equivalent, up to existential closure, to \(D \land C\)).
- Maher & Huang provide algorithms to enumerate fully maximal answers for SCA instances, and analyze recognition complexity (co-NP completeness for recognizing maximal/fully maximal answers).
- Joint abduction (JCA) adds another layer: even if each implication has a manageable set of (fully) maximal answers, combining them can be nontrivial, and JCA does not reduce to SCA in general.

### 2.3 Sulzmann et al.: GADT inference via Herbrand constraint abduction

Sulzmann–Schrijvers–Stuckey propose to model GADT typing via implication constraints \(D \supset C\) and then solve them by **Herbrand constraint abduction**, producing conjunctions of type equations as solutions (“Type Inference for GADTs via Herbrand Constraint Abduction”). The paper’s central empirical punchline is that even for small GADT programs, there can be **infinitely many maximal types**, establishing that unrestricted GADT inference is not the Hindley–Milner story.

The methodological linkage to Section 4.2 of your thesis is:

- the “implication constraint” view aligns with SCA/JCA-style problems;
- the need to control the solution space aligns with “fully maximal” and with additional admissibility criteria (“intuitive solutions” in Sulzmann et al.).

However, the thesis’ JCAQP focus is strictly broader: it targets *quantifier prefixes and multi-sorted combination*, motivated by invariant generation and richer constraint domains than pure type equations.

## 3. JCAQP over \(\mathcal{T}(\mathcal{F})\): what exactly is hard?

### 3.1 JCAQP vs the first-order decision problem

Your thesis distinguishes (implicitly but crucially) between:

- checking \(\mathcal{T}(\mathcal{F}) \models Q:\bigwedge_i(D_i \Rightarrow C_i)\), which is a first-order problem (cited as decidable by Comon in the extraction), and
- finding \(A\) such that \(\mathcal{T}(\mathcal{F}) \models \bigwedge_i (D_i \land A \Rightarrow C_i)\) plus validity/consistency/no-escaping.

Even if the *decision* problem is decidable, the abduction problem can remain open/undecidable/ill-behaved because abduction quantifies over candidate hypotheses \(A\) (a synthesis space), and because “good” answers are usually constrained by admissibility conditions that are not purely semantic (e.g. avoiding escaping parameters, avoiding non-intuitive solutions, etc.).

### 3.2 Why Herbrandization/Skolemization must be treated with suspicion here

Section 4.2 of the thesis extraction makes a sharp point that is easy to miss if one comes from automated deduction rather than fixed-model constraints:

- **Herbrandization and Skolemization are transformations at the level of logical consequence**, often used to eliminate quantifiers by moving to a Herbrand universe with additional function symbols.
- In a **fixed model \(\mathcal{M}\)** (here \(\mathcal{T}(\mathcal{F})\) or a multi-sorted combination built on it), these transformations are **not semantics-preserving**: they introduce new uninterpreted function symbols and thus do not yield equivalent formulas *in that model*.

The thesis’ illustrative counterexample (Section 4.2.4.1) shows that Herbrandization can change a formula’s meaning when interpreted in \(\mathcal{T}(\mathcal{F})\): a premise that is unsatisfiable in \(\mathcal{T}(\mathcal{F})\) (“\(a \doteq b(x)\)”) collapses an implication away, while Herbrandization/Skolemization can turn it into a statement that effectively forces a particular instantiation (e.g. \(\varphi(a)\)).

**For invariant synthesis, this is the core reason you typically want to reason under the quantifier prefix rather than Skolemize it away:** Skolem functions represent *witnesses that may depend on universals*; but invariants (and types) are usually required to live in a constraint language that does **not** admit arbitrary fresh function symbols, and—in the fixed-model reading—adding such symbols changes the model and thus changes what it means for an abduction answer to be relevant/consistent.

### 3.3 A second reason to avoid Skolem constraints (even when “sound”): language of solutions

Even if one could justify Skolemization in a given setting (e.g. by switching to a proof-theoretic rather than fixed-model reading, or by extending the signature intentionally), it can still be counterproductive for synthesis tasks:

- Skolem functions effectively *name* dependencies. In invariant generation, this often yields solutions that are correct only because they smuggle in a new, uninterpreted function capturing “the witness choice”.
- Those solutions are not expressible in the intended target language (program invariants, type constraints, etc.), and they can destroy generality: instead of finding a relational invariant under \(Q\), you get a functional witness that is an artifact of the transformation.

This is exactly the thesis’ motivation for keeping quantification explicit and adding “no escaping variables” constraints to control dependency.

## 4. Relation to SREU and the “rigid / intuitionistic” boundary

### 4.1 SREU in brief

**Simultaneous rigid \(E\)-unification (SREU)** arose in proof search for first-order logic with equality (tableaux, connection method, model elimination, etc.). Intuitively, it asks for a single substitution that makes multiple “rigid equations” solvable under their respective (rigid) equational assumptions. Classic results include:

- SREU is undecidable (Degtyarev & Voronkov 1995; see also Voronkov’s 1999 survey “Simultaneous Rigid \(E\)-Unification and Other Decision Problems Related to the Herbrand Theorem”).
- There are deep equivalences between SREU, fragments of intuitionistic logic with equality, and other Herbrand-theorem-related decision problems (Voronkov 1999).
- Degtyarev & Voronkov (1995) give an elementary reduction from second-order unification to SREU (UPMAIL Technical Report 109), positioning SREU as a robust undecidable “hub” problem.

### 4.2 The thesis claim: JAQP (logic) is equivalent to SREU “by Herbrandization”

Section 4.2.4.1 states: the **JAQP problem for first-order logic with function symbols and equality** is undecidable because it is equivalent—*via Herbrandization*—to SREU; moreover the existence of (JCAQP/JAQP-style) answers coincides with intuitionistic satisfiability.

The important nuance for the present survey is that this equivalence is *not* an immediate statement about JCAQP over the fixed model \(\mathcal{T}(\mathcal{F})\). It is about a proof-theoretic/logical reading where Herbrandization is admissible as part of the meta-theory.

### 4.3 Can SREU be reduced to JCAQP over \(\mathcal{T}(\mathcal{F})\)?

Your question (“Can SREU be reduced to JCAQP over \(\mathcal{T}(\mathcal{F})\)?”) is exactly where the fixed-model vs proof-theoretic split matters.

What we can say with high confidence from the material at hand:

1. **SREU \(\leftrightarrow\) JAQP is a standard equivalence in the automated deduction / intuitionistic provability literature, and the thesis uses it explicitly.**
2. **A direct reduction from SREU to JCAQP\(_{\mathcal{T}(\mathcal{F})}\)** would be extremely consequential: it would immediately resolve the (currently “unknown” in your thesis extraction) decidability status of JCAQP over term algebras in the negative (for sufficiently expressive signatures), unless the reduction relies on changing the model or signature in a way that is not admissible in the fixed-model setting.
3. **The obstacle is exactly the one emphasized in Section 4.2’s introduction and in Section 4.2.4.1:** the reduction that goes “by Herbrandization” moves quantifiers into function symbols that are *uninterpreted with respect to the original model*. JCAQP\(_{\mathcal{T}(\mathcal{F})}\) is evaluated in a fixed \(\mathcal{T}(\mathcal{F})\), so that step is not semantics-preserving.

So: **as stated (fixed model \(\mathcal{T}(\mathcal{F})\), fixed signature \(\mathcal{F}\), abducted constraints are equations over that algebra), a clean published reduction SREU \(\leq\) JCAQP\(_{\mathcal{T}(\mathcal{F})}\) is not something the thesis extraction provides, and it is plausibly open.**

There *are* two ways one might try to get a reduction “in spirit”, each with a cost:

- **Allow changing/encoding the signature.** Voronkov shows how to encode arbitrary finite signatures into a small fixed signature (e.g. \((1,0,1)\)) while preserving SREU hardness. If JCAQP\(_{\mathcal{T}(\mathcal{F})}\) allowed *extending* \(\mathcal{F}\) (or systematically encoding additional symbols) so that Skolem functions become constructors, one could attempt to import the JAQP\(\leftrightarrow\)SREU story. But then the target is no longer “over the original \(\mathcal{T}(\mathcal{F})\) arising from the programming language/type constructors”.
- **Change the semantics from fixed-model validity to proof-theoretic provability.** One could define a JAQP/JCAQP-like problem where \(\models\) means provability in an intuitionistic calculus with equality (as in Voronkov’s account), rather than satisfaction in \(\mathcal{T}(\mathcal{F})\). In that setting, Herbrandization is again admissible and the classical equivalences reappear. But this is a different problem than constraint abduction “in a model”.

### 4.4 What about reducing SREU to *existential-only* JCA over \(\mathcal{T}(\mathcal{F})\)?

If we restrict to “plain” Herbrand JCA where:

- the quantifier prefix contains only existentials (or is empty),
- and answers are existential conjunctions of equations (standard \(\mathcal{FT}\) / \(\mathcal{FT}_\exists\) setting),

then we are squarely in the Maher/Maher–Huang world. This world already exhibits severe combinatorial blowups and unknown decidability for some joint problems, but it lacks the explicit quantifier alternation and the proof-theoretic strength that drives SREU’s connection to intuitionistic provability.

Heuristically:

- **SREU’s rigidity behaves like quantifier alternation / scoped assumptions** (different local equational assumptions, globally shared substitution), which is closer to the “under a quantifier prefix” discipline of JCAQP than to existential-only JCA.
- **Existential-only JCA\(_{\mathcal{T}(\mathcal{F})}\)** is a plausible target for reductions from *unification-style* problems and some fragments of semi-unification, but it is not an obvious target for SREU without reintroducing universal structure somewhere (either via quantifiers, or via an encoding that simulates them).

From the excerpts at hand, a conservative conclusion is:

> A reduction SREU \(\leq\) JCA\(_{\mathcal{T}(\mathcal{F})}\) with existential variables only is not supported by the provided sources, and would be surprising without additional machinery that reintroduces universal/rigid structure.

## 5. Why “reason under the prefix” in invariant finding (and in JCAQP more generally)

Your question frames a common tension: “Do we really need to avoid Herbrandization/Skolem constraints and reason under the quantifier prefix?”

In the fixed-model constraint-abduction setting of Section 4.2, the answer is: **yes, if the goal is to preserve semantics and keep solutions in the intended constraint language.** More concretely:

1. **Non-equivalence in a fixed model:** Skolemization/Herbrandization does not, in general, preserve equivalence in \(\mathcal{T}(\mathcal{F})\) (thesis Section 4.2 intro and 4.2.4.1 counterexample).
2. **Witness functions are not admissible constraints:** invariants and types typically must be expressible using the original constructors/relations. Skolem functions introduce extra symbols that cannot be interpreted as program-level structure.
3. **Dependency control is the point:** in a prefix \(Q\), an existential can depend only on universals to its left; this dependency discipline is precisely what the “no escaping variables” condition enforces for abduced constraints involving invariant parameters. Skolemization replaces that discipline by explicit function symbols, which is a different representation that you may not want—and, in a fixed model, may not even be meaningful.

So, in the thesis’ setting you are not “wrong” to avoid Herbrandization; rather, the avoidance is a principled response to the fixed-model semantics and the intended language of solutions.

## 6. Does the Skolem/Herbrandization issue apply to Sulzmann et al.?

Mostly *no*, at least not in the same way.

Sulzmann et al. work inside the Herbrand constraint domain and give a normalization/elimination procedure that **removes universal quantifiers from solved forms without introducing Skolem function symbols** (their “elim” construction). The transformations are justified as equivalences in the intended semantics of Herbrand constraints (their Theorem 4).

That said, your thesis’ warning becomes relevant again if one tries to:

- extend the approach beyond pure Herbrand equations to **combined theories** (e.g. term algebra + arithmetic + other interpreted sorts), or
- interpret the constraints in a **fixed program model** where “new functions” are not admissible, or
- mix in quantifier alternations that do not admit such elimination on solved forms.

In other words: Sulzmann et al. do not appear to rely on “Skolemization introduces fresh uninterpreted functions” as a core step; but the thesis’ caution is still relevant to *generalizing* the approach to JCAQP-style multi-sorted, quantifier-prefix problems for invariant generation.

## 7. 2014–2026 follow-up work on closely related problems

The 2014–2026 period does not (to the best of what is visible from the sources consulted here) deliver a universally accepted, fully automatic, strictly more expressive alternative to OutsideIn for **general GADT inference**—largely because the underlying inference problem remains fundamentally ill-behaved (infinite maximal types / undecidability phenomena already documented by Sulzmann et al.). What *does* evolve substantially is the ecosystem around **abduction as solver functionality**, especially in SMT and verification.

### 7.1 SMT/SyGuS abduction (“abduction as a service”)

Work in the SyGuS/SMT community turns abduction into a first-class query to solvers:

- CVC4 introduced an option to compute abducts via SyGuS (`--sygus-abduct`). (CVC4 1.7 release notes, 2019)
- cvc5 documents interactive support for producing abducts via SMT-LIB commands such as `get-abduct` / `get-abduct-next`. (cvc5 documentation, continuously updated; accessed 2026)
- Reynolds et al. describe solver-side abduction via enumerative SyGuS, giving scalable algorithms and an SMT-oriented interface. (LNCS 12166, 2020)

From the JCAQP perspective, this direction is interesting because it makes abduction a *composable back-end service*: one can imagine decomposing a multi-sorted JCAQP instance into multiple abduct subqueries (as your thesis proposes via a combination procedure), while letting the solver handle substantial fragments of each domain.

### 7.2 Abduction in compositional verification and invariant synthesis

Abduction continues to play a role in verification beyond the classic interpolant-based toolkit:

- Albarghouthi, Gurfinkel, and Chechik develop an abduction-based approach to synthesize circular compositional proofs, with a journal version in 2017 (STTT), building on earlier conference work.
- “Ilinva” (2019) explicitly frames invariant generation as an abductive process for producing inductive invariants.
- The Dillig–Dillig–Li–McMillan line (“Inductive Invariant Generation”) remains a canonical formulation of abduction as “find strengthening \(\psi\) such that \(\chi \land \psi \Rightarrow \gamma\)”, with quantifier elimination as a generator of abductive candidates. Follow-up work in this period often changes the *machinery* (better solvers, better search/CEGIS loops, better combination with learning) rather than the core abductive shape.

These verification uses often operate in arithmetic or decidable background theories and focus on generating helpful auxiliary assertions. The bridge back to JCAQP\(_{\mathcal{T}(\mathcal{F})}\) is methodological: if term equalities and their quantifier-prefix discipline are part of the invariant language (e.g. symbolic heaps, inductive data structures, or type-level invariants), then JCAQP becomes a natural organizing abstraction.

### 7.3 (Bi-)abduction in separation logic and richer heap theories

Although classic bi-abduction for separation logic predates 2014, work continues on extending bi-abduction to richer domains. For example, a 2020 paper studies bi-abduction in a fragment of separation logic with ordered data. This matters to the present survey mainly as evidence that abduction remains a viable lens even in domains where constraints include inductive structure and nontrivial theories.

### 7.4 GADT inference after 2014 (relative to OutsideIn)

Post-2014 practical type inference work in mainstream compilers largely continues to rely on constraint solving with carefully designed restrictions and with user-provided annotations in hard cases. From the perspective of this survey:

- the most informative “follow-up” is not a new complete inference algorithm, but an increasing recognition that **implication constraints and abduction-like reasoning** are natural tools for understanding where annotations are necessary and for supporting error reporting and suggestion generation (echoing Sulzmann et al.’s type error diagnosis discussion).
- where research seeks *more power*, it frequently accepts **incompleteness** or **semi-decision** characteristics (e.g. CEGIS/SyGuS-based search), which aligns more with the “abduction as synthesis” direction than with purely algorithmic constraint solving.

## 8. Open problems and research directions (centered on JCAQP\(_{\mathcal{T}(\mathcal{F})}\))

1. **Decidability of JCAQP over \(\mathcal{T}(\mathcal{F})\):** the extraction describes this as unknown. A clean reduction from SREU would settle it, but the fixed-model semantics appears to block the standard Herbrandization-based route (see Section 9).
2. **Characterizing “good” answers under prefixes:** the no-escaping-variables condition encodes a dependency discipline that is essential for invariants and polymorphic typing. Better structural characterizations (analogous to fully maximal answers) under prefixes could make solver search less ad hoc.
3. **Interaction with combination procedures:** the thesis proposes a plug-in architecture where the term-algebra abducer runs first and other sorts are solved afterward. Understanding when this loses completeness, and how to regain it (e.g. via feedback/iteration), remains an important systems question.
4. **Bridging to solver-level abduction:** SMT/SyGuS abduct engines suggest a path toward practical implementations that can search large hypothesis spaces while respecting a syntactic solution language. Integrating such engines into a JCAQP-style pipeline seems promising, especially for mixed term/arithmetic domains.

## 9. Deep dive on Open Problem 1: decidability of JCAQP\(_{\mathcal{T}(\mathcal{F})}\) (and a reduction attempt from SREU)

This section tries to make the “is it *obviously* undecidable by SREU?” question as crisp as possible. The outcome is not a proof, but (i) a concrete reduction attempt and (ii) a clear explanation of where it breaks under the *fixed-model* semantics of Section 4.2. The punchline is that the standard SREU \(\leftrightarrow\) prenex intuitionistic provability route goes through transformations (Herbrandization/Skolemization and “assumptions as derivability”) that do *not* have a straightforward counterpart in satisfaction over the free term algebra.

### 9.1 What must a reduction even target?

There are at least three “nearby” problems with similar syntax but different semantics:

1. **JAQP/JCAQP in a proof-theoretic sense.** Here \(\models\) means provability/validity in a deductive system (e.g. the LJ\(^=\) setting in Voronkov’s account of rigid unification), and Herbrandization is a standard meta-theoretic move.
2. **JCAQP\(_{\mathcal{T}(\mathcal{F})}\) in the thesis’ fixed-model sense.** Here \(\models\) means satisfaction in a *specific* model \(\mathcal{M} = \mathcal{T}(\mathcal{F})\), and the abducted \(A\) must satisfy relevance/validity/consistency/no-escaping (your thesis, Def. 4.1).
3. **Abduction over quotient/axiomatized term algebras.** One could also consider \(\mathcal{T}(\mathcal{F})/E\) or “term algebra with an equational theory \(E\) baked in” as the model. This is closer to equational reasoning, but it is *not* the same fixed model across all implications when each rigid equation has a different \(E_i\).

The SREU equivalences in Voronkov’s account live squarely in (1). Your Open Problem 1 is about (2).

### 9.2 SREU (informal but operational)

An SREU instance can be seen as a finite family of rigid equations
\[
\{E_i \vdash^\forall s_i \approx t_i\}_{i=1}^n
\]
and asks for a single substitution \(\theta\) (shared across all \(i\)) such that for each \(i\),
\[
E_i\theta \vdash s_i\theta \approx t_i\theta
\]
holds in the intended “rigid/equational” derivability relation (Voronkov’s survey discusses several equivalent formulations and their links to intuitionistic provability).

Two semantic features matter for the reduction attempt:

- \(E_i\) are **assumptions for derivability**, not constraints required to be true in a particular structure.
- The judgment \(E_i\theta \vdash s_i\theta \approx t_i\theta\) is **not just syntactic equality of terms**; it is equality *derivable from* \(E_i\theta\) under the relevant equational calculus.

### 9.3 First naive attempt: “encode rigid equations as implications” (fails vacuously)

Try to translate each rigid equation \(E_i \vdash s_i \approx t_i\) into an implication constraint
\[
D_i \Rightarrow C_i
\quad\text{where}\quad
D_i := \bigwedge E_i,\; C_i := (s_i \doteq t_i),
\]
and let the abducted hypothesis \(A\) encode the substitution \(\theta\) as a conjunction of equations (e.g. \(x_j \doteq u_j\) for each substitution variable \(x_j\)).

If this worked, the target would be a JCA instance in \(\mathcal{T}(\mathcal{F})\) asking for \(A\) such that for all \(i\):
\[
\mathcal{T}(\mathcal{F}) \models (D_i \land A) \Rightarrow C_i.
\]

But this immediately runs into the “premises are assumptions, not satisfiable constraints” problem:

- In \(\mathcal{T}(\mathcal{F})\), a ground equation like \(f(a) \doteq a\) is **false** unless the two ground terms are syntactically identical.
- Many \(E_i\theta\) produced by a would-be SREU solution are *precisely* such nontrivial ground equations; they are meant to be used as rewrite/derivation axioms, not to be *true in the free term algebra*.
- In JCAQP\(_{\mathcal{T}(\mathcal{F})}\), the **consistency condition** requires \(\exists \mathrm{FV}(D_i,A).\; D_i \land A\) to be satisfiable in \(\mathcal{T}(\mathcal{F})\). Thus any encoding where \(D_i\land A\) forces a nontrivial ground equality is rejected (or becomes vacuous if consistency is dropped).

This is the same phenomenon highlighted by the thesis’ Section 4.2.4.1 counterexample: antecedents that are false in \(\mathcal{T}(\mathcal{F})\) make implications trivially true, collapsing the intended meaning.

So the naive encoding does not even get off the ground: it cannot faithfully represent “derivability under assumptions” using only satisfaction of implications in the *free* term algebra.

### 9.4 Second attempt: “make the assumptions true by changing the model” (breaks ‘fixed model’ and ‘shared model’)

One might try to repair the previous failure by choosing a model in which each \(E_i\theta\) is true—e.g. a quotient term algebra modulo the congruence generated by \(E_i\theta\). Then \((E_i\theta \Rightarrow s_i\theta = t_i\theta)\) being true in that quotient looks more like equational consequence.

This does not yield a reduction to JCAQP\(_{\mathcal{T}(\mathcal{F})}\) for two reasons:

1. It changes the model away from \(\mathcal{T}(\mathcal{F})\), i.e. it targets problem (3), not (2).
2. Worse, SREU has **different \(E_i\)** for each component, which would require **different quotient models** for different implications—while JCAQP uses a single fixed model \(\mathcal{M}\) for all \(i\).

Thus “quotienting to make premises true” is incompatible with the JCAQP definition you use for invariants (and would also undermine the multi-sorted combination story, where a single shared base model matters).

### 9.5 Third attempt: “internalize derivability” (requires leaving the pure term-algebra constraint language)

What SREU needs is not the truth of \(E_i\theta\) as equations, but the ability to *use them as rewrite/derivation axioms* to show \(s_i\theta \approx t_i\theta\). To capture that inside a fixed model, one would need to internalize a relation like:
\[
\mathrm{Derive}_E(s,t) \;\; \text{meaning “\(s=t\) is derivable from \(E\)”}.
\]

However, once \(\mathrm{Derive}_E\) is part of the object language, the problem is no longer “JCAQP over \(\mathcal{T}(\mathcal{F})\) with equations as atoms” (the Herbrand constraint domain). It becomes abduction over a richer structure that includes (at least) a reachability / congruence-closure predicate parameterized by a set of equations.

There are ways to represent derivability (e.g. via explicit proof objects, or via a rewriting-step predicate plus transitive closure), but these generally push you beyond first-order equations over a term algebra and into:

- transitive closure / inductive definitions, or
- second-order quantification over derivations, or
- encoding of congruence closure that is not finitely axiomatizable as a pure conjunction of equations.

So this “internalize derivability” route would be a reduction to a *different* abduction problem than the one in Section 4.2.4.1.

### 9.6 Where the classic SREU hardness *does* apply (and why that can be misleading)

Your thesis’ statement that (a suitable) JAQP problem in first-order logic with equality is undecidable “because it is equivalent, by Herbrandization, to SREU” is consistent with the rigid-unification literature:

- SREU is tied to intuitionistic provability (Voronkov’s survey), and
- Herbrandization/Skolemization are admissible meta-transformations in that proof-theoretic setting.

But that line of reasoning targets semantics (1), not fixed-model semantics (2). The reduction does not automatically transfer because JCAQP\(_{\mathcal{T}(\mathcal{F})}\) is not “provability in LJ\(^=\)”; it is “truth in a particular structure”, and (crucially) the antecedents must be satisfiable in that structure to avoid vacuity (the consistency condition in Def. 4.1).

### 9.7 What would constitute a genuine SREU \(\leq\) JCAQP\(_{\mathcal{T}(\mathcal{F})}\) reduction?

To actually reduce SREU to your JCAQP\(_{\mathcal{T}(\mathcal{F})}\), one would need to address **both** gaps:

1. **Assumption gap:** encode the effect of assuming equations \(E_i\theta\) without requiring those equations to be true in the free term algebra (otherwise the consistency condition kills the instance).
2. **Derivability gap:** encode “\(E_i\theta \vdash s_i\theta \approx t_i\theta\)” using only the satisfaction of quantifier-prefix implications whose atoms are equations (or whatever the allowed solved form is).

The analysis above suggests that doing both while staying inside the pure Herbrand constraint language is nontrivial and may be impossible—at least without enriching the constraint language with an explicit derivability/reachability predicate or changing the model away from the free term algebra.

### 9.8 Provisional conclusion: strong evidence the reduction is non-obvious (and the problem plausibly open)

This reduction attempt fails in a structurally informative way: it fails not due to a missing trick, but due to a semantic mismatch between:

- **rigid/equational reasoning under assumptions** (SREU), and
- **model satisfaction of implication constraints with a satisfiable antecedent** in a fixed structure (JCAQP\(_{\mathcal{T}(\mathcal{F})}\)).

So your thesis’ “open question” stance looks defensible: SREU-undecidability does not simply carry over “for free” to JCAQP\(_{\mathcal{T}(\mathcal{F})}\) as defined for constraint abduction in a model.

That said, none of the above is a proof of decidability or undecidability. To firm up the status, the next actionable step would be to precisely fix (in the write-up) which variant of JCAQP is meant:

- fixed model \(\mathcal{T}(\mathcal{F})\) with equations as atoms (Section 4.2’s constraint-abduction setting), versus
- proof-theoretic JAQP/JCAQP where Herbrandization is admissible.

If you share the full thesis PDF (especially appendices and the exact formal definition of “JAQP” used in Section 4.2.4.1), I can align the notation and turn the above into a tighter “failed reduction proof” section (with explicit lemmas showing why each attempted encoding collapses under the consistency condition).

## References

- Isil Dillig, Thomas Dillig, Boyang Li, Ken McMillan. “Inductive Invariant Generation.”
- Anatoli Degtyarev, Andrei Voronkov. “Reduction of Second-Order Unification to Simultaneous Rigid \(E\)-Unification.” UPMAIL Technical Report 109, 1995.
- Michael Maher. “Herbrand Constraint Abduction.” LICS 2005.
- Michael Maher, Ge Huang. “On Computing Constraint Abduction Answers.”
- Martin Sulzmann, Tom Schrijvers, Peter J. Stuckey. “Type Inference for GADTs via Herbrand Constraint Abduction.”
- Andrei Voronkov. “Simultaneous Rigid \(E\)-Unification and Other Decision Problems Related to the Herbrand Theorem.” Theoretical Computer Science 224, 1999.
- Isil Dillig, Thomas Dillig, Boyang Li, Ken McMillan, Mooly Sagiv. “Synthesis of Circular Compositional Program Proofs via Abduction.” STTT, 2017.
- Haniel Barbosa et al. “CVC4 1.7 release notes” (SyGuS abduction option).
- cvc5 documentation: abducts (`get-abduct`, `get-abduct-next`).
- Andrew Reynolds, Haniel Barbosa, Daniel Larraz, Cesare Tinelli. “Scalable Algorithms for Abduction via Enumerative Syntax-Guided Synthesis.” *Automated Reasoning* (LNCS), 2020.
- Mnacho Echenim, Nicolas Peltier, Yanis Sellami. “Ilinva: Using Abduction to Generate Loop Invariants.” 2019.
- Christopher Curry, Quang Loc Le. “Bi-Abduction for Shapes with Ordered Data.” 2020.
