# Literature check for §8–§9 of the mindedness outline (the carrier)

Date: 18 November 2026. Checks the † citations in `mindedness-essay-outline.md` §8–§9 and in `carriers-multiplexing-and-regulation.md` (CAR).

Labels: **Confirmed** (primary read; "abstract" or "record" where only that much of the primary could be read), **Reported** (secondary only), **Not found**. Publisher and PMC PDFs refused automated download, so several classics rest on PubMed abstracts and Crossref records. Figure readings are marked "≈".

## 1. Hesse et al. 2026

Hesse JK, Lanfranchi FF, McGrory C, Shi Y, Engel TA, Tsao DY. "Rapid alternation of conscious and suppressed stimulus representations in the primate brain." bioRxiv 2026.10.15.759299, v1, 16 Oct 2026. https://doi.org/10.64898/2026.10.15.759299. **Confirmed**: all 50 pages read, including Methods and Extended Data Figs 1–10.

**(a) Rhythm.**
- No spectral analysis, no LFP analysis, and no analysis of saccades or microsaccades. Gaze was tracked at 1000 Hz, and trials with at least 90% fixation were kept.
- The log-likelihood-ratio autocorrelation (Fig. 2d) decays to a zero-crossing near 90 ms, with no side lobe out to 200 ms. It is fitted as a symmetric two-state Markov chain, and the dwell analysis is a hidden Markov model whose only free parameter is a 2×2 transition matrix. Dwell-time distributions are not shown. So the switching is modelled as memoryless, and rhythmicity is untested. A rhythm near 8 Hz would put a trough near 60 ms and a peak near 120 ms in Fig. 2d (my inference), and neither is visible.
- The alternation is independent of On–Off excitability fluctuations (Cohen's κ ≈ 0).
- The "67 ms time constant" of the main text is, in Methods, the fitted *mean dwell* D of the Markov chain. The authors derive a median dwell of "D·ln2 ≈ 46 ms" and call that "approximately matching" the HMM medians. "15 Hz" is 1/D, the rate of state changes, so each state recurs about 7.5 times a second. The HMM medians with exponential dwells give about 11 changes and 5.5 recurrences a second (my inference).

**(b) Coordination.**
- Inferotemporal–prefrontal: not reported anywhere. Prefrontal states were inferred from prefrontal neurons and templates alone. The paper does not say whether prefrontal and inferotemporal recordings were simultaneous ("We repeated the flash-suppression experiments in prefrontal cortex").
- ML–AM: states inferred in one patch, faces reconstructed from the other, 7 of 9 sessions. Significant (p = 3×10⁻⁴ and p = 9×10⁻⁶), with low explained variance and one condition reversed. Quote exact: "do not provide strong evidence for coordination across patches".
- The headline "coordinated" analyses infer states from ML and AM neurons pooled and hold out a random half, so they do not separate within-patch from between-patch coordination.

**(c) Carry-over between dominant epochs.** Nothing bears on it. Stimuli are static images. Both state templates are fixed vectors taken from priming trials. No analysis compares successive epochs of the same state. Tuning axes in each state match the priming axes close to the noise ceiling, which shows the same code and is silent on recomputation versus carry-over.

**(d) Areas.** Only ML and AM (inferotemporal), PO (orbitofrontal) and PVL (ventrolateral prefrontal). Nothing below ML.

**(e) Re-verification.**
- Confirmed: HMM median dwells 64 and 59 ms; gain ratio 1.21; decoder 66%; states "occupied about equally"; two macaques; 19 sessions (10 with a 10-stimulus set, 9 with 1,500 faces); 14 human participants (flashed percept reported on 82% of binocular trials, against 87% for unambiguous priming).
- "About 400 cells": 429 in the example session, in ML and AM only. Totals: 3,501 visually responsive inferotemporal neurons and 661 prefrontal.
- Quotes exact. The first is mid-sentence ("indicating that conscious access requires…"). The second begins "Speculatively," and continues "or influencing behaviour".
- ~0.5 Hz perceptual switching is a literature value, not measured here.

**New facts that matter.**
- *Circularity.* "Over 80% explained variance for some features" comes from the analysis the authors themselves call circular, and is stated for the conscious face; the suppressed face was "high, albeit slightly lower". Cross-validated: per-session medians ≈ 10% (conscious) and ≈ 5% (suppressed) against ≈ 58% for priming (ED Fig. 4); pooled ≈ 45% and ≈ 32% (ED Fig. 10d).
- *Gain confound.* The suppressed face is always the one already shown for 1–2 s, and the dominant face is newly flashed. No adaptation control is reported. Hesse and Tsao 2020 (eLife 9:e58360) wrote of flash suppression that "any modulation observed may be driven entirely externally". Mean firing rate is slightly *higher* in the suppressed state.
- *Noise floor.* During monocular priming ≈ 25% of bins go to the absent face's state (Fig. 2c).

**(f)** No published version: the bioRxiv API lists v1 only, "published: NA" (18 Nov 2026). Press coverage only; scholarly commentary or reply: **Not found**.

**Outline needs correcting:**
- §9 Setup: "about 400 cells recorded at once in two face patches … and two prefrontal face regions" is wrong. About 400 were simultaneous in ML and AM.
- §9 and CAR: "67 ms time constant" should read "fitted mean dwell of 67 ms".
- §9 "Is this a synchrony account?": no rhythm is shown, the model is memoryless, and neither LFP nor eye movements were analysed.
- CAR F1 and §9: "apparently recomputed from continuing input" has neither support nor counter-evidence in the data.
- CAR "Sources" ("Faces reconstructed from either state exceed 80 percent"), CAR F3 and §8 P5 ("tracked at full resolution"): overstated. The suppressed code is the same code at lower fidelity and gain, and the 80% is circular. "Tracks its input moment by moment" is not shown, since the images are static.
- §9 option 1 and CAR test 1: the gain asymmetry cannot yet be read as a footprint of corrections or of attention. Adaptation of the older stimulus predicts it without feedback.
- "Barely line up" overstates "weakly coordinated"; the cross-patch effect is significant.

## 2. Prinz, the AIR theory

Sources. Prinz JJ, *The Conscious Brain: How Attention Engenders Experience*, OUP 2012 (not accessed; page-cited quotations via Mole C, review, *NDPR* 2013.01.01, read in full: **Reported**). De Brigard F, Prinz J, "Attention and consciousness", *WIREs Cognitive Science* 1(1):51–59, 2010, doi 10.1002/wcs.27 (**Confirmed**, read in full). Prinz's 2011 chapter (in Mole, Smithies and Wu, *Attention*, OUP, pp. 174–204) was not accessible.

- *Statement.* "Consciousness arises when and only when vectorwaves that realize intermediate-level representations fire in the gamma range, and thereby become available to working memory" (p. 293).
- *Attention.* "attention can be identified with the processes that allow information to be encoded in working memory" (p. 93). De Brigard and Prinz: attending is "a means by which information from the perceptual systems becomes available to working memory. Top–down, bottom–up, focal, or diffuse, availability to working memory is always involved." Attention "does not guarantee encoding in working memory". (**Confirmed**)
- *Intermediate level.* Jackendoff's level, Marr's 2½-D sketch: viewpoint-retaining, integrated "surfaces and shapes oriented in specific ways at various distances from us" (p. 52). **Reported** (Ota K., Kyoto University repository, in Japanese, summarizing Prinz 2000, 2005, 2007): V1 is low-level; V2, V3, V4 and V5/MT are intermediate; inferotemporal TE and TEO are high-level, with viewpoint- and size-invariant content, a seen face being the example. So for faces the intermediate level is view-specific contours, colours and surfaces in extrastriate cortex. Prinz's own passage on faces: **Not found**.
- *A wrinkle.* ML neurons are view-specific and AM nearly view-invariant (Freiwald and Tsao, *Science* 330:845–851, 2010; **Confirmed**, abstract). By Prinz's functional criterion ML is not clearly high-level. Hesse et al. pool ML and AM.
- *Top-down gain.* Included as one variety, and not constitutive. Executive centres "can exert top–down control on perceptual pathways, heightening sensitivity, and resulting in increased stimulus contrast". Against Lamme: "re-entrant activity is just attention going back into early visual areas in order to facilitate propagation forward into working memory", and attention is "a single process, which tends to result in re-entry, but does not have to". (**Confirmed**)
- *Attention without awareness.* The reply distinguishes spatial attention from "attentional modulation of perceptual representations"; "consciousness involves the latter, not the former". GY "cannot form a good representation of objects"; the cue may lower thresholds, expand receptive fields, or prime responses. The book: "GY may suffer from a general deficit in his object representations, so his success may not reflect the presence of AIRs" (p. 115; Mole notes the reply needs intermediateness to do constitutive work). Against Koch and Tsuchiya's gist and dual-task cases: "the near absence of attention is not the same as the absence of attention". (**Confirmed**)
- *Vectorwave.* Prinz's definition was not read. *Rivalry.* De Brigard and Prinz mention suppressed rivalry patterns only as Lamme's example; Prinz's own treatment: **Not found**.

**Outline needs correcting:**
- §9 note "The second difference may be smaller than it looks": overstated. Prinz says in print that re-entry is not required, and bottom-up capture counts as attention.
- §9 third option: "below the face patches" is safe for V2–V4. Calling both face patches high-level in Prinz's sense needs the ML caveat.
- "The standard objection to Prinz": add that he answers it by separating spatial attention from modulation of an object representation. Koch and Tsuchiya's claim concerns *top-down* attention; Prinz's notion is wider.

## 3. Temporal coding

- von der Malsburg C, "The correlation theory of brain function", Internal Report 81-2, MPI for Biophysical Chemistry, Göttingen, 1981 (report number from memory); reprinted in *Models of Neural Networks II* (Springer 1994), pp. 95–119 (**Confirmed**, record).
- Singer W, Gray CM, "Visual feature integration and the temporal correlation hypothesis", *Annu Rev Neurosci* 18:555–586, 1995. **Confirmed** (record).
- Fries P, *TICS* 9(10):474–480, 2005 (record); Fries P, "Rhythms for cognition: communication through coherence", *Neuron* 88(1):220–235, 2015 (**Confirmed**, full text): gamma "is rhythmically reset by a 4 Hz theta rhythm"; the behavioural data "can be parsimoniously explained by an 8 Hz attentional sampling process. If this process samples two stimuli, each stimulus is sampled 4 times per second".
- Landau AN, Fries P, "Attention samples stimuli rhythmically", *Curr Biol* 22(11):1000–1004, 2012. **Confirmed** (abstract): "a 4 Hz rhythm … at both stimulus locations, and the two rhythms were in antiphase".
- Fiebelkorn IC, Kastner S, "A rhythmic theory of attention", *TICS* 23(2):87–101, 2019. **Confirmed** (full text): "theta rhythms (3–8 Hz)" in FEF, LIP and pulvinar.
- Rollenhagen JE, Olson CR, *J Neurophysiol* 94(5):3368–3387, 2005. **Confirmed** (abstract): inferotemporal bursts "at a frequency of about 5 Hz", strengthened by a competing flanker.
- Kienitz R et al., *Curr Biol* 28(15):2377–2387, 2018. **Confirmed** (full text): V4 multi-unit rhythm at 3–6 Hz when centre and surround hold separate objects; "did not depend on small fixational eye movements".
- Closer precedents. Caruso VC et al., *Nat Commun* 9:2715, 2018: neurons fluctuate between the responses to each of two simultaneous stimuli, in inferior colliculus and in face patch MF, down to 50 ms bins (**Confirmed**). Jun NY et al., *eLife* 11:e76452, 2022: the same in V1 and V4 for separate objects (abstract). Hesse et al.'s own analogies are Fiebelkorn and Kastner 2019, Rich and Wallis 2016 and Jezek et al. 2011. They cite neither binding by synchrony nor communication through coherence.

**Outline needs correcting:**
- "In the range of the rhythmic sampling of attention": the documented alternation between two objects is 4 Hz per object behaviourally and 3–6 Hz in V4 and inferotemporal cortex. Hesse's states recur at 5.5–7.5 per second and are not shown to be rhythmic. The comparison holds only with the 7–8 Hz overall sampling rate.
- "The family of binding by synchrony … and communication through coherence": those are gamma-phase accounts. The nearer family is time-division multiplexing (Caruso; Jun), which is also the authors' own framing.

## 4. Rivalry and suppression by level

- Leopold DA, Logothetis NK, *Nature* 379:549–553, 1996. **Confirmed** (full text). V1/V2: 6 of 33 (18%). V4: 26 of 68 (38%); of these, 12 fired with the percept of the preferred orientation, 6 "when their preferred orientation was suppressed", 8 had no preference under congruent stimulation. MT 43% (Logothetis and Schall, *Science* 245:761–763, 1989). "the majority of cells in all areas continue to respond to their preferred stimulus even when it is perceptually suppressed".
- Sheinberg DL, Logothetis NK, *PNAS* 94:3408–3413, 1997. **Confirmed** (abstract): "almost all neurons" in inferotemporal cortex and superior temporal sulcus. The 90% figure: **Reported** (Hesse and Tsao 2020, whose own no-report figures are 57% in ML and 73% in AM).
- Logothetis NK, "Single units and conscious vision", *Phil Trans R Soc B* 353:1801–1818, 1998. **Confirmed** (abstract; no figures by area in it).
- Polonsky A, Blake R, Braun J, Heeger DJ, *Nat Neurosci* 3:1153–1159, 2000, doi 10.1038/80676. **Confirmed** (abstract): V1 fluctuations "about 55% as large" as for physical alternation, and "roughly equal" in V2, V3, V3a, V4v.
- Tong F, Engel SA, *Nature* 411:195–199, 2001. **Confirmed** (abstract): in the V1 blind-spot representation, responses "as large as those observed during actual alternations".
- Suppression paradigms below inferotemporal cortex (**Confirmed**, abstracts):
  - Keliris, Logothetis and Tolias, *J Neurosci* 30:12353–12365, 2010: V1 under binocular flash suppression, 20% of neurons, weakly modulated.
  - Wilke, Logothetis and Leopold, *PNAS* 103:17507–17512, 2006: under generalized flash suppression V1 and V2 spiking "uncorrelated with the perceptual visibility", V4 spiking significantly modulated, low-frequency LFP modulated in all three.
  - Chen C-X et al., *eLife* 14:RP107518, 2026: two-photon imaging of macaque V1 under continuous flash suppression; activity supports "coarse orientation classification but not accurate stimulus reconstruction".
- Single-unit or high-density recordings in V2, V4 or posterior inferotemporal cortex under binocular flash suppression: **Not found**.

**Outline needs correcting:**
- The third option's "what counts against it" is one-sided. In V4 only 12 of 68 cells followed the percept and 6 ran opposite. But human fMRI finds V1 modulation at 55–100% of physical alternation, and LFP dissociates from spiking.
- Hesse's reanalysis (weak average modulation hiding alternating states) has not been tried on V4.

## 5. Attention without awareness; illusory conjunctions

- Koch C, Tsuchiya N, "Attention and consciousness: two distinct brain processes", *TICS* 11(1):16–22, 2007. **Confirmed** (abstract): "top-down attention and consciousness are distinct phenomena"; "subjects can attend to perceptually invisible objects".
- Kentridge RW, Heywood CA, Weiskrantz L, *Proc R Soc B* 266:1805–1811, 1999; and *Neuropsychologia* 42:831–835, 2004. **Confirmed** (abstracts). 2004: "although attention may be a necessary precursor to visual awareness it is not a sufficient one". In normal observers: Kentridge, Nijboer and Heywood, *Neuropsychologia* 46:864–869, 2008.
- Treisman A, Schmidt H, "Illusory conjunctions in the perception of objects", *Cogn Psychol* 14:107–141, 1982. **Confirmed** (record); content not re-read.

**Outline needs correcting:** nothing.

## 6. Perception sources for §8

- Duhamel J-R, Colby CL, Goldberg ME, *Science* 255:90–92, 1992. **Confirmed** (abstract): in parietal cortex "the location of the receptive field is shown to shift transiently before an eye movement".
- Amodal completion: Michotte, Thinès and Crabbé, *Les compléments amodaux des structures perceptives*, Louvain 1964; Kanizsa, *Organization in Vision*, Praeger 1979; Kellman and Shipley, *Cogn Psychol* 23:141–221, 1991. Filling-in: Pessoa, Thompson and Noë, *BBS* 21:723–748, 1998; Komatsu, *Nat Rev Neurosci* 7:220–231, 2006. **Confirmed** (records).
- Hsieh P-J, Vul E, Kanwisher N, *J Neurophysiol* 103:1501–1507, 2010. **Confirmed** (abstract). The early-retinotopic pattern to a two-tone image "was more similar to the response to the full grayscale photo version of the same image when observers knew what the two-tone image represented". In a second experiment the pattern to an identified two-tone image was closer to the photo's than to that of the same image unidentified.
- Dalmatian: photograph by Ronald C. James; in Gregory, *The Intelligent Eye*, Weidenfeld and Nicolson 1970; first published "probably" in *Life*, 1965. **Reported** (Bach's illusion pages).
- Grush R, "The emulation theory of representation", *BBS* 27(3):377–396, 2004 (**Confirmed**, abstract). On time: *J Neural Eng* 2(3):S209–S218, 2005; *Synthese* 153:417–450, 2006 (records).
- Gibson JJ, *The Ecological Approach to Visual Perception*, Houghton Mifflin 1979. Replies: Fodor and Pylyshyn, *Cognition* 9:139–196, 1981; Ullman, "Against direct perception", *BBS* 3:373–381, 1980. **Confirmed** (records). Gibson treats occlusion as specified by optical information over time (from memory), so the sharper case against pickup is a constant array with a changed percept, which is Hsieh et al.

**Outline needs correcting:** "one-shot learning of two-tone images (Hsieh, Vul and Kanwisher 2010)" (Before drafting, item 8): Hsieh et al. show that recognition alters the early-cortex pattern. They did not study learning.

## 7. Recurrent state in hybrid models

- Afendulev K, Dontsov A, Tutubalina E, Korznikov A, "What Attention Recalls and Recurrence Controls in Hybrid Language Models", *Findings of EMNLP 2026*, pp. 43888–43900; arXiv 2609.04434. **Confirmed** (full text). Qwen3.5-4B, recurrent-only against cache-only: retrieval 0.00 and 0.89; language following 0.70 and 0.01; persona 0.49 and 0.14 (a judge's score, not a rate). Kimi-Linear-48B agrees. In Falcon-H1-7B and 34B persona is higher cache-only. Authors' caveat: "We do not claim either channel is empty of the other type of content."
- The 24-token median half-life is from Li J, Lou J, Li J (GateSight, arXiv 2610.14754) on Qwen3.8-27B. **Confirmed**: "Across heads the median is about 24 tokens". The same paper fixes 293 of 2,304 heads whose half-life is at least 1,000 tokens.
- Interventions on recurrent state:
  - Lee K, Park J, Kim S, Ko J, "How Linear Attention Remembers", arXiv 2609.33093 (**Confirmed**): write block, donor write and state swap in GLA and GDN models and in Qwen3.5-4B and 9B. A donor write "remains behaviorally effective after the intervening context" (the donor value is the answer in 68–90% of cases). In the hybrids recurrent interventions recover 0.2–3.6% of the effect and cache interventions 96–100%.
  - Young J, "WriteSAE", arXiv 2605.12770 (abstract): replaces and injects writes in the Gated DeltaNet state. Young J, "S0 Tuning", arXiv 2604.01168 (abstract): optimizes the initial state.
- A perturb-and-watch-for-restoration study (CAR test 4), or any state intervention on Kimi K3, Qwen3.8 or Mamba-3: **Not found**. Lee et al.'s donor writes persist, which fits assimilation but is not CAR's test.

**Outline needs correcting:** §9 "Afendulev et al. found … and a median head halves its contents in about 24 tokens" runs two sources together; the half-life is Li, Lou and Li. Add that about an eighth of heads hold content for 1,000 tokens or more, and that "not retrieved content" is a functional claim.
