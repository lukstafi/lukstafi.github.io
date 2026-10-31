# Adaptive logics, Pollock/Dung, and ASP: literature check (31 Oct 2026)

Method: web search, OpenAlex/Crossref metadata (dblp.org is behind a bot wall and could not be queried), and full-text reads of open PDFs where available. "Read" means I read the relevant passage in the primary text; "abstract" means only the publisher/index abstract was seen.

---

## 1. Encodings or implementations of adaptive-logic consequence

**No ASP or logic-programming encoding of adaptive logics was found.** Searches: "adaptive logic(s)" + "answer set programming", + "logic programming"/"Prolog", + "SAT"/"solver"/"implementation"; an OpenAlex harvest of ~200 works with "adaptive logic(s)" in title/abstract, filtered for computational terms. All "adaptive logic" + ASP hits use "adaptive" in an unrelated sense.

**The one direct solver-based computation found is QBF, not ASP:**

- Arieli, "Paraconsistent reasoning and preferential entailments by signed quantified Boolean formulae", *ACM TOCL* 8(3), 2007. The abstract says off-the-shelf QBF solvers can simulate "Priest's logic LPm ..., Batens' adaptive logic ACLuNs2, Besnard and Schaub's inference relation ...". Ex. 5.5 in the text (read) says "The same pointwise consequence relations also simulate Batens' adaptive logic ACLuNs2". ACLuNs2 is the minimal-abnormality strategy over CLuNs. https://doi.org/10.1145/1243996.1244001 ; author PDF https://www2.mta.ac.il/~oarieli/Papers/tocl.pdf
- Arieli, "Reducing preferential paraconsistent reasoning to classical entailment", *J. Logic Comput.* 13(4):557–580, 2003. Multi-valued preferential (minimal-inconsistency) reasoning is represented "by classical circumscription-like axioms" and can be "implemented using algorithms for processing circumscriptive theories (such as DLS and SCAN)" (abstract). This paper is about preferential paraconsistent logics, not adaptive logics by name. https://doi.org/10.1093/logcom/13.4.557
- Related work in the same family, but not on adaptive logics: Besnard, Schaub, Tompits, Woltran, "Paraconsistent reasoning via QBFs, II: Circumscribing inconsistent theories", ECSQARU 2003 (LNCS 2711:528–539). It encodes LPm and related systems as QBFs for off-the-shelf solvers (read). https://doi.org/10.1007/978-3-540-45062-7_43

**Algorithmic proof procedures from the Ghent group (no software reported):**

- Batens & Meheus, "A tableau method for inconsistency-adaptive logics", TABLEAUX 2000 (LNCS 1847:127–142). https://doi.org/10.1007/10722086_13 . Batens & Meheus, "Shortcuts and dynamic marking in the tableau method for adaptive logics", *Studia Logica* 69, 2001. https://doi.org/10.1023/a:1013865807250
- Batens, "On a partial decision method for dynamic proofs", PCL 2002 (arXiv cs/0207090). It gives a goal-directed procedure for propositional ACLuN1 that is "an algorithm for final derivability" at the propositional level and only a criterion at the predicate level. https://arxiv.org/abs/cs/0207090
- Batens, "A procedural criterion for final derivability in inconsistency-adaptive logics", *J. Applied Logic* 3(1):221–250, 2005. https://doi.org/10.1016/j.jal.2004.07.018
- Verdée, "A proof procedure for adaptive logics", *Logic J. IGPL* 21(5):743–766, 2013. It covers CLuNm and generalises to all adaptive logics whose lower limit logic has a proof procedure (abstract). https://doi.org/10.1093/jigpal/jzs046

**The reverse direction (adaptive logics used to compute argumentation):** Straßer & Šešelja, *JLC* 21(2):133–156, 2010/2011, gives adaptive logics whose models "correspond exactly to specific extensions" of Dung frameworks (abstract). https://doi.org/10.1093/logcom/exq015

## 2. Formal relations

### (a) Circumscription / abnormality predicates

