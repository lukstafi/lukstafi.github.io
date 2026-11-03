# Citation check: retrieval-attention lineage outline (3 Nov 2026)

Checks the † items in `retrieval-attention-lineage-essay-outline.md`. Sources were read from arXiv PDFs and abstract pages (converted with `pdftotext`), PubMed, MIRI's blog and GreaterWrong's mirror of the LessWrong post. LSA was read from the supplied plain-text copy of the arXiv HTML. Quotes are verbatim from those copies. Line breaks and hyphenation from the PDFs are joined.

## 1. Memorizing Transformers (Wu, Rabe, Hutchins & Szegedy; arXiv 2203.08913; ICLR 2022 spotlight)

**Main-run layer: layer 9 of a 12-layer decoder.** §4.2, Experimental Method: "We used a 12-layer decoder-only transformer (with and without Transformer-XL cache) with an embedding size of 1024, 8 attention heads of dimension 128, and an FFN hidden layer of size 4096. For all of our experiments, we used k = 32. Unless specified otherwise, we use the 9th layer as the kNN augmented attention layer."

"99th" is a rendering glitch. ar5iv shows "9 9 th", which is the math-mode digit printed twice. The PDF says "9th".

§3.1 describes the placement as "One of the transformer layers near the top of the stack is a kNN-augmented attention layer". Elsewhere: the 1B and 8B scaling runs (§4.4) do not name a layer, and the Isabelle case study "used a model with two memory layers of size 32K" (§4.5).

**Layer ablation (Appendix A.1, Table 14).** This is the ablation setup: "context size 512, XL cache 512 with a memory size of 8192". The paper says: "We experimented with adding the external memory to layer 3, 6, 9 and 12 in a 12-layer transformer, with results shown in Table 14. We found that adding memory to the middle of the layer stack will obtain the best result, whereas adding memory to layers either too close to the input or to the output obtained less gains." Perplexities: layer 3, 2.40; layer 6, 2.36; layer 9, 2.37; layer 12, 2.43.

So the outline's "layer 6 did best" is right, but only by 0.01 over layer 9, the layer the main runs used. Suggested wording: "One kNN-augmented attention layer, layer 9 of 12 in the main runs. In the ablation over layers 3, 6, 9 and 12, the middle of the stack did best (layer 6, then 9); the first and last layers gained least."

**Abstract, first two sentences.** "Language models typically need to be trained or finetuned in order to acquire new knowledge, which involves updating their weights. We instead envision language models that can simply read and memorize new data at inference time, thus acquiring new knowledge immediately."

The outline's quote leaves out ", which involves updating their weights" and ", thus acquiring new knowledge immediately" without marking either cut. Quote the full sentences, or mark the cuts with ellipses.

## 2. Focused Transformer (Tworkowski, Staniszewski, Pacek, Wu, Michalewski & Miłoś; arXiv 2307.03170; NeurIPS 2023)

**Builds on Memorizing Transformers' memory layers: yes, explicitly, in the body.**
- §1: "The Focused Transformer permits a subset of attention layers to access an additional context of (key, value) pairs through the k-nearest neighbors (kNN) algorithm, akin to the method used in [Wu et al., 2022]."
- §3.1: "Our memory attention layer design is closely related to [Wu et al., 2022], we follow most of its design choices, except for the gating, which we replace with a simpler mechanism, which turns out to be more effective in our applications."
- §5.5: "We note that due to the limited resources we have followed the Memorizing Transformer in the choice of memory layers."
- §2: "Memorizing Transformer [Wu et al., 2022] uses kNN lookup to pick up the most relevant tokens ... Our work adheres to this approach and aims to train a key space that handles longer attention context length".
- Appendix B.5 and C.3 compare the two models directly. C.3 opens: "Memorizing Transformer Wu et al. [2022] is closely related to our method. The two key differences are 1) the training protocol and 2) how the memory is integrated into the model."

