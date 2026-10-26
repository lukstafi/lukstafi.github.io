# Two October 2026 papers against the recent essays

Status: suggestions for review, 26 Oct 2026. Sections 2a and 2b (main edits, not the optional ones) were applied on 26 Oct 2026.

- **OPST.** Sick, Hoyer, Strümpler, Reisswig, Ropinski, Tombari (Google, Ulm), *On-Policy Self-Training: Data-Free Self-Improvement in Large Language Models*, arXiv 2610.32770 (23 Oct 2026).
- **Dual Exam.** Rao, Chu et al. (HKUST and many others), *Dual Exam: Controlled Evaluation of Multimodal Agents and World Models*, arXiv 2610.31066 (22 Oct 2026).

OPST bears on the continual-learning series' central claim, and Part 1 publishes on Wed 28 Oct. Dual Exam bears on the September essays about world models and perception, and no deadline applies to them.

---

## 1. OPST: what it does and what it found

**Method.** OPST is on-policy self-distillation (the OPSD/SDFT construction of Part 1) with the privileged context written by the model itself.

1. Given only a topic name, such as "Abstract Algebra" (in the experiments, mostly the benchmarks' own category labels), the generator writes a question $x$ and privileged information $z=(r,a)$: a rationale and a candidate answer.
2. **Pseudo-verification.** The generator re-solves $x$ in a fresh context, and again after paraphrasing it. The sample is kept only if both answers equal $a$.
3. **Consensus gate.** The student samples $G$ rollouts. If all of them already agree with $a$, the sample is dropped. The retained samples sit at the student's frontier, so the curriculum moves with the student.
4. **Training.** The student sees $x$ alone, and the teacher sees $x$ and $z$. The per-token loss is a skewed Jensen–Shannon divergence with $\alpha=0.8$, leaning mode-seeking and bounded by $H(\alpha)$. The teacher is an EMA of the student ($\beta=0.05$), and the generator is either that EMA or the frozen base. There is no frozen anchor in the loss. Generation, filtering and training repeat for $N$ rounds. **The EMA teacher is the model that is evaluated.**

**Results** (Gemma 4 E2B and E4B; Qwen3-4B-Base in an appendix; three seeds, std ≤ 1.2):

- **Same data, three roles (Table 1).** This is the cleanest number for us. On E2B without thinking, the generated answers raise the three-benchmark average (MMLU, GPQA, HellaSwag; GSM8K is unscored without thinking) by +1.7 as an SFT target, by +1.0 as a GRPO reward (agreement with the answer), and by **+7.3 as teacher context**. The ordering holds in all four settings (2B/4B × thinking on/off), with one cell excepted.
- **Wrong answers (Table 5c, filters disabled).** With 75% of the candidate answers replaced by wrong ones, OPST loses 1.9 points on MMLU (42.7 → 40.8), while SFT loses 5.7 (38.8 → 33.1, which is 4.4 below base). OPST at 75% wrong lands about where it lands with no privileged information at all (40.6, Table 5b).
- **Privileged-information ablation (Table 5b).** None: +3.1. Placebo (a different problem on the same topic): +2.7. Answer only: +7.1. Rationale only: +8.3. Full: +10.2. The gain is sample-specific, and the rationale carries more of it than the answer.
- **Filters (Table 5a).** No filters: +5.2. Adding verification: +2.7 more. Adding the gate: +2.3 more.
- **EMA (Table 6a).** With $\beta=1$ (the teacher equals the current student) the gain is +0.6, essentially none. $\beta=0.05$ is best, and $\beta=0.01$ is too slow. The EMA beats the final student by 1.8.
- **Rounds (Table 6c).** The peak comes at 7 rounds (47.7). Accuracy holds at about 46 through 20 rounds, with no runaway.
- **Against supervision levels (Table 2).** OPST beats u-OPSD (Li et al. 2026, arXiv 2608.06296: curated questions, majority-vote answers as context) and R-Zero (self-play with RL) at every setting. With thinking, it matches supervised OPSD on curated data.
- **Out of domain (Table 3).** Mixed. ARC-C and Winogrande rise. MATH-500 falls by 4.9 when trained on all three topic sets, and by 8.5 on MMLU+HellaSwag topics. MMLU still rises by 5.1 with no MMLU topics at all.
- **Visual OPST.** From unlabeled images alone, VQAv2 rises by +6.9 at 2B.

**Caveats to carry into any citation.**
- The models are small.
- The headline +10.2 on MMLU is without thinking, on a base of 37.5. With thinking the base is 69.9 and the gain is +1.2. GPQA and GSM8K gains persist with thinking.
- The topic names are the benchmarks' category labels, so the in-domain numbers are aimed at the test distribution. The out-of-domain table is the honest test.
- No diversity, entropy or pass@$k$ measurements are reported, although the divergence leans mode-seeking.
- The authors' own limitation: "OPST can only amplify existing knowledge, and since pseudo-verification measures self-consistency rather than correctness, consistent errors still enter training."

## 2. Where OPST meets the essays

### 2a. *Who Teaches the Weights?*: a third case between grounded and ungrounded (high priority; publishes 28 Oct)

The essay says (§"The model with privileged context as teacher", at the end of the *Given and the Found* paragraph): "Without such context, self-distillation is the ungrounded case that essay warned about: a model regressed onto its own confident mistakes." The closing section says: "When the context holds no demonstration or feedback, there is nothing grounded to consolidate."

OPST is a direct test of these claims, and it qualifies them without refuting them:

- **The essay's reading wins the comparison it cares about.** Table 1 holds the data fixed and varies only its role, and context beats target and reward by a wide margin. This is the strongest evidence yet for "policy improvement done by reading".
- **The tilt predicts the robustness to wrong answers.** The teacher is the bare model tilted by the implicit value $Q_c$, so a hint the model finds implausible yields a small log-ratio, not a large wrong one. In *The Given and the Found* §6 terms, an ungrounded hint lowers the **amplitude** more than it flips the **sign**. The 75%-wrong run falling to roughly the no-hint level is what this predicts. (The authors' Appendix A.1 gives the same explanation in prose.)
- **The filter supplies weak grounding: agreement across contexts.** The kept answer has survived a fresh context and a rewording. That makes the teacher as reliable as the model's knowledge under several framings, and no more. It exposes what is latent (the essay's usable-information paragraph) and cannot correct a consistent error. So the essay's warning stands for consistent errors, while "nothing grounded to consolidate" is too strong.
- **Where does "knows more" come from, if nothing enters from outside? From authorship.** The generator wrote the question around an answer it already held, so its rationale runs from the fact to the question, while the student must run from the question to the fact. That is the asymmetry of Lampinen's in-context/fine-tuning comparison and of the reversal curse, already in Part 1 and Part 3. This is our reading, not the paper's. The ablation fits it: the rationale beats the answer, and the placebo is worth nothing.

**Draft insertion.** It replaces the last two sentences of the *Given and the Found* paragraph (from "Without such context…"), about 220 words:

> Without such context, self-distillation is the ungrounded case that essay warned about: a model regressed onto its own confident mistakes. A preprint from Google, [*On-Policy Self-Training*](https://arxiv.org/abs/2610.32770) (OPST), tests the space between the two cases. The model writes its own privileged context. Given only a topic name, it poses a question and writes a rationale and an answer. The sample is kept only if the model reaches the same answer again in a fresh context and after rewording the question. Nothing outside the model checks the answer. Yet the role it plays matters most. On Gemma 4 E2B, the same generated answers raised a three-benchmark average by 1.7 points as fine-tuning targets, by 1.0 as a GRPO reward, and by 7.3 as the teacher's context. With three-quarters of the answers replaced by wrong ones, the context route lost 1.9 points on MMLU and fine-tuning lost 5.7. The tilt says why. A wrong hint moves the teacher only as far as the model finds it plausible, so in that essay's terms it weakens the signal more than it reverses it. The agreement filter is a weak form of grounding: the answer must survive a change of framing. That makes the teacher as reliable as what the model already knows, and no more. The authors draw the consequence themselves: consistent errors still enter training. The next section shows what happens when the grounding is weak.

**Matching edit in the closing section.** "When the context holds no demonstration or feedback, there is nothing grounded to consolidate." → "When the context holds no demonstration or feedback, only what the model already knows is there to consolidate."

**Optional, in "A weak in-context learner is a weak teacher".** OPSD beat SFT on curated reasoning data at Gemma 4 E2B/E4B (Table 2), below the 3B size at which SDFT fell behind SFT. One sentence could note that the threshold depends on whether the skill is latent. On reasoning benchmarks it is; for SDFT's new tools and facts it is not. This is a hypothesis, so mark it as one or leave it out.

**Optional, in "A self-teacher is sharper…".** One clause: in OPST a teacher equal to the current student ($\beta=1$) produced no gain at all, while an EMA over about twenty steps produced the full gain. It is a second data point beside Zucchet–Linderman.

**Optional, one sentence where the narrowing is discussed.** OPST reports single-attempt scores only, with a mode-leaning divergence and no anchor, so whether it narrows the alternatives cannot be checked.

### 2b. *Where Experience Goes*, "The boundary": OPST constructs its own teaching conditions (high priority; publishes 2 Nov)

The paragraph "Some of this is already learned" lists SEAL, PowerPlay, novelty search and OMNI. Each of them builds teaching conditions under a condition given one level up. OPST is the cleanest instance in Part 1's terms. It manufactures "knows more" by authorship and "absorbable" through the consensus gate, which is PowerPlay's "simplest task the current solver cannot yet solve" done by sampling. What remains given one level up is the topic names, chosen by people (in the paper, the benchmarks' own labels), and the prior. Its only correctness test is the model's agreement with itself.

**Draft.** After the PowerPlay sentence:

> OPST, from Part 1, poses its own questions from a topic name and keeps those its student cannot yet answer consistently, so its curriculum moves with the student.

Then, in the list of conditions given one level up, after PowerPlay's:

> OPST's topics are named by people, in its experiments the category labels of the benchmarks it is scored on, and its only test of an answer is the model's agreement with itself.

If 2a is not adopted, introduce OPST here with its link instead of "from Part 1".

**Optional table row** (the EM table): "OPST | the student's samples, rescored by a moving-average copy holding a question and rationale it wrote itself | core weights; the moving-average copy is the model kept".

### 2c. *The Given and the Found* §6 (medium; already published, so this would go in a revision note)

§6 ends its first paragraph with: "Ungrounded self-distillation is the regime to fear." The amplitude/sign framework is right, and OPST sharpens it. The "ungrounded" case it warned about is a target that is the same computation's confident output. A target built from a *differently conditioned* computation, kept only where several conditionings agree, behaves differently. A wrong hint lowers the amplitude, and agreement across contexts sets the sign as reliably as the model's knowledge does. One or two sentences in the paragraph on what grounding does not prevent, linking Part 1, would cover it.

### 2d. *Learning About What You Do Not Do*, closing ("Neither line has crossed")

No change. That sentence is about the Horde and VPO lines, and Part 3's boundary section is the right place for OPST.

## 3. Dual Exam: what it does and what it found

**Setting.** "World Models" here are image and video generators acting as environment simulators: GPT-Image-2, Seedance 2.5, Qwen-Image-3.0, MiniMax H3 and others. They are not representations inside a language model. "Multimodal Agents" are frontier models in harnesses (GPT 6 Astra, GPT 5.6 Sol, Gemini 3.6 Flash, Qwen 3.8 Max, Kimi K3, DeepSeek V4.1 Flash, Seed 2.1 Pro…).

- **Coupled pilot.** GPT-5.6 Sol acting inside Seedance 2.5 had **0/150 task success** across ten scenarios. World-state consistency was 26.6%, and the agent's corrective response 9.2%. The trajectories could not say which side failed.
- **Design.** Each component is tested with the other held fixed. Agents act in fixed reference environments (1,088 items, 15 categories, physical/digital/social/scientific). World models receive fixed action interventions (400 cases, 8 scenarios).
- **Agents.** GPT 6 Astra leads with an Index of 31.3 (out of 100). Next come Sol (20.7), Gemini 3.6 Flash (20.1), Qwen 3.8 Max (20.0) and Kimi K3 (19.8). Manipulation peaks at 9.5 and desktop at 5.6. The ranking depends on domain weights: under equal weights, DeepSeek V4.1 Flash moves from 6th to 2nd. Failures: "locally correct elements may fail to form a valid solution". Examples include routes with nonexistent edges, and the right clips in the wrong order.
- **World models.** GPT-Image-2 leads the full-coverage Overall at 21.7. Web is ≤ 16.5 and Game ≤ 13.3 for every model. The illustrated failures are disturbances of state the action should have left alone: extra cups (Qwen-Image-3.0) and an unrequested red tray (MiniMax H3). **Rankings reverse by scenario**: GPT-Image-2 vs MiniMax H3 is 21.7 vs 17.3 overall, but 20.9 vs 53.8 on Embodiment. The authors conclude that "selecting an effective Agent–World Model pairing requires evaluation on the interactions the pair actually produces."
- **Packing case.** The task is to pack three items into the same blue backpack and carry it to the entryway. Midway, the generated scene substitutes a smaller blue pouch. The agent carries on, and none of four identity discrepancies receives a targeted response.
- **Self-declared gaps.** There are no copy-last-frame, no-op or shuffled-action controls, and no independent agreement estimate for the judge. The packing rubric was written after inspecting the trajectory. No repeated-run uncertainty is given.

## 4. Where Dual Exam meets the essays

### 4a. *Which World Model?*, closing evaluation section (medium)

The essay ends by asking to "measure separately whether the system knows the structure, tracks its state, selects useful actions, and retains corrections", and to "compare success with plausible shortcuts". Dual Exam is a first benchmark built on the "measure separately" principle, and the controls it says it has not run are exactly the shortcut comparisons the essay asks for. Its scenario reversals also give the title question a literal answer: which world model is best depends on which agent's states it must serve. This is the on-policy point of *Who Teaches the Weights?*, transposed to simulators (and the reason MBPO keeps model rollouts short). One clarification is needed. Dual Exam's world models are external generators, the $F(\hat s_t,a_t)$ of the essay's control-theory paragraph, not representations inside a language model.

**Draft paragraph** (after "Measure separately whether…"):

> A benchmark built on this principle appeared in October 2026. [Dual Exam](https://arxiv.org/abs/2610.31066) couples agents with generated environments, in which an image or video model renders the result of each action. A pilot that placed GPT-5.6 Sol inside the video model Seedance 2.5 completed none of 150 tasks, and its trajectories could not say which side had failed. The benchmark therefore tests each side with the other held fixed. Agents act in reference environments, and world models receive scripted actions. The world models' illustrated failures were not ignored actions but disturbed surroundings: an extra cup in a stacking task, a tray nobody asked for. That is the frame problem, rendered in pixels. Their rankings also reversed between scenarios, so a model's average says little about how it will serve the states one particular agent visits. The authors list the controls they have not yet run: copying the last frame, a null action, shuffled actions. Those are the comparisons with shortcuts that this section asks for.

### 4b. *Where Does Seeing Become Thinking?*, object-identity test (low; illustration only)

The packing case is a natural example of "tracking an individual versus matching its current appearance". The agent treated a blue pouch as the blue backpack. The evidence is a single case, audited after the fact, in a closed loop where the generator caused the swap, so it illustrates the question without testing it. If used, one sentence after the object-identity paragraph, with that caveat.

### 4c. Architectures-and-training outline §11 (low)

Dual Exam's ranking sensitivity to domain weights (V4.1 Flash moves from 6th to 2nd) and its explicit "model–harness configurations, settings not fully matched" support the bullet "Benchmarks across models cannot isolate an architectural change…". K3, Qwen 3.8 Max and V4.1 Flash appear in its leaderboard if a concrete example is wanted. OPST does not belong in this outline: it is small-model research, not a disclosed frontier recipe.

## 5. Not recommended

- No changes to *Which AGI?* or *What Breadth Reaches*. OPST's "amplifies only existing knowledge" fits them, but adding it would be a recap.
- Do not cite OPST's +10.2 MMLU without the thinking-mode caveat.