- I found **no paper proving a theorem that relates adaptive logics to McCarthy's circumscription.** Heyninck & Straßer (2016) list "adaptive logics, Makinson's default assumptions and forms of circumscription" together as strict-rule-based NMLs (read) but prove nothing about circumscription.
- The semantic analogy holds by definition. Batens, "A universal logic approach to adaptive logics", *Logica Universalis* 1:221–242, 2007, Def. 9 (read): "A LLL-model M of Γ is minimally abnormal iff there is no LLL-model M′ of Γ such that Ab(M′) ⊂ Ab(M)", where Ab(M) = {A ∈ Ω | M ⊨ A}. This is circumscription-style subset-minimisation of the abnormal part. The same paper fixes the **standard format**: a lower limit logic, a set Ω of abnormalities of a common logical form, and a strategy. https://doi.org/10.1007/s11787-006-0012-5 ; PDF https://users.ugent.be/~dbatens/publ/A2007D_universal.pdf
- Maximal consistent subsets (MCS) and default assumptions: Van De Putte, "Default assumptions and selection functions", MICAI 2013 (LNCS 8265:54–67), links adaptive logics to Makinson's default-assumption consequence relations. Heyninck & Straßer cite it as their Theorem 5 [22, p.10] (read). https://doi.org/10.1007/978-3-642-45114-0_5 . Van De Putte & Straßer, "Adaptive logics: a parametric approach", *LJ IGPL* 22(6):905–932, 2014, transfers its results to default-assumption relations (abstract). https://doi.org/10.1093/jigpal/jzu017

### (b) Dung-style abstract argumentation

- Straßer & Šešelja 2010/11 (above): adaptive logics represent all standard Dung extensions, sceptical and credulous. An extended version is ch. 8 of Straßer's 2014 book, and ch. 9 ("Allowing for joint attacks") extends it to joint attacks.
- Arieli & Straßer, "Sequent-based logical argumentation", *Argument & Computation* 6(1):73–99, 2015. Arguments are sequents, attacks are elimination rules, and conclusions follow Dung semantics (abstract). https://doi.org/10.1080/19462166.2014.1002536
- Arieli & Straßer, "Logical argumentation by dynamic proof systems", *TCS* 781:63–91, 2019. Proofs are "dynamic", in the adaptive-logic style. https://doi.org/10.1016/j.tcs.2019.02.019
- Arieli, Borg & Straßer, "Reasoning with maximal consistency by argumentative approaches", *JLC* 28(7):1523–1563, 2018. It shows that MCS-based reasoning is captured by Dung semantics and gives "soundness and completeness results for the dynamic proof systems with respect to several of Dung's semantics" (abstract). https://doi.org/10.1093/logcom/exy027

### (c) Assumption-based argumentation (ABA), the precise result

Heyninck & Straßer, "Relations between assumption-based approaches in nonmonotonic logic and formal argumentation", NMR 2016, arXiv:1604.00162 (read). https://arxiv.org/abs/1604.00162

- **Translation (Def. 23).** An adaptive logic with lower limit logic L, abnormalities Ω and premises Γ maps to the ABA framework ABF(Γ). Its rules are those of L, its assumptions are Ab_Ω = {¬A | A ∈ Ω}, and the contrary of ¬A is A.
- **Theorem 6.** For sem ∈ {naive, preferred, stable}:
  1. credulous ABA consequence (some extension) = **Normal Selections**;
  2. sceptical ABA consequence (every extension) = **Minimal Abnormality**;
  3. consequence of the intersection of all extensions = **Reliability**.
- **Key lemma.** The stable or preferred assumption sets are exactly Ab_Ω minus the negations of a minimal choice set over the derivable minimal disjunctions of abnormalities ("Dab-formulas").
- **Converse (Theorems 8–9).** A fragment of ABA translates back into adaptive logics, using Kleene-style connectives (∼, ∨) superimposed on the rule language. The result holds for naive semantics in general, and for naive, preferred and stable semantics under condition (EX), which makes every naive set stable.
- The paper also translates adaptive logics into ASPIC+, and ASPIC+ without priorities into ABA.
- Survey restatement: Arieli, Borg, Heyninck & Straßer, "Logic-based approaches to formal argumentation", *J. Applied Logics – IfCoLog* 8(6), 2021, §2.4.2-A (read). PDF https://www2.mta.ac.il/~oarieli/Papers/jal-ifcolog21.pdf

## 3. Complexity

