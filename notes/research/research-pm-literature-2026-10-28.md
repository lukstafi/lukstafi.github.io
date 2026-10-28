# Prediction-market lecture notes (ATG 2010): source verification and post-2010 literature

Research pass, 2026-10-28. Source under review: `~/Downloads/Dokumenty-ATG/ATG_rynki_pred.pdf` ("Rynki predykcyjne", 17 pp., Algorytmiczna Teoria Gier, V 2010) and the exercise sheet `ATG_rynki_pred_zad.pdf`. Section, theorem and lemma numbers below are the notes' own unless stated otherwise.

Method: the primary papers were downloaded and read where they are open (Lambert et al. 2008; Chen & Wortman Vaughan 2010; Agrawal et al. 2009 and the OR final version; Chen, Fortnow, Nikolova, Pennock 2007; Chen, Fortnow, Lambert, Pennock, Wortman 2008; Chen, Goel, Pennock 2008). Metadata were checked against Crossref. Items marked *(abstract only)* were checked only at the abstract or metadata level.

---

## Part A. Source map and correction list

### Source map at a glance

| Notes section | Primary source(s) | Notes' numbering → source numbering |
|---|---|---|
| §1 Intro, three market types | Generic; close to Pennock & Sami, "Computational aspects of prediction markets", AGT book ch. 26 (2007) | — |
| §2 Wagering properties, Thm 1 | Lambert, Langford, Wortman, Chen, Reeves, Shoham, Pennock, EC 2008 | Thm 1 = their **Thm 3** (characterization); their Thm 1 lists all 7 properties of WSWMs |
| §2 last paragraph (myopic IC, bluffing) | Chen, Reeves, Pennock, Hanson, Fortnow, Gonen, WINE 2007; Dimitrov & Sami, EC 2008; merged journal version Chen et al., Algorithmica 2010 | — |
| §3 MSR, LMSR, QSR | Hanson 2003 (ISF), Hanson 2007 (J. Prediction Markets) | — |
| §3 Cost-function markets | Chen & Pennock, UAI 2007 ("valid cost function" wording is Chen & Wortman Vaughan 2010) | — |
| §3 SCPM | Peters, So, Ye, WINE 2007; Peters PhD thesis 2009; Agrawal, Delage, Peters, Wang, Ye, EC 2009 | — |
| §4.1 Duality, KKT, sensitivity, zero-sum games | Boyd & Vandenberghe, *Convex Optimization* (2004), ch. 5 | — |
| §4.1 Eisenberg–Gale | Eisenberg & Gale 1959; Vazirani, AGT book ch. 5 | — |
| §4.1 "Model SCPM", Lemma 2 | Agrawal et al. EC 2009 | Lemma 2 = their Lemma 3.1 (items 1, 2, 4, 5; item 3 "consistency" omitted) |
| §4.2 Ellipsoid | Khachiyan 1979; Grötschel, Lovász, Schrijver 1988 | — |
| §5.1.1 Market from Weighted Majority | **Chen, Fortnow, Lambert, Pennock, Wortman, EC 2008, §6.2** (not Chen–Vaughan) | derivation copied incl. one of its typos |
| §5.1.2 Learner from market | Chen & Wortman Vaughan, EC 2010, §4 | Lemma 3 = their Lemma 2; Thm 4 = their Thm 2 |
| §5.2 MSR ⇔ CFBM, FTRL | Chen & Wortman Vaughan 2010, §5; Föllmer & Schied 2002; Gneiting & Raftery 2007 | Lemma 5 = Thm 1; Lemmas 6+7 = Lemma 4; Lemma 8 = Lemma 5; Def 9 = their equivalence notion; Thm 10 = Thm 3; Thm 11 = Thm 4 |
| §5.3 CFBM ⇔ SCPM | Agrawal et al. EC 2009 (and OR 2011) | Thm 13 = their Thm 3.3; Thm 14 = Thm 4.1; Thm 15 = Thm 4.2; Lemma 12 from their appendix |
| §6.1 Matching (subset / pair betting) | Chen, Fortnow, Nikolova, Pennock, EC 2007 | Thm 16 = Thm 1; Lemma 17 = Lemma 2; Thm 18 = Thm 4; Lemma 19 = Lemma 5; Thm 20 = Thm 6; Lemma 21 = Lemma 7; Lemmas 22, 23 = Lemmas 8, 9; Thm 24 = Thm 10; Lemma 25 = Lemma 11; Thm 26 = Thm 12; Lemmas 27, 28, 29 = Lemmas 13, 14, 15 |
| §6.2 #P-hardness of LMSR pricing | Chen, Fortnow, Lambert, Pennock, Wortman, EC 2008 | Thm 30 = Thm 1 (permanent); Thm 31 = Thm 3 (linear extensions) |
| §6.3 (empty) Regret vs best permutation | Helmbold & Warmuth, PermELearn (COLT 2007; JMLR 2009), as used in Chen et al. EC 2008 §6.3 | their Thm 9 |
| §6.3.1 (empty) Poly-time approximation of subset betting | **Chen et al. EC 2008 §6.4**: PermELearn plus Sinkhorn balancing. **Not** Jerrum–Sinclair–Vigoda | their Lemma 10, Thm 11, Cor 12 |
| §6.4 (empty) Tournaments | Chen, Goel, Pennock, STOC 2008 | — |
| Exercise 5 | Agrawal et al., *Operations Research* 59(3):550–568, 2011 | the exercise's "Theorem 1" = OR Thm 1 (VCG) |

### §1 Introduction

No technical claims to check. The three-way taxonomy (exchange or call market, pari-mutuel pool, market maker) is standard. Pennock & Sami (2007, AGT ch. 26) and Lambert et al. (2008, intro) give it in roughly this form. The company list and InklingMarkets case studies are 2010 period material; Inkling Markets later became Cultivate Labs.

The notes say "sprzedarzy" twice (should be "sprzedaży") and "tranzakcję" (should be "transakcję"). These are spelling slips only.

### §2 Desirable properties and Theorem 1 (wagering mechanisms)

