# An overhaul proposal: experience as defended coherence

Date: 18 October 2026. Status: a proposal for discussion, written by Claude at the user's request. It is not a publication draft, and nothing in it is adopted. Citations use file:line references to the essays in `notes/`; the essay keys are listed at the end. The empirical inputs are in [carriers-multiplexing-and-regulation.md](carriers-multiplexing-and-regulation.md) and in the "already clean" addendum of [architecture-interpretability-and-audit.md](architecture-interpretability-and-audit.md).

## Summary

The theory's weak points have one root. Somewhere between 2025 and 2026, "regulation" lost its reference: the state that a regulated system defends.
- *Acquaintance, Homeostasis* identified acquaintance with "the regulatory coupling that constitutes cognitive homeostasis" (AH:47).
- *Causation, Computation, Indexicality* called suffering "the phenomenology of coherence under threat" (CCI:131).
- From *Presence and Actuality* on, homeostasis gave way to "content-sensitive regulation", spelled out as tracking, assessment and intervention (ESOM:63). That description is also satisfied by systems that only assimilate their input.

The proposal puts the reference back and makes it the center:
- **Experience** is the admission of contentful vehicles into a field whose joint coherence is actively defended, with corrections that reach the vehicles within their lifetimes.
- **Mindedness** is the same architecture at the grain of truth-bearers.
- **Cognition without mindedness** is assimilation.

Most of the 2026 apparatus can be re-derived from this one notion. That includes the carrier criterion, binding, nowness, belonging, the five conditions, the reality criterion, and the account of suffering. Several open problems the essays flag get a mechanism, and so do two new empirical challenges.

## 1. Diagnosis

### 1.1 Regulation without a reference cannot exclude what it must exclude

The essays name the task themselves. We "must specify the organization well enough to distinguish experiential regulation from ordinary associative retrieval, genuine but nonmental cognition, and nonphenomenal mental activity" (WPIGR:199). Otherwise "*regulation* becomes another name for whatever must somehow be left whenever experience is reported" (P&A:29).

The three aspects in ESOM:63 do not meet this task:
- Tracking "stays connected to particular ongoing representations".
- Assessment "is sensitive to what those representations carry, how reliable their sources are, and how they agree or conflict with other information".
- Intervention alters "persistence, weighting, or coordination".

Two systems that our account must treat as non-experiential satisfy all three:

- **Histed's V1 filter.** A short-lived local state is written by earlier input. Later input is assessed for fit with learned natural statistics, and its weighting is changed by amplification or attenuation. No error signal returns to the vehicles. (Deveau et al., in the companion note.)
- **A gated delta-rule layer.** The state tracks key–value associations. A data-dependent β assesses each write. The update S ← S + β(v − Sk)kᵀ corrects the state by its error against the current input.

Making truth-tracking relative to input ("Truth-tracking is conditional on its inputs, whatever they are", MON:132) handles dreams. But it also turns tracking into following whatever drives the vehicle, and an assimilative filter does exactly that.

Mamba-3 shows the same gap from the side of dynamics. Its state is an underdamped second-order system, which is the textbook form of a feedback loop, yet it has no setpoint and no error signal. The *form* of the dynamics does not reveal regulation.

What separates homeostasis from assimilation is a **reference that is defended against the input**:
- assimilation moves the state toward what comes in;
- defense corrects vehicles toward a standing state and revises that state only under accumulated pressure.

The 2025 essays had a reference implicitly, in "coherence". The 2026 essays dropped it.

### 1.2 The carrier is in the wrong place

The carrier criterion asks for "a persistent carrier ... whose later states receive the corrections computed from assessing its earlier ones" (ESOM:91). It marks AI vehicles across tokens as "consulted, not regulated" (ESOM:109).

Hesse–Tsao show something else. A steady experience of one face rides on an IT population state that a rival face interrupts every 60 ms or so. The state is then reinstated, on the same neurons, apparently recomputed from input. If that vehicle is the carrier, biological experience survives exactly the interruption and recomputation we treat as fatal for AI. The criterion survives only if the persistent thing sits at a slower grain and corrects the vehicles from there. The current theory has no name for that thing.