**Propositional circumscription** is Π2P-complete: Eiter & Gottlob, "Propositional circumscription and extended closed-world reasoning are Π2P-complete", *TCS* 114(2):231–245, 1993. https://doi.org/10.1016/0304-3975(93)90073-3

**Disjunctive ASP:** Eiter & Gottlob, "On the computational cost of disjunctive logic programming: propositional case", *AMAI* 15(3–4):289–323, 1995 (abstract, read). Consistency is Σ2P-complete and "the inference problem for these semantics is Π2P-complete" under the disjunctive stable model semantics. "Analogous results are derived for the answer sets semantics of extended disjunctive logic programs." Inference here means truth in all models, i.e. cautious reasoning. https://doi.org/10.1007/bf01536399 ; PDF https://www.kr.tuwien.ac.at/staff/eiter/et-archive/files/amai-dlp.pdf

**Propositional adaptive logics with finite premise sets:**

- These are decidable: Batens, De Clercq, Verdée & Meheus, "Yes fellows, most human reasoning is complex", *Synthese* 166(1):113–131, 2009 (read). https://doi.org/10.1007/s11229-007-9268-4
- **Π2P membership in print.** Arieli (TOCL 2007), Prop. 5.15 (read): the decision problems for his preferential relations |=4(Υ,Δ) and |=3(Υ,Δ) "are in Π2P". This family includes the relation that simulates ACLuNs2 (Ex. 5.5).
- **Π2P hardness.** The same paper cites Coste-Marquis & Marquis 2004 for Π2P-hardness of LPm, even for CNF input. Arieli spells the name "Costa-Marquis". The paper is "On the complexity of paraconsistent inference relations", in *Inconsistency Tolerance*, LNCS 3300:151–190, 2005; I did not read it.
- Taken together, this suggests Π2P-completeness for ACLuNs2. **No paper was found that states Π2P-completeness for Minimal Abnormality in general** (CL-based, standard format, finite Γ).
- Odintsov & Speranski prove "relativized versions of some principal results on computational complexity" for propositional CLuNr and CLuNm: "On algorithmic properties of propositional inconsistency-adaptive logics", *Logic & Logical Philosophy* 21(3):209–228, 2012 (abstract only). https://doi.org/10.12775/LLP.2012.011 . They give general theorems in "Computability issues for adaptive logics in multi-consequence standard format", *Studia Logica* 101(6):1237–1262, 2013 (metadata only). https://doi.org/10.1007/s11225-013-9531-2 . I could not see which classes these theorems name.
- MCS reasoning: Cayrol, Lagasquie-Schiex & Schiex, *AMAI* 22(3–4):207–236, 1998, Table 3.1 (read in the HAL report). Universal and existential inference from inclusion-maximal consistent subsets are complete at the second level. The text layer of the PDF dropped the Π/Σ glyphs. https://hal.inrae.fr/hal-02842327

**Infinite (recursive) premise sets:**

- Horsten & Welch, "The undecidability of propositional adaptive logic", *Synthese* 158(1):41–60, 2007. Final consequence is undecidable in general and can be Σ⁰₃-complete. https://doi.org/10.1007/s11229-006-9049-5
- Verdée, "Adaptive logics using the minimal abnormality strategy are Π¹₁-complex", *Synthese* 167(1):93–104, 2009. For Minimal Abnormality, some recursive premise sets have Π¹₁-complete consequence sets, which corrects Horsten & Welch for that strategy (indexed abstract). https://doi.org/10.1007/s11229-007-9291-5 . Batens et al. 2009 restate it (read): "the complexity of final CLuNm derivability is Π¹₁".
- An index lists the title variant "Propositional adaptive logics using the minimal abnormality strategy are Π¹₁ complex", so the result concerns propositional logics with infinite premise sets.

## 4. Dung 1995 and ASPARTIX

Dung, *Artificial Intelligence* 77(2):321–357, 1995 (read). https://doi.org/10.1016/0004-3702(94)00041-x

- **§4.2, "Pollock's inductive defeasible logic as grounded argumentation".** "We will show that Pollock's inductive theory of defeasible reasoning is based on our notion of grounded extension" (Lemma 46, Thm 47). The paper relates Pollock to *grounded* semantics, not stable.
- **§4.3, logic programming.** Thm 49: M is a stable model of P iff there is a stable extension E of AF(P) that M corresponds to. Thm 50: the well-founded model corresponds to the grounded extension.
- **Converse direction.** Thm 62(1): "E is a stable extension of AF iff m(E) is a stable model of P_AF".

