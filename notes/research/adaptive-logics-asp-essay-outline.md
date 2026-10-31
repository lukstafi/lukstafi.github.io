# Outline: adaptive logics, defeasible reasoning and Answer Set Programming

*Working notes, 31 Oct 2026. Not for publication.*

## Sources

- Slides "Adaptive and Probabilistic Logics for Reasoning Systems" (~2008; `~/Downloads/AdRS/AdRS.pdf`, TeXmacs source `AdRS.tm`). Used: Batens's adaptive logics (general characterization, flat and prioritized, semantics, dynamic proofs, the goal-directed procedure for ACLuN1), concrete logics (induction, abduction, vagueness, metaphor, question evocation), Pollock's OSCAR. Slides 16–17 and 43–45 are empty.
- The user's ASP notes (Anki deck `~/Downloads/AdRS/Answer Set Programming.txt`; plain-text dump in the session scratchpad). They follow the Potassco book (Gebser, Kaminski, Kaufmann, Schaub, *Answer Set Solving in Practice*), Lifschitz and colleagues on strong equivalence and equilibrium logic (HT, N5, first-order SE), and the Datalog chapters of Abiteboul, Hull, Vianu.
- Literature check: `research-adaptive-asp-literature-2026-10-31.md` (31 Oct; dblp was blocked, so the null results rest on OpenAlex and Crossref).

## Decisions (user, 31 Oct 2026)

- **Out:** NARS and PLN. Their truth-value calculi are not covered. NARS appears only through the link to *What Must Be True?*, if at all.
- **No provenance paragraph.** Don't say the slides were made for a reading group.
- **Abduction:** try for a connection, which would be a new result. The user doesn't see one yet. Candidates are in §7 below.

## Candidate thesis

Every system here puts a retraction somewhere. Batens puts it in the proof: lines carry conditions and get marked. Pollock puts it in the inference graph, where defeaters can themselves be defeated. ASP puts it in the solver, where nogoods are learned and the search backjumps. In exchange, ASP computes final consequence exactly, but only for finite ground programs. The infinite part went into grounding.

A second thread is the answer to *What Must Be True?*'s "can we always stop?". Batens: final derivability has no positive test, and "acting on provisional and fallible insights is rational, because not acting at all is not rational". Pollock: warrant is undecidable, so accept the current state provisionally.

## Sections