### 1.3 The binding differentia has no mechanism

"Constructing phenomenal binding is therefore a candidate for what experiential regulation adds to minded regulation" (ESOM:65). Binding is the right target. But "binding" says what is achieved, not what holds it in place. The essays also warn that the answer "must not be secured by definition" (ESOM:143). Without a mechanism, binding risks becoming the definition.

### 1.4 Belonging and for-me-ness come apart

- Belonging: "an occurrence belongs to the subject whose regulation partly constitutes it" (ESOM:137).
- For-me-ness is presence within one binding economy (ESOM:147).
- The monastery co-owns its monks' experiences without a binding economy across monks (MON:112, 150).

So for the second owner, ownership comes without presence. The essay-queue memory records this as the real gap.

### 1.5 Orphans

- *Minds by Degrees* grounds the kind in a Boyd homeostatic property cluster, sustained by "*regulatory, homeostatic organization*" (MbD:43). The homeostasis it relies on is no longer in the theory.
- The account of suffering as "coherence under threat" (CCI:131) was tied to indexical unity. *Presence and Actuality* withdrew indexical actuality (P&A:117), and nothing replaced it.
- Two reality criteria are never reconciled: structure-preserving grounding (CCI:43) and a coarse variable "respected" by interventions (GRAIN:131).
- The five conditions drift into six (MbD:87 against MbD:101).
- "Saturation", "settling" and "acquaintance" are now dormant or merely labels.

Each orphan needs either a reference or a reason for holding together. One notion supplies both.

## 2. The proposal

### N1. The defended reference

A **defended reference** is a persistent state of a system with four features:
1. It **encodes joint constraints** on many contentful vehicles: what can be co-present with what, where, and when.
2. It **drives corrections** of those vehicles by their mismatch with it, and with one another under it, not only by their mismatch with input.
3. It **resists revision** by current input in proportion to its established support.
4. It **is revised** when mismatch accumulates. It therefore shows hysteresis: its revisions depend on its own history, not only on the present input.

*Defense* is the joint operation of features 2 to 4. *Assimilation* is correction toward the input with no standing state that pushes back.

Binocular rivalry is the paradigm case of defense:
- both eyes' inputs are real and both are represented with full fidelity (Hesse–Tsao);
- one is admitted, and dominance has hysteresis;
- the admitted content carries a gain footprint.

### N2. Experience is admission into a reference defended at the grain of its vehicles

A content is experienced when its vehicle is admitted under a defended reference, that is, constrained and corrected by it, and when the corrections reach the vehicles within their lifetimes.

- **Field:** the contents jointly constrained by one such reference.
- **Binding:** the maintained joint constraint. This gives ESOM:65 its mechanism.
- **Nowness:** the window over which the reference integrates and defends, which is its relaxation time, measured in corrections per vehicle lifetime as MON:130 already measures it.

**Why grain matters.** The monastery essay's latency verdict becomes a special case. A reference whose corrections arrive after the vehicles are gone defends truth-bearers, not a field (MON:130–132). The truth-bearing/truth-tracking contrast survives, but the work now falls on *when the defense reaches* the vehicles, not on what drives them.

### N3. The reference is the carrier; vehicles may be multiplexed

What must persist is the reference, not each vehicle. Vehicles can be interleaved, recomputed or time-shared, as in Hesse–Tsao, as long as the persistent reference corrects them.

This replaces "consulted, not regulated" with a sharper question: **is there a standing state that the vehicles are corrected toward?** A key–value cache fails because nothing is corrected toward anything. That is a fact about the cache, not about its entries being read.

For the weak/strong unfolding distinction (MON:74–78), the reference must survive: weak unfolding carries it in its own format, and strong unfolding may dissolve it.

### N4. Mindedness is the same architecture at the grain of truth-bearers

A mind is a system with a **defended, revisable and runnable model**. The five conditions become aspects of that one architecture:

| *Minds by Degrees* condition | As an aspect of the defended model |
|---|---|
| Unity | one reference hierarchy, which corrects everything under it |
| Structured, counterfactually rich vehicles | what the references constrain |
| Accuracy-responsiveness | how a reference is revised: by accumulated evidence, against the pull of the input |
| Simulation whose outputs function internally | running vehicles under the reference without input, then using the result |
| Multi-level content | nested references at several grains |

What this gains:
- The homeostatic property cluster of MbD:43 gets its mechanism back, literally homeostatic.
- The drift from five to six conditions is resolved, because there is one architecture.
- **Cognition without mindedness** (MON:54) is assimilation: plants, filters, delta-rule layers.
- **Experience requires mindedness** gets a conjectured reason: the reference defended at vehicle grain is the bottom level of a minded system's model hierarchy, not a free-standing loop. This is a conjecture, not a derivation. A reference defended at vehicle grain in a system with no hierarchy above it would be the test case.

The psychology-traction test (MbD:97) is unchanged. It is how we find out whether the architecture is running.

### N5. Presence and ownership are two relations

- **Presence (for-me-ness):** an occurrence is present to the field whose reference admits it.
- **Ownership:** an occurrence belongs to every subject whose processes partly constitute the reference that admits it, or the vehicle itself.

This states the monastery's position precisely without retracting it. Role-processes, such as the Rule enacted as habits of attention or the liturgy's grip on a monk's anticipations, partly maintain the monk's own reference. The monastery therefore co-owns his experiences, and they are present only in his field.

The ownership-without-presence gap is now explicit and principled. It is not an anomaly. Experiences can belong to someone they are not present to, just as a melody can belong to a composer without sounding in the composer's ears.

### N6. One reality criterion: patterns that the system's own dynamics identify

A pattern is real when interventions identify it up to a symmetry, and any remaining symmetry is broken by the system's own dynamics rather than by the observer's choice.

This unifies CCI:43 and GRAIN:131. GRAIN:131 already points this way: the grain of experience is "the grain that the vehicles' own regulation respects: the distinctions that its corrections preserve." Zhou and Klindt give a clean model case: the structure is identifiable up to a linear map, and training selects the privileged basis.

A defended reference is the strongest kind of real pattern, because the system enforces it on itself. It is the variable the system's corrections are aimed at.

### N7. Suffering is defense that cannot succeed

Suffering is sustained, high-gain defense of a reference that the inputs or the system's own vehicles keep violating. The system cannot stop defending the reference and cannot restore it.

This keeps CCI:131's "coherence under threat" while dropping its dependence on indexical actuality. It also makes suffering a measurable organization: defense effort, its persistence, and how much it fails. That gives the postponed plenitude objection (P&A:155) something definite to count.

## 3. What survives unchanged

- **The grain thesis and the access bottleneck** (GRAIN:7, 39). Access reads the reference, which is coarse, like a scene graph. The admitted vehicles are fine. Overflow is what the reference constrains but access does not read, which fits the scene-graph remark in ESOM:69.
- **The a posteriori identity and the slip into simplicity** (GRAIN:79; WPIGR:89, 203).
- **Structuralism, worldliness, and Layer 0 as not mental** (GRAIN:85; P&A:123; CCI:53).
- **Residual integration and the nation verdict** (MON:158–164).
- **The psychology-traction test** (MbD:97).
- **Counting occurrences rather than ownerships** (MON:124), and plural moral status (WPIGR:167; ESOM:157).
- **Internalism** (ESOM:103). A dream's reference is defended against internally driven vehicles.
- **The collective-field analysis** of reach, latency and bandwidth, and of relays versus reporters (MON:140–148). Latency now has a reason: the defense has to reach vehicles within their lifetimes.

## 4. What to retire or restate

