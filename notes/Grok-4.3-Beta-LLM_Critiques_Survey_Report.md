# Survey Report: Critiques of LLM-Based AI by Yann LeCun, Richard Sutton, David Silver, and the Case Against LLMs as the Path to AGI

**Date:** April 30, 2026  
**Author:** AI Research Survey (based on primary sources and 2025–2026 developments)

## Executive Summary

Yann LeCun (Meta FAIR/Turing Award winner, now leading AMI Labs), Richard Sutton (Turing Award winner, “father of reinforcement learning”), and David Silver (DeepMind RL leader behind AlphaGo/AlphaZero, now founder of Ineffable Intelligence) are among the most prominent architects of modern AI who argue that scaling large language models (LLMs) — autoregressive next-token predictors trained primarily on human-generated text/data — will not yield artificial general intelligence (AGI) or superintelligence. They view pure or dominant LLM scaling as a sophisticated but limited “mimicry” or “imitation” paradigm that lacks grounding in physical/causal reality, true agency, efficient learning from experience, and the capacity for novel discovery beyond human knowledge distributions.

**Key shared shortcomings they highlight:**
- **Lack of grounding/world models**: LLMs manipulate symbols/statistical patterns without internal causal models of physics, consequences, or persistent reality.
- **Architectural flaws**: Autoregressive generation causes exponential error compounding; passive, offline training on static data yields no continual “on-the-job” adaptation or grounded feedback/rewards.
- **Inefficiency and ceilings**: Sample-inefficient compared to biological learning; bounded by exhaustible high-quality human data; cannot reliably plan, reason deeply, or self-discover transformative knowledge.
- **No intrinsic goals or experience loop**: Intelligence requires sensation → action → reward/feedback streams for understanding “what will happen if I do X,” not just predicting “what a person would say.”

Their proposed paths converge on **predictive world models** (latent-space representations of dynamics), **reinforcement learning (RL)/experience-based paradigms**, hierarchical planning, and continual lifelong learning from rich sensory/action streams (real or simulated). In 2025–2026, both LeCun and Silver have left major labs to found well-funded startups (AMI Labs ~$1B+ raise; Ineffable Intelligence $1.1B seed at $5.1B valuation) explicitly betting against LLM monoculture. Sutton co-authored the influential 2025 paper “Welcome to the Era of Experience” with Silver. These critiques are not anti-LLM (they acknowledge utility for narrow tasks) but argue LLMs are an “off-ramp,” “dead end,” or “distraction” for the shortest path to AGI/superhuman adaptable intelligence. Gary Marcus-style symbolic critiques are set aside here per the query, as scaling has empirically demonstrated strong pattern-based capabilities.

## 1. Introduction: Scaling Hypothesis vs. Paradigmatic Critiques

The dominant “scaling hypothesis” (more parameters + data + compute → emergent intelligence) powered the LLM boom (GPT series, Llama, Claude, Gemini). Critics like LeCun, Sutton, and Silver — whose prior work (convolutional nets, RL theory, Alpha* systems) enabled much of this — contend it hits fundamental walls. Language/text is a narrow, indirect proxy for reality (“language describes the world, but it is not the world itself” — LeCun). Human intelligence develops primarily through perception, interaction, and prediction *before* language. LLMs excel at fluent compression/imitation of human outputs but lack the ingredients for robust generalization, causal understanding, long-horizon planning, or transcending human knowledge ceilings.

By 2026, with data exhaustion concerns mounting and diminishing returns on pure pre-training scale reported in some labs, these voices have gained traction. New ventures by the critics themselves signal a potential paradigm shift toward “world models + experience/RL” hybrids or successors. This report surveys their specific arguments from papers, talks (e.g., LeCun’s “Mathematical Obstacles on the Way to Human-Level AI”), interviews (Dwarkesh Podcast with Sutton), and the Silver–Sutton “Era of Experience” paper.

## 2. Yann LeCun’s Arguments: LLMs Lack World Models, Suffer Compounding Errors, and Are Architecturally Doomed for AGI

LeCun has been the most vocal and consistent critic since ~2022–2023, repeatedly stating variants of: “If you are interested in human-level AI, *don’t work on LLMs*.” He calls them a “dead end,” “off-ramp,” “distraction,” and recently (2026) “complete bullshit” as a path to superintelligence or even robust human-level intelligence.

**Core Shortcomings** (drawn from his 2022 position paper *A Path Towards Autonomous Machine Intelligence*, lectures, and 2025–2026 interviews):