**Crossbatch procedure, exactly.**
- §3.2: "The key idea, inspired by contrastive learning, is to expose ℓ to (key, value) pairs from the current and previous local context of the given document (positives) and d − 1 contexts from unrelated documents (negatives). Importantly, this is done in a differentiable way. To achieve this, we use a data pipeline in which each element of the batch corresponds to a different document. We embed the previous (Cprev) and the current (Ccurr) local context for each of the processed documents. ... for each document δ in Ccurr we create a set {pδi}i={1,...,d} consisting of the (key, value) pairs from the previous local context of δ (positives), along with pairs from d − 1 other contexts coming from Cprev (negatives)."
- §3.2: "it does not require any additional loss (i.e., uses the standard transformer training objective) and is done on the level of the data loading pipeline and a minor self-attention change. The only new hyperparameter is d, which prescribes the ratio of positive to negative samples. Typically, we find it beneficial to start with small d ≤ 8 (otherwise, the model tends to ignore the previous local context) and later switch to bigger values, say d ≥ 64."
- Appendix B.3: "the batch index occupied by each document is fixed from the moment we load the document till we finish processing it". Also: "Assume that document δ has index i. We include into pδ all tokens from Cprev with the batch indices in {i, (i + 1) mod bs, . . . , (i + d − 1) mod bs}." Attention runs over pδ ∪ Ccurr (the tokens before q), with a softmax at a learnable temperature τ. Positional encoding is disabled in ℓ.
- Appendix B.5: "F OT does not use memory during training, while MT does", and "F OT is differentiable through all (key, value) pairs, while MT does not differentiate through the retrieved tokens."
- The contrast is implicit. Negatives are the other documents' previous-context keys, which sit in the same attention softmax as the positives. No separate contrastive loss is added.
- LongLLaMA variant (Appendix A.2): memory layers {6, 12, 18} for 3B and {8, 16, 24} for 7B. Within a batch, d and the positive/negative mix vary by segment. For 3B: "1/4 (0, 0), 1/4 (1, 1), 1/4 (2, 1), 1/4 (3, 0)".

**Lineage to Wu, Szegedy and Rabe's group (only what the text says).**
- Yuhuai Wu is a co-author, footnoted "Work done while at Google Research", and listed under xAI.
- Acknowledgments: "We would also like to thank Markus Rabe for reviewing the initial manuscript and Christian Szegedy, Charles Staats, and DeLesley Hutchins for helpful discussions."
- The paper does not attribute the crossbatch idea to that group or to any earlier discussion. It presents the procedure as its own: "Our training procedure is a novel way of training (or fine-tuning) transformer-based architectures".
- The related work names one prior memory-training method with negatives, TRIME: "TRIME [Zhong et al., 2022] proposes a training approach designed for training LMs with memory augmentation, which uses negatives to improve the quality of representations. The main difference between this and our approach is that we incorporate negatives into the chosen subset of attention layers instead of interpolating in the output layer and use the standard language modeling loss."
- TRIME is Zhong, Lei & Chen, arXiv 2205.12674, May 2022, and is not by the Google group. Its abstract says: "Our approach uses a training objective that directly takes in-batch examples as accessible memory." It is the closest published "use the training batch as memory, contrastively" method before FoT.
- FoT also lists CLIP and SimCLR as the general precedent: "During contrastive pre-training, negative examples are kept in the same batch to learn to distinguish them from positive examples."

## 3. Unlimiformer: confirmed

Amanda Bertsch, Uri Alon, Graham Neubig & Matthew R. Gormley (CMU), "Unlimiformer: Long-Range Transformers with Unlimited Length Input", arXiv 2305.01625 (v1 2 May 2023), NeurIPS 2023.

The kNN search runs over encoder hidden states, inside the decoder's cross-attention:
- §2.2: "In standard cross-attention, a transformer decoder attends to the encoder's top-layer hidden states, where the encoder usually truncates the input ... Instead of attending only to this k-token prefix of the input, we retrieve the top-k hidden states from the kNN index for each cross-attention head, and attend only to these top-k." Also: "The full input is encoded using the encoder in chunks and indexed in a kNN index; then, the index of encoded hidden states is queried at each decoding step."
- One index serves all heads and layers ("we can create a single index of the hidden states he only"). The query is reformulated as h_d W_q W_k^⊤.
- Abstract: "wraps any existing pretrained encoder-decoder transformer, and offloads the cross-attention computation to a single k-nearest-neighbor (kNN) index".

Suggested wording: "kNN over the encoder's hidden states in an encoder-decoder's cross-attention, for unlimited-length inputs".

## 4. In-Context Pretraining: confirmed

Weijia Shi, Sewon Min, Maria Lomeli, Chunting Zhou, Margaret Li, Gergely Szilvasy, Rich James, Xi Victoria Lin, Noah A. Smith, Luke Zettlemoyer, Scott Yih & Mike Lewis (Meta AI, UW, AI2), "In-Context Pretraining: Language Modeling Beyond Document Boundaries", arXiv 2310.10638 (v1 16 Oct 2023), ICLR 2024.

