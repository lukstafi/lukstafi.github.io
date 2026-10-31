# Citation check: bibliography for the ontology-by-compression essay (31 Oct 2026)

The 39 items below were cited from memory in conversation. Each was checked against a primary source (ACL Anthology, arXiv, publisher or DOI record, the paper's PDF), and the attached claims were checked as well as the bibliographic data.

- **VERIFIED**: the bibliographic data and the attached claim hold.
- **CORRECTED**: something in the citation or the claim needs changing (the change is stated).
- **NOT FOUND**: no primary source located.

A note is marked "(read)" when I read the PDF or the abstract text in this session. "(record)" means only the bibliographic record was checked.

## Summary of corrections

1. **USP (Poon & Domingos 2009).** The prior is *not* on the number of clusters. It is "an exponential prior with weight α on the number of parameters" (α = −5). There is a second prior, β = −10, on conjoined pairs ("X and Y") put in the same cluster, added to stop antonyms merging. Weights are not learned by gradient. Under per-group normalization they come in closed form as log relative frequencies, log(n_c,f / n_c). The search is hard-EM-like: the sum over parses is replaced by the mode, and an operation runs only if its log-likelihood gain exceeds a threshold of 10. The rest of the claim holds.
2. **OntoUSP.** It induces ISA *and IS-PART* hierarchies. ISA comes from a new ABSTRACT operator and drives hierarchical smoothing (shrinkage). The induced ISA hierarchy is shallow: the paper's example is REGULATE above INDUCE, INHIBIT and ACTIVATE.
3. **Klein & Manning 2004.** The DMV paper is titled "Corpus-Based Induction of Syntactic Structure: Models of Dependency and Constituency" (ACL 2004, 478–485), not "DMV".
4. **Uszkoreit & Brants 2008.** The largest corpus is **31 billion tokens** (the abstract says ">30 billion tokens"), clustered as the 0.5M most frequent words into 1,000 classes. The objective is a one-sided "predictive" class bigram, P(w|v) = P(w|c(w))·P(c(w)|v), not the Brown two-sided model. The distributed version is not guaranteed to converge.
5. **GFlowNet-EM.** It does include grammar induction: a binary PCFG on PTB sentences of ≤20 words, plus a "non-context-free" grammar. The non-CFG is only mildly so: a rule's probability may depend on the parent of its left-hand side. Exact marginalization still beat GFlowNet-EM on the CFG. Do not present it as general non-CF grammar induction.
6. **"Amortizing intractable inference…" (ICLR 2024 oral).** The seventh author is now listed on arXiv and OpenReview as **Esmeralda S. Whitammer**. Older records (dblp/CoRR 2023) list Nikolay Malkin. Follow the current record.
7. **MeCo (Gao et al., ICML 2025).** The models prepend the **domain name** ("URL: en.wikipedia.org"), not the full URL, for the first 90% of training, then cool down for 10% without metadata. A 1.6B model matches the 240B-token baseline using 160B tokens (33% less). **Hashed URLs work as well as real ones.** The authors conclude the metadata's role is to group documents by source. Validation perplexity did not track downstream gains.
8. **Grammar-based compressors vs PPM.** The claim holds, with sources. On the Calgary corpus, Sequitur-style grammar coding is 23% worse than PPMC (static) and 8.4% worse (adaptive) (Nevill-Manning, Witten & Maulsby, DCC 1994). On regular text, Re-Pair is "clearly outperformed by Bzip2, Ppmdj and 7-zip" (Nunes et al., ACM JEA 2022).
9. **Sowa 1984.** Conceptual graphs link concept nodes and relation nodes by arcs. The thematic roles (AGNT, OBJ…) are themselves *relation* nodes, so "role arcs" is a misnomer.
10. **Vepštas 2022.** "Purely Symbolic Induction of Structure" was published at **AGI 2022** (LNCS 13539, pp. 134–144). Its companion, "Grammar Induction – Experimental Results", is in the same volume (pp. 413–423) and contains **no grammar-quality evaluation**.
11. **OpenCog ULL (AGI 2018/2019).** Results were scored against Link Grammar parser output, not human treebanks. The paper reports no standard baselines (right-branching, DMV, PTB F1). The best real-corpus grammar F1 from MST parses is 0.48–0.50. The results cannot be compared with mainstream grammar induction.
12. **Minor.** Cyc `genlInverse` semantics are from memory; no primary Cycorp page was retrieved. Sommers's "wild quantity" is confirmed through Englebretsen's attribution, not from the 1982 text itself.

---

## 1. Poon & Domingos, "Unsupervised Semantic Parsing" — CORRECTED (claim detail)

Hoifung Poon and Pedro Domingos. 2009. Unsupervised Semantic Parsing. *Proceedings of EMNLP 2009*, pp. 1–10, Singapore. ACL Anthology D09-1001. https://aclanthology.org/D09-1001/ (read)

- **Input.** "It generated Stanford dependencies (de Marneffe et al., 2006) from the input text using the Stanford parser." Holds.
- **QLFs.** "USP first uses a deterministic procedure to convert dependency trees into quasi-logical forms." Holds.
- **Operators.** MERGE(C1, C2) and COMPOSE(C_R, C_A). Initialization first merges clusters with the same core form. The paper only mentions a split operator as future work. Holds.
- **Markov logic.** Holds. The model is a small MLN with four mixture-style formulas.
- **Prior. CORRECTED.** "To encourage clustering and avoid overfitting, we impose an exponential prior with weight α on the number of parameters." There is a second prior: "an exponential prior with weight β on the number of conjunctions where the two conjunctive parts are assigned to the same cluster", which targets antonyms. The values: "α and β are set to −5 and −10." The prior penalizes parameters, not clusters directly, though fewer clusters means fewer parameters.
- **Weights. Closed form.** Local normalization constraints (Σ e^w = 1 per group) make "the optimal weights … derived in closed form using empirical relative frequencies. E.g., the optimal weight of p ∈ c ∧ Form(p, f) is log(n_c,f / n_c)."
- **Search.** The sum over parses is approximated by the mode ("search instead for the L and θ that maximize log P_θ(Q, L)"). Operations are scored "by log-likelihood improvement", and an operation enters the agenda only if its score exceeds a threshold, "currently set … to 10 to favor precision". The paper describes this as "the same optimization objective as hard EM". It is greedy agenda search, so "greedy" holds.
- **Evaluation.** GENIA, "1999 PubMed abstracts", with 2,000 generated questions on relations between entities. USP gave 334 answers, 295 correct (88%). Baselines were KW, KW-SYN, TextRunner, RESOLVER and DIRT; the next best on correct answers was DIRT with 94. Holds.

## 2. Poon & Domingos, "Unsupervised Ontology Induction from Text" (OntoUSP) — VERIFIED, with an addition

Hoifung Poon and Pedro Domingos. 2010. Unsupervised Ontology Induction from Text. *Proceedings of ACL 2010*, pp. 296–305, Uppsala. ACL Anthology P10-1031. https://aclanthology.org/P10-1031/ (read)

- Abstract: "OntoUSP builds on the USP unsupervised semantic parser by jointly forming ISA and IS-PART hierarchies of lambda-form clusters. The ISA hierarchy allows more general knowledge to be learned, and the use of smoothing for parameter estimation."
- The new operator is ABSTRACT(c1, c2), which creates an abstract parent cluster. The ISA hierarchy is used for "hierarchical smoothing (a.k.a. shrinkage)".
- Results: 480 answers, 435 correct (91%), "a gain of 47% in absolute recall" over USP. The example hierarchy in Fig. 3 is shallow: REGULATE ⊃ {INDUCE, INHIBIT, ACTIVATE}.
- The paper also learns that active–passive alternation lives in an abstract agent/patient cluster inherited by rare verbs ("super-induce").

## 3. Titov & Klementiev, "A Bayesian Model for Unsupervised Semantic Parsing" — VERIFIED

Ivan Titov and Alexandre Klementiev. 2011. A Bayesian Model for Unsupervised Semantic Parsing. *Proceedings of ACL-HLT 2011*, pp. 1445–1455, Portland. ACL Anthology P11-1145. https://aclanthology.org/P11-1145/ (record + abstract)

The model is non-parametric Bayesian, using hierarchical Pitman–Yor processes, with inference by a modified Metropolis–Hastings split-merge sampler. It follows Poon & Domingos's decomposition of dependency trees into fragments and is evaluated on biomedical QA. "Nonparametric Bayesian version of USP" holds.

## 4. Brown et al., "Class-Based n-gram Models of Natural Language" — VERIFIED

Peter F. Brown, Vincent J. Della Pietra, Peter V. deSouza, Jenifer C. Lai, Robert L. Mercer. 1992. Class-Based n-gram Models of Natural Language. *Computational Linguistics* 18(4): 467–480. ACL Anthology J92-4003. https://aclanthology.org/J92-4003/ (read)

- "The partition that maximizes L(π) is, in the limit, also the partition that maximizes the average mutual information of adjacent classes."
- "Initially, we assign each word to a distinct class … We then merge that pair of classes for which the loss in average mutual information is least."
- The paper adds an exchange pass after merging: "we cycle through the vocabulary moving each word to the class for which the resulting partition has the greatest average mutual information." The claim holds. Note that "equivalently" holds only "in the limit" (the H(w) term is constant).

## 5. Uszkoreit & Brants, "Distributed Word Clustering for Large Scale Class-Based Language Modeling in Machine Translation" — CORRECTED (corpus size and objective)

Jakob Uszkoreit and Thorsten Brants. 2008. *Proceedings of ACL-08: HLT*, pp. 755–762, Columbus, Ohio. ACL Anthology P08-1086. https://aclanthology.org/P08-1086/ (read)

- Abstract: "a distributed version of this algorithm to efficiently obtain automatic word classifications for large vocabularies (>1 million words) using such large training corpora (>30 billion tokens)."
- Scale: "clustering the 0.5 million most frequent words in the vocabulary of an English corpus with 31 billion tokens into 1,000 clusters, one iteration takes approximately 30 minutes on 200 workers." A smaller run used 1.5M word types from 405M tokens, with 50 workers.
- The algorithm is a modified exchange algorithm that optimizes a *predictive* (one-sided) class bigram. It fits MapReduce. "While the greedy non-distributed exchange algorithm is guaranteed to converge …", the distributed one is not. They ran 20–30 iterations.
- Evaluation was by BLEU gains in MT, not perplexity alone.

## 6. Stolcke & Omohundro, "Inducing Probabilistic Grammars by Bayesian Model Merging" — VERIFIED

Andreas Stolcke and Stephen Omohundro. 1994. Inducing Probabilistic Grammars by Bayesian Model Merging. In R. C. Carrasco and J. Oncina (eds.), *Grammatical Inference and Applications (ICGI-94)*, LNCS 862, pp. 106–118. Springer. DOI 10.1007/3-540-58473-0_141. arXiv cmp-lg/9409010. (record)

The paper applies Bayesian model merging to HMMs, class-based n-grams and SCFGs.

## 7. Pereira, Tishby & Lee, "Distributional Clustering of English Words" — VERIFIED

Fernando Pereira, Naftali Tishby, Lillian Lee. 1993. Distributional Clustering of English Words. *Proceedings of ACL 1993*, pp. 183–190, Columbus, Ohio. DOI 10.3115/981574.981598. https://aclanthology.org/P93-1024/ (read)

- "Deterministic annealing is used to find lowest distortion sets of clusters: as the annealing parameter increases, existing clusters become unstable and subdivide, yielding a hierarchical 'soft' clustering of the data."
- Temperature T = β⁻¹, so the hierarchy emerges through phase transitions as β increases. Holds.
- Data: nouns clustered by their distribution as direct objects of verbs, from 1988 AP newswire (44M words).

## 8. Grünwald 1996; de Marcken 1996 — VERIFIED

- Peter Grünwald. 1996. A Minimum Description Length Approach to Grammar Inference. In S. Wermter, E. Riloff, G. Scheler (eds.), *Connectionist, Statistical and Symbolic Approaches to Learning for Natural Language Processing*, LNCS 1040, pp. 203–216. Springer. DOI 10.1007/3-540-60925-3_48. (record) This is from the IJCAI-95 workshop, so some indexes say 1995. Do not confuse it with Grünwald's ECML 2003 workshop paper of the same title.
- Carl G. de Marcken. 1996. *Unsupervised Language Acquisition*. PhD thesis, MIT (EECS; advisor Robert C. Berwick), 133 pp. arXiv cmp-lg/9611002; MIT DSpace handle 1721.1/10640. (record)

## 9. Wolff, SP theory — VERIFIED (canonical citation chosen)

J. Gerard Wolff. 2013. The SP Theory of Intelligence: An Overview. *Information* 4(3): 283–341. DOI 10.3390/info4030283. arXiv 1306.3888. (record)

The book-length alternative is Wolff, *Unifying Computing and Cognition: The SP Theory and Its Applications* (CognitionResearch.org, 2006). For grammar induction specifically, there is also the early Wolff (1982), "Language acquisition, data compression and generalization", *Language & Communication* 2: 57–89, which Sequitur's JAIR paper cites (from memory, not re-fetched).

## 10. Kemp, Tenenbaum, Griffiths, Yamada, Ueda, IRM — VERIFIED

Charles Kemp, Joshua B. Tenenbaum, Thomas L. Griffiths, Takeshi Yamada, Naonori Ueda. 2006. Learning Systems of Concepts with an Infinite Relational Model. *Proceedings of AAAI-06*, pp. 381–388. (read)

- "z | γ ∼ CRP(γ)" is used for each type's partition.
- On relations: "We also allow predicate types … define a ternary relation applies(i, j, p) … Our goal is now to simultaneously cluster the people and the predicates." The paper also says: "our emphasis on clustering predicates is somewhat unusual."
- So "jointly clusters entities and relations" holds when the predicates are made a type in a higher-arity relation. Each block has a Beta–Bernoulli likelihood.

## 11. Kemp & Tenenbaum, "The Discovery of Structural Form" — VERIFIED

Charles Kemp and Joshua B. Tenenbaum. 2008. The Discovery of Structural Form. *PNAS* 105(31): 10687–10692. DOI 10.1073/pnas.0802631105. (record)

## 12. Belth, Zheng, Vreeken, Koutra (KGist) — VERIFIED

Caleb Belth, Xinyi Zheng, Jilles Vreeken, Danai Koutra. 2020. What is Normal, What is Strange, and What is Missing in a Knowledge Graph: Unified Characterization via Inductive Summarization. *Proceedings of The Web Conference 2020 (WWW '20)*, pp. 1115–1126. DOI 10.1145/3366423.3380189. arXiv 2003.10412. Code: github.com/GemsLab/KGist. (abstract read)

KGist learns rules that best compress the graph under MDL. The rules are "labeled, rooted graphs", not first-order Horn rules: "Unlike first-order logic rules, our rules are labeled, rooted graphs." The paper reports locating up to 93% of missing entities on NELL, DBpedia and Yago.

## 13. Kim, Dyer, Rush (Compound PCFG); Kim et al. (URNNG) — VERIFIED

- Yoon Kim, Chris Dyer, Alexander M. Rush. 2019. Compound Probabilistic Context-Free Grammars for Grammar Induction. *Proceedings of ACL 2019*, pp. 2369–2385. DOI 10.18653/v1/P19-1228. (read) Rule probabilities are "modulated by a per-sentence continuous latent variable", and inference is "collapsed variational inference, in which an amortized variational posterior is …".
- Yoon Kim, Alexander M. Rush, Lei Yu, Adhiguna Kuncoro, Chris Dyer, Gábor Melis. 2019. Unsupervised Recurrent Neural Network Grammars. *Proceedings of NAACL-HLT 2019*, pp. 1105–1117. DOI 10.18653/v1/N19-1114. (read) "we instead apply amortized variational inference. To maximize the evidence lower bound, we develop an inference network parameterized as a neural CRF constituency parser." Holds.

## 14. Yang, Zhao, Tu (TN-PCFG) and follow-ups — VERIFIED

- Songlin Yang, Yanpeng Zhao, Kewei Tu. 2021. PCFGs Can Do Better: Inducing Probabilistic Context-Free Grammars with Many Symbols. *Proceedings of NAACL-HLT 2021*, pp. 1487–1498. DOI 10.18653/v1/2021.naacl-main.117. (read) The model uses a tensor-decomposition parameterization of binary rules and scales to "1000 nonterminal and preterminal symbols".
- Follow-up: Songlin Yang, Wei Liu, Kewei Tu. 2022. Dynamic Programming in Rank Space: Scaling Structured Inference with Low-Rank HMMs and PCFGs. *Proceedings of NAACL-HLT 2022*, pp. 4797–4809. DOI 10.18653/v1/2022.naacl-main.353. (read) It applies CPD to factor graph grammar factors and runs inference in rank space.
- Follow-up: Wei Liu, Songlin Yang, Yoon Kim, Kewei Tu. 2023. Simple Hardware-Efficient PCFGs with Independent Left and Right Productions. *Findings of EMNLP 2023*, pp. 1662–1669. DOI 10.18653/v1/2023.findings-emnlp.113. arXiv 2310.14997. (record)

## 15. Drozdov et al., DIORA — VERIFIED

Andrew Drozdov, Patrick Verga, Mohit Yadav, Mohit Iyyer, Andrew McCallum. 2019. Unsupervised Latent Tree Induction with Deep Inside-Outside Recursive Auto-Encoders. *Proceedings of NAACL-HLT 2019*, pp. 1129–1141. DOI 10.18653/v1/N19-1116. (record + title page)

## 16. Hu et al., GFlowNet-EM — VERIFIED, with a caveat on the claim

Edward J. Hu, Nikolay Malkin, Moksh Jain, Katie Everett, Alexandros Graikos, Yoshua Bengio. 2023. GFlowNet-EM for Learning Compositional Latent Variable Models. *Proceedings of ICML 2023*, PMLR 202: 13528–13549. arXiv 2302.06576. (read)

- Grammar induction: **yes**. The abstract says "experiments on non-context-free grammar induction and on images using discrete variational autoencoders".
- The setup is a PTB subset, sentences ≤20 words, with a Neural-PCFG architecture.
- On the CFG, the paper finds: "Marginalization baseline performs the best in terms of both NLL and F1." GFlowNet-EM matched or exceeded exact-sampling EM, and could add an energy-based prior on tree shape.
- The non-CFG "allows a rule probability to depend on the parent of the LHS of the rule", so exact posterior sampling becomes expensive. It got lower NLL with "comparable F1 to Marginalization on a CFG".
- Caveat: this is a parent-annotation-style dependence, not mildly context-sensitive formalisms like TAG or CCG.

## 17. Hu et al., "Amortizing Intractable Inference in Large Language Models" — CORRECTED (author list)

Edward J. Hu, Moksh Jain, Eric Elmoznino, Younesse Kaddar, Guillaume Lajoie, Yoshua Bengio, Esmeralda S. Whitammer. 2024. Amortizing Intractable Inference in Large Language Models. *ICLR 2024* (oral). arXiv 2310.04363. Code: github.com/GFNOrg/gfn-lm-tuning. (read)

- The current arXiv and OpenReview records name the seventh author Esmeralda S. Whitammer. The 2023 CoRR/dblp record names Nikolay Malkin.
- Claim: "fine-tuning LLMs via diversity-seeking reinforcement learning algorithms: generative flow networks (GFlowNets)". The paper samples from intractable posteriors (infilling, constrained generation) and treats chain-of-thought as a latent variable. Holds.

## 18. DreamCoder; Stitch; LILO — VERIFIED

- Kevin Ellis, Catherine Wong, Maxwell Nye, Mathias Sablé-Meyer, Lucas Morales, Luke Hewitt, Luc Cary, Armando Solar-Lezama, Joshua B. Tenenbaum. 2021. DreamCoder: Bootstrapping Inductive Program Synthesis with Wake-Sleep Library Learning. *PLDI 2021*, pp. 835–850. DOI 10.1145/3453483.3454080. (read) It uses a "wake-sleep" scheme with a recognition model and dream sleep. The paper says: "Programs synthesized during waking are refactored during abstraction sleep to expose new candidate primitives", with a "Compress (MDL/Bayes objective)" step. Holds.
- Matthew Bowers, Theo X. Olausson, Lionel Wong, Gabriel Grand, Joshua B. Tenenbaum, Kevin Ellis, Armando Solar-Lezama. 2023. Top-Down Synthesis for Library Learning. *Proc. ACM Program. Lang.* 7(POPL), Article 41, pp. 1182–1213. arXiv 2211.16605. (read) The search is branch-and-bound: "computing an upper bound on the utility of abstractions in the branch, and discarding the branch …". Stitch is "3-4 orders of magnitude faster and uses 2 orders of magnitude less memory" than DreamCoder's compressor, "while maintaining comparable or better library quality (as measured by compressivity)". Holds.
- Gabriel Grand, Lionel Wong, Maddy Bowers, Theo X. Olausson, Muxin Liu, Joshua B. Tenenbaum, Jacob Andreas. 2024. LILO: Learning Interpretable Libraries by Compressing and Documenting Code. *ICLR 2024*. arXiv 2310.19791. (read) LLM-guided synthesis is followed by Stitch compression and then AutoDoc, which names abstractions and writes docstrings. The paper notes that AutoDoc also improves the synthesizer's performance. Holds.

## 19. Wang et al., "Grammar Prompting" — VERIFIED

Bailin Wang, Zi Wang, Xuezhi Wang, Yuan Cao, Rif A. Saurous, Yoon Kim. 2023. Grammar Prompting for Domain-Specific Language Generation with Large Language Models. *NeurIPS 2023* (Advances in NeurIPS 36). arXiv 2305.19234. (read)

Each demonstration is augmented with a "specialized grammar that is minimally sufficient for generating the particular output example". At inference, the LLM first predicts a BNF grammar and then generates the output.

## 20. Delétang et al., "Language Modeling Is Compression" — VERIFIED

Grégoire Delétang, Anian Ruoss, Paul-Ambroise Duquenne, Elliot Catt, Tim Genewein, Christopher Mattern, Jordi Grau-Moya, Li Kevin Wenliang, Matthew Aitchison, Laurent Orseau, Marcus Hutter, Joel Veness. 2024. Language Modeling Is Compression. *ICLR 2024*. arXiv 2309.10668. (read; PDF header "Published as a conference paper at ICLR 2024")

If quoting compression numbers, note the paper's distinction between "raw compression rate, which does not take the model size … into account" and the "adjusted" rate. The headline Chinchilla figures are raw rates.

## 21. Blier & Ollivier, "The Description Length of Deep Learning Models" — VERIFIED

Léonard Blier and Yann Ollivier. 2018. The Description Length of Deep Learning Models. *NeurIPS 2018* (Advances in NeurIPS 31), pp. 2216–2226. arXiv 1802.07044. (read)

The abstract supports the claim: "Unexpectedly, we found that these variational methods provide surprisingly poor compression bounds … On the other hand, simple incremental encoding methods yield excellent compression values on deep networks." Prequential coding gave the best codelengths of the methods tested. Two-part codes were "widely inefficient".

## 22. Xie, Raghunathan, Liang, Ma — VERIFIED

Sang Michael Xie, Aditi Raghunathan, Percy Liang, Tengyu Ma. 2022. An Explanation of In-context Learning as Implicit Bayesian Inference. *ICLR 2022*. arXiv 2111.02080. (abstract read)

The analysis uses a mixture-of-HMMs pretraining distribution and the synthetic GINC dataset.

## 23. CTRL; MeCo — VERIFIED (CTRL); CORRECTED detail (MeCo)

- Nitish Shirish Keskar, Bryan McCann, Lav R. Varshney, Caiming Xiong, Richard Socher. 2019. CTRL: A Conditional Transformer Language Model for Controllable Generation. arXiv 1909.05858. (read) The model has 1.63B parameters and was trained on 140 GB of text. Control codes are "derived from structure that naturally co-occurs with raw text". On URLs: "In our version of OpenWebText, we include the URL used to download each document as the start of the input sequence." Table 3 is headed "CTRL is trained with links as control codes." The paper also proposes source attribution. Holds. Note that it is an arXiv preprint only.
- Tianyu Gao, Alexander Wettig, Luxi He, Yihe Dong, Sadhika Malladi, Danqi Chen. 2025. Metadata Conditioning Accelerates Language Model Pre-training. *ICML 2025*. arXiv 2501.01956. Code: github.com/princeton-pli/MeCo. (read)
  - **Method.** "We use the document URL's absolute domain name", in the template "URL: en.wikipedia.org\n\n[document]", for the first 90% of training. The last 10% is a cooldown on plain text. Loss is computed on document tokens only.
  - **Headline number.** A 1.6B model trained on 160B DCLM tokens with MeCo "achieves equivalent average performance to the 240B-token baseline while using 33% less data". Gains hold from 600M to 8B parameters on C4, RefinedWeb and DCLM.
  - **Adversarial point.** "Surprisingly, using hashed URLs achieves performance on par with semantically-meaningful URLs … simply providing signals that group certain documents together is sufficient." Also: "validation perplexity (PPL) does not correlate with downstream performance."
  - **Steering.** Prepending a fabricated "factquizmaster.com" gave about 6% absolute on zero-shot commonsense QA. Prepending "wikipedia.org" reduced toxic output.

## 24. Knowledge-Based Trust; source dependence; Dawid & Skene — VERIFIED

- Xin Luna Dong, Evgeniy Gabrilovich, Kevin Murphy, Van Dang, Wilko Horn, Camillo Lugaresi, Shaohua Sun, Wei Zhang. 2015. Knowledge-Based Trust: Estimating the Trustworthiness of Web Sources. *PVLDB* 8(9): 938–949. DOI 10.14778/2777598.2777603. arXiv 1502.03519. (read) The model separates extraction errors from source errors "by using joint inference in a novel multi-layer probabilistic model". It was applied to 2.8B extracted facts and 119M web pages.
- Xin Luna Dong, Laure Berti-Equille, Divesh Srivastava. 2009. Integrating Conflicting Data: The Role of Source Dependence. *PVLDB* 2(1): 550–561. DOI 10.14778/1687627.1687690. (read) "If two data sources provide a large number of common values and many of these values are rarely provided by other sources (e.g., particular false values), it is very likely that one copies from the other. We apply Bayesian analysis to decide dependence." This is copy detection. Holds.
- A. P. Dawid and A. M. Skene. 1979. Maximum Likelihood Estimation of Observer Error-Rates Using the EM Algorithm. *Journal of the Royal Statistical Society, Series C (Applied Statistics)* 28(1): 20–28. DOI 10.2307/2346806. (record)

## 25. Gordon & Van Durme, "Reporting Bias and Knowledge Acquisition" — VERIFIED

Jonathan Gordon and Benjamin Van Durme. 2013. Reporting Bias and Knowledge Acquisition. *Proceedings of the 2013 Workshop on Automated Knowledge Base Construction (AKBC '13, at CIKM)*, pp. 25–30. ACM. DOI 10.1145/2509558.2509563. (read)

- Abstract: "Much work in knowledge extraction from text tacitly assumes that the frequency with which people write about actions, outcomes, or properties is a reflection of real-world frequencies … In this paper, we question this idea."
- Example: "murder is mentioned in text many more times than more quotidian actions like hugging or constant activities like breathing."
- The Gricean point is quoted from Havasi et al.: "people tend not to provide information which is obvious or extraneous." The paper adds a second cause, that writers prefer interesting topics.

## 26. McCarthy 1993; Guha 1991; Cyc predicates — VERIFIED (predicates partly from memory)

- John McCarthy. 1993. Notes on Formalizing Context. *Proceedings of IJCAI-93* (13th IJCAI, Chambéry), pp. 555–560 (some indexes give 555–562). (record) The basic relation is ist(c, p).
- R. V. Guha. 1991. *Contexts: A Formalization and Some Applications*. PhD thesis, Stanford University. Technical report STAN-CS-91-1399-Thesis; also MCC Technical Report ACT-CYC-423-91. (record) ProQuest dates it 1992.
- **Cyc predicate names.**
  - `isa`, `genls`, `genlPreds`, `arg1Isa`, `arg2Isa` and `genlMt` are confirmed in the Northwestern OpenCyc ontology introduction (IntroOpenCycOnt.pdf): "(arg1Isa likes-Generic Agent-Generic)", "(genlPreds likesAsFriend likes-Generic)", "(genlMt FolkPsychologyMt HumanActivitiesMt)".
  - `ist` is confirmed as the microtheory modal operator in secondary sources (e.g. the First-Orderized ResearchCyc paper: "ist(k, φ) ('is true')").
  - `genlInverse` exists in the Cyc vocabulary (listed beside genlPreds and genlMt in Cyc-related posts). Its argument semantics are from memory: (genlInverse P Q) means (P a b) implies (Q b a). No Cycorp primary page was retrieved.

## 27. Abadi, Burrows, Lampson, Plotkin — VERIFIED

Martín Abadi, Michael Burrows, Butler Lampson, Gordon Plotkin. 1993. A Calculus for Access Control in Distributed Systems. *ACM Transactions on Programming Languages and Systems* 15(4): 706–734. (record) The earlier version is DEC SRC Research Report 70 (1991).

The Edinburgh repository lists the issue as No. 3, but the ACM page header reads Vol 15, No 4. "Says" and "speaks for" are the calculus's core operators (from memory; standard).

## 28. Nanopublications; Named Graphs — VERIFIED

- Paul Groth, Andrew Gibson, Jan Velterop. 2010. The Anatomy of a Nanopublication. *Information Services & Use* 30(1–2): 51–56. DOI 10.3233/ISU-2010-0613. (record)
- Jeremy J. Carroll, Christian Bizer, Patrick Hayes, Patrick Stickler. 2005. Named Graphs, Provenance and Trust. *Proceedings of WWW 2005*, pp. 613–622, Chiba. DOI 10.1145/1060745.1060835. (record) Do not confuse it with the same authors' "Named Graphs", *Journal of Web Semantics* 3(4): 247–267 (2005).

## 29. Pei Wang, Non-Axiomatic Logic — VERIFIED

Pei Wang. 2013. *Non-Axiomatic Logic: A Model of Intelligent Reasoning*. World Scientific. ISBN 978-981-4440-27-1. A second edition is listed for 2025 (ISBN 978-981-98-1942-3).

The claims below were checked against Wang's 2012 summer-school draft of the book. The draft asks not to be cited, so cite the published book; the definition numbers may shift.

- **Inheritance primary.** "The basic form of a statement is an inheritance statement" (Def. 2.2).
- **No basic individual/class split.** "what happened in NAL is like to take 'subset' as fundamental, and to use it to define 'membership'." "The instance statement 'S ◦→ P' is defined by the inheritance statement '{S} → P'" (Def. 6.4). "A term does not have to represent a set." [] is the dual intensional set, and property is defined similarly.
- **Relations as products.** "Intuitively, a product represents an anonymous relation … a product is a relation, though a relation is not necessarily a product." The form (×A B) → R holds. Extensional and intensional images are compound terms in NAL-4 (also listed in Wang's NAL user guide).
- **Truth value.** f = w⁺/w and "confidence, defined as c = w/(w+k)", from evidence counts.
- **Evidential base.** "The evidential base of a derived conclusion is the union of the evidential bases of the premises." Premises "cannot have overlapping evidential bases". The OpenNARS "stamp" is the implementation of this.
- **Higher-order.** Statements can be used "as a (compound) term to form 'statements on statements', or higher-order statements".

## 30. Sommers; Englebretsen — VERIFIED (wild quantity via secondary source)

- Fred Sommers. 1982. *The Logic of Natural Language*. Oxford: Clarendon Press / Oxford University Press. (record)
- Wild quantity: Englebretsen credits Sommers with developing the thesis that singular terms take "wild" (freely chosen) quantity, and traces it to Leibniz. See G. Englebretsen, "A Note on Leibniz's Wild Quantity Thesis", *Studia Leibnitiana* 20(1) (1988): 87–89. I did not retrieve the 1982 text to give a chapter.
- Englebretsen on term functor logic: George Englebretsen, *Something to Reckon With: The Logic of Terms* (University of Ottawa Press, 1996). Also Fred Sommers and George Englebretsen, *An Invitation to Formal Reasoning: The Logic of Terms* (Ashgate, 2000). For an overview, see Englebretsen, "Fred Sommers' Contributions to Formal Logic", *History and Philosophy of Logic* 37(3) (2016): 269–291, DOI 10.1080/01445340.2016.1186884.

## 31. Halpin, Object-Role Modeling — VERIFIED, with a nuance

Canonical citation: Terry Halpin and Tony Morgan. *Information Modeling and Relational Databases*, 3rd ed. Morgan Kaufmann/Elsevier, 2024. ISBN 978-0-443-23790-4. The 2nd edition is 2008.

- Fact types with named roles, and forward/inverse readings: Halpin's ORM 2 notation states that "forward and inverse readings for binaries may be shown together, separated by a slash". Role names are shown in square brackets.
- Nuance (Keet, arXiv cs/0702089): reading labels are "surface semantics" for validation with domain experts. They do not denote distinct inverse predicates.

## 32. Sowa, Conceptual Structures — CORRECTED (terminology)

John F. Sowa. 1984. *Conceptual Structures: Information Processing in Mind and Machine*. Reading, MA: Addison-Wesley. ISBN 978-0-201-14472-7. (record)

Concept nodes (boxes) and conceptual-relation nodes (ovals) are connected by arcs. Thematic roles such as AGNT, PTNT and OBJ are relation types, i.e. relation nodes, not labels on arcs. Arcs are only directed or numbered. Say "concept nodes and relation nodes; thematic roles are relations", not "role arcs".

## 33. Guarino & Welty, OntoClean — VERIFIED

Nicola Guarino and Christopher Welty. 2002. Evaluating Ontological Decisions with OntoClean. *Communications of the ACM* 45(2): 61–65. (record; the CACM page refused fetching)

- Anti-rigid properties are never essential, e.g. Student. The paper's constraint is that an anti-rigid property cannot subsume a rigid one.
- "Roles are anti-rigid" holds with a precision. In the OntoClean/Welty–Guarino taxonomy, roles are anti-rigid *and* dependent (~R, +D) (from memory). Not every anti-rigid property is a role; phases such as Caterpillar are anti-rigid but not dependent.

## 34. Yuret, Lexical Attraction — VERIFIED

Deniz Yuret. 1998. *Discovery of Linguistic Relations Using Lexical Attraction*. PhD thesis, MIT. arXiv cmp-lg/9805009. (record)

## 35. DMV; Jiang et al.; Zhu et al. — CORRECTED (Klein & Manning title)

- Dan Klein and Christopher D. Manning. 2004. **Corpus-Based Induction of Syntactic Structure: Models of Dependency and Constituency**. *Proceedings of ACL 2004*, pp. 478–485. DOI 10.3115/1218955.1219016. (read) The DMV is introduced here and combined with CCM. There is no paper titled "DMV".
- Yong Jiang, Wenjuan Han, Kewei Tu. 2016. Unsupervised Neural Dependency Parsing. *Proceedings of EMNLP 2016*, pp. 763–771. DOI 10.18653/v1/D16-1073. (read)
- Hao Zhu, Yonatan Bisk, Graham Neubig. 2020. The Return of Lexical Dependencies: Neural Lexicalized PCFGs. *TACL* 8: 647–661. DOI 10.1162/tacl_a_00337. (read)

## 36. Hinton & van Camp; Townsend, Bird, Barber — VERIFIED

- Geoffrey E. Hinton and Drew van Camp. 1993. Keeping the Neural Networks Simple by Minimizing the Description Length of the Weights. *Proceedings of COLT '93*, pp. 5–13. DOI 10.1145/168304.168306. (read) Section 5.2 is titled "The 'bits back' argument". The name was popularized by Hinton & Zemel (1994) and Frey & Hinton (1997), but the argument is already in this paper.
- James Townsend, Thomas Bird, David Barber. 2019. Practical Lossless Compression with Latent Variables using Bits Back Coding. *ICLR 2019*. arXiv 1901.04866. (abstract read) BB-ANS, demonstrated on MNIST with a VAE.

## 37. Grammar-based compressors vs PPM on text — VERIFIED (sources found)

- Craig G. Nevill-Manning, Ian H. Witten, David L. Maulsby. 1994. Compression by Induction of Hierarchical Grammars. *Proceedings of DCC '94*, pp. 244–253. DOI 10.1109/DCC.1994.305932. Also Waikato Working Paper 93/9. (read)
  - Calgary corpus, grammar transmitted statically: "19% better than compress and only 3.7% worse than LZFG. It is still 23% worse than PPMC."
  - Adaptive transmission: "a mean compression rate of 2.7 [bpc] … only 8.4% worse than PPMC … PPMC is best on all the other files" (grammar induction won only on geo and pie).
- Craig G. Nevill-Manning and Ian H. Witten. 1997. Identifying Hierarchical Structure in Sequences: A Linear-Time Algorithm. *JAIR* 7: 67–82. arXiv cs/9709102. (read) Sequitur "outperforms other schemes that achieve compression by factoring out repetition, and approaches the performance of schemes that compress based on probabilistic predictions." The full compression evaluation is in Nevill-Manning & Witten (1997), "Compression and Explanation Using Hierarchical Grammars", *The Computer Journal* 40(2/3): 103–116, DOI 10.1093/comjnl/40.2_and_3.103 (record only).
- Daniel S. N. Nunes, Felipe A. Louza, Simon Gog, Mauricio Ayala-Rincón, Gonzalo Navarro. 2022. Grammar Compression by Induced Suffix Sorting. *ACM Journal of Experimental Algorithmics* 27. DOI 10.1145/3549992. arXiv 2011.12898. (read) On regular texts (Pizza&Chili, enwiki, Silesia…), "RePair … is competitive with a basic Lempel-Ziv compressor such as Gzip. However, it is clearly outperformed by Bzip2, Ppmdj and 7-zip." On highly repetitive texts the ranking flips, and Re-Pair is close to the best.
- Re-Pair itself: N. Jesper Larsson and Alistair Moffat. 2000. Off-line Dictionary-Based Compression. *Proceedings of the IEEE* 88(11): 1722–1732. (record) Its abstract stresses speed and searchability, not ratio.

## 38. Batens, adaptive logics — VERIFIED (canonical citation chosen)

Diderik Batens. 2007. A Universal Logic Approach to Adaptive Logics. *Logica Universalis* 1(1): 221–242. DOI 10.1007/s11787-006-0012-5. (record)

This paper gives the "standard format": lower limit logic, set of abnormalities, strategy. Inconsistency-adaptive logics are the case whose lower limit logic is paraconsistent. An older alternative is Batens (1989), "Dynamic dialectical logics", in Priest, Routley & Norman (eds.), *Paraconsistent Logic*, Philosophia (from memory).

## 39. Vepštas 2022; OpenCog/SingularityNET ULL — CORRECTED (venue); claim answered

- **Vepštas.** Linas Vepštas. 2022. Purely Symbolic Induction of Structure. In *Artificial General Intelligence (AGI 2022)*, LNCS 13539, pp. 134–144. Springer. DOI 10.1007/978-3-031-19907-3_13. (read; preprint dated Feb 2022) Preprint: github.com/opencog/learn/raw/master/learn-lang-diary/agi-2022/grammar-induction.pdf. It is **not on arXiv**.
- **Companion paper.** Linas Vepštas. 2022. Grammar Induction – Experimental Results. AGI 2022, LNCS 13539, pp. 413–423. DOI 10.1007/978-3-031-19907-3_40. Preprint: opencog/learn, learn-lang-diary/inlp-2022/grammar-experiments.pdf. (read) Its results are distributions over MI and similarity graphs. Its conclusion: "An immediate next step is to evaluate the quality of the resulting grammars." So no quality evaluation is reported.
- **ULL, AGI 2018.** Alex Glushchenko, Andres Suarez, Anton Kolonin, Ben Goertzel, Claudia Castillo, Man Hin Leung, Oleg Baskov. 2018. Unsupervised Language Learning in OpenCog. AGI 2018, LNCS 10999, pp. 109–118. DOI 10.1007/978-3-319-97676-1_11. (record; full text not retrieved)
- **ULL, AGI 2019.** Alex Glushchenko, Andres Suarez, Anton Kolonin, Ben Goertzel, Oleg Baskov. 2019. Programmatic Link Grammar Induction for Unsupervised Language Learning. AGI 2019, LNCS 11654, pp. 111–120. DOI 10.1007/978-3-030-27005-6_11. Preprint: agi-conf.org/2019/wp-content/uploads/2019/07/paper_8.pdf. (read)
  - **Metrics.** "Parse-ability" is the share of words the induced grammar parses. F1 is computed over undirected links, against reference parses that are either manual (a 388-word toy corpus) or **produced by the Link Grammar parser with the hand-written English dictionary** ("LG-parses").
  - **Best results (Fig. 4).** Child-Directed Speech: grammar F1 0.97–0.98 from LG-parses, 0.45–0.50 from MST-parses. Gutenberg Children: 0.55–0.61 from LG-parses, 0.48 from MST-parses (MST-parse F1 vs LG itself is 0.52).
  - **Paper's own finding.** "the quality of a learned grammar is linearly related to the quality of its input parses" (Pearson 93–100%). Learning from the unsupervised MST parses adds little beyond the parses.
  - **Competitiveness.** The paper gives **no comparison** with standard baselines (right-branching, adjacent-word, DMV, CCL, PCFG induction) and no evaluation on human treebanks (PTB, UD). The scores therefore cannot be placed against the grammar-induction literature, and nothing in the paper shows the system is competitive. The LG-parse inputs are a supervised resource, so the high LG-input scores measure re-learning a hand-built grammar.
  - A 2020 follow-up (Goertzel, Suárez-Madrigal, Yu, "Guiding Symbolic Natural Language Grammar Induction via Transformer-Based Sequence Probabilities", AGI 2020, arXiv 2005.12533) is a proof of concept on a small synthetic grammar, with no benchmark comparison.