- **No grounding or causal world model**: LLMs are “stochastic parrots” or sophisticated pattern matchers predicting plausible *text*, not reality. They lack persistent internal representations of physics, causality, objects, or consequences (e.g., “an LLM doesn’t understand that if you push a glass off a table, it will break — it only knows the words ‘glass’ and ‘break’ often appear together”). Most human knowledge is non-linguistic (sensory/perceptual); text-only training misses this. Result: fluent but brittle outputs with basic factual/logical errors, hallucinations, and poor out-of-distribution generalization.
- **Autoregressive next-token prediction is mathematically doomed**: In high-dimensional or partially unpredictable spaces (text, video, real world), each prediction has small error probability *e*; over *n* steps, success probability ≈ (1−*e*)^n → exponential divergence/catastrophic failure for long outputs, planning, or reasoning chains. Chain-of-thought is a “trick,” not a fix — still feed-forward with fixed compute.
- **Sample inefficiency and lack of key faculties**: Deep learning “sucks” vs. humans/animals (needs vast labeled data/trials vs. few-shot learning). LLMs lack: true reasoning/planning (no variable compute/search like A*/MCTS on hard problems), persistent long-term memory (beyond context windows), intrinsic objectives, or autonomous adaptation. They optimize plausibility, not truth or goals.
- **Data and architectural monoculture limits**: Training data volume (even massive) is dwarfed by a child’s visual experience (~10^14 bytes by age 4). GPT-style homogeneity “kills research”; scaling alone won’t force discovery of missing principles (internal state, time, causality, goals).

**Proposed Alternative — JEPA/H-JEPA World Models + Cognitive Architecture**

LeCun advocates shifting to **self-supervised predictive world models** on rich sensory data (video, multimodal) using **Joint Embedding Predictive Architecture (JEPA)** and hierarchical variants (H-JEPA). Key innovations (detailed in his 2022 openreview paper and subsequent I-JEPA/V-JEPA work at Meta, now continued at AMI Labs):

- **Non-generative latent prediction**: Embed inputs into abstract representations; predict *in latent space* (not pixels/tokens) to avoid high-dimensional unpredictability and compounding errors. Use energy-based models (EBMs) and non-contrastive objectives (e.g., VICReg) for informative, predictable representations.
- **Full differentiable cognitive architecture**: Configurator (sets objectives/mode), perception (encoders), **world model** (predicts future states/scenarios from actions + noise for uncertainty), actor (proposes actions), cost module (intrinsic objectives + safety), short-/long-term memory. Hierarchical planning via optimization/search in latent space.
- **Training paradigm**: Self-supervised on observation streams (like babies/animals); intrinsic motivation; RL “glue” for decision-making. Enables Mode-1 (fast/intuitive) and Mode-2 (slow/deliberative planning/reasoning) thinking.
- **Why this reaches AGI/AMI (“Advanced Machine Intelligence” — LeCun prefers this over “AGI” as human intelligence is specialized, not truly general)**: Builds causal, predictive understanding of the physical/social world; supports efficient planning, novel problem-solving, and continual learning. Language can be layered on top. Recent progress (2025–2026 JEPA variants at his lab) shows faster planning and better dynamics modeling.

LeCun left Meta (late 2025) to found **AMI Labs**, raising ~$1B+ at multi-billion valuation to accelerate this. He argues the industry is “LLM-pilled” and herd-like; creative alternatives (e.g., Chinese labs) may win by focusing on world models.

## 3. Richard Sutton’s Arguments: LLMs Are Mimicry Engines Lacking Goals, Feedback, and Continual Experience-Based Learning

Sutton (co-author of the RL bible *Reinforcement Learning: An Introduction*) emphasizes that intelligence is “the computational part of the ability to achieve goals” (John McCarthy). LLMs fail this test fundamentally.

**Core Shortcomings** (prominently from his 2025 Dwarkesh Podcast interview and related commentary):

- **Mimicry vs. world understanding**: LLMs predict “what a person would say” (next token on human text) rather than “what will happen” in the world. They are “mimicry engines” compressing human communication patterns — impressive but not building models of reality, causality, or consequences. “To mimic what people say is not really to build a model of the world at all. You’re mimicking things that have a model of the world: people.”
- **No goals, rewards, or ground truth**: No intrinsic notion of “right” or “wrong” outcome in an environment. Training is offline/static with no real-time feedback loop during deployment (“learning on the job”). Catastrophic forgetting, poor transfer, and inability to adapt dynamically.
- **Violates core principles (Bitter Lesson)**: While Sutton’s 2019 “Bitter Lesson” celebrated scaling computation/search/learning over hand-crafted knowledge, LLMs inject massive human knowledge (data + preferences) and still plateau on true intelligence. They lack the experience-driven scalability of RL.
- **Dead end for AGI**: Without continual learning from sensation-action-reward streams, scaling yields diminishing returns and cannot produce flexible, goal-driven agents. LLMs are useful tools (“great new tool and building block”) but not a foundation for AGI.

**Proposed Path: RL and the “Era of Experience”**

Sutton advocates returning to fundamentals: agents in lifelong **streams of experience** (sensation → action → reward/feedback). Core components: policies, value functions (temporal-difference learning), perception, and **transition/world models**. Knowledge is about “if you do some action, what will happen.” This enables continual, on-the-fly learning without separate training phases — like humans/animals. Scalable via compute and exploration; shares learned knowledge across agents. LLMs can be components but not the core.

## 4. David Silver’s Arguments: Human-Data LLMs Hit a Ceiling; “Era of Experience” Unlocks Superintelligence via Self-Discovery