**Source.** N. Lambert, J. Langford, J. Wortman, Y. Chen, D. Reeves, Y. Shoham, D. M. Pennock, "Self-financed wagering mechanisms for forecasting", *Proc. 9th ACM EC* 2008, pp. 170–179, doi:10.1145/1386790.1386820 (EC'08 Best Paper). PDF: https://www.jennwv.com/papers/wagering.pdf. The journal version is substantially rewritten: Lambert, Langford, Wortman Vaughan, Chen, Reeves, Shoham, Pennock, "An axiomatic characterization of wagering mechanisms", *J. Economic Theory* 156:389–416, 2015 (PDF https://www.jennwv.com/papers/axwagering.pdf). It reframes the mechanism as the "Brier betting mechanism" and characterizes it by anonymity, proportionality, sybilproofness and homogeneity, which is a different axiom set.

**What the paper proves.**
- **Theorem 1** (EC'08): every weighted-score wagering mechanism (WSWM) satisfies all seven properties: budget balance, anonymity, truthfulness, sybilproofness, normality, individual rationality and monotonicity.
- **Theorem 3** (EC'08): a wagering mechanism is *budget-balanced, anonymous, truthful, normal and sybilproof* iff Π_i = m_i + m_i (s^M(r_i, ω) − (1/M) Σ_j m_j s^M(r_j, ω)), where M = Σ_j m_j and s^M is a **smooth** strictly proper scoring rule **with values in [0,1]** that may **depend on the total wager M**. This is the "single-parameter generalization" in the abstract. The theorem rests on two standing assumptions: payouts are smooth (twice continuously differentiable), and payouts are nonnegative.

**Discrepancies.**
1. **Lead-in sentence overstates the iff.** The notes say the mechanism has "all these properties iff it pays a weighted average with respect to a strictly proper scoring rule". The proven iff uses **five** properties (BB, A, T, N, S), not seven. Its right-hand side is the M-parameterized family, not WSWMs with a fixed s. Individual rationality and monotonicity are extra properties that WSWMs also have (Thm 1). The notes' Theorem 1 itself is stated correctly and matches the paper's Theorem 3, including s^M and "smooth with values in [0,1]". Only the lead-in is wrong.
2. **"Weighted average" misdescribes the payout.** The payout is the player's own wager plus the wager times (own score minus the wager-weighted average score). It is a relative-score payout, not a weighted average.
3. **Individual rationality is misstated.** The notes say expected payout is "niezerowa" (nonzero). The paper requires expected **profit** E[Π_i − m_i] ≥ 0, i.e. **nonnegative**, for some report r_i*, whatever the others do. Correct to "oczekiwany zysk jest nieujemny".
4. **Monotonicity is misstated.** The notes say "expected payout is always strictly increasing in the wager". The paper's property is two-sided and about **profit**. If expected profit is positive, raising the wager strictly raises it. If it is negative, raising the wager makes it strictly more negative. Read literally, the notes' version (payout Π, which includes the returned stake) is a different and weaker property, and it fails as a statement about losing players' profit.
5. **Normality** (minor): the paper is about changes in **expected** payouts under any admissible P, each "null or of opposite sign". The notes omit "expected".
6. Truthfulness, anonymity, budget balance and sybilproofness match the paper.

**Myopic incentive compatibility and bluffing (last paragraph of §2).** The paragraph is correct in substance. Sources:
- Y. Chen, D. M. Reeves, D. M. Pennock, R. Hanson, L. Fortnow, R. Gonen, "Bluffing and strategic reticence in prediction markets", WINE 2007, LNCS 4858. For two traders with LMSR, truthful immediate revelation is an equilibrium when signals are conditionally independent given the outcome. When signals are unconditionally independent (conditionally dependent), a trader may prefer to delay or to mislead.
- S. Dimitrov, R. Sami, "Non-myopic strategies in prediction markets", *Proc. 9th ACM EC* 2008, pp. 200–209, doi:10.1145/1386790.1386823. Under generic conditions the myopically optimal strategy is not a sequential equilibrium under LMSR: traders can mislead others and correct later. They propose discounting later trades as a fix.
- Merged journal version: Y. Chen, S. Dimitrov, R. Sami, D. M. Reeves, D. M. Pennock, R. D. Hanson, L. Fortnow, R. Gonen, "Gaming prediction markets: equilibrium strategies with a market maker", *Algorithmica* 58(4):930–969, 2010, doi:10.1007/s00453-009-9323-2. PDF: https://projects.iq.harvard.edu/sites/projects.iq.harvard.edu/files/yiling/files/algorithmica10.pdf.

### §3 Dynamic markets (MSR, CFBM, SCPM)

Sources:
- R. Hanson, "Combinatorial information market design", *Information Systems Frontiers* 5(1):107–119, 2003, doi:10.1023/A:1022058209073.
- R. Hanson, "Logarithmic market scoring rules for modular combinatorial information aggregation", *J. Prediction Markets* 1(1):3–15, 2007, doi:10.5750/jpm.v1i1.417.
- Y. Chen, D. M. Pennock, "A utility framework for bounded-loss market makers", UAI 2007, pp. 49–56. This is the cost-function formulation.
- M. Peters, A. M.-C. So, Y. Ye, "Pari-mutuel markets: mechanisms and performance", WINE 2007, LNCS 4858, pp. 82–95, doi:10.1007/978-3-540-77105-0_11. This introduces the SCPM with the log utility u(s) = Σ θ_i log s_i ("Log-SCPM").
- M. Peters, "Convex mechanisms for pari-mutuel markets", PhD thesis, Stanford 2009.

The definitions check out: proper and strictly proper; LMSR s_i = b log p_i; QSR s_i = b(2p_i − Σ p_j²); valid cost function (p_i ≥ 0, Σ p_i = 1); LMSR cost C = b log Σ e^{q_i/b}; SCPM program and dual prices. One nit: "(ściśle – strictly – jeśli równość wtw. gdy p̄ = p̄′)" is correct.

### §4 Optimization background

- **§4.1 duality, Slater, KKT, sensitivity, shadow prices, the matrix-game example.** This follows S. Boyd, L. Vandenberghe, *Convex Optimization*, CUP 2004, ch. 5 (mixed strategies for matrix games §5.2.5; strong duality via separating hyperplane §5.3.2; price interpretation §5.4.4; KKT §5.5.3; perturbation and sensitivity §5.6). Free PDF: https://web.stanford.edu/~boyd/cvxbook/. The content is correct.
- **Eisenberg–Gale.** E. Eisenberg, D. Gale, "Consensus of subjective probabilities: the pari-mutuel method", *Ann. Math. Statist.* 30(1):165–168, 1959, doi:10.1214/aoms/1177706369. The four optimality conditions are the standard ones (cf. V. Vazirani, "Combinatorial algorithms for market equilibria", AGT book ch. 5, 2007). **Point the essay could use:** the EG program was introduced *for pari-mutuel betting*, as a way to compute consensus probabilities from bettors' budgets and subjective beliefs, and only later became "the Fisher-market program". The notes present it only as a Fisher market. Its original setting is the prediction-market one. Freeman & Pennock (IJCAI 2018) revisit it as a wagering mechanism ("parimutuel consensus mechanism"); see Part B.
- **Index typo in the reduction to standard form.** The constraints Σ_i x_ij − 1 ≤ 0 number **n** (one per good, k = 1..n). The nonnegativity constraints should therefore run k = n+1, …, n + n·n′, with m = n + n·n′. The notes write k = n′+1, …, n′+n n′ and m = n′ + n n′. The exercise's assignment λ_k (k = 1..n) = p̄ is consistent with the corrected indexing.
- **§4.1 "Model SCPM", Lemma 2.** This is Agrawal et al. EC 2009, Lemma 3.1. Their list has five items; the notes omit item 3, "the price is consistent: the market organizer accepts another infinitesimal order iff π exceeds the instantaneous price". The KKT derivation and the monotonicity proof are fine.
- **§4.2 ellipsoid.** L. G. Khachiyan, "A polynomial algorithm in linear programming", *Soviet Math. Dokl.* 20:191–194, 1979. M. Grötschel, L. Lovász, A. Schrijver, *Geometric Algorithms and Combinatorial Optimization*, Springer 1988 (equivalence of separation and optimization; the "S(a0,r) ⊆ K ⊆ S(a0,R)" well-boundedness assumption is theirs). Survey: Bland, Goldfarb, Todd, "The ellipsoid method: a survey", *Oper. Res.* 29(6):1039–1091, 1981. Boyd & Vandenberghe's book covers the ellipsoid method only lightly (more in their EE364b notes), so GLS is the apt citation. Chen et al. (2007) cite GLS for Theorem 16.

### §5.1 Bounded-loss market maker ⇔ no-regret learning

**§5.1.1 is from Chen et al. 2008, not from Chen & Wortman Vaughan.** Y. Chen, L. Fortnow, N. Lambert, D. M. Pennock, J. Wortman, "Complexity of combinatorial market makers", *Proc. 9th ACM EC* 2008, pp. 190–199, doi:10.1145/1386790.1386822; PDF https://www.jennwv.com/papers/lmsrcomplexity.pdf. Section 6.2 ("Relationship to LMSR markets") contains exactly this derivation. Chen & Wortman Vaughan (2010) credit it to them: "Chen et al. [6] were the first to formally demonstrate a connection…".

Discrepancies in §5.1.1:
1. **Weighted Majority bound: ln(η) must be ln(n).** The notes write ln(η)/η three times (theorem statement and two derivation lines). The source (Chen et al. 2008, Thm 8) has L_A − min_i L_i ≤ ηT + ln(n)/η. The final line of the notes, "… ≤ 4ε²Tb + b ln(n)", already uses ln n, so the error is a transcription slip. (For losses in [0,1], the sharper Hedge bound is ln n/η + ηT/8; the looser ηT + ln n/η is still valid.)
2. **4ε²Tb should be 4ε²T/b.** Multiplying the regret inequality by ηb gives max_i Σ_t q_i,t − Σ_t Σ_i p_i,t q_i,t ≤ η²bT + b ln n. With η = 2ε/b, the first term is 4ε²T/b. The slip is **in the source paper** (Chen et al. 2008 print "η²Tb" correctly and then "4ε²Tb"); the notes copied it. The conclusion is unaffected: with T = O(1/ε) the term is O(ε/b) → 0, and the worst-case loss tends to b ln n, which is the known LMSR bound.
3. **Loss vs exponent mismatch (harmless).** The notes define l_i,t = (ε − q_i,t)/(ηb), but the exponent in the price identity is 2εt/b − ηL_i,t. The source uses l = (2ε − q)/(ηb), which gives 2εt/b. With the notes' loss the exponent would be εt/b. The term is common to all i, so it cancels from the ratio. For consistency, either use (ε − q) with εt/b, or follow the source. Note that (ε − q) ∈ [0, 2ε] is what makes "valid for η ≥ 2ε/b" exactly right; with the source's (2ε − q) ∈ [ε, 3ε] the condition should be η ≥ 3ε/b. So the notes' loss is the better-calibrated choice; only the exponent needs fixing.
4. Rigor nit, common to the source: Σ p_i,t q_i,t uses the **end-of-step** price as the market maker's revenue. The true revenue is C(Q_t) − C(Q_{t−1}), which lies between p_{t−1}·q_t and p_t·q_t. The discrepancy is O(ε²/b) per step and vanishes in the limit. On the learning side, the weights p_i,t = w_i,t include the current loss (a "be-the-leader" weight). Exponential tilting only lowers the expected loss, so the regret bound still holds.

**§5.1.2.** Y. Chen, J. Wortman Vaughan, "A new understanding of prediction markets via no-regret learning", *Proc. 11th ACM EC* 2010, pp. 189–198, doi:10.1145/1807342.1807372; arXiv:1003.0034, https://arxiv.org/abs/1003.0034.
- φ-stability definition, **Lemma 3** (= their Lemma 2, |C(q+r) − C(q) − Σ p_i(q) r_i| ≤ ε²φ/2 for |r_i| ≤ ε): correct.
- **Theorem 4** (= their Theorem 2): the statement in the notes is **correct**, with ε = √(2B/(φT)) and regret ≤ √(2BφT). The PDF renders it correctly; the pdftotext layout only *looks* like "2B√(φT)". The bound is not 2√(BφT).
- **Discrepancy in the proof's last line.** It reads "Wystarczy wziąć ε √(B/(φT))", which is missing "=" and the factor 2. From B/ε + εφT/2, the choice ε = √(2B/(φT)) gives exactly √(2BφT), as the theorem says. The choice ε = √(B/(φT)) gives (3/2)√(BφT) ≈ 1.06·√(2BφT), which does **not** yield the stated bound. Correct to "ε = √(2B/(φT))".
- Sanity check from the paper: LMSR has B = b log N and φ = 2/b, which gives regret ≤ √(2·b log N·(2/b)·T) = 2√(T log N). This is the standard WM bound at η = √(log N / T).

### §5.2 MSR ⇔ CFBM, and FTRL (Chen & Wortman Vaughan 2010, §5)

- **Lemma 5** = their Theorem 1 (valid iff differentiable, increasing-monotone, translation-invariant). Correct. Note that "valid" does **not** include convexity.
- **Lemma 6 is missing "convex".** Their Lemma 4 reads: "A function C is a **valid convex** cost function iff it is differentiable and can be represented as C(q) = sup_{p∈Δ} (Σ p_i q_i − α(p)) for a convex lsc α." A sup of affine functions is always convex, so a non-convex valid cost function (Lemma 5 allows one) has no such representation, and the "iff" fails as written. Föllmer–Schied's representation theorem applies to **convex** risk measures (monotone, cash-invariant, convex). "Applying it to Lemma 5" is therefore incomplete without the convexity hypothesis. Fix: "C jest poprawną **wypukłą** funkcją kosztu wtw. …". Theorem 11 in the notes already says "poprawną wypukłą".
  Source: H. Föllmer, A. Schied, "Convex measures of risk and trading constraints", *Finance and Stochastics* 6(4):429–447, 2002, doi:10.1007/s007800200072. Textbook: Föllmer & Schied, *Stochastic Finance*, de Gruyter, 2002 and later editions, §4.2. Agrawal et al. (2009) first noted the link between cost functions and convex risk measures.
- **Lemma 7** = second half of their Lemma 4 (prices are the maximizing p). Correct. The proof's "f is concave" means concave in p.
- **Lemma 8** = their Lemma 5 (worst-case loss ≤ sup_{p,p′} α(p) − α(p′)). Correct.
- **Theorem 10** = their Theorem 3. The notes omit one hypothesis: the scoring rules must be **differentiable** ("strictly proper, regular market scoring rules with differentiable scoring functions"). Otherwise it matches, including the explicit formulas α_C(p) = Σ p_i s_i(p) and s_i(p) = α_C(p) − Σ_j p_j ∂_jα_C + ∂_iα_C. That is the Gneiting–Raftery representation with G = α_C, the expected-score function. Source for the representation and the "strictly proper ⇒ strictly convex expected score" fact: T. Gneiting, A. E. Raftery, "Strictly proper scoring rules, prediction, and estimation", *JASA* 102(477):359–378, 2007, doi:10.1198/016214506000001437, Theorem 1. Older roots: Savage 1971; McCarthy 1956.
- **Theorem 11** = their Theorem 4. Correct: ε = η = √(2 sup(α − α′)/(φT)), regret ≤ √(2Tφ sup(α − α′)). The paper also shows explicitly that the market-derived learner *is* FTRL with regularizer α_C and learning rate ε. The notes leave that identification implicit ("such that α_C = R").
- The paper's §6 example (QMSR = Quad-SCPM = online gradient descent; φ = N²/(2b)) is not in the notes. It would be a good concrete second instance for the essay: LMSR ↔ Hedge (entropic regularizer), QMSR ↔ OGD (Euclidean regularizer).

### §5.3 CFBM ⇔ SCPM

**Source.** S. Agrawal, E. Delage, M. Peters, Z. Wang, Y. Ye, "A unified framework for dynamic pari-mutuel information market design", *Proc. 10th ACM EC* 2009, pp. 255–264, doi:10.1145/1566374.1566412; arXiv:0902.2429, https://arxiv.org/abs/0902.2429.
- Thm 13 = their Thm 3.3. C(q) = min_t t − u(t e − q), with eᵀ∇C(q) = 1 for q ≥ 0. Correct.
- Thm 14 = their Thm 4.1 (u(s) = −C(−s)). Correct.
- Thm 15 = their Thm 4.2 (∇u spans the simplex ⇒ implicit proper scoring rule). Correct.
- Lemma 12 (duals of (15) and (16) coincide) is their appendix argument.
- **"The original SCPM is not truthful."** Correct. Agrawal et al. cite Peters, So, Ye 2007 and Peters 2009 for it. The original SCPM charges the *final* dual price, p̄(x*)ᵀā per share, times the accepted quantity x*. That price depends on the trader's own bid, so traders gain by shading or splitting orders. The fix charges ∫₀^{x*} p̄(ε)ᵀā dε (their eq. 5 and Thm 3.2, "myopically truthful irrespective of u").
- Small wording slip: the notes say "instead of p̄(l)". The original charge is p̄(x*)ᵀā·x*. This equals p̄(l)ᵀā·x* when the quantity limit is slack (x* < l), but the multiplication by x* is missing.
- **"Two ways to derive the corrected version, one left as an exercise."** The two derivations are the incremental integral pricing (EC 2009) and **VCG pricing** (OR 2011). The OR paper proves they coincide: C(q + a x) − C(q) = χ(0) − χ(x).

**Exercise 5: published version found.** S. Agrawal, E. Delage, M. Peters, Z. Wang, Y. Ye, "A unified framework for dynamic prediction market design", *Operations Research* 59(3):550–568, 2011, doi:10.1287/opre.1110.0922. The URL in the exercise still resolves at https://web.stanford.edu/~yyye/scpm-or-final.pdf (the old `www.stanford.edu` host now returns 403). That PDF contains **Theorem 1**: "Irrespective of the choice of value function v(·), the SCPM mechanism admits myopically truthful bidding under VCG pricing scheme". The proof writes the allocation as an affine maximizer x* = argmax_{0≤x≤l} πx + χ(x), with χ(x) = max_{z,s} −z + v(s) subject to a x + s + q = z e, and charges χ(0) − χ(x*). This matches the exercise exactly. The published version renames the "utility function u" to the "value function v". Its **Lemma 1** gives the convex, arbitrage-free cost C(q) = min_t t − v(t e − q). It also extends VCG pricing to batches of simultaneous orders (Example 1).

### §6 Combinatorial markets

**§6.1 matching.** Y. Chen, L. Fortnow, E. Nikolova, D. M. Pennock, "Betting on permutations", *Proc. 8th ACM EC* 2007, pp. 326–335, doi:10.1145/1250910.1250957; PDF https://users.ece.utexas.edu/~nikolova/papers/ec2007-permutation-betting.pdf. The notes track the paper closely; the numbering map is in the table above.
- Thm 16 (divisible subset betting optimal matching is polynomial, via ellipsoid with a max-weight bipartite matching separation oracle): correct. The paper explicitly leaves **indivisible subset-betting matching open**. The notes' §6.1.1 title does not overclaim.
- Thms 18, 20, 24, 26 (pair betting: computing the optimal worst-case profit, and finding the optimal match, are NP-hard for both indivisible and divisible orders, by reduction from minimum feedback arc set): correct.
- **Lemma 17 says "weighted" but should be "unweighted".** With unit weights x_e = 1, k(H) is the solution to the **unweighted** minimum feedback arc set problem. The paper's Lemma 2 says "unweighted", and the notes' own Lemma 19 distinguishes l(H) (weighted) from k(H) (unweighted).
- Lemmas 27–28 (sufficient cycle condition Σ_{e∈C} b_e ≥ |C| − 1; best cycle via shortest cycle with weights 1 − b_e): correct. "e<C" in the extracted text is a rendering of "e∈C". The paper stresses the condition is sufficient but **not necessary**: interleaving cycles that are each unprofitable can be jointly profitable. The notes mention this in prose.
- **Lemma 29 reads as a guarantee but is a negative result.** The paper's Lemma 15 is worded "the greedy algorithm gives at most an O(√n)-approximation", and the notes copy the wording. The proof is a *lower-bound* example: a cycle of √n edges, each edge on another cycle of length √n + 1, so greedy finds 2 cycles where √n exist, a ratio of √n/2. So greedy is *no better than* Ω(√n). That the greedy shortest-cycle algorithm also *achieves* O(√n) for edge-disjoint cycle packing in directed graphs is a separate result the paper cites: M. Krivelevich, Z. Nutov, M. R. Salavatipour, J. Yuster, R. Yuster, "Approximation algorithms and hardness results for cycle packing problems", *ACM Trans. Algorithms* 3(4), 2007. Rephrase as "greedy cannot do better than an Ω(√n) factor (and O(√n) is known to be achievable)". The notes' preceding sentence ("łatwo skonstruować przykład…") already frames it as negative, so the error is only in the lemma's wording.

**§6.2 #P-hardness of LMSR pricing.** Chen, Fortnow, Lambert, Pennock, Wortman, EC 2008 (above). Thm 30 = their Thm 1 (subset betting, by reduction from the permanent of a 0/1 matrix). Thm 31 = their Thm 3 (pair betting, by reduction from counting linear extensions; Brightwell & Winkler 1991). Their Corollaries 2 and 4 add that transaction payments are #P-hard too. Their Thm 5 and Cors 6–7 cover **Boolean betting** (disjunctions or conjunctions of two events), which the notes omit. The compound-security LMSR price derivation is correct. In its last line, q_ω silently means the total payout to outcome ω, Σ_{S∋ω} q_S; it should be defined.
- **Thesis-relevant contrast** (stated in the paper's intro): for subset betting, *matching* divisible orders without a market maker is polynomial (Thm 16), but *pricing* the same bets with an LMSR market maker is #P-hard (Thm 30). Introducing a risk-taking market maker is what moves the computational wall.

**§6.3 (empty) "Learning that minimizes regret against the best permutation".** This is Chen et al. EC 2008 **§6.3 "Considering permutations"**. It presents D. P. Helmbold, M. K. Warmuth, "Learning permutations with exponential weights", *JMLR* 10:1705–1736, 2009 (COLT 2007 version). PermELearn keeps an n×n doubly stochastic weight matrix, updates it multiplicatively (entry-wise e^{−η loss}), and restores double stochasticity by **Sinkhorn balancing** (Sinkhorn 1964). Their bound (Thm 9 in Chen et al.): L_A ≤ (n ln n + η min_σ L_σ)/(1 − e^{−η}).

**§6.3.1 (empty) "Polynomial-time approximation of subset-betting prices".** This is Chen et al. EC 2008 **§6.4 "Approximating subset betting"**. Start from P¹ = (1/n); after each trade multiply entries by e^{q_ij/b} and Sinkhorn-balance. Lemma 10 shows the price matrices equal PermELearn's weight matrices for suitable losses. Thm 11 and Cor 12 show the market maker's worst-case loss is ≤ **b·n·ln n** in the limit ε → 0. That compares with b ln(n!) for exact (intractable) LMSR over permutations, and with b·n·ln n for n independent per-position LMSRs, which can show inconsistent prices. The approximation keeps prices consistent (doubly stochastic) at all times.
- **The approximation is not Jerrum–Sinclair–Vigoda.** Chen et al. 2008 do not use the permanent FPRAS. (Their only permanent-approximation reference is Linial–Samorodnitsky–Wigderson 2000 on matrix scaling, *Combinatorica* 20(4):545–568, in connection with Sinkhorn.) The PermELearn market maker is a *different* market maker with bounded loss. It does not approximate *LMSR's* prices. A JSV-based approach would be possible in principle: LMSR subset-betting prices are ratios of permanents of nonnegative matrices (e^{q_ij/b}), and M. Jerrum, A. Sinclair, E. Vigoda, "A polynomial-time approximation algorithm for the permanent of a matrix with nonnegative entries", *J. ACM* 51(4):671–697, 2004, gives an FPRAS. That is an observation, not what the 2008 paper did, and JSV's polynomial is impractically high-degree. If the companion page fills §6.3.1, it should describe the PermELearn/Sinkhorn construction and present JSV, if at all, as an aside.
- Chen & Wortman Vaughan (2010) cite this PermELearn construction as their motivating example ("by exploiting the connection between Weighted Majority and the LMSR, Chen et al. [6] showed that an extension of the Weighted Majority algorithm to permutation learning [20] could be used to approximate prices…"). It is the clearest instance of "market maker = learner" paying off computationally.

**§6.4 (empty) "Polynomial-time pricing for tournaments".** Y. Chen, S. Goel, D. M. Pennock, "Pricing combinatorial markets for tournaments", *Proc. 40th ACM STOC* 2008, pp. 305–314, doi:10.1145/1374376.1374421; PDF https://www.5harad.com/papers/tournaments.pdf. Result: in an n-team single-elimination tournament (2^{n−1} outcomes), **general LMSR pricing is #P-hard**. For the restricted language "team i wins game k", "team i wins game k given that they reach it" and "team i beats team j given that they face off", LMSR prices can be maintained in polynomial time. The market distribution is represented as a **Bayesian network on the tournament's binary tree with edges oriented from later rounds to earlier ones** ("opposite to causality"), and **O(n³) operations per trade** suffice (their Thm 3.3). Surprise: "team i wins game k" bets alone can introduce dependence between first-round games. Restricting to "i beats j given they meet" restores the usual independence structure. The authors call this the first betting language for a combinatorial market maker that is both useful and tractable. Follow-up: L. Xia, D. M. Pennock, "An efficient Monte-Carlo algorithm for pricing combinatorial prediction markets for tournaments", IJCAI 2011. Also D. M. Pennock, L. Xia, "Price updating in combinatorial prediction markets with Bayesian networks", UAI 2011.

### Exercise sheet

- Ex. 1: the EG conditions match Vazirani's. Fix the k-range typo as in §4.1.
- Ex. 2: correct (implicit vs explicit MSR formula, Chen–Vaughan eqs. 7–8).
- Ex. 3: well-posed (original SCPM charges the bid-dependent final price).
- Ex. 4: FTRL ⇔ SCPM directly. Fine; it follows by composing Thm 14 with Chen–Vaughan Thm 4.
- Ex. 5: see §5.3. Published as *Oper. Res.* 59(3):550–568 (2011). The cited PDF is still online at web.stanford.edu.
- Ex. 6 is empty.

---

## Part B. What the literature did after 2010

Organized by the essay's three theses: (1) the market maker is a learner; (2) one mechanism with three faces related by convex conjugacy; (3) a computational wall for combinatorial outcome spaces. Strategic, wagering, decision-market and LLM-era work follows.

### B1. Thesis 1: market maker = learner, consolidated and generalized

**Abernethy, Chen, Wortman Vaughan, "Efficient market making via convex optimization, and a connection to online learning", *ACM TEAC* 1(2):12, 2013, doi:10.1145/2465769.2465777.** EC 2011 version: "An optimization-based framework for automated market-making", arXiv:1011.1941. This is the definitive version of the 2010 notes' §5. Start from an arbitrary set of securities with bounded payoff vectors ρ(ω), not one Arrow–Debreu security per outcome. Five axioms (path independence, existence of instantaneous prices, information incorporation, no arbitrage, expressiveness) force a **duality-based cost function** C(q) = sup_{x∈Π} x·q − R(x). Here Π is the convex hull of the payoff vectors (for Arrow–Debreu securities, the simplex) and R is a strictly convex conjugate. Prices are ∇C = argmax over the hull. Trading is **FTRL over Π**. Worst-case loss is bounded by sup R − inf R over Π. The price space is now a marginal polytope, for example the Birkhoff polytope for subset betting or the linear-ordering polytope for pair betting. This puts the computational wall into geometric form: pricing is tractable when you can optimize over Π. The paper builds a market for a point on a sphere. It **relaxes no-arbitrage** (prices range over an outer polytope) to get an efficient **pair-betting** market maker with bounded loss, sidestepping the #P-hardness of §6.2 at the price of bounded arbitrage. The same relaxation enables transaction fees and liquidity that grows with volume. Everything in the notes' §5.2 (Lemmas 6–8, Thm 11) is the special case Π = Δ_N.

**Frongillo, Della Penna, Reid, "Interpreting prediction markets: a stochastic approach", NIPS 2012, pp. 3266–3274.** https://papers.nips.cc/paper/2012/hash/41a60377ba920919939d83326ebee5a1-Abstract.html. When traders arrive at random from a fixed population (with risk-averse utilities), a duality-based market maker's price process is **stochastic mirror descent** on an objective determined by the traders' beliefs. The stationary point of the price process is the classical **Walrasian equilibrium** (a qualifier in the preprint is dropped in the proceedings version). This moves "market = learner" from worst-case regret to stochastic optimization, and gives prices an interpretation as an aggregate of beliefs.

**Frongillo, Reid, "Convergence analysis of prediction markets via randomized subspace descent", NIPS 2015.** *(abstract only)* Trades on subsets of securities are randomized block-coordinate descent, which yields convergence rates for price dynamics.

**Abernethy, Kutty, Lahaie, Sami, "Information aggregation in exponential family markets", *Proc. 15th ACM EC* 2014, pp. 395–412, doi:10.1145/2600057.2602896; arXiv:1402.5458.** https://arxiv.org/abs/1402.5458 *(abstract only)*. Design market makers from **exponential-family** distributions: the cost function is the log-partition function, and prices are mean parameters (sufficient-statistic expectations). With risk-averse traders with exponential utility, the equilibrium price corresponds to a natural belief-aggregation rule among learning agents (a weighted pooling in natural-parameter space). Budget-constrained variants are analyzed too. This explicitly identifies the market maker's cost function with the log-partition function of a statistical model, and LMSR is the categorical case.

**Hu, Storkey, "Multi-period trading prediction markets with connections to machine learning", ICML 2014, PMLR 32:1773–1781; arXiv:1403.0648.** Agents are modeled through risk measures, with a market maker. Self-interested multi-period trading converges to a **global objective**, and the trading dynamics are an optimization algorithm for it. The authors propose both analyzing markets with ML tools and solving ML problems by running markets.

**Storkey, "Machine learning markets", AISTATS 2011, PMLR 15:716–724.** Markets of utility-maximizing agents with different utility functions implement different model-combination rules: log utility gives mixtures, other isoelastic utilities give products of experts. Follow-up: Storkey, Millin, Geras, "Isoelastic agents and wealth updates in machine learning markets", ICML 2012. Related: A. Barbu, N. Lay, "An introduction to artificial prediction markets for classification", *JMLR* 13:2177–2204, 2012 (markets of classifiers as an ensemble method).

**Abernethy, Frongillo, "A collaborative mechanism for crowdsourcing prediction problems", NIPS 2011.** *(abstract only)* A market over a *hypothesis space*: participants are paid for improving a shared ML model, by analogy with an MSR on a loss function. Follow-up: Waggoner, Frongillo, Abernethy, "A market framework for eliciting private data", NIPS 2015.

**Freeman, Pennock, Podimata, Wortman Vaughan, "No-regret and incentive-compatible online learning", ICML 2020, PMLR 119:3270–3279.** This reverses the direction. Wagering mechanisms (the notes' §2) are used to build an **experts algorithm whose experts are strategic**. Weighted-Score Update (WSU) is incentive-compatible and achieves O(√(T ln K)) regret. It ties the notes' §2 to its §5.

**Nueve, Waggoner, "Smooth quadratic prediction markets", NeurIPS 2025; arXiv:2505.02959.** This takes "market = FTRL" as given (citing Abernethy et al. 2013) and asks *which other learning algorithms* could inspire market designs. A modified duality-based market drives traders to collectively run **steepest gradient descent**. It has better worst-case loss for Arrow–Debreu securities than the corresponding DCFMM while keeping no-arbitrage and incentive axioms, and it separates the price-update rule from the fee structure. This is the most recent explicit use of thesis 1 as a *design* principle.

**Liquidity-sensitive LMSR.** A. Othman, D. M. Pennock, D. M. Reeves, T. Sandholm, "A practical liquidity-sensitive automated market maker", *Proc. 11th ACM EC* 2010, pp. 377–386; journal *ACM TEAC* 1(3):14, 2013, doi:10.1145/2509413.2509414. LS-LMSR sets b(q) = α Σ_i q_i, so liquidity grows with volume. Prices then **sum to more than 1** (a vig or overround), and the loss remains bounded and can be made arbitrarily small. The paper shows that **path independence, translation invariance and liquidity sensitivity cannot all hold**. LS-LMSR keeps path independence and liquidity sensitivity and gives up translation invariance. It is therefore *not* a "valid cost function" in the notes' Lemma 5 sense, and it is an instructive boundary of the notes' framework. Follow-up: Abernethy, Frongillo, Li, Wortman Vaughan, "A general volume-parameterized market making framework", EC 2014.

**Continuous outcomes.** X. A. Gao, Y. Chen, "Betting on the real line", WINE 2010, show LMSR cannot have bounded loss on continuous outcome spaces. Y. Chen, M. Ruberry, J. Wortman Vaughan, "Cost function market makers for measurable spaces", *Proc. 14th ACM EC* 2013, pp. 785–802, characterize when bounded-loss cost-function markets exist on measurable spaces. These limits matter for any "market maker = learner" story beyond finite outcomes.

### B2. Thesis 2: one mechanism, several faces via conjugacy (and a fourth face, CFMMs)

- **Dual faces.** In Abernethy–Chen–Vaughan 2013, the cost function C and the regularizer R are convex conjugates, prices are ∇C, and the scoring rule is the Bregman divergence of R. This makes the MSR / cost-function / FTRL correspondence one statement. Gneiting & Raftery's representation (expected score = convex G; score = supporting hyperplane of G) is the scoring-rule side of the same conjugacy.
- **Elicitation theory.** R. Frongillo, I. Kash, "General truthfulness characterizations via convex analysis", WINE 2014 (LNCS 8877, pp. 354–370), and *Games and Economic Behavior* 130:636–662, 2021, doi:10.1016/j.geb.2021.09.010. One convex-analytic theorem characterizes truthful mechanisms across scoring rules, menu auctions, cost-function markets and more: truthful payoff = subgradient of a convex "consumer surplus" function. In effect it shows the notes' thesis 2 extends to essentially all of mechanism design with linear utilities. See also Frongillo & Kash, "Vector-valued property elicitation", COLT 2015, and "On elicitation complexity", NIPS 2015. Abernethy & Frongillo, "A characterization of scoring rules for linear properties", COLT 2012.
- **Fourth face: constant-function market makers (DeFi).**
  - G. Angeris, T. Chitra, "Improved price oracles: constant function market makers", *Proc. 2nd ACM AFT* 2020, pp. 80–91, doi:10.1145/3419614.3423251. CFMMs (Uniswap's x·y = k, Balancer, Curve) are defined by a trading function that keeps reserves on a level set. The paper shows they are good price oracles because arbitrage keeps them aligned with external prices, and it phrases the arbitrage problem as convex optimization. Related: Angeris, Kao, Chiang, Noyes, Chitra, "An analysis of Uniswap markets", *Cryptoeconomic Systems* 2021; Angeris, Evans, Chitra, Boyd, "Optimal routing for constant function market makers", EC 2022.
  - R. Frongillo, M. Papireddygari, B. Waggoner, "An axiomatic characterization of CFMMs and equivalence to prediction markets", ITCS 2024, LIPIcs 287:51, doi:10.4230/LIPIcs.ITCS.2024.51; arXiv:2302.00196. Market-making axioms characterize CFMMs with concave potential functions. **Every such CFMM on n assets is equivalent to a cost-function prediction market for an n-outcome event, with a conversion in both directions.** Every CFMM implicitly defines a proper scoring rule ("Uniswap's scoring rule is unusual but known"). Liquidity-provision strategies transfer between the two literatures. Slogan: markets are good at facilitating trade iff they are good at eliciting beliefs. **This is the strongest post-2010 confirmation of the notes' thesis 2.** Uniswap becomes a fourth face of the same convex object.
  - J. C. Schlegel, M. Kwaśnicki, A. Mamageishvili, "Axioms for constant function market makers", EC 2023, p. 1079 (abstract); full version *Mathematical Finance* 2026, doi:10.1111/mafi.70041. *(abstract only)* An independent axiomatization of CFMMs.
  - P. S. Hossain, X. Wang, F.-Y. Yu, SODA 2025 (see B3), add a "combinatorial swap" problem for DeFi AMMs that reduces to range updates. The combinatorial and DeFi lines are converging.
  - Applied note: Manifold Markets moved to a Uniswap-style CPMM, and Gnosis/Omen used LMSR and later a fixed-product market maker. The big real-money venues (Polymarket, Kalshi) run order books. This is industry practice from general knowledge, not a cited claim; verify before stating.

### B3. Thesis 3: the computational wall for combinatorial outcome spaces

The post-2010 story: the wall stands in the worst case, but it is engineered around in three ways. Tractable languages exploit structure. Relaxations accept bounded arbitrage. Integer programming oracles handle typical cases.

- **Dudík, Lahaie, Pennock, "A tractable combinatorial market maker using constraint generation", *Proc. 13th ACM EC* 2012, pp. 459–476, doi:10.1145/2229012.2229047.** PDF http://slahaie.net/pubs/DudikLaPe12.pdf. Price each security with an LMSR-like rule, as if independent, but detect logical arbitrage among related securities by **constraint generation**. An optimization or IP oracle finds a violated linear constraint of the marginal polytope, which is added and projected onto. The result is tractable like independent markets but propagates information like a combinatorial one. The paper uses this to price the relaxation of Abernethy et al.
- **Dudík, Lahaie, Pennock, Rothschild, "A combinatorial prediction market for the U.S. elections", *Proc. 14th ACM EC* 2013, pp. 341–358, doi:10.1145/2492002.2482601.** A live deployment (PredictWiseQ, 2012 US elections) using the 2012 engine, with millions of possible combinatorial predictions.
- **Kroer, Dudík, Lahaie, Balakrishnan, "Arbitrage-free combinatorial market making via integer programming", *Proc. 17th ACM EC* 2016, pp. 161–178, doi:10.1145/2940716.2940767; arXiv:1606.02825.** Pricing is a **Bregman projection** onto the marginal polytope, computed by (fully corrective) **Frank–Wolfe** with an **integer-programming oracle** for the linear minimization step. A careful initialization and adaptive contraction keep the market maker's loss bounded. Exact arbitrage-free pricing is #P-hard in the worst case, but IP solvers handle realistic instances: the 2010 NCAA tournament with 2^63 outcomes was handled in seconds per trade. Thesis 3 in its modern form: the wall is a worst-case wall.
- **Laskey, Sun, Hanson, Twardy, Matsumoto, Goldfedder, "Graphical model market maker for combinatorial prediction markets", *JAIR* 63:421–460, 2018, doi:10.1613/jair.1.11249.** LMSR maintained on a junction tree (Bayesian network), deployed in DAGGRE/SciCast. Trades are restricted to keep the graph's structure. Related: Pennock & Xia, UAI 2011 (when LMSR updates preserve BN structure); Xia & Pennock, IJCAI 2011 (Monte-Carlo pricing for tournaments). Powell, Hanson, Laskey, Twardy, "Combinatorial prediction markets: an experimental study", SUM 2013.
- **Dudík, Wang, Pennock, Rothschild, "Log-time prediction markets for interval securities", AAMAS 2021, pp. 465–473.** Exact LMSR pricing for bets on intervals of a continuous or large ordered outcome in O(log n) per operation, using a balanced-tree data structure. Related: Wang, Pennock et al. on combinatorial options markets (EC 2021) *(not verified)*.
- **Hossain, Wang, Yu, "Designing automated market makers for combinatorial securities: a geometric viewpoint", SODA 2025, doi:10.1137/1.9781611978322.40; arXiv:2411.08972.** Combinatorial LMSR price queries and trade updates are **range query and range update** problems from computational geometry. Sublinear-time algorithms exist when the set system has **bounded VC dimension**, and they provably cannot when the VC dimension is unbounded. Extended to quadratic and power scoring rules. This is the cleanest current statement of *where* the wall is: a VC-dimension dichotomy instead of a list of #P-hard languages.
- **What the 2010 notes would need updating on.** §6 presents the wall as #P-hardness plus a few islands (divisible subset matching, PermELearn approximation, tournaments). After 2010 there are four more pieces. (a) The price space is a marginal polytope, so tractability is optimization over it (Abernethy et al. 2013). (b) Relaxation trades arbitrage for tractability. (c) IP plus Frank–Wolfe handles realistic instances exactly. (d) VC dimension governs sublinear tractability.

### B4. Wagering mechanisms, strategic play and aggregation after 2010

- **Chen, Devanur, Pennock, Wortman Vaughan, "Removing arbitrage from wagering mechanisms", *Proc. 15th ACM EC* 2014, pp. 377–394, doi:10.1145/2600057.2602876; PDF https://www.jennwv.com/papers/noarbwager.pdf.** **Weighted-score wagering mechanisms (the notes' §2) admit arbitrage.** When participants disagree, any participant can secure a guaranteed positive payoff by reporting anything in a certain range, so rewards need not go to the most accurate. The paper introduces **no-arbitrage wagering mechanisms (NAWM)**, which keep most WSWM properties without the arbitrage, and proves structural results. This is a substantive later qualification of the notes' §2: the "all desirable properties" list missed no-arbitrage.
- **Lambert et al., *JET* 2015** (above): Brier betting mechanism; a new axiomatization.
- **Freeman, Pennock, Wortman Vaughan, "The double clinching auction for wagering", EC 2017**, doi:10.1145/3033274.3085118. **Freeman, Pennock, "An axiomatic view of the parimutuel consensus mechanism", IJCAI 2018**, pp. 254–260, doi:10.24963/ijcai.2018/35 (AAMAS 2018 extended abstract): this revives the **Eisenberg–Gale 1959 pari-mutuel consensus** program as a wagering mechanism and characterizes it axiomatically. It links the notes' §4.1 EG digression back to §2.
- **Witkowski, Freeman, Wortman Vaughan, Pennock, Krause, "Incentive-compatible forecasting competitions", AAAI 2018** *(not verified in detail)*: the ELF mechanism, a winner-take-all competition made truthful by randomization.
- **Strategic play.** X. A. Gao, J. Zhang, Y. Chen, "What you jointly know determines how you act: strategic interactions in prediction markets", *Proc. 14th ACM EC* 2013, pp. 489–506, doi:10.1145/2492002.2482592: in finite-stage LMSR games with two agents, the joint information structure determines whether agents reveal truthfully or delay. Kong & Schoenebeck, "Optimizing Bayesian information revelation strategy in prediction markets: the Alice Bob Alice case", ITCS 2018 *(not verified)*.
- **M. Ostrovsky, "Information aggregation in dynamic markets with strategic traders", *Econometrica* 80(6):2595–2647, 2012, doi:10.3982/ECTA8479** (EC 2009 abstract). In dynamic markets with strategic, partially informed traders (Kyle-style dealer markets *and* Hanson MSRs), information is **aggregated in every equilibrium iff the security is "separable"**. Arrow–Debreu securities on finite outcome spaces are separable. This bounds the bluffing worry in the notes' §2: bluffing can delay revelation, but with separable securities the market still aggregates in the limit.
- **Belief aggregation.** R. Sethi, J. Wortman Vaughan, "Belief aggregation with automated market makers", *Computational Economics*, 2016 (SSRN 2013, doi:10.2139/ssrn.2288670) *(abstract only)*: LMSR prices under myopic risk-averse traders converge to a weighted (wealth-dependent) average of beliefs.
- **Privacy.** Cummings, Pennock, Wortman Vaughan, "The possibilities and limitations of private prediction markets", EC 2016. Frongillo, Waggoner, "Bounded-loss private prediction markets", NeurIPS 2018. Differential privacy versus bounded loss.
- **Unverifiable outcomes.** S. Srinivasan, E. Karger, Y. Chen, "Self-resolving prediction markets for unverifiable outcomes", arXiv:2306.04305 (2023, rev. 2025). Pay agents by negative cross-entropy against a later reference agent, with random termination. Truthful reporting is an ε-perfect Bayesian equilibrium. Relevant to questions that never resolve, such as AI-safety forecasts.

### B5. Decision markets

- A. Othman, T. Sandholm, "Decision rules and decision markets", AAMAS 2010 *(not verified in detail)*: conditional markets used to choose actions break myopic incentives.
- Y. Chen, I. Kash, M. Ruberry, V. Shnayder, "Decision markets with good incentives", WINE 2011, LNCS 7090, pp. 72–83, doi:10.1007/978-3-642-25510-6_7. Journal: "Eliciting predictions and recommendations for decision making", *ACM TEAC* 2(2):6, 2014, doi:10.1145/2556271. Incentive compatibility for experts whose forecasts determine the action requires a **stochastic decision rule with full support**, so every action is taken with positive probability. Strictly proper scoring scaled by inverse action probabilities then works. Deterministic "pick the best-forecast action" rules cannot be strictly proper.
- C. Oesterheld, V. Conitzer, "Decision scoring rules", WINE 2020 *(abstract only; content from memory, verify before quoting)*. With a deterministic argmax decision rule, one can incentivize honest reporting only of the chosen action's expected utility. Essentially, the right rules pay the expert an affine function of the principal's realized utility, aligning expert and principal. Companion: "Minimum-regret contracts for principal-expert problems", WINE 2020, doi:10.1007/978-3-030-64946-3_30.
- R. Hanson, "Shall we vote on values, but bet on beliefs?", *J. Political Philosophy* 21(2):151–178, 2013 (futarchy; circulated from 2000).

### B6. 2020–2026: prediction markets and LLMs

**Scoring rules as training objectives.** The common point: next-token cross-entropy *is* the logarithmic scoring rule, the rule underlying LMSR.
- C. Shao, F. Meng, Y. Liu, J. Zhou, "Language generation with strictly proper scoring rules", ICML 2024 *(not verified in detail)*: replaces the log score in LM training with the Brier and spherical scores.
- M. Damani et al., "Beyond binary rewards: training LMs to reason about their uncertainty" (RLCR), arXiv:2507.16806, 2025: adds a Brier-score term to the binary correctness reward in RL. They argue any bounded proper scoring rule gives accurate *and* calibrated reasoning models, and report better calibration with no loss of accuracy.
- "Mitigating LLM hallucination via behaviorally calibrated reinforcement learning", arXiv:2512.19920, 2025: averages rewards over a distribution of risk thresholds, which yields a proper scoring rule (Brier under a uniform prior) and supports abstention.
- A. T. Kalai, O. Nachum, S. Vempala, E. Zhang, "Why language models hallucinate", OpenAI / arXiv:2509.04664, 2025: binary benchmark grading is an improper scoring rule that rewards guessing over abstaining. They propose confidence-target grading. This is a mechanism-design diagnosis of a training pathology.
- B. Turtel, D. Franklin, K. Skotheim, L. Hewitt, P. Schoenegger, "Outcome-based reinforcement learning to predict the future", *TMLR* 2025; arXiv:2505.17989. RLVR (adapted GRPO and ReMax) on 1,265 Polymarket questions with Brier-proportional rewards. A 14B model matches o1-level accuracy with much better calibration, but **no model beats Polymarket's own Brier score**. Simulated trading returns about 10%.

**LLMs as forecasters, benchmarked against markets.**
- D. Halawi, F. Zhang, C. Yueh-Han, J. Steinhardt, "Approaching human-level forecasting with language models", NeurIPS 2024; arXiv:2402.18563. A retrieval-augmented pipeline roughly matches the crowd aggregate of competitive forecasting platforms.
- E. Karger et al., "ForecastBench: a dynamic benchmark of AI forecasting capabilities", ICLR 2025; arXiv:2409.19839. AI still trails superforecasters.
- P. Schoenegger et al., "Wisdom of the silicon crowd: LLM ensemble prediction capabilities rival human crowd accuracy", *Science Advances* 10(45), 2024 *(not verified in detail)*.
- Prophet Arena (U. Chicago, launched Aug 2025): "LLM-as-a-Prophet: Understanding predictive intelligence with Prophet Arena", ICLR 2026; arXiv:2510.17638. Live Kalshi and Polymarket questions. LLMs are well calibrated and earn promising simulated returns, but **aggregate information more slowly than markets as resolution nears**, and they mis-recall events.
- Y. Wang et al., "Beyond forecasting: the belief-to-trade layer in prediction-market agents", arXiv:2607.03015, July 2026: a large gap between calibrated probability scores and trading results. Trading needs a separate belief-to-trade layer (Raven-Agent).

**LLM agents as traders in simulated markets (aggregation tests).**
- **S. Galanis, "Information aggregation with AI Agents", arXiv:2604.20050** (v1 Apr 2026, v4 Sep 2026). A controlled experiment: LLM traders with private signals in LMSR markets across four information structures of increasing complexity. Aggregation succeeds in simple structures and fails where **more than two levels of interactive reasoning** are needed, mirroring a ceiling seen in human subjects. Cheap talk, market duration and strategic prompting do not help. More capable agents aggregate better and earn more. In the hardest structure, frontier models hedge near 0.5 instead of converging to wrong prices. This is the most direct modern test of the notes' §2 strategic paragraph, with AI traders.
- **J. Begin et al., "Preference optimization drives monoculture in LLM prediction markets", arXiv:2606.26583** (June 2026). DPO-tuned LLM traders have pairwise error correlation of about 0.70. Ten agents carry about 1.4 independent forecasters' worth of information, which stays flat from 5 to 40 agents. A 10-agent LMSR market scored *below* a single agent. Mixing model families lowers the correlation (0.68 → 0.40). This bears on *any* "market of models" aggregation: markets aggregate independent errors, and alignment training removes the independence.
- A. Lopez-Lira, "Can large language models trade? Testing financial theories with LLM agents in market simulations", arXiv:2504.10789, 2025 (order-book stock-market simulation, not a prediction market).
- PolySwarm, arXiv:2604.03888, 2026: 50 LLM personas on Polymarket, Bayesian-aggregated with market prices. Engineering, not mechanism design.

**Assessment for the essay.** I found no 2020–2026 paper that runs an LMSR or cost-function market maker *as* a learning algorithm over model outputs in the Chen–Vaughan sense. The LLM-era literature uses (i) proper scoring rules as rewards, (ii) markets as benchmarks, and (iii) LLMs as simulated traders. The two 2026 aggregation papers (Galanis; Begin et al.) are the most relevant to "markets aggregate what learners know". Both find that aggregation degrades for structural reasons: higher-order reasoning limits, and correlated errors from shared training.

### B7. Surveys and reference works

- D. M. Pennock, R. Sami, "Computational aspects of prediction markets", ch. 26 in Nisan, Roughgarden, Tardos, Vazirani (eds.), *Algorithmic Game Theory*, CUP 2007, pp. 651–674. This is the likely skeleton of the notes, since the course was AGT.
- Y. Chen, D. M. Pennock, "Designing markets for prediction", *AI Magazine* 31(4):42–52, 2010.
- J. Abernethy, R. Frongillo, survey-style chapters and tutorials on elicitation and markets *(not located as a single citable survey)*. Lahaie's Princeton talk "Tractable market making in combinatorial prediction markets" summarizes B3.
- I found no comprehensive 2023–2026 survey of automated market makers spanning prediction markets and DeFi. Frongillo–Papireddygari–Waggoner (ITCS 2024) has the best current related-work section bridging the two.

---

## Summary of errors and discrepancies in the notes (correction list)

1. **§2 lead-in:** the "iff" is for 5 properties (BB, A, T, N, S) and the M-parameterized family, under smooth, nonnegative payouts. It is not for all 7. "Weighted average" misdescribes the payout.
2. **§2 IR:** "niezerowa" → "nieujemna", and about expected *profit*, not payout.
3. **§2 monotonicity:** it is two-sided and about profit. Positive expected profit increases with the wager; negative expected profit decreases.
4. **§2 normality:** add "expected".
5. **§4.1 EG standard form:** the index ranges should be k = n+1 … n+n·n′ and m = n + n·n′.
6. **§4.1 Lemma 2:** omits Agrawal et al.'s "consistency" item (minor).
7. **§5.1.1:** ln(η) → ln(n) (three places). 4ε²Tb → 4ε²T/b (error inherited from Chen et al. 2008). The loss (ε − q)/(ηb) needs exponent εt/b, not 2εt/b. Attribute §5.1.1 to Chen, Fortnow, Lambert, Pennock, Wortman (EC 2008), not Chen–Vaughan.
8. **§5.1.2 proof of Thm 4:** "ε √(B/(φT))" → "ε = √(2B/(φT))". The theorem statement itself is correct: √(2BφT).
9. **§5.2 Lemma 6:** must read "valid **convex** cost function". Föllmer–Schied needs convexity.
10. **§5.2 Thm 10:** add "differentiable scoring functions".
11. **§5.3:** the original SCPM charge is p̄(x*)ᵀā·x*, not "p̄(l)". The two derivations of the corrected version are integral pricing (EC 2009) and VCG pricing (OR 2011), and they coincide.
12. **§6.1 Lemma 17:** "weighted" → "unweighted" minimum feedback arc set.
13. **§6.1 Lemma 29:** a lower bound on greedy's ratio (Ω(√n)), not an approximation guarantee. The O(√n) upper bound is Krivelevich et al. 2007.
14. **§6.2:** define q_ω in the compound-security price formula. Boolean-betting hardness (Chen et al. 2008) is omitted.
15. **§6.3.1:** the polynomial-time approximation in the literature is PermELearn plus Sinkhorn balancing (Chen et al. 2008 §6.4), with loss ≤ b n ln n. It is not a Jerrum–Sinclair–Vigoda approximation of LMSR prices.

Superseded or qualified by later work:
- WSWMs admit arbitrage (Chen et al. 2014).
- The bluffing worry is bounded by Ostrovsky's separability theorem (2012).
- §5 is subsumed by Abernethy–Chen–Vaughan (2013): arbitrary securities, marginal polytopes, FTRL.
- "Valid cost function" (prices summing to 1) is shown incompatible with liquidity sensitivity (Othman et al. 2010/2013).
- The combinatorial wall is reframed as optimization over marginal polytopes, with relaxations, IP-based Frank–Wolfe, and a VC-dimension dichotomy (2012–2025).
- Thesis 2 gains a fourth face: CFMMs (Uniswap) are cost-function prediction markets (Frongillo–Papireddygari–Waggoner, ITCS 2024).

---

## URLs (primary)

- Lambert et al. EC 2008: https://www.jennwv.com/papers/wagering.pdf ; JET 2015: https://www.jennwv.com/papers/axwagering.pdf
- Chen & Wortman Vaughan EC 2010: https://arxiv.org/abs/1003.0034
- Chen, Fortnow, Lambert, Pennock, Wortman EC 2008: https://www.jennwv.com/papers/lmsrcomplexity.pdf
- Chen, Fortnow, Nikolova, Pennock EC 2007: https://users.ece.utexas.edu/~nikolova/papers/ec2007-permutation-betting.pdf
- Chen, Goel, Pennock STOC 2008: https://www.5harad.com/papers/tournaments.pdf
- Agrawal et al. EC 2009: https://arxiv.org/abs/0902.2429 ; OR 2011 (final): https://web.stanford.edu/~yyye/scpm-or-final.pdf , doi:10.1287/opre.1110.0922
- Chen et al. Algorithmica 2010: https://projects.iq.harvard.edu/sites/projects.iq.harvard.edu/files/yiling/files/algorithmica10.pdf
- Boyd & Vandenberghe: https://web.stanford.edu/~boyd/cvxbook/
- Abernethy, Chen, Wortman Vaughan: https://arxiv.org/abs/1011.1941 (TEAC doi:10.1145/2465769.2465777)
- Dudík, Lahaie, Pennock 2012: http://slahaie.net/pubs/DudikLaPe12.pdf
- Kroer et al. 2016: https://arxiv.org/abs/1606.02825
- Abernethy, Kutty, Lahaie, Sami 2014: https://arxiv.org/abs/1402.5458
- Frongillo, Della Penna, Reid 2012: https://papers.nips.cc/paper/2012/hash/41a60377ba920919939d83326ebee5a1-Abstract.html
- Hu & Storkey 2014: https://arxiv.org/abs/1403.0648
- Chen, Devanur, Pennock, Wortman Vaughan 2014: https://www.jennwv.com/papers/noarbwager.pdf
- Frongillo, Papireddygari, Waggoner 2024: https://arxiv.org/abs/2302.00196
- Hossain, Wang, Yu 2025: https://arxiv.org/abs/2411.08972
- Nueve & Waggoner 2025: https://arxiv.org/abs/2505.02959
- Galanis 2026: https://arxiv.org/abs/2604.20050
- Begin et al. 2026: https://arxiv.org/abs/2606.26583
- Wang et al. 2026: https://arxiv.org/abs/2607.03015
- Turtel et al. 2025: https://arxiv.org/abs/2505.17989
- RLCR 2025: https://arxiv.org/abs/2507.16806
- Prophet Arena: https://arxiv.org/abs/2510.17638
- Halawi et al.: https://arxiv.org/abs/2402.18563 ; ForecastBench: https://arxiv.org/abs/2409.19839
- Srinivasan, Karger, Chen: https://arxiv.org/abs/2306.04305