0. **Opening.** Batens's example from the ACLuN1 slides: from {p, ∼p ∨ r, q, ∼q ∨ s, ∼p}, derive s but not r. Show a five-line dynamic proof. r first appears on condition {p ∧ ∼p}, and the line is marked once p ∧ ∼p is derived. The reader watches a conclusion being withdrawn inside a proof. Point: a paraconsistent base logic loses disjunctive syllogism everywhere, while the adaptive logic loses it only where the premises are inconsistent.
1. **The format.** Lower limit logic + abnormalities + strategy, and the upper limit logic. Dab-formulas. Worked example where the strategies differ: premises Dab(1,2), r ∨ ab₁, r ∨ ab₂. Minimal Abnormality derives r and Reliability doesn't. Checked in clingo (scratchpad `asp/ab.lp`, `run.py`: domain heuristic `--enum-mode=domRec` for subset-minimal models, then intersection). Semantics: reliable models vs minimally abnormal models, Cn_LLL ⊆ Cn_ALr ⊆ Cn_ALm ⊆ Cn_ULL. Prioritized logics in one paragraph.
2. **Dynamic proofs.** RU/RC rules, marking, internal vs external dynamics, final derivability ("for every extension that marks it, a further extension unmarks it"). No positive test. Box: the goal-directed procedure's three phases (derive G on Θ; try Dab(Θ) on Λ; try Dab(Λ) unconditionally). That is argument, attack and counter-attack, which sets up §4.
3. **Reach of the format.** Pick two or three, one paragraph each: induction (abnormality ∃A ∧ ∃∼A; the upper limit adds ∃A ⇒ ∀A; prioritized background generalizations give way first); vagueness ("assume crispness when needed, but check for fuzziness in conditions"); question evocation (a question is derived from its presupposition and withdrawn once a direct answer appears). Metaphor is probably cut. Abduction goes to §7.
4. **Pollock.** Rebutting vs undercutting defeaters, reinstatement, undecidable warrant and provisional acceptance. Planning as defeasible reasoning; epistemic interests drive investigation. Bridge to Dung 1995. Pollock's system maps to *grounded* semantics (§4.2), not stable. Stable extensions correspond to stable models of logic programs (Thms 49, 62). ASPARTIX (Egly, Gaggl, Woltran, A&C 2010) encodes argumentation frameworks in ASP. Adaptive logics ↔ Dung: Straßer & Šešelja (JLC 2010/11); Arieli–Straßer sequent-based argumentation (2015–2019).
5. **ASP.** Reduct and stable model as a guess that must reproduce itself (X = Cn(Pˣ)). {a ← ∼a} has the classical model {a} and no stable model. Constructive flavour: negative literals need only be true, positive ones must also be provable. Equilibrium logic and HT as the logic behind it (strong equivalence = HT equivalence); keep it light. Correspondences:
   - Minimal Abnormality ↔ circumscription of the abnormality atoms ↔ cautious reasoning over subset-minimal answer sets. The circumscription link holds by definition (Batens 2007, Def. 9), but no paper states it as a theorem, so the essay states it as our observation. Complexity: propositional circumscription is Π₂ᵖ-complete (Eiter & Gottlob 1993), and so is inference under disjunctive stable models (Eiter & Gottlob 1995). Minimal Abnormality is in Π₂ᵖ for ACLuNs2-type logics (Arieli 2007, Prop. 5.15), and Π₂ᵖ-hardness is shown for LPm (Coste-Marquis & Marquis, not read). No general completeness statement was found, so say "in Π₂ᵖ", not "complete". Infinite premise sets: Σ⁰₃ (Horsten & Welch 2007), and Π¹₁-complete for Minimal Abnormality (Verdée 2009).
   - Reliability ↔ intersecting over models whose abnormal part stays inside U(Γ). Heyninck & Straßer give the argumentation reading (consequence of the intersection of extensions; see §7).
   - Clingo encoding of §1's example as a figure or box. No ASP or SAT encoding of adaptive logics turned up. The only solver-based precedent is Arieli's QBF simulation (ACM TOCL 2007), which should be cited when the box appears.
   - Straßer & Van De Putte (JLC 2016): Minimal Abnormality equals Reliability exactly for "finite-conditional" premise sets (conjunction-closed abnormalities). Possibly a footnote to §1's example, which is not finite-conditional.
6. **The solver as a dynamic proof.** A derived Dab(Θ) is a nogood on the normality of Θ. Lines that carry conditions work like ATMS labels. Conflict-driven nogood learning plus backjumping is marking and unmarking, done in the search and not in the proof. Unfounded sets and loop nogoods rule out self-supporting conditions. Grounding is where first-order undecidability went: function symbols, infinite groundings, safety. What ASP gives up compared with dynamic proofs: the trace of the search is not an object of reasoning.
7. **Abduction (open; possibly new).** See below.
8. **Closing (undecided).** Option: LLM reasoning traces put the retraction back into visible text ("wait, that's wrong"), so a trace is a dynamic proof without a marking definition. Needs the user's call: it may be too slight, or it may duplicate essays already on the blog.

## §7 working notes: abduction

**Known ground (not new):** Poole's Theorist (1988) treats default reasoning as abduction over a fixed set of hypotheses. Abductive logic programming (Kakas, Kowalski, Toni) is already cited in *What Must Be True?*. Assumption-based argumentation covers both. Meheus's adaptive logics of abduction derive ♦A, i.e. "A is a possible explanation".