ASPARTIX:

- Canonical journal paper: Egly, Gaggl & Woltran, "Answer-set programming encodings for argumentation frameworks", *Argument & Computation* 1(2):147–177, 2010. https://doi.org/10.1080/19462166.2010.486479
- System paper: "ASPARTIX: Implementing argumentation frameworks using answer-set programming", ICLP 2008, LNCS 5366. https://doi.org/10.1007/978-3-540-89982-2_67
- Current version: Dvořák, Rapberger, Wallner & Woltran, "ASPARTIX-V19", FoIKS 2020. https://doi.org/10.1007/978-3-030-39951-1_5

## 5. Abduction

### (a) Adaptive logics of abduction

**Meheus & Batens, "A formal logic for abductive reasoning", *LJ IGPL* 14(2):221–236, 2006 (read).** https://doi.org/10.1093/jigpal/jzk015 ; PDF https://users.ugent.be/~dbatens/publ/A2006JD_cogsci.pdf

- The logic is LAr: lower limit logic CL, **Reliability** strategy.
- Abnormalities have the form (∀α)(A(α) ⊃ B(α)) ∧ (B(β) ∧ ¬A(β)), i.e. an explanandum occurred while a sufficient cause did not.
- The presupposition is that "if an effect did occur, then all its potential causes ... did also occur".
- What is minimised is the set of abnormalities. Hypotheses are "jointly compatible with the premises but also as weak as possible". When several explanantia compete, "the logic allows only for the abduction of their disjunction".
- The authors note that Minimal Abnormality "would deliver a few more consequences in peculiar ... cases".
- This minimality differs from abductive logic programming: it is not subset-minimal choice of hypotheses but adaptive minimisation of *failed* explanations, combined with weakest-disjunction output.

**Lycke, "A formal explication of the search for explanations: the adaptive logics approach to abductive reasoning", *LJ IGPL* 20(2):497–516, 2012** (abstract). https://doi.org/10.1093/jigpal/jzq053

- Affirming the consequent is a defeasible rule, retained while its negation is not derivable.
- The paper covers several abduction processes and explicitly aims at the proof theory of actual reasoning.

**Other adaptive logics of abduction:**

- Meheus, "A formal logic for the abduction of singular hypotheses", in *Explanation, Prediction, and Confirmation*, Springer 2011, 93–108. https://doi.org/10.1007/978-94-007-1180-8_6
- Gauderis & Van De Putte, "Abduction of generalizations", *Theoria* 27(3):345–363, 2012. Adaptive logic LAG (abstract). https://doi.org/10.1387/theoria.4059
- Gauderis, "Modelling abduction in science by means of a modal adaptive logic", *Found. Sci.* 18(4):611–624, 2013. https://doi.org/10.1007/s10699-012-9293-8
- Beirlaen & Aliseda, "A conditional logic for abduction", *Synthese* 191(15):3733–3758, 2014. An explanatory conditional (Chellas-style conditional logic) plus the adaptive framework for defeasibility (abstract via PhilPapers). https://doi.org/10.1007/s11229-014-0496-0
- Batens, "Abduction logics: illustrating pitfalls of defeasible methods", in *Applications of Formal Philosophy*, Springer 2017, 169–193. https://doi.org/10.1007/978-3-319-58507-9_8

### (b) Abduction in logic programming and ASP

Eiter, Gottlob & Leone, "Abduction from logic programs: semantics and complexity", *TCS* 189(1–2):129–177, 1997 (abstract read from author PS). https://doi.org/10.1016/s0304-3975(96)00179-x

- Problems: existence of an explanation, relevance (a hypothesis is in some explanation), necessity (it is in all explanations).
- Semantics: well-founded, stable (brave and cautious) and minimal-model, over normal and disjunctive programs.
- Results "populate the classes at the lower end of the polynomial hierarchy up to [level 4]". The glyph was lost in conversion, so the exact top class is unread. Subset-minimality and smallest-size preferences are among the explanation preferences analysed.