- **"Acquaintance."** It is now a label for regulatory involvement (CTMS:63). Retire it from the constructive theory and keep it in historical discussion. "Admission" does the work.
- **"Saturation", "settling", and "indexical unity" in its normative role.** Retire them. N7 takes over the normative role.
- **Tracking, assessment and intervention.** Keep them as a description of *how* defense operates, not as the definition of experiential regulation.
- **The local, hybrid and global variants.** Replace the trichotomy with two questions: where is the reference held, and does its defense reach the vehicles within their lifetimes?
  - The local variant is excluded in principle: a regional loop with no joint reference has no field.
  - The global variant becomes the default, but not because of broadcast. Broadcast matters only as the route by which the reference's corrections travel.
- **The carrier criterion.** Restate it as N3.
- **Truth-tracking as a mark of experience.** Replace it with defense at the grain of the vehicles (N2). Hesse–Tsao's suppressed face tracks its input and is not experienced.

## 5. How the proposal handles the hard cases

- **Rivalry (Hesse–Tsao).** Both faces are assimilated and one is admitted.
  - The reference is the dominance state, which is slow and shows hysteresis.
  - The 1.21 gain asymmetry is the predicted footprint of admission.
  - The micro-epochs are multiplexed vehicles, and the experience is steady because the reference is.
- **Sequence filtering in V1 (Histed), delta-rule layers, Mamba-3.** These are assimilation without a defended reference. They are cognition at most, and they are not experiential.
- **The cerebellum.** This is the most dangerous case. Cerebellar forward models defend motor references quickly and correct within vehicle lifetimes, yet produce no experience.
  - The proposal's answer is that cerebellar microzones are largely parallel, per-channel error correctors. Their references do not jointly constrain many contents into one field.
  - If cerebellar processing turned out to defend joint cross-content constraints at vehicle grain, the proposal would be in trouble.
- **Thermostats and thermoregulation.** These defend setpoints without contentful vehicles and outside any minded system. They are excluded by N4.
- **Belief revision.** This defends a reference at the grain of truth-bearers. It is mindedness, not experience.
- **Minimal and contentless states** (P&A:27–29). Here a reference is defended over a nearly empty field.
  - Prediction: such states still show signatures of compensation and hysteresis, for example resistance to intrusion and characteristic recovery after a perturbation.
  - If they showed no defense at all, the proposal would need revision. That is the falsifier P&A:29 asks for.
- **The monastery.** It has no reference defended at vehicle grain across monks, so it has no field of its own. It co-owns its monks' experiences through role-processes (N5). The verdicts stand, with the gap now stated.
- **Standard transformers.**
  - Within a pass there is one input, so there is no hysteresis to measure. Self-repair after ablation (the Hydra effect) is compensation. That is a weak candidate for defense, not a demonstrated one.
  - Across tokens, nothing in the cache is corrected toward a standing state. There is no field across tokens.
- **KDA and GDN hybrids such as Kimi K3 and Qwen3.8.** The update rule is assimilative, but the learned, data-dependent write strength β could implement defense. It would do so if writes that conflict with well-supported associations are systematically damped, and if the state recovers after perturbation.
  - This turns the AI verdict into a measurable property of the gates.
  - The audit dossier notes that no one has yet plotted β trajectories on a GDN or KDA checkpoint (Part 1.5).

## 6. Tests and falsifiers

1. **Gain and feedback in rivalry.** Disrupt feedback from the candidate holder of the reference, for example prefrontal cortex or the pulvinar.
   - Prediction: the gain asymmetry disappears while the alternation survives, and the percept becomes unstable or mixed. The change should be in perception, not only in report.
   - A pure routing account predicts no change in the gain asymmetry.