How it orders documents:
- §2.1, neighbours: "for each document di ∈ D, a dense retrieval model is used to retrieve the top-k most similar documents ... The retrieval model uses approximate nearest neighbours search". The retriever is Contriever: mean-pooled embeddings, cosine similarity, faiss with IVF and product quantization, k = 10, over the first 512 tokens of each document. Retrieval scores are also used to remove near-duplicates.
- §2.2, graph and path: the neighbours form an undirected weighted document graph. Ordering is then posed as "the maximum traveling salesman problem", solved greedily. The greedy rule: "starts by selecting a yet-to-be-visited document with the minimum degree as the starting node ... then progressively extends the current path by navigating to its unvisited neighboring document with highest weight". Dead ends jump "to a random unvisited minimum degree document".
- Then: "we traverse the documents along the path and concatenate them to create fixed-sized input contexts". Each document is used once. The paper contrasts this with plain kNN grouping, which repeats data.

## 5. Quiet-STaR (Zelikman, Harik, Shao, Jayasiri, Haber & Goodman; arXiv 2403.09629)

**REINFORCE on the log-likelihood of the following true tokens: confirmed, with one correction.** The baseline is the mean over the sampled thoughts for that token, not the model without a thought. Negative rewards are dropped.

- §4.4.3, Objective: "We use REINFORCE to optimize the likelihoods of the rationales based on their usefullness: the log-likelihood of the ntrue true next tokens X j+1:j+ntrue+1 under the language model given previous observed tokens and a particular rationale ... We thus define the reward r j for each rationale Tj as the difference between ptalk j:j+ntrue and the average across rationales for that token". The update is ∇θ L^REINFORCE_j = −r_j · ∇θ log pθ(T_j | [X:j; <|startofthought|>]).
- Same section: "We found it useful to exclude the negative reward from the REINFORCE loss term, as it led to more stable training, though it may introduce some bias." It also adds a log-likelihood loss L^NLL.
- Figure 1 caption: "We apply REINFORCE, as in STaR, to increase the likelihood of thoughts that help the model predict future text while discarding thoughts that make the future text less likely (learn)."
- p_talk is the mixing head's blend of the predictions with and without the thought.
- Appendix D: "simply computing the reward as the difference between the losses with and without thought proves to be a strong baseline", but multiple thoughts did better.

Suggested wording: "rewarded by REINFORCE on how much a thought raises the log-likelihood of the next few true tokens, relative to the other thoughts sampled at that position".

## 6. Whittington, Warren & Behrens, arXiv 2112.04035: confirmed

The title is "Relating transformers to models and neural representations of the hippocampal formation" (ICLR 2022; v1 7 Dec 2021). It names TEM and relates transformers to it directly:
- §3: "Here we focus on the Tolman-Eichenbaum Machine (TEM) (Whittington et al., 2020) ... The critical points are: 1) the memory component of TEM can be viewed as a transformer self-attention, since the TEM memory network is analogous to a Hopfield network (Hopfield, 1982) which have recently been shown to be closely related to transformers (Ramsauer et al., 2020); 2) TEM path integration (see below) can be viewed as a way to learn a position encoding."
- §5 is titled "TEM AS A TRANSFORMER". It defines the "TEM-transformer (TEM-t)", which "offers dramatic performance improvements over the original TEM model".

Useful for the §7 bridge: the introduction lists among its contributions "a novel take on the computational role of the hippocampus, and an instantiation of hippocampal indexing theory (Teyler & Rudy, 2007)". So the LSA senior author's earlier paper itself connects transformers to indexing theory.

## 7. Hippocampal indexing theory: citations confirmed (PubMed)

- Teyler, T. J., & DiScenna, P. (1986). The hippocampal memory indexing theory. *Behavioral Neuroscience*, 100(2), 147–154. doi:10.1037/0735-7044.100.2.147. PMID 3008780.
- Teyler, T. J., & Rudy, J. W. (2007). The hippocampal indexing theory and episodic memory: Updating the index. *Hippocampus*, 17(12), 1158–1169. doi:10.1002/hipo.20350. PMID 17696170.
- Precursor (optional): Teyler & DiScenna (1985), "The role of hippocampus in memory: a hypothesis", *Neurosci. Biobehav. Rev.* 9(3):377–389. Its abstract already names the "Memory Indexing Theory".