### (c) Maher-style constraint abduction vs adaptive logics, ASP, argumentation: **null result**

Primary works:

- Maher, "Herbrand constraint abduction", LICS 2005, 397–406. https://doi.org/10.1109/LICS.2005.21
- Maher, "Abduction of linear arithmetic constraints", ICLP 2005. https://doi.org/10.1007/11562931_15
- Maher, "Heyting domains for constraint abduction", AI 2006. https://doi.org/10.1007/11941439_5
- Maher & Huang, "On computing constraint abduction answers", LPAR 2008, LNCS 5330:421–435. Recognising a maximally general or fully maximal answer is co-NP-complete (abstract). https://doi.org/10.1007/978-3-540-89439-1_30

What I searched:

1. The full OpenAlex citing-works lists of the four Maher papers above (15, 8, 4 and 7 citers). They cover GADT type inference (Sulzmann, Schrijvers, Stuckey, Vytiniotis, Peyton Jones), program analysis (Bräuer et al.), constraint programming (Chu et al.) and Bistarelli et al. on trust negotiation with soft constraints. **None is on adaptive logic, ASP or argumentation.**
2. Web searches for "constraint abduction" with "adaptive logic(s)", "answer set", "abstract argumentation" and "assumption-based argumentation", and for "joint constraint abduction".
3. An OpenAlex search for "constraint abduction". It returns only ACLP/CIFF/SCIFF-style abductive constraint logic programming and CSP-abduction complexity (Schmidt & Wrona, CSL 2013). These are a different problem: abducing atoms with constraints inside a program, not Maher's abduction of a constraint answer over a constraint domain.

**Nothing connecting Maher-style or joint constraint abduction to adaptive logics, ASP or argumentation was found.**

Nearest neighbours, which are not connections:

- Constrained ABA (CABA), with arguments over constrained variables: De Angelis, Fioravanti, Meo, Pettorossi, Proietti & Toni, arXiv:2602.13135, 2026. It does not mention abduction. https://arxiv.org/abs/2602.13135
- Michael Maher himself also works on defeasible logic and argumentation, but no paper bridging that work with his constraint abduction was found.

"Joint constraint abduction" turns up only Stafiniak's thesis materials (Wrocław) and https://lukstafi.github.io/projects/jca/Herbrand_JCA.html .

## 6. ASP support for subset-minimality

- **Potassco guide v2.2.0 (Jan 2019), §10.3 "Computing subset minimal answer sets with heuristics" (read).** `--heuristic=Domain --dom-mod=5,16` or `#heuristic a(1..3). [1,false]` "guarantee that the first answer set produced is subset minimal with respect to the atoms of predicate a/1". Together with `--enum-mode=domRec` (spelled `--enum-mod` in the guide text) they enumerate all subset-minimal solutions, "projected on shown atoms". domRec uses solution recording, so it can need exponential space, but "in practice ... often turns out to be superior" to disjunctive encodings. https://github.com/potassco/guide/releases/download/v2.2.0/guide.pdf
- Gebser, Kaufmann, Romero, Otero, Schaub & Wanko, "Domain-specific heuristics in answer set programming", AAAI 2013, 350–356 (read). Modifiers like h(a,false,1) "allow for computing a (single) inclusion-minimal model". Enumerating all such models needs extra machinery, per Di Rosa, Giunchiglia & Maratea, *Constraints* 2010. https://doi.org/10.1609/aaai.v27i1.8585
- Brewka, Delgrande, Romero & Schaub, "asprin: Customizing answer set preferences without a headache", AAAI 2015, 1467–1474. This is the asprin framework, and its library includes the `subset` preference type (guide §11, `#preference(p1,subset){...}`). https://doi.org/10.1609/aaai.v29i1.9398

## 7. Adaptive logics after 2010

**Straßer, *Adaptive Logics for Defeasible Reasoning: Applications in Argumentation, Normative Reasoning and Default Reasoning*.** Trends in Logic 38, Springer. The eBook appeared 29 Nov 2013 with © 2014 (ISBNs 978-3-319-00791-5 and 978-3-319-00792-2). https://doi.org/10.1007/978-3-319-00792-2 . Chapters (from DOIs):