Silver (AlphaGo/AlphaZero architect) reinforces Sutton while adding empirical weight from self-play RL successes. He co-founded **Ineffable Intelligence** (2025/2026, $1.1B seed) explicitly to pursue AI that “learns without human data” and outperforms LLMs.

**Core Shortcomings and “Welcome to the Era of Experience” (2025 Paper with Sutton)**:

Current paradigm (massive human-generated data + preference fine-tuning) reproduces *competent human-level* performance but cannot reach **superhuman** across domains. High-quality human data (math, code, science) is exhausting; synthetic data from LLMs creates echo chambers without new insights. Passive imitation yields correlations, not causal understanding or grounded testing of hypotheses. LLMs are “bounded by human knowledge” — a model trained in a “flat Earth” world would likely retain flawed beliefs without reality-testing via action/experiment.

**The New Era — Experiential Learning**:

Agents generate their own vast experiential data through autonomous interaction (real robots, simulated environments, APIs, sensors). Key features:
- **Lifelong streams** (not short episodes).
- **Grounded actions/observations** (motor control, rich sensors — beyond dialogue).
- **Grounded rewards** (environmental signals, not just human preferences; flexible neural reward models).
- **World models + planning/reasoning**: Predict consequences; develop non-human strategies (as AlphaZero did in Go/chess; AlphaProof generated millions of novel proofs).

This reconciles narrow superhuman RL (games) with broad task generality. Experiential data will dwarf human data; enables self-discovery of theorems, materials, strategies *beyond* human knowledge. “Incredible new capabilities will arise once the full potential of experiential learning is harnessed.” Silver’s Ineffable bets on RL “superlearners” for this.

## 5. Common Threads, Related Voices, and Why LLMs Are an “Off-Ramp”

**Shared diagnosis**: LLM scaling optimizes next-token (or multimodal token) prediction on human-like data → strong imitation/compression but misses agency, causal world modeling, efficient continual learning, and open-ended discovery. Error compounding, lack of feedback loops, and data ceilings make it inefficient/non-scalable for AGI. Hybrids (LLM + tools/search/agents) help short-term but inherit base flaws.

**Convergent solutions**: Predictive (latent) world models + RL/experience loops + hierarchical planning + intrinsic objectives. LeCun emphasizes JEPA-style self-supervised representations on video/sensor data; Sutton/Silver emphasize RL value functions, TD learning, and grounded reward streams in the “Era of Experience.” Both enable planning under uncertainty and transcending human data limits.

**Related critics** (briefly): Ilya Sutskever has echoed needs for self-generated experiences and world models over passive text scaling. Fei-Fei Li stresses embodiment and multimodal interaction for common sense. These reinforce that text-centric scaling is narrow.

## 6. Conclusion and Outlook (as of April 2026)

LeCun, Sutton, and Silver — with decades of foundational contributions — present a coherent case that LLM-based AI, while transformative for specific applications, is not on the shortest (or even viable long-term) path to AGI or superintelligence. It excels at what it was designed for (predicting human-like outputs) but lacks the architectural and experiential ingredients for robust, goal-directed, continually learning intelligence that discovers genuinely new knowledge. Their alternatives — JEPA-style world models (LeCun/AMI Labs) and experience/RL paradigms (Sutton/Silver/Ineffable) — offer principled, scalable routes grounded in how biological intelligence actually develops.

Empirical counter-evidence (stronger reasoning models, agentic systems) is acknowledged but viewed as incremental within the old paradigm or early hybrids. The critics’ new ventures, massive funding, and papers like “Welcome to the Era of Experience” indicate the field is diversifying. Talent, compute, and capital may increasingly flow toward experience-based world-model systems, especially for robotics, science, and long-horizon planning where LLMs demonstrably falter.

The debate remains open — progress is rapid, and hybrids may bridge gaps — but these pioneers’ arguments highlight why betting *exclusively* on LLM scaling risks an expensive off-ramp. Future AGI is more likely to emerge from systems that *understand and act in* the world, not merely describe it. Researchers and organizations should diversify beyond pure next-token prediction to remain on the critical path.

## Key Sources (Selected)

- LeCun’s *A Path Towards Autonomous Machine Intelligence* (2022, openreview.net/pdf?id=BZ5a1r-kVsf) and lectures (e.g., “Mathematical Obstacles on the Way to Human-Level AI”).
- Sutton Dwarkesh Podcast interview (2025) and “The Bitter Lesson” (2019).
- Silver & Sutton, *Welcome to the Era of Experience* (2025 preprint, storage.googleapis.com/deepmind-media/Era-of-Experience/The%20Era%20of%20Experience%20Paper.pdf).
- Contemporaneous reporting on AMI Labs (~$1B+ raise) and Ineffable Intelligence ($1.1B seed) in 2025–2026.
- buildml.substack.com synthesis of architect critiques and related papers (e.g., JEPA/V-JEPA developments).

*This survey is based on primary statements and does not claim consensus; the field evolves quickly.*