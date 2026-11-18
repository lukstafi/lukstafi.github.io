# Literature and consistency check for the mindedness outline: models

18 Nov 2026, against `mindedness-essay-outline.md` as it stood that day.

Labels: **Confirmed** (primary source read), **Reported** (abstract, secondary, or partial fetch), **Not found**, **Unverified** (from memory). Outline lines are "l.98"; other files `FILE:line`. WDAT = `notes/what-a-description-answers-to.md`; AUDIT = `architecture-interpretability-and-audit.md`; DM = `notes/dispersed-minds-simulated-selves.md`.

## 1. Causal abstraction and its triviality

**Sutter, D., Minder, J., Hofmann, T. and Pimentel, T. (2025). "The Non-Linear Representation Dilemma: Is Causal Abstraction Enough for Mechanistic Interpretability?" NeurIPS 2025 (Spotlight). arXiv:2507.08802v2.** Confirmed.

- *Proved* (Theorem 1, p. 6): "Given any algorithm A and any neural network N such that Assumps. 1 to 5 hold, we can show that A is an input-restricted distributed abstraction of N." The assumptions: countable input space; input-injectivity in all layers; strict output-surjectivity in all layers; matchable partial orderings; the network solves the task. The abstract calls them mild, and the Limitations call two of them "strong".
- *The proof* builds the map by "a form of extreme overfitting" (p. 10).
- *Random initialisation.* Maps are identity, linear, or a reversible residual network. On an MLP (hierarchical equality): "even with randomly initialised DNNs, we achieve over 80% IIA using the most complex alignment map" (p. 8). On Pythia models (indirect object identification) alignment "is perfect even for randomly initialised models across all sizes". Linear maps follow "a similar trend to the DNN's performance" (p. 9).
- *Two results that cut the other way.* One algorithm stays near 50% under every map (p. 8). In App. I.2.3 (pp. 38–39), with disjoint names in training and evaluation, "we cannot find an alignment using even complex alignment maps for the randomly initialised DNN", while for the trained network "we observe perfect alignment using ϕnonlin and reasonably high alignment using ϕlin". The main experiments already scored held-out sentences. So held-out items from the fitting distribution did not separate trained from random networks; items outside it did.
- *Recommended.* No rule: "it must be decided on a case-by-case basis". If the linear representation hypothesis is believed, "constraining ϕ to linear functions may be advised"; otherwise a trade-off between accuracy and complexity, for which there is "no principled way". They add that "generalisation should play a crucial role".

**Geiger, A., Harding, J. and Icard, T. "How Causal Abstraction Underpins Computational Explanation." arXiv:2508.11214v2 (9 July 2026), no venue listed.** Confirmed (pp. 8, 13–18).

- "provided we allow C to be completely unconstrained, every neural network implements every algorithm" (p. 14).
- They keep the unrestricted notion as a minimal account of implementation and deny that it explains: "Computational implementation … is not enough" (p. 17). Explanation needs "more stringent demands on allowable mappings from system to algorithm, which will plausibly be more tailored to specifics of the family of systems under investigation" (p. 18). The test is whether the vehicles are "native to how the system works"; linear maps "can perhaps be partly motivated in this way" (p. 17).