- ch. 2: the standard format
- ch. 3: sequential combinations
- ch. 5: generalising the standard format
- ch. 6: conditional logics of normality
- ch. 7: rational closure
- chs. 8–9: Dung argumentation, joint attacks
- chs. 10–12: deontic logic

**Standard format:** Batens 2007 (§2 above), with first steps in Batens 2001.

**Notable work 2014–2026:**

- Van De Putte & Straßer 2014, parametric approach (§2a).
- Straßer & Van De Putte, "Adaptive strategies and finite-conditional premise sets", *JLC* 26(5):1517–1539, 2016. Minimal Abnormality equals Reliability over conjunction-closed abnormalities exactly for "finite-conditional" premise sets. https://doi.org/10.1093/logcom/exu044
- Straßer & Van De Putte, "Proof theories for superpositions of adaptive logics", *Logique et Analyse* 230, 2015. https://doi.org/10.2143/lea.230.0.3141812
- Straßer, Beirlaen & Van De Putte, "Adaptive logic characterizations of input/output logic", *Studia Logica*, 2016. https://doi.org/10.1007/s11225-016-9656-1
- Heyninck & Straßer 2016 (§2c).
- Arieli & Straßer 2019 (TCS).
- Batens, "Devising the set of abnormalities for a given defeasible rule", *Logical Investigations* 26(1):9–35, 2020. https://doi.org/10.21146/2074-1472-2020-26-1-9-35
- Arieli, van Berkel & Straßer, "Annotated sequent calculi for paraconsistent reasoning and their relations to logical argumentation", IJCAI 2022. https://doi.org/10.24963/ijcai.2022/351
- Straßer & Molick, "Minimal-inconsistency tolerant logics: a quantitative approach", *Australasian J. Logic* 22(3):308–365, 2025. https://doi.org/10.26686/ajl.v22i3.6718
- Arieli & Straßer, "Representation considerations for logical argumentation frameworks", *Argument & Computation* 17(2):107–140, 2026. https://doi.org/10.1177/19462174261418979

The visible trend is that the Bochum group's work has moved into argumentation and sequent-based proof theory. In the indexed record, Ghent-style "adaptive logic" papers become sparse after about 2017.

---

## Unverified / not found

- **No ASP, logic-programming or SAT encoding of adaptive logics found.** The only solver route found is Arieli's QBF encoding (2007) of ACLuNs2/LPm-type preferential relations, plus circumscription-style axioms for related paraconsistent logics (Arieli 2003). No adaptive-logic software implementation was found; the Ghent proof procedures appear only on paper.
- **No published theorem relates adaptive logics to circumscription.** The correspondence below is my inference from Batens 2007 Def. 9, not a cited result: with LLL = CL and Ω a set of atoms ab_i, Minimal Abnormality coincides with circumscription of those atoms with all other atoms varying.
- **Π2P-completeness of Minimal Abnormality in general is not stated anywhere I found.** Membership is stated for ACLuNs2-type relations (Arieli 2007, Prop. 5.15). Hardness is stated for LPm (Coste-Marquis & Marquis 2004/05; not read). The classes in Odintsov & Speranski 2012/2013 were not visible.
- Eiter, Gottlob & Leone 1997: the exact class table was not read.
- Horsten & Welch's Σ⁰₃ result and Verdée's Π¹₁ result are from indexed abstracts and Batens et al. 2009, not from the full papers.
- Minimality notions in Beirlaen & Aliseda 2014, Gauderis 2013 and Lycke 2012 beyond their abstracts were not checked.
- s(CASP) (Arias & Carro, TPLP 2018) is constraint ASP without grounding. Whether it supports constraint-valued abduction, and whether it cites Maher, is unverified.
- **Pollock/OSCAR and ASP:** not searched beyond Dung §4.2.
- dblp could not be queried, so the coverage of OpenAlex and Crossref limits the null results. Stafiniak's own JCA thesis is not in OpenAlex.

## Correction (31 Oct, from the draft's fact-check)

Batens 2007 (*Logica Universalis*), fn. 10, mentions a program, pdp2.exe, that implements the goal-directed procedure for propositional ACLuNr. So the procedure has been implemented, against what question 1 above suggests. The fact-check report sits in the session scratchpad, and its corrections went into `notes/presumed-normal.md`.