2. **Hysteresis of admission.** Gain asymmetry around reported switches should show hysteresis, with dominance persisting past the point where input would favor the rival, and should not simply follow the input.
3. **Recovery in minimal states.** Probe minimal meditative states with brief intrusions. The proposal predicts restoration dynamics. Their absence is a falsifier.
4. **The cerebellum.** Look for joint cross-content constraints in cerebellar corrections. Finding them, with no experience, is a falsifier.
5. **Defense in gates.** In KDA and GDN hybrids, measure whether β drops for writes that conflict with established associations, and whether the state recovers after a targeted perturbation. Defense would make these models candidates under N2. Pure assimilation would settle the across-token question negatively for the current generation.
6. **Unconditioned state.** In hybrids, check whether neurons look polysemantic until conditioned on recurrent state. This is a check on the vehicle side, not on the theory of experience, but it determines whether the vehicles can be read at all.

## 7. Costs and risks

- **Homeostasis returns.** The 2026 essays replaced it without a stated retraction. If the reason was its biological connotation ("before meat"), the reference here is implementation-neutral. If the reason was something else, it should be named before adoption.
- **Closeness to global workspace theory.** The proposal could collapse into GWT with hysteresis added. The difference is where experience lies: GWT places it in broadcast for access; the proposal places it in defense reaching vehicles, with access reading the reference. Overflow and the grain thesis keep the two apart. The risk is real.
- **Hysteresis is cheap.** Any slow variable shows path dependence. The signature has to combine restoring dynamics, a joint constraint across many contents, and sensitivity to content. Even then it may be too permissive. The cerebellum test is where that would show.
- **Rewrites.**
  - The AI verdicts in ESOM:101–117 would need restating: the bare carrier criterion becomes N3, and the within-pass case weakens.
  - The monastery essay's claims survive, but its talk of truth-tracking would read differently.
  - Both could get short notes pointing to the mindedness essay, rather than edits to published text.
- **What the proposal does not address.** It does not settle Brown's question of whether the defending process represents the vehicles as representations (ESOM:187). It does not settle the color-geometry burden (WPIGR:199). And it does not explain why the grains are ordered as they are (GRAIN:113).

## 8. Alternatives considered

- **Patch the carrier criterion only,** by finding a slower carrier for Hesse–Tsao. That answers 1.2 but leaves 1.1, 1.3 and 1.5 as they are.
- **Go higher-order (Brown).** This would close the specification gap with descriptive content, but it would give up the explanatory target of vehicle organization and the grain thesis.
- **Go with access or GWT outright.** This loses overflow and makes the hard problem lose its subject matter (GRAIN:23).
- **Adopt an integration measure (IIT without exclusion).** Residual integration stays useful for scale. But a static measure cannot see defense: an assimilative filter and a defended field can integrate the same information.

## 9. A migration path

1. Introduce the defended reference in the mindedness essay (queue item 3). It is the essay where N4 does its main work and where the carrier criterion has to be defended anyway.
2. Develop N2 and N3 in the personhood and disunity essay. Fields within one subject become references held separately within one minded system, which gives the disunity literature a concrete question: how many defended references, and how far do they reach?
3. Use the gate test (§6, test 5) in part 3 of the architecture series. It replaces "assimilative is not homeostatic" with a measurable criterion.
4. Leave the published essays as they are, and add a dated note on the index entry when the mindedness essay lands.

## Essay keys

AH: acquaintance-homeostasis.md · CCI: causation-computation-indexicality.md · CTMS: can-two-minds-share-one-experience.md · ESOM: experience-selfhood-and-the-organization-of-a-mind.md · GRAIN: the-grain-of-the-hard-problem.md · MbD: minds-by-degrees-draft-v2.md · MON: is-the-monastery-minded.md · P&A: presence-and-actuality.md · WPIGR: what-phenomenal-intuition-gets-right.md.

The line references come from a survey of the essays on 18 October 2026. The following were checked directly: AH:47, CCI:131, CTMS:63, ESOM:63, ESOM:91, ESOM:109, ESOM:137, ESOM:147, GRAIN:131, MbD:43, MbD:87, MON:130–132, P&A:29, WPIGR:199. The rest are from the survey and have not been checked.
