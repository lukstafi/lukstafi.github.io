# Carriers, multiplexing, and regulation: three papers

Research date: 18 October 2026. Status: a research note for the mindedness essay and the architecture series. It is not a publication draft. It extends the "already clean" addendum of [architecture-interpretability-and-audit.md](architecture-interpretability-and-audit.md), and it uses that dossier's evidence labels (Confirmed, Reported, Inferred).

Three papers bear on three of our commitments:

- the carrier criterion of *Experience, Selfhood, and the Organization of a Mind*;
- the claim that binding into a field is what experiential regulation adds;
- the assimilative-versus-homeostatic thesis proposed for the architecture series.

They also add a source of apparent polysemanticity that the interpretability debate does not consider.

## Sources

**Hesse, Lanfranchi, McGrory, Shi, Engel, and Tsao, [*Rapid alternation of conscious and suppressed stimulus representations in the primate brain*](https://doi.org/10.64898/2026.10.15.759299)** (bioRxiv, 16 October 2026).
- *Setup.* Two rhesus macaques and 19 sessions, with Neuropixels recordings of about 400 simultaneously recorded cells. Regions: the face patches ML and AM in inferotemporal cortex (IT), and the prefrontal face regions PO and PVL. Paradigm: binocular flash suppression with 1,500 faces.
- *Alternation.* With the stimulus and percept held constant, the population alternates between a state that represents the dominant (flashed) face and one that represents the suppressed face.
  - Median dwell is 64 ms and 59 ms. The likelihood autocorrelation has a 67 ms time constant, roughly 15 alternations a second. Perceptual switches run at about 0.5 Hz.
  - The two states take up about equal time.
- *Each state is a clean representation.* Each reinstates the code an unambiguous presentation evokes. Modulation slopes are 0.93 and −0.76 in the two states, against 0.23 for the time average.
  - Faces reconstructed from either state exceed 80 percent explained variance for some features.
  - The same neurons carry both faces: gain correlates across states at r = 0.90.
  - The result holds with held-out neurons, rules out between-trial explanations, and survives shuffled templates and an On–Off excitability model.
- *Asymmetries.* Tuning gain is 1.21 times higher in the dominant-face state, and a linear decoder separates the states 66 percent of the time.
- *Coordination.* Switching is weakly coordinated between ML and AM; the authors say the data "do not provide strong evidence for coordination across patches". Prefrontal cortex shows the same interleaving.
- *Report.* The monkeys made no report. The percept was checked in 14 human participants.
- *The authors' reading.* "Conscious access requires temporal selection beyond localization". The dominant state may be the one routed to report and control. Suppressed states may "explore alternative interpretations of the visual input, without being broadcast".

[Confirmed: main text, discussion and part of the figure legends read, pp. 1–18; Methods and Extended Data not read]

**Deveau, Zhou, LaFosse, Deng, Mirbagheri, Steinmetz, and Histed, [*Recurrent cortical networks encode natural sensory statistics via sequence filtering*](https://www.biorxiv.org/content/10.1101/2024.02.24.581890v2)** (bioRxiv v2, September 2024). A citation gives the published version as *Neuron*, DOI 10.1016/j.neuron.2025.12.024; that version was not accessed and the DOI is not verified.
- *Setup.* An all-optical study in mouse V1, layer 2/3. Patterns of 15 to 30 excitatory cells are stimulated by two-photon holography while the network is imaged.
- *Order matters.* A fixed pattern evokes different responses depending on the patterns before it (ABC versus CBA).
- *Natural context matters.* A movie frame's activation pattern, played back at the right moment in the movie, is amplified. At the wrong moment it is attenuated.
- *Mechanism.* An earlier pattern drives non-target cells, and suppressed responses last about 225 ms. Those responses change how later patterns are received, sometimes nonlinearly. Sequences designed from this mechanism were amplified or attenuated as predicted.
- *The authors' reading.* Predictive processing "without explicit error or mismatch signals", and part of the answer to "What does the other 85% of V1 do?"

[Confirmed: main text and discussion read, pp. 1–12; six experiments for the core result]

**Liang and Song, [*Understanding Mamba-3 Through Oscillatory Dynamics*](https://arxiv.org/abs/2610.13341)** (Tsinghua, October 2026).
- *Theory.* Mamba-3's decay-and-rotation transition is the exact flow of an underdamped second-order system, with damping ratio ζ = a/√(a²+ν²) < 1.
- *State tracking.* The underdamped variant solves parity and mod-3 (scaled accuracy 100 and 95). Overdamped, critically damped and non-rotating variants with the same state structure fail.
- *Phase removal.* Removing the rotation from pretrained 1.5B models raises PG-19 perplexity at 64K from 20.6 to 851. These models were trained with the rotation, so the intervention is out of distribution.
- *From-scratch training.* At 187M and 444M the gains are modest, and the authors say oscillation "is not required for stable length extrapolation".
- *Mechanism.* Rotation lowers the cosine similarity between retained history and incoming writes (0.29 against 0.47) and lowers the state norm.
- *Appendix.* DeltaNet and Gated DeltaNet are overdamped or non-oscillatory. Complex KDA and Momentum DeltaNet can be underdamped under stated conditions.

[Reported: about 100,000 of 122,000 characters read through a summarizing fetch; the end of the appendix not read]

## Findings

### F1. Hesse–Tsao against the carrier criterion

*Experience, Selfhood* measures nowness structurally: "What carries over is structural: how many corrections a carrier undergoes, and whether it persists through them." It denies experience across tokens to standard transformers because "Earlier vehicles are consulted, not regulated". It holds that "a session recomputed from its transcript starts a new carrier".

In Hesse–Tsao, a steady experience of one face rides on an IT population state that a rival face interrupts every 60 ms or so. The state is then reinstated, on the same neurons, apparently recomputed from continuous input. If that state carries the experience, biological experience survives exactly the interruption and recomputation that our AI verdicts treat as fatal. [Inferred]

The criterion survives only if the persistent carrier sits at a slower grain. Candidates:
- the dominance state, which lasts seconds;
- a working-memory scene graph, which *Experience, Selfhood* already invokes for overflow.

That carrier would have to send corrections down onto the interleaved IT states. This makes a prediction: the 1.21 gain asymmetry is the footprint of those corrections.

If the slower state turns out to be only a statistical bias in repeated recomputation, with nothing persistent receiving corrections, then the carrier criterion fails as a condition of experience. The verdicts that rest on it fall with it. [Inferred]

### F2. Binding has no synchronous signature yet

If global corrections bind the field, the dominant-face states should line up across the areas that carry the same face. ML and AM barely line up. The authors frame this as an absence of strong evidence, and the cross-patch analysis is noisy. They do not report whether IT and prefrontal states line up. Still, this was the first dataset that could have shown such a signature, and it did not. [Reported; Inferred]

### F3. Two markers do no distinguishing work

The suppressed face is held at the same resolution as the dominant one, and it tracks its driving input moment by moment. Two of our markers therefore fail to separate experience from its absence:
- the resolution beyond access that *The Grain of the Hard Problem* points to;
- the moment-by-moment truth-tracking that *Is the Monastery Minded?* contrasts with truth-bearing.

Both were used only as necessary conditions, so the monastery argument stands. Neither can be offered as a mark of experience. [Inferred]

### F4. What the paper supports

- **Momentary-state views fail.** On such a view, the content of experience at a time is the content of the neural correlate at that time. The experience is steady while the top-level content flips about 15 times a second. A view on which the phenomenal now is temporally thick predicts this.
- **The local variant loses ground.** The suppressed face gets a coherent, coordinated, high-fidelity local representation, yet humans report not seeing it. Local recurrence is present and experience is absent, unless one takes Block's route of phenomenality without access.
- **The one asymmetry is the right kind.** In *Experience, Selfhood*, intervention alters "persistence, weighting, or coordination", and gain is weighting. The effect is small.

[Inferred]

**The labels are a caveat.** "Conscious micro-epoch" is the authors' label, not a measurement. The two states take up equal time while the experience is all one face, so no single state has been shown to be conscious. The label already assumes a momentary-state reading.

### F5. Unconditioned state as a source of apparent polysemanticity

In Histed's V1, a neuron's response to a fixed input depends on the network's recent history. Read as a fixed feature detector, such a neuron looks mixed and leaves variance unexplained. Conditioned on the state, it does not.

In Hesse–Tsao, each face cell carries two faces with the same tuning, and which one depends on time.

So Cammarata's list of causes of apparent polysemanticity needs a sixth item: unconditioned state. It arises only in systems with recurrence. [Inferred]

Prediction for the architecture series: in Kimi K3 and Qwen3.8, MLP neurons downstream of KDA or GDN layers should look more polysemantic than comparable neurons in dense transformers. Conditioning on the recurrent state, or on the recent write history, should recover cleaner tuning. Neither side of the Cammarata–Nanda exchange considers this. [Inferred; untested]

### F6. Local recurrence that filters without regulating

Histed's V1 circuit works like this:
- earlier inputs write into a short-lived local state;
- later inputs are amplified when they fit learned statistics;
- no error signal returns to the vehicles.

That is assimilative filtering. Structurally, it is closer to a gated recurrent layer than to the tracking, assessment and intervention of *Experience, Selfhood*. It is a second empirical case of local recurrence without the regulation our account calls experiential. [Inferred]

### F7. Three ways to multiplex contents in shared units

| Dimension | Mechanism | Case |
|---|---|---|
| Space | separate neurons, or dictionary directions in a shared space | the Cammarata–Nanda debate; SAEs |
| Time | alternation in separate epochs | Hesse–Tsao's 60 ms states |
| Phase or state | rotation that keeps writes apart; dependence on history | Mamba-3's underdamped modes; Histed's V1 |

Interpretability tools mostly assume the first row. The other two predict that units look polysemantic until they are indexed by time or state. [Inferred]

### F8. Dynamical form is not regulation

Damping ratios and underdamped responses are the textbook vocabulary of feedback control. A thermostat's closed-loop response is second-order *because of* its feedback. Mamba-3's second-order form is built into the transition matrix: it has no setpoint and no error signal. Liang and Song's phrase "regulating how information accumulates" describes the unforced dynamics.

So the paper shows that the dynamical signature of regulation (bounded accumulation, damping, oscillation) can be had without regulation. [Inferred]

Two independent axes, then:

| | Error-driven | Not error-driven |
|---|---|---|
| **Oscillatory** | Complex KDA (conditions stated) | Mamba-3 |
| **Not oscillatory** | delta rule: DeltaNet, GDN, KDA | Mamba-2, linear attention |

The delta rule computes an error: S ← S + β(v − Sk)kᵀ moves the state toward the current key–value pair. That is correction toward the input, which is assimilation. None of these layers has a setpoint that the system defends against disturbance, and homeostasis needs one. So the architecture series' candidate thesis, that assimilative correction is not homeostatic regulation, now has a sharper criterion: whether there is a defended reference, not the form of the dynamics. [Inferred]

## Tests these findings suggest

1. **Feedback and the gain asymmetry.** Disrupt feedback from the candidate slower carrier, for example by inactivating prefrontal cortex or the pulvinar.
   - Our account predicts that the 1.21 gain asymmetry disappears while the alternation survives, and that the percept changes, not only the report.
   - A pure routing account needs no gain asymmetry at all.
2. **Gain around perceptual switches.** The asymmetry should flip with, or just before, a reported perceptual switch, and should not lag it.
3. **Neurons conditioned on state in hybrids.** Compare neuron cleanliness in KDA hybrids with and without conditioning on recurrent state (F5).
4. **A defended reference in recurrent layers.** Perturb a delta-rule state and check whether later updates restore a value that is fixed by something other than the current input. Assimilation predicts that they do not.

## Open work

- Read Hesse–Tsao's Methods and Extended Data. Is IT–prefrontal coordination of states reported? How were the states defined in prefrontal cortex?
- Read the *Neuron* version of Deveau et al. and check the DOI.
- Read the end of Liang and Song's appendix on KDA and Complex KDA.
- Find out whether any of the seven frontier checkpoints uses complex-valued or rotating recurrent state.