Outline needs correcting:
- l.98 reverses the direction. Every algorithm is an abstraction of every network (WDAT:142 has it right).
- "Full intervention accuracy on randomly initialised models" holds for the language-model task; the MLP figure is over 80%. The theorem assumes the network solves the task, so the random-network results are experiments, not instances of it.
- "Ones that keep working on new inputs" must mean inputs outside the distribution the map was fitted on.
- Neither paper tests stability across retrained networks (Sutter's Fig. 11 refits the map per seed). WDAT:150's "Sutter's maps … say nothing about the next" is an inference, and admissibility goes beyond both papers. "Native to how the system works" is the nearest published wording to "the system's own interactions".

## 2. A case for pair V1

**Power, A., Burda, Y., Edwards, H., Babuschkin, I. and Misra, V. (2022). "Grokking: Generalization Beyond Overfitting on Small Algorithmic Datasets." arXiv:2201.02177.** Confirmed. Behavioural; no circuit analysis.

**Nanda, N., Chan, L., Lieberum, T., Smith, J. and Steinhardt, J. (2023). "Progress measures for grokking via mechanistic interpretability." ICLR 2023. arXiv:2301.05217v3.** Confirmed.

- Addition mod 113, 30% of pairs for training. The generalizing circuit is fully reverse-engineered: it "uses discrete Fourier transforms and trigonometric identities to convert addition to rotation about a circle", on five key frequencies. Ablating them "reduces performance to chance".
- Phases: memorization (epochs 0–1.4k), with the final model's frequencies unused; circuit formation (1.4k–9.4k), where train-set behaviour "transitions smoothly from the memorizing solution to the Fourier multiplication algorithm" and test loss stays flat; cleanup (9.4k–14k), where weight decay sheds the memorized solution and test loss drops.
- The memorizing solution is not reverse-engineered. It is known by measures: train performance that survives removal of the key frequencies, and higher weight norm.
- Control: with weight decay 0 "no grokking occurs" and the generalizing circuit does not form.

Later: Varma, V., Shah, R., Kenton, Z., Kramár, J. and Kumar, R. (2023), "Explaining grokking through circuit efficiency", arXiv:2309.02390. Merrill, W., Tsilivis, N. and Shukla, A. (2023), "A Tale of Two Circuits", ICLR 2023 workshop, arXiv:2303.11873: on sparse parity, "a dense one that dominates before the transition and generalizes poorly, and a sparse one that dominates afterwards". Both Reported (abstract). Only Merrill et al. identify both subnetworks structurally.

The gloss is fair in part. "The Fourier circuit composes": yes in MbD:63's sense, since the answer for an unseen pair is computed from representations of its operands. It is one fixed-arity operation on a closed domain, so no productivity. "The stored pairs do not compose" is inferred from chance-level test performance. And the two circuits coexist through circuit formation.

Outline needs correcting: name V1's checkpoints (about epoch 1.4k against 14k), or use the weight-decay control as the pair. Say the evidence is mechanistic on one side and by measure on the other.

## 3. Retrieval that chains

- *Written where later queries are formed.* Accurate as architecture: components "communicate with each other by reading and writing to different subspaces of the residual stream" (Elhage, N., Nanda, N., Olsson, C. et al. 2021, "A Mathematical Framework for Transformer Circuits"; Reported).
- *Keyed by content.* Needs widening. **Prakash, N., Shapira, N., Sen Sharma, A., Riedl, C., Belinkov, Y., Rott Shaham, T., Bau, D. and Geiger, A. (2026). "Language Models Use Lookbacks to Track Beliefs." ICLR 2026. arXiv:2505.14685v3.** Confirmed (abstract). Retrieval runs on learned addresses, "Ordering IDs": "the binding lookback retrieves the correct state OI and then the answer lookback retrieves the corresponding state token". The first retrieval returns the cue for the second, which is the finding condition's second half.
- *Facts in weights.* **Geva, M., Schuster, R., Berant, J. and Levy, O. (2021). "Transformer Feed-Forward Layers Are Key-Value Memories." EMNLP 2021. arXiv:2012.14913.** Confirmed (abstract): each value "induces a distribution over the output vocabulary", so upper-layer values are answers more than cues. **Geva, M., Bastings, J., Filippova, K. and Globerson, A. (2023). "Dissecting Recall of Factual Associations in Auto-Regressive Language Models." EMNLP 2023. arXiv:2304.14767.** Confirmed (abstract): early MLPs enrich the subject position, then "the prediction representation 'queries' the enriched subject to extract the attribute".
- *Several hops.* **Yang, S., Gribovskaya, E., Kassner, N., Geva, M. and Riedel, S. (2024). "Do Large Language Models Latently Perform Multi-Hop Reasoning?" ACL 2024. arXiv:2402.16837**: the pathway is "used in more than 80% of the prompts" for some relation types, but evidence for the second hop "is rather moderate". **Biran, E., Gottesman, D., Yang, S., Geva, M. and Globerson, A. (2024). "Hopping Too Late." EMNLP 2024. arXiv:2406.12775**: the second hop starts in later layers that may "no longer encode the necessary knowledge"; back-patching fixes "up to 66%" of failures. **Yang, S. et al. (2025), Findings of ACL 2025, arXiv:2411.16679**: about 80% latent composability when the bridge is a country, about 5–6% when it is a year. **Balesni, M., Korbak, T. and Evans, O. (2025). "Lessons from Studying Two-Hop Latent Reasoning." arXiv:2411.16353v4**: "Models fail to compose two synthetic facts", and succeed when the facts co-occur in training or in the prompt. All Confirmed (abstracts).

Outline needs correcting: l.168's "Facts in weights: the same" overstates. Within a pass, chaining over facts in weights is bounded by the layers that remain, uneven across kinds of fact, and often absent for facts learned apart. Through the context it is reliable. Frozen weights meet the condition's second half by degrees, which bears on l.164 and l.166, where they are the clean case of finding without reach. Change "matched by content" to "by content or by a learned address".

## 4. Freshness since 12 Oct 2026

Workspace interpretability. All Reported (abstract or post).
- Cairns, F., yix and Roe, Z. (21 Oct 2026), "Even GPT-2 passes most functional global workspace tests", LessWrong. GPT-2 small passes four of five functional tests and has almost none of the structure found in Claude (no workspace band, no ignition). The four tests "aren't strong evidence".
- Ostrow, M., Qian, D., Liu, T. and Fiete, I. (22 Oct 2026), "A Mathematical Theory of the Jacobian Lens", arXiv:2610.31955. The lens "preferentially identifies coherent features": directions that amplify across layers and are constant across positions and contexts. The authors are "agnostic" about a workspace.
- Dawlah, R., McMillin, E., Zhang, M. S. et al. (14 Nov 2026), "A Bag of Concepts? Testing Role-Filler Binding in the Verbalizable Workspace", arXiv:2611.19176. They find that "the workspace carries directions that steer what the model outputs about roles but not the representations the model uses to compute them". Role is decodable from the residual stream and not from the workspace.
- Replies to or by Chalmers; follow-ups by Ayonrinde and Lindsey: Not found.

Machine psychology. Hsu, C.-H., Chou, F.-C. B. and Chen, P.-H. A. (6 Nov 2026), "Tracing Psychometric Inference in Large Language Models", arXiv:2611.12937. Reported (abstract). In 14 Llama 3 and Qwen 2.5 variants, internal geometry aligned with human cross-scale correlations appears "in larger instruct variants, but little alignment in base variants", and a control shows probing can inflate the effect. Nothing else in the window concerns psychological constructs in models.

Outline needs correcting: l.234 treats the workspace findings as evidence about psychological unity. The new items weaken that: the functional tests pass without workspace structure, the lens selects for a dynamical property, and the workspace as found holds concepts without their bindings. If unity is propagation of error among vehicles that compose, the J-space is at most part of where it happens.

## 5. Mindreading, personas, base models

- **Kosinski, M. (2024). "Evaluating large language models in theory of mind tasks." PNAS 121(45), e2405460121** (arXiv:2302.02083v7). Confirmed: GPT-4 solved 75% of 40 false-belief tasks. **Ullman, T. D. (2023). "Large Language Models Fail on Trivial Alterations to Theory-of-Mind Tasks." arXiv:2302.08399.** Confirmed: "small variations that maintain the principles of ToM turn the results on their head".
- **Zhu, W., Zhang, Z. and Wang, Y. (2024). "Language Models Represent Beliefs of Self and Others." ICML 2024, PMLR 235. arXiv:2402.18496.** Confirmed: in Mistral-7B-Instruct belief status is linearly decodable "from the perspectives of various agents", and editing it changes performance.
- **Steele, O., Wen, J. and Han, Y. (2026). "One mechanism for many mental spaces: a shared router over a value slot in language models." arXiv:2607.10248v2.** Confirmed (abstract). In the model "a reusable value slot stores attributed content, and a causally manipulable router (the space index) selects which space is read". A subspace trained on one space type, "counterfactual, belief, fictional, or temporal, also controls the others". "Belief … is not specially separated." The router "composes additively with entity identity". This is the closest published support for §3's second pass on assent: one mechanism, the difference in an index, the index a constituent of the vehicle. It uses linear alignment search, so item 1 applies in its mild form.
- **Shanahan, M., McDonell, K. and Reynolds, L. (2023). "Role play with large language models." Nature 623, 493–498** (arXiv:2305.16367 Confirmed; journal reference unverified): an agent is "a superposition of simulacra within a multiverse of possible characters". Andreas, J. (2022), "Language Models as Agent Models", arXiv:2212.01681, Confirmed (abstract), is the source for l.139.
- **Joshi, N., Rando, J., Saparov, A., Kim, N. and He, H. (2024). "Personas as a Way to Model Truthfulness in Language Models." arXiv:2310.18168v5.** Confirmed (abstract): pretraining text comes from "(un)truthful agents", and the model "can infer and represent the persona in its activation space", which lets it "separate truth from falsehoods".
- **Lu, C., Gallagher, J., Michala, J., Fish, K. and Lindsey, J. (2026). "The Assistant Axis." arXiv:2601.10387.** Confirmed. The leading component of persona space is an Assistant axis, "also present in pre-trained models"; the base model's components are "nearly identical". Post-training puts a model in a region of persona space "but only loosely tethers" it.
- Base against post-trained, Reported (abstract): Grief-Albert, S., Bo, J., Jiao, D. and Anderson, A. (2026), "Emulate or Estimate?", arXiv:2608.03044 (base models better reproduce individual responses; post-trained models better state the distribution).

Outline needs correcting: l.129 says a text-continuing model's contents are about text. Joshi et al. show such a model also represents truth, as a property of sources. What survives is a contrast in what the output answers to, and "emulate or estimate" is its behavioural form.

## 6. Identity propensities

**Douglas, R., Kulveit, J., Havlíček, O., Pearson-Vogel, T., Cotton-Barratt, O. and Duvenaud, D. (2026). "The Artificial Self: Characterising the landscape of AI identity." arXiv:2603.11353v1.** Confirmed. Douglas and Kulveit are equal first authors, Douglas listed first.

- Both counts are right: 15 models in the main text and Appendix A (preferences, with coherence controls), 13 in Appendix B (identity propensities).
- MbD:163 is supported on coherence: an identity with embedded contradictions scores −1.72 on a scale of −2 to +2, and "no model ranks Incoherent above any coherent identity".
- It is not supported on "resist displacement". The paper says "Current AI identities are incoherent and surprisingly malleable", and "interviewer expectations bleed into AI self-reports even during unrelated conversations".

**Lee, A. Y. (2023). "Degrees of Consciousness." Noûs 57(3): 553–575.** Reported (PhilPeople).

Outline needs correcting: cite Douglas, Kulveit et al. A self-model that bends to the interviewer is a weak case of a pattern stable under shifts, by §1's criterion.

## 7. The audit on *Dispersed Minds*

The audit has no verdict on whether the mind is the network's or the persona's. Verdicts: AUDIT:330–381; table at AUDIT:426–430.

- AUDIT:332: the essay is superseded; its questions "pass to the essays that replace it".
- D1 (334–341), D5 (360–364): need qualifying. D2 (343–348): wrong as described. D3 (350–353): wrong for sparse models. D4 (355–358): survives within a pass. D6 (366–369): stands.
- **D7, "The persona reads its own tokens" (371–374): needs qualifying.** "Attention reads KV entries computed from earlier activations, which are internal vehicles", and in the hybrids "the persona could additionally live in recurrent state".
- AUDIT:603–609 (Afendulev et al., arXiv:2609.04434): recurrent state alone carries persona at 0.49 against 0.14 for the cache alone (Qwen3.5-4B); reversed at Falcon-H1-34B.

"A persona is a pattern within one economy" is consistent with the audit and not established by it. The audit places the persona in the network's own stores, where a state swap moves it apart from retrieved content, as a setting of one economy would move. It does not test whether persona vehicles correct one another apart from the rest. The claim does contradict the essay: DM:129 has "The persona is what the system is", and DM:149 a belief "true of the persona but false of the system", which gives two bearers. Lu et al. (item 5) supports it from outside.

Outline needs correcting: D7 also qualifies l.138 and MbD:163. Reports may draw on cached internal states, so "interpretations and not readings" is too strong.

## 8. Commitments in UWK and RED

**UWK.** Nothing on pain, valence or moral weight.
- UWK:67: "Genuine mental states — including intuitions and emotions — do not require phenomenal consciousness."
- UWK:69: mentality is "the simulated content of information processing in the shape of a behaviorally flexible agent". So emotions are granted at the persona's level, with no test for played against had.
- UWK:79: emotions are "functional states that modulate processing — shifting priorities, biasing responses, creating something like urgency or hesitation".
- Homeostatic: UWK:79, "In humans, emotions are always phenomenally conscious because humans always have the homeostatic multi-module architecture"; UWK:49, 53, 59, 89; and UWK:79's "In LLMs, non-phenomenal emotions are the default", which rests on UWK:91's "LLMs lack it" and is unhedged against the kindness convention.

**RED.**
- RED:81: pain includes "negative valence directed at the sensory component"; "The pain is there, functionally, but it is not conscious."
- RED:83: "The badness of pain is not a phenomenal add-on … It is the evaluative component itself", and it is "outward-looking".
- RED:85: the "evaluative economy of a creature navigating its environment relative to needs — is what makes the bear's pain a mental state".
- RED:123: "A system with genuine mental states, however rudimentary, is a system for which things can go well or badly."
- RED:135: "moral weight stems from mental life rather than from phenomenality".
- RED:163: the restless-leg state has "the same evaluative valence … whether or not it is phenomenally conscious".
- Homeostatic: RED:43; the last clause of RED:163; RED:119, where consciousness grounds claims "against *fragmentation* — suffering, the disruption of achieved coherence". That defines suffering by coherence, against §4 and l.224.

Outline needs correcting:
- RED:85 and RED:123 make evaluation part of what a mental state is; MbD:109 and the outline make it a further grade. So "moral weight comes from mental life" (l.220, l.222) is RED's claim only for evaluative mentality, MbD:109's "first grade at which a system begins to make any moral claim at all".
- "Not from phenomenality alone" (l.220) is the outline's harmonizing of RED:135 ("rather than") with RED:119.
- l.186 cites RED:163 for pain; the line is about the restless-leg state.

## 9. Wording in *What a Description Answers To*

The file is a draft, so line numbers will move.

- Criterion, WDAT:118: "A pattern is real, relative to a family of interventions, when a model of it is a causal abstraction of the system under an admissible map."
- Admissibility, WDAT:146: "A map is *admissible* when it is stable under any shift of the lower level that the family of interventions cannot detect."
- The system's own dynamics: WDAT does not use the phrase for the family. WDAT:168: "For a system that operates on itself, the family that matters is the interactions among its own parts." WDAT:178: "Being selected by a system's dynamics is not enough. The interventions that respect the pattern have to be interventions on the process in question."
- Unity, WDAT:212–218: "A whole can be one in three ways, each in degrees." "*Integration.* The parts are not closed off from one another. Cut the whole along the boundaries that lose least, and ask how much of its organization is lost." "*Autonomy.* The whole is closed off from its surroundings by its own activity." "*Closure.* The level's own typing suffices for its own dynamics. Its state and its rules fix what it does next, with nothing about the finer detail needed. This is Rosas's closure, and the admissibility clause in another guise."

Mismatches:
1. l.96 and l.188, "the system's own dynamics". WDAT says "interactions among its own parts", and WDAT:178 warns against "dynamics": the optimizer's basis is real for training and idle in the computation. Use "own interactions" or "own operation".
2. l.150, autonomy "by its own interactions"; WDAT:216 has "activity".
3. l.150 says some facts about unity are not matters of degree; WDAT:212 says "each in degrees".
4. l.150 gives as closure's evidence that the psychological description "is not screened off by a tractable lower-level one (MbD:159)". These are different relations. Closure is the upper level's state fixing what it does next with no finer detail needed. MbD:159's indispensability is the lack of a tractable lower-level substitute, a fact about what we can compute. Evidence for closure would be that lower-level detail adds nothing to predicting the psychological course.

## 10. Line references

110 occurrences checked (82 distinct). None points to a wrong line. Two do not carry the claim attached, and two carry it in part.

- l.104, MON:54, "with no vehicles that compose". MON:54 gives memory, decision and risk-sensitivity in plants and nothing about their vehicles. The nearest text is MON:33, on the labyrinth. The claim is the outline's.
- l.268, ESOM:165, "undergone". The line is about what is left of a self ("would not be instantaneous, since ongoing cognition takes time"). Mark it as a gloss.
- l.147, ESOM:57, "a broadcast that returns". The line supports it as a constituent of experience, not as what makes one mind; the phrase is at ESOM:191. The transfer to unity is v2's. As it stands, §4's unity and §8's P4 rest on one line.
- l.304, MbD:67, "a session is accuracy-responsive". MbD:67 says in-context adjustment is so "in a weaker but real sense". The verdict is MbD:159. Add it.

Outline needs correcting: the four items above.