**Literature check (31 Oct) changes this section.** Correspondence 1 below is published in substance. Heyninck & Straßer (NMR 2016, arXiv:1604.00162, Thm 6) translate an adaptive logic into assumption-based argumentation, with the negations of abnormalities as assumptions. Under naive, preferred or stable semantics: credulous consequence = Normal Selections, sceptical consequence = Minimal Abnormality, and consequence of the intersection of extensions = Reliability. So "conditions are assumptions" is known; only the JCA positioning below may be new. No published work connects Maher-style or joint constraint abduction with adaptive logics, ASP or argumentation (searched: every OpenAlex work citing the four Maher papers, plus keyword searches). Also relevant:
- Meheus & Batens 2006 (LAr, Reliability): when several explanations compete, only their *disjunction* is abduced. JCA instead keeps incomparable answers apart. That is a sharp contrast for the essay.
- Gauderis & Van De Putte, "Abduction of generalizations" (Theoria 2012): answers that are generalizations, closest in spirit to JCA's x ≐ y. Read before drafting.
- Batens, "Abduction logics: illustrating pitfalls of defeasible methods" (2017). Read before drafting.

**Correspondence 1: conditions are abductive answers** (known in substance; see above). With classical logic in the base logic, a line for G on condition Θ says Γ ⊢ G ∨ Dab(Θ). So with A := "every member of Θ is normal", we get Γ ∧ A ⊨ G. A derivation condition is an abductive answer whose hypothesis language is "normality of members of Ω". Consistency of Γ ∧ A is exactly "Dab(Θ) not derivable". Then:
- Reliability: G is derivable iff some explanation uses only uncontested normalities (Θ ∩ U(Γ) = ∅).
- Minimal Abnormality: G is derivable iff every minimal abnormal part φ is avoided by some explanation of G. Roughly: every maximal consistent set of normality assumptions contains an explanation. This is a skeptical reading in Theorist's terms. Check the infinite case.
- Preference for generality: the goal-directed procedure D-marks lines whose conditions are supersets of another line's (rule 2). So "keep minimal conditions" plays the role of "prefer most general answers". Incomparable minimal conditions play the role of incomparable maximally general answers.

**Where joint constraint abduction (JCA) differs:**
- *Joint:* one Θ must serve several (Γᵢ, Gᵢ).
- *Marking:* JCA asks only that each Dᵢ ∧ A be consistent. That is weaker than Reliability (no member of Θ contested anywhere). It matches abduction's modal answers: several mutually incompatible ♦A can stand together. So JCA's acceptance test is "consistency marking", and Batens's Phase 3 drops out.
- *Hypothesis language:* Ω is open. Answers are equations with fresh variables and unbounded depth, so nothing presumes them normal in advance. The nearest analogue is the first-order inductive logic, whose Ω is defined by a form and is infinite.
- *Decidability shape:* in JCA over T(F), marking is decidable (unification) and the only unbounded thing is the size of the condition. Adaptive consequence in general lacks a positive test because the marking itself depends on unprovability. Framing: **JCA is adaptive derivability with decidable marking and unbounded conditions.** That places JCA-EXIST in Σ₁, with decidability hinging only on a bound for condition size. That is the open bound L in *What Must Be True?*.

This is a reframing, not a theorem. A result would need a transfer. One possibility: a bound on condition size from adaptive-logic metatheory for some class of Ω. Round 8's counterexample to the Bounded Reach Lemma (premise x ≐ y audits unbounded answer depth) warns against naive bounds. No adaptive-logic paper bounding condition size turned up. Straßer & Van De Putte's "finite-conditional" premise sets are the nearest notion, but they concern when strategies coincide, not how large conditions must be.

**Correspondence 2: fixpoints (secondary).** A stable model is a guess that its reduct must reproduce. Invariant inference in the thesis guesses contracts for recursive calls and re-derives them for the body. The contrast is sharp: ASP rejects unfounded (circularly supported) atoms, while partial-correctness invariant inference accepts circular support because induction over finite runs justifies it. Stable vs supported models; a loop that ASP forbids corresponds to a non-terminating run that partial correctness ignores. Abduction supplies the guessed assumptions at the recursive calls. Probably a box at most.

## Open questions for the user

1. Title. Candidates: *Normal Until Shown Otherwise*; *Where the Retraction Lives*; *Presumed Normal*.
2. Is the §8 closing on LLM traces in or out?
3. §7: is "JCA as adaptive derivability with decidable marking and unbounded conditions" worth a section if no theorem comes out of it, or only a paragraph with a pointer to `projects/jca`?
4. Which concrete logics in §3?
5. Co-author line: Claude (Opus 5.5)?