Statement of the theory, from the 1986 abstract: "Here it is proposed that the role of the hippocampus is to form and retain an index of neocortical areas activated by experiential events. ... It is asserted that the reactivation of the stored hippocampal memory index will serve to also reactivate the associated unique array of neocortical areas and thus will result in a memorial experience."

The 2007 abstract gives a one-sentence version: "because the hippocampus projects back to these neocortical regions the information it stored could serve as an index to the pattern of neocortical activity produced by the episode. Consequently, a partial cue that activated the index could activate the neocortical patterns and thus retrieve the memory of the episode."

The outline's paraphrase ("stores an index pointing to cortical traces rather than the content itself") fits. The 1986 wording says the index points to neocortical *areas/patterns activated by an event*.

## 8. LSA (Kubicek, Caciolai, Peng, ..., Whittington; arXiv 2610.42147)

**Appendix A oracle: confirmed, with conditions to add.** The setup is from Appendix A ("Attention Sparsity") and the Figure 8 caption. Model: Qwen-3.8-27B at 128k tokens, on RULER. Caption: "Each query attends to a 4-token sink, a 512-token window and the top-k long-range keys, one list shared by all heads. Process: sum over all heads, pick top-k, renormalise per head over the shared selection."

Text: "At 128k tokens, Top-k Oracle Attention keeps 98% of the RULER accuracy of Full Attention down to k = 512, while each query attends to 0.8% of the keys. Single-needle retrieval holds down to k = 16, while MultiKey 2, MultiKey 3 and CWE fall first in accuracy. Therefore, sparse attention loses little if it finds the most relevant keys, which is what LSA is designed to do without scoring every key."

Suggested wording: "With a 4-token sink and a 512-token local window, attending to only the true top 512 long-range keys (one selection shared across heads) keeps 98% of full attention's RULER accuracy for Qwen-3.8-27B at 128K: 0.8% of the keys."

**"98% of time spent finding tokens": the paper has it, in more specific form (prefill, one sparse-attention layer).**
- §1: "For example, at 10M tokens, 98% of the prefill time of a sparse attention layer is spent on indexing (Figure 2). The cost of sparse attention at ultra-long context is therefore dominated by the cost of finding the keys."
- §2: "For example, at 10M tokens the indexer takes 98% of the prefill time of traditional sparse attention (Figure 2), and a 'free' indexer would make sparse attention a further 58× faster in prefill and 8.9× in decode."
- Figure 2 conditions: "One global attention layer of GLM-5.3-Flash (512k to 10M tokens) on one H200, prefilling the last chunk of 32,768 queries and decoding one token."
- §6 (Conclusion): "At ultra-long context, the cost of sparse attention lies in finding which keys to attend to."

Quote the paper's §1 sentence instead of the blog's.

Note for the outline: Benjamin Hoover is an LSA co-author (Prefrontal AI), which bears on the Energy Transformer link (item 9).

## 9. Energy Transformer: confirmed

Benjamin Hoover, Yuchen Liang, Bao Pham, Rameswar Panda, Hendrik Strobelt, Duen Horng Chau, Mohammed J. Zaki & Dmitry Krotov, "Energy Transformer", arXiv 2302.07253 (v1 14 Feb 2023), NeurIPS 2023.

One line: a transformer-like network whose attention layers are built to minimize an engineered energy function, joining attention to Dense Associative Memory (modern Hopfield networks). Abstract: "uses a sequence of attention layers that are purposely designed to minimize a specifically engineered energy function, which is responsible for representing the relationships between the tokens." It is evaluated on image completion and graph anomaly detection and classification.

## 10. MIRI Visible Thoughts Project: confirmed

"Visible Thoughts Project and Bounty Announcement", by So8res (Nate Soares). On LessWrong it is timestamped 30 Nov 2021, 0:19 UTC (GreaterWrong mirror). MIRI's blog dates its copy November 29, 2021 (US time). Both are the same moment; "30 Nov 2021" is right for LessWrong.

Verbatim (identical in both copies): "The goal is to transition the state of AI dungeon technology from "An AI outputs story text in response to actions (and we have no idea how)" to "An AI produces thoughts as visible intermediates on the way to story text, allowing us to watch the AI think about how to design its output, and to verify that we can get different sensible outputs by intervening on the thoughts"."

The quoted phrase is accurate. Its clause "verify that we can get different sensible outputs by intervening on the thoughts" supports the outline's "thoughts that steer the output".
