# **Beyond the Classical: The Renaissance of Cognitive Architectures in the Era of Neuro-Symbolic and Generative AI (2024-2025)**

## **1\. Introduction: The Paradigm Shift in Structural Cognition**

The domain of cognitive architecture—the scientific and engineering discipline dedicated to modeling the fixed computational infrastructures that support intelligent behavior—is currently undergoing its most significant transformation since the cognitive revolution of the 1970s. For nearly four decades, the field was anchored by what are now termed the "classical" architectures, most notably **ACT-R (Adaptive Control of Thought-Rational)** and **Soar**. These systems provided the foundational blueprints for modeling the human mind, establishing the necessity of distinct memory modules, production-rule-based reasoning, and the integration of perception and action.1 However, the research landscape of 2024 and 2025 reveals a dramatic departure from these purely symbolic or strictly hybrid origins. The meteoric rise of Large Language Models (LLMs), coupled with the maturation of neuromorphic computing and Spiking Neural Networks (SNNs), has forced a fundamental re-evaluation of what constitutes a "cognitive architecture."  
The contemporary state-of-the-art is no longer defined solely by the fidelity with which a system models human reaction times or error rates in distinct psychological tasks. Instead, the frontier has shifted toward **Grand Unification** and **Generative Integration**. Researchers are now tasked with reconciling the generative power of connectionist models (which excel at statistical correlation and natural language) with the structured, goal-directed, and metacognitive capabilities of cognitive architectures (which excel at consistency, planning, and agency).4 This convergence is driving the development of new frameworks that are not merely updates to old codebases but are radical reimaginings of the mind's machinery.  
We are witnessing the emergence of three distinct but increasingly overlapping research vectors. First, the **Common Model of Cognition (CMC)** is evolving from a static consensus diagram into a dynamic specification for metacognition and emotional modulation, effectively giving the "standard model" the ability to introspect and feel.2 Second, the chaos of "LLM agents" is being formalized through frameworks like **CoALA (Cognitive Architectures for Language Agents)**, which impose architectural discipline on probabilistic models to create persistent, memory-driven entities.4 Third, the push for energy efficiency and biological plausibility is elevating architectures like **Nengo** and **LIDA**, which utilize spiking neurons and global workspace dynamics to model the brain's temporal and energetic reality, offering a stark contrast to the power-hungry nature of transformer-based systems.10  
This report provides an exhaustive analysis of these developments. It moves beyond the classical definitions to explore the cutting-edge research of late 2024 and 2025\. It examines how Sigma is achieving unification through graphical models, how biologically constrained systems are solving the energy crisis of AI, and how the very definition of "agent" is being rewritten by the integration of neural and symbolic paradigms.

## **2\. The Common Model of Cognition: From Consensus to Metacognition**

The Common Model of Cognition (CMC), often referred to as the Standard Model of the Mind, represents the community consensus on the necessary macroscopic components for human-like intelligence. Historically derived from the architectural convergences between ACT-R, Soar, and Sigma, the CMC posits a central Working Memory (WM) that acts as a hub for interaction between long-term Declarative Memory, Procedural Memory, Perception, and Action.2 While the CMC began as a high-level abstraction to facilitate cross-disciplinary communication between AI, cognitive science, and neuroscience, research in 2024 and 2025 has moved aggressively toward extending this model to handle higher-order cognitive functions that were previously considered "too abstract" or "too high-level" for standard architectural specification: specifically, **metacognition** and **emotion**.

### **2.1 The Metacognitive Extension (2025)**

A critical and longstanding limitation of early cognitive architectures was their lack of robust introspection—the ability to monitor, critique, and regulate their own cognitive processes in real-time. Traditional systems could detect errors (e.g., a rule failing to fire), but they generally lacked a unified mechanism for "thinking about thinking." Recent proposals in 2025 have formalized the integration of metacognition into the CMC without resorting to the "homunculus fallacy"—that is, without adding a "magic" distinct module that supervises the rest of the system from the outside. Instead, the new consensus is that metacognition arises from reasoning over explicit representations of the agent's own process states.8  
The 2025 proposal for extending the CMC with metacognition advocates for a unified approach where metacognition is not a separate supervisor but a natural consequence of the architecture's data flow. This involves reasoning over explicit representations of an agent's cognitive capabilities and processes within Working Memory itself. The proposal identifies three specific architectural extensions required to support this capability:

1. **Process-State Buffers:** The introduction of specialized buffers within Working Memory that hold metadata about the current processing state of other modules. For instance, the declarative memory module might output not just a retrieved fact, but a "feeling of knowing" signal or a confidence score. The perceptual module might output a measure of signal-to-noise ratio. These metadata signals allow the procedural system to make decisions based on the *quality* of the cognition, not just the content.8  
2. **Episodic Monitoring and Replay:** Utilizing the episodic memory system to store sequences of past Working Memory contents, effectively creating a "black box" recording of the agent's own mind. This allows the agent to retrieve and "replay" its own reasoning trajectories. By treating past cognitive states as objects of study, the agent can critique past decisions, identify recurring logic errors, or reinforce successful strategies—a function essential for self-correction and autonomous learning.14  
3. **Hypothetical State Representation:** The ability to represent counterfactual or future states in Working Memory that are distinct from the current perceptual reality. This is crucial for planning and regret. The architecture must support "middle memory" or distinct sub-states where base-level reasoning mechanisms (procedural rules) can operate on "what-if" scenarios without confusing them with reality or executing them physically. This capability allows the agent to simulate the outcome of a metacognitive intervention before applying it.8

The implications of this extension are profound. It allows the CMC to support complex behaviors such as deciding to abandon a retrieval attempt because the "feeling of knowing" is low (efficiency), or adjusting a search strategy based on the recognition of a repeated loop in the episodic trace (deadlock resolution). This moves the CMC from a model of "doing" to a model of "managing doing".15

### **2.2 Integrating Emotion as Architectural Modulation**

Parallel to the work on metacognition, the integration of emotion into the CMC has transitioned from a theoretical desideratum to architectural specification. Work led by researchers associated with the Sigma architecture (discussed in detail in Section 4\) has heavily influenced the CMC to view emotion not as a separate "feeling" layer or a distinct "emotion module," but as a global modulation mechanism driven by appraisal.5  
The 2024 proposals for extending the CMC to emotion rely on adding a **Metacognitive Assessment Module**. This mechanism continuously evaluates the contents of Working Memory against long-term goals, constraints, and homeostatic drives. It generates high-dimensional appraisal variables—such as "desirability" (does this state advance my goal?), "expectedness" (did I predict this state?), and "controllability" (can I alter this state?).16  
Crucially, these variables do not just sit in a buffer; they modulate the global parameters of the architecture. For example:

* **High Surprise (Low Expectedness):** Might trigger an automatic widening of the attention bottleneck in the perceptual module, allowing more data to flow into Working Memory to resolve the discrepancy.  
* **High Anxiety (Low Controllability \+ High Negative Desirability):** Might bias the procedural memory to prefer safe, well-rehearsed retrieval paths over exploratory or risky ones.  
* **Positive Affect:** Might increase the learning rate or the "temperature" of action selection, encouraging creativity and exploration.

This architectural view aligns with findings in neuro-symbolic research and affective neuroscience, where "hot cognition" (emotion-influenced) is shown to be essential for efficient resource allocation in biological systems. By embedding these mechanisms into the CMC, researchers are providing a blueprint for agents that are not just intelligent, but "care" about the outcome of their actions in a functional sense.8

### **2.3 Shadow Production Systems and Generative Integration**

A third major evolution in the CMC during 2024-2025 is the concept of **Generative Integration**. This addresses the "Elephant in the Room": the existence of massive, pre-trained generative models (LLMs/VLMs). The traditional CMC assumes knowledge is acquired through experience or hand-coding. The new model proposes restructuring the classic modules into "shadow production systems" that interface with generative neural networks.18  
In this view, the "Central Production System" (the rule engine) handles high-level reasoning, policy, and safety. However, distinct "shadow" systems run peripherally, utilizing generative models to propose hypotheses, generate text, or imagine visual outcomes. The central system then "selects" or "vetoes" these generative proposals. This allows the CMC to maintain its rigid cognitive control loop while leveraging the vast, albeit unreliable, knowledge bases of modern neural networks. This hybrid structure seamlessly connects the rigorous constraints of cognitive architectures with the fluidity of deep learning.18

## **3\. The Generative Shift: Cognitive Architectures for Language Agents (CoALA)**

The explosion of Large Language Models (LLMs) created a crisis of categorization in AI research. While LLMs exhibit vast semantic knowledge and emergent reasoning capabilities, they lack the persistence, goal-directedness, and dynamic learning characteristic of true agents. They are, effectively, "disembodied brains in a jar," resetting after every context window closes. The **Cognitive Architectures for Language Agents (CoALA)** framework, formalized in 2024, has emerged as the definitive standard for organizing and designing LLM-based agents, imposing architectural discipline on the probabilistic chaos.4

### **3.1 The CoALA Framework Structure**

CoALA serves as a bridge between the symbolic history of AI (referencing Soar and ACT-R) and the modern probabilistic reality of Transformers. It rejects the notion of the LLM as a standalone agent, instead treating the LLM as a subsystem—specifically, a reasoning and retrieval engine—within a broader architecture. CoALA organizes agents along three primary dimensions 20:

1. **Modular Memory Components:**  
   * **Working Memory:** The active context window. Unlike traditional architectures where Working Memory is a set of fixed-size buffers, in CoALA, Working Memory is a textual/token-based space. It maintains current goals, recent observations, and intermediate reasoning steps.  
   * **Episodic Memory:** A log of past experiences. In systems like *Generative Agents*, this is implemented as a retrieval-augmented generation (RAG) database where experiences are stored as vector embeddings and retrieved based on relevance, recency, and importance.22  
   * **Semantic Memory:** Knowledge bases or external corpora that provide facts about the world, distinct from the agent's autobiography. This can be external (e.g., Wikipedia) or internal (the weights of the LLM itself).  
   * **Procedural Memory:** The code or "skills" the agent can execute. In CoALA, this includes both the static prompt chains (implicit procedures) and executable tools (APIs) the agent can call. This is a significant evolution from the "production rules" of ACT-R, allowing for code-based skills.9  
2. **Structured Action Space:**  
   * **Internal Actions:** Actions that affect the agent itself, such as retrieving a memory, reasoning (updating Working Memory with new tokens), or learning (writing to long-term memory).  
   * **External Actions:** Grounding actions that interact with the physical or digital environment (e.g., click(), say(), move()). The distinction is vital for safety and planning.20  
3. **Generalized Decision-Making Process:**  
   * The framework mandates a cycle of **Planning** (proposing actions via reasoning) and **Execution** (performing the action and observing feedback). This cyclic nature—reminiscent of the OODA loop or the Soar decision cycle—is what transforms a passive LLM into an active agent.

### **3.2 Generative Agents: The Memory Stream Architecture**

One of the most influential implementations of a CoALA-compliant architecture is the "Generative Agents" model (Park et al., 2023/2024). This architecture simulates believable human behavior by introducing a sophisticated memory retrieval mechanism that governs how an agent "remembers" its life in a sandbox environment.23  
The core innovation is the **Memory Stream**, a comprehensive list of memory objects (observations, thoughts, conversations). The architecture solves the context-window limitation not by summarization alone, but by a scored retrieval function. The retrieval score ![][image1] for a memory ![][image2] given a query ![][image3] is defined by a weighted sum of three components, heavily detailed in recent analyses 26:  
![][image4]

* **Recency:** An exponential decay function favoring newly created memories. ![][image5].  
* **Importance:** A score assigned by the LLM itself at the time of memory creation. For example, the agent is prompted to rate "breaking up" higher (e.g., 8/10) than "eating breakfast" (e.g., 2/10). This mimics the biological saliency of emotional events.  
* **Relevance:** The cosine similarity between the embedding vector of the query ![][image3] and the memory ![][image2].

This architecture also introduces **Reflection**, a higher-order cognitive process. Periodically, the agent pauses to synthesize low-level memories into high-level abstract thoughts (reflections), which are then written back into the memory stream. This allows the agent to generalize (e.g., "I am a shy person") from specific behaviors, effectively creating a dynamic self-concept that persists over time.25

### **3.3 Agent-Pro and Dynamic Social Beliefs (2025)**

Moving beyond individual simulation, the **Agent-Pro** framework (2025) introduces an agent architecture designed for complex social interaction and game theory. It addresses the "Theory of Mind" gap in standard LLMs. Agent-Pro models the agent's interaction as a game where it must maintain two dynamic matrices: **Self-Belief** (an evolving understanding of its own capabilities and role) and **Social-Belief** (an evolving model of other agents' intentions and strategies).29  
The architecture operates on a "Policy-Level Reflection" mechanism. Unlike simple error correction, Agent-Pro updates its long-term procedural memory (its "instructions" or "constitution") based on interaction outcomes. This mimics the *production compilation* found in Soar, where successful problem-solving traces are compiled into efficient rules, but applies it to the probabilistic prompts of an LLM. This enables the agent to navigate complex multi-agent environments (like auctions or social deduction games) by maintaining a stable yet adaptive personality.29

### **3.4 Self-Refinement and Recursive Architectures**

A major theme in 2024-2025 research is the formalization of **Self-Refinement** (or Reflexion) architectures. These systems employ a heuristic loop where the agent generates an output, critiques it (self-evaluation), and then regenerates the output based on the critique. This is architecturally distinct from simple prompting; it represents a "System 2" cognitive process (slow, deliberative) implemented over a "System 1" substrate (the LLM).  
Recent work on **AgentRefine** (2025) demonstrates that this architecture significantly outperforms standard "one-shot" agents on generalization tasks. By treating the generation process as an iterative optimization problem within Working Memory, the agent can "debug" its own reasoning before committing to an external action. This recursive structure is becoming a standard design pattern for high-reliability agents in domains like code generation and complex planning.31

## **4\. Sigma: Grand Unification via Graphical Models**

While CoALA organizes the new wave of LLMs, the **Sigma (![][image6])** cognitive architecture represents the leading edge of non-connectionist (or hybrid) unification. Developed largely at USC's Institute for Creative Technologies, Sigma distinguishes itself by eschewing the distinct, specialized modules of ACT-R or Soar in favor of a uniform computational substrate: **Factor Graphs**.19

### **4.1 The Graphical Architecture Hypothesis**

Sigma explores the **Graphical Architecture Hypothesis**: the idea that all cognitive processing—memory, perception, learning, decision-making, and emotion—can be formulated as inference on a factor graph. In this view, the "mind" is a massive probabilistic graphical model, allowing for a mathematical elegance that modular architectures often lack.

* **Uniformity:** Instead of separate codebases for declarative memory (a database) and procedural memory (a production system), Sigma uses generic **factor nodes** and **variable nodes** to represent both. Knowledge is stored as functions at the factor nodes.  
* **Hybridity:** Sigma natively handles both discrete symbols (like classic AI) and continuous variables (like control systems or neural networks) using **piecewise-linear functions**. This allows it to bridge the gap between symbolic logic and sensorimotor control without needing "translation" layers.34

### **4.2 PySigma and Generative Integration (2024-2025)**

The 2024–2025 period has seen the maturation of **PySigma**, a Python-based implementation aimed at enhancing accessibility and integration with deep learning libraries. A key focus of PySigma is **Grand Unification** via **Generative Integration**. This involves restructuring the architecture to interface with deep generative models (like Variational Autoencoders or GANs) as if they were native parts of the graph.18  
In this setup, a "shadow production system" might wrap a neural network. When the architecture needs to imagine a visual scene, it queries the neural network. The network's continuous output is then discretized or approximated by the factor graph, allowing the symbolic core to reason about the "imagined" content. This provides a rigorous mathematical framework for neuro-symbolic integration, distinct from the ad-hoc "prompting" used in CoALA systems.19

### **4.3 Appraisal-Based Emotion in Sigma**

A major focus of recent Sigma research is the computational implementation of **Appraisal-Based Emotion**. Unlike systems that treat emotion as a simple variable (e.g., sadness \= 0.5), Sigma derives emotion from the fundamental operations of the architecture itself.16  
The architecture continuously computes two primary appraisal variables:

1. **Expectedness:** This is computed by comparing current observations against the architecture's predictive models (forward inference on the graph). If the observation diverges from the prediction, "Expectedness" drops. Low expectedness architecturally triggers a **Surprise** response, which automatically reallocates attention (processing power) to the discrepancy.  
2. **Desirability:** This is computed as the gradient of the goal state. Does the current state reduce the distance to the goal? This is modeled as a relationship between the current state variables and the goal function variables in the graph.

These computations are automatic and architectural—they happen "everywhere" in the graph, not in a specific module. This matches the biological reality that emotion is a pervasive modulation of cognition. The gradient-descent learning mechanism in Sigma has also been shown to play an essential role in refining these appraisals over time, effectively allowing the agent to "learn what to feel" based on reward signals.35

## **5\. Biological Plausibility and Neuromorphic Cognition**

A significant trend in 2024–2025 is the move toward **Biological Plausibility**. While LLMs are powerful, their energy consumption (Joules per token) is orders of magnitude higher than the human brain, which operates on approximately 20 Watts.36 Research into Spiking Neural Networks (SNNs) and vector-symbolic architectures attempts to bridge this efficiency gap by mimicking the brain's sparse, event-driven nature.

### **5.1 Nengo and the Semantic Pointer Architecture (SPA)**

**Nengo** is a leading framework for building large-scale brain models, utilizing the **Neural Engineering Framework (NEF)**. Its cognitive layer, the **Semantic Pointer Architecture (SPA)**, addresses the "binding problem"—how to represent structured hierarchical data (like "the blue ball is on the red box") in a fixed-size vector space using spiking neurons.10

* **Semantic Pointers:** These are high-dimensional vectors that can be compressed (via circular convolution) to carry information about structure and content. They act like pointers in computer science (referencing data) but are "semantic" because they carry meaning in their vector distance. This allows the architecture to perform symbolic-like operations (binding, unbinding, recursion) using purely algebraic vector operations that are easily mapped to spiking neural activity.38  
* **Spaun 2.0 (2024-2025):** The "Semantic Pointer Architecture Unified Network" (Spaun) remains the world's largest functional brain model. Recent updates to Spaun 2.0 have significantly improved its vision system, now capable of processing ImageNet-level data, and its adaptive motor control. It can perform diverse tasks—from copy-drawing to pattern recognition—using a single, fixed network of 6.6 million spiking neurons, without re-training the weights for each task. This demonstrates "general" intelligence within a biologically constrained substrate.39  
* **NengoSPA:** The modern implementation allows researchers to write high-level cognitive operations (e.g., visual\_input \>\> memory) which the Nengo compiler translates into networks of spiking neurons with biologically plausible connection weights. This abstraction layer is crucial for scaling up neuromorphic development.41

### **5.2 BrainTransformers: Spiking Large Language Models**

An emerging breakthrough in late 2024 is the development of **BrainTransformers**, which combine the architectural advantages of Transformers (Self-Attention) with the energy efficiency of SNNs. This represents a direct challenge to the GPU-dominated paradigm of AI.12

* **Mechanism:** Traditional MatMul (Matrix Multiplication) operations in Transformers—which are computationally expensive—are replaced with **SNNMatmul**. This relies on the property that spiking neurons output discrete events ![][image7] rather than continuous floating-point numbers.  
* **Synaptic Plasticity Module:** The architecture incorporates a **Synapsis Module** that simulates biological plasticity. It enables efficient linear transformations by leveraging the sparsity of spikes, allowing the model to convert complex multiplication operations into simpler accumulation operations (addition and subtraction).  
* **EI\_IF Neurons:** The model utilizes **EI\_IF (Excitatory-Inhibitory Integrate-and-Fire)** neurons with adaptive thresholds and membrane potential decay. These neurons update their potential based on input current and fire only when thresholds are reached, ensuring the system remains silent (and energy-neutral) when no information is being processed.  
* **Impact:** This hybrid approach allows for "LLM-like" capabilities (tested on benchmarks like MMLU and GSM8K, achieving scores competitive with standard 3B parameter models) but with drastically reduced energy consumption. This paves the way for deploying cognitive agents on edge devices (neuromorphic chips like Intel Loihi) rather than massive GPU clusters.12

### **5.3 Energy Efficiency: The Critical Metric**

The comparative analysis of architectures in 2025 is increasingly focused on energy. The human brain's efficiency (approx. 20W) is the gold standard.

* **LLMs:** High energy cost per inference. They are "always on" during processing, engaging billions of parameters for every token.  
* **SNNs (Nengo/BrainTransformers):** These systems demonstrate extreme efficiency due to **event-driven computation**. Neurons only consume power when they spike.  
* **Spiking Brain Compression (SBC):** A 2025 technique, SBC allows for **one-shot post-training quantization** of SNNs. This method computes the Hessian of the spike train loss to prune or quantize synapses in a single pass, making it possible to compress large cognitive models onto resource-constrained hardware without extensive retraining. This addresses one of the major bottlenecks in neuromorphic deployment: the difficulty of training SNNs.44

## **6\. Explicit/Implicit Synergy: CLARION and LIDA**

While much of the field focuses on "Unification," other architectures focus on the duality of the mind—specifically, the distinction between implicit (subconscious) and explicit (conscious) processing.

### **6.1 CLARION: The Dual-Process Integrator**

**CLARION (Connectionist Learning with Adaptive Rule Induction ON-line)** occupies a unique niche by explicitly structuring the mind into two interacting levels.46

* **Top Level (Explicit):** Contains symbolic rules and conceptual knowledge (e.g., "If the light is red, stop"). This level is accessible to consciousness and verbalization.  
* **Bottom Level (Implicit):** Contains neural networks and reinforcement learning values (e.g., the motor intuition of how much pressure to apply to the brake). This level is inaccessible to consciousness but drives fast, reactive behavior.

**The 2025 LLM Integration:** In 2025, Ron Sun and colleagues proposed a synergistic combination of CLARION and LLMs to solve the "Hallucination" and "Grounding" problems. The proposal leverages CLARION's dichotomy: the LLM serves as the **Bottom Level**, providing powerful, intuitive text generation and statistical association. However, it is wrapped by CLARION's **Top Level**, which imposes symbolic constraints, goal tracking, and logic verification.

* This hybrid architecture allows the agent to "verify" the intuition of the LLM against explicit rules. If the LLM generates a chemically impossible formula, the Top Level (which knows the explicit rules of valency) can veto or correct it. This structure offers a promising path toward **Safe AGI**, where the creativity of neural networks is bounded by the rigor of symbolic logic.47

### **6.2 LIDA: Consciousness and the Cognitive Cycle**

The **LIDA (Learning Intelligent Decision Agent)** architecture continues to evolve, maintaining its focus on **Global Workspace Theory (GWT)**. LIDA models cognition not as a continuous flow, but as a sequence of rapid (approx. 10 Hz) **cognitive cycles**.48  
**The LIDA Cognitive Cycle:**

1. **Perception:** Sensory data is sensed and interpreted.  
2. **Workspace:** Percepts are brought into the pre-conscious workspace where they cue associated memories (episodic and semantic).  
3. **Consciousness (Broadcast):** A competition ensues between the contents of the workspace. The most salient content "wins" and is globally broadcast to all modules. This broadcast *is* the moment of consciousness in the model.  
4. **Action Selection:** The broadcast triggers action schemes in procedural memory.

**2025 Updates: Digital Twins:** Recent work has applied LIDA to **Industrial Digital Twins**. A "Bio-inspired LIDA-based Digital Twin" was proposed for unmanned maintenance. In this system, the LIDA agent uses its "conscious" broadcast mechanism to prioritize diverse sensor data from a machine tool (vibration, heat, sound). The "broadcast" effectively gives the machine a form of **situational awareness**, allowing it to detect anomalies that a standard threshold-based sensor system would miss. This application demonstrates the utility of cognitive architectures in high-stakes, real-world engineering environments.11

## **7\. Open-World Adaptability: NovelGym and Hybrid Systems**

A major failure mode of traditional AI (and even standard RL) is the "Open World" problem. When the rules of the environment change unexpectedly (e.g., a tool breaks, or a new law of physics applies), standard models often fail catastrophically. Research in 2024-2025 has focused on architectures that can adapt to *novelty*.

### **7.1 NovelGym and Neuro-Symbolic Handling of Novelty**

Research at the Tufts Human-Robot Interaction (HRI) Lab has produced **NovelGym**, a simulation ecosystem designed to benchmark cognitive architectures against "open-world" novelties.49

* **The Problem:** Standard RL agents (like DQN or PPO) suffer from **catastrophic forgetting**. If they retrain to handle a new rule, they forget the old ones.  
* **The Architecture:** A **Neuro-Symbolic Cognitive Architecture** is proposed that combines:  
  * **Deep Computer Vision:** To detect objects and attributes.  
  * **Symbolic Planning:** To reason about object affordances and causal links.  
  * **Reinforcement Learning:** To adapt to new mechanics.  
* **Mechanism:** When the agent encounters a contradiction (e.g., an object that usually breaks now bounces), the symbolic planner detects the anomaly (a "surprise" signal, similar to Sigma's expectedness). It then triggers a **localized** RL process to learn the new property *only for that object context*, without overwriting the entire policy.  
* **Hybrid Hierarchical RL:** This approach utilizes **nested hierarchical action abstraction**. The robot uses previously acquired symbolic skills to tackle the novelty, while the RL component fine-tunes the specific motor control required for the new situation. Results show this hybrid approach accommodates changes significantly faster than pure RL methods.49

## **8\. Synthesis: The State of the Art and Future Outlook**

The landscape of cognitive architecture in 2025 is defined by the collapse of the rigid boundary between "symbolic" and "neural." The field has moved beyond the "Big Two" (ACT-R and Soar) into a rich ecosystem of hybrid, generative, and biologically constrained systems.

### **8.1 The Convergence of Paradigms**

We observe a clear convergence:

* **Symbolic architectures** (Sigma, CMC) are incorporating continuous variables, probabilistic inference, and gradient-based learning to handle the messiness of the real world and the nuance of emotion.13  
* **Neural architectures** (LLMs, Transformers) are being wrapped in symbolic control structures (CoALA, CLARION hybrid) to provide memory, consistency, and metacognition.4  
* **Biologically plausible models** (Nengo, SNNs) are scaling up to perform "AI-grade" tasks (BrainTransformers) while offering a sustainable path forward regarding energy consumption.12

### **8.2 The Energy Bottleneck**

A critical insight from this analysis is that **Energy Efficiency** is becoming the primary constraint on the future of cognitive architecture. While CoALA agents are powerful, they are energetically unsustainable for embodied, always-on deployment. The future belongs to architectures that can replicate the "LLM" capabilities within the "SNN" energy envelope—a goal that projects like BrainTransformers and Nengo are actively pursuing.36

### **8.3 Conclusion**

The "State of the Art" is no longer a specific software version of Soar or ACT-R. It is the **Neuro-Symbolic Synthesis**: architectures that possess the fluid generativity of large neural models, the rigorous consistency of symbolic planners, and the energy efficiency of spiking neuromorphic substrates. The "Standard Model of the Mind" is no longer a static diagram; it is becoming a dynamic, self-refining, and emotionally modulated system capable of surviving the open world.

### ---

**Table 1: Comparative Analysis of Modern Cognitive Architectures (2024–2025)**

| Architecture | Core Paradigm | Primary Memory Structure | Key Novelty (2024-2025) | Biologically Plausible? | Energy Efficiency |
| :---- | :---- | :---- | :---- | :---- | :---- |
| **CoALA / Generative Agents** | LLM-based Agentic | Textual Memory Stream (Vector DB) | Reflection, Self-Refinement, Modular Memory | No | Low (High Joules/Token) |
| **Sigma (![][image6])** | Hybrid Graphical Model | Factor Graph (Unified) | Appraisal-based Emotion, PySigma Generative Integration | Functionally Yes, Structurally Abstract | Medium |
| **Nengo / SPA** | Neuromorphic / SNN | Semantic Pointers (Vectors) | Spaun 2.0, BrainTransformers (SNN-LLM) | **Yes** (Spiking) | **High** (Event-Driven) |
| **CLARION** | Dual-Process (Implicit/Explicit) | Neural (Bottom) \+ Rules (Top) | Synergy with LLMs to control hallucination | Yes (Psychological) | N/A (Software) |
| **LIDA** | Global Workspace Theory | Sparse Distributed Memory | Digital Twin Integration, Consciousness Broadcast | Yes (Cycle-based) | Medium |
| **NovelGym Agents** | Neuro-Symbolic Hybrid | Symbolic Planner \+ RL Policy | Handling Open-World Novelty via localized RL | Partially | Medium |

### **Table 2: The CoALA Memory & Action Matrix**

| Module | Function | Example Implementation |
| :---- | :---- | :---- |
| **Working Memory** | Active Context | Current prompt window, scratchpad |
| **Episodic Memory** | Experience Log | Vector database (RAG) with Recency/Importance scoring |
| **Semantic Memory** | World Knowledge | External Knowledge Graph, Wikipedia, or LLM weights |
| **Procedural Memory** | Skills / Code | Tool definitions (def search():), Prompt Chains |
| **Action Space** | Interaction | **Internal:** retrieve(), think(); **External:** click(), speak() |

#### **Works cited**

1. (PDF) Integrated cognitive architectures: A survey \- ResearchGate, accessed December 31, 2025, [https://www.researchgate.net/publication/225257926\_Integrated\_cognitive\_architectures\_A\_survey](https://www.researchgate.net/publication/225257926_Integrated_cognitive_architectures_A_survey)  
2. Bridging Generative Networks with the Common Model of Cognition \- arXiv, accessed December 31, 2025, [https://arxiv.org/html/2403.18827v1](https://arxiv.org/html/2403.18827v1)  
3. Cognitive Architectures Overview \- Emergent Mind, accessed December 31, 2025, [https://www.emergentmind.com/topics/cognitive-architectures](https://www.emergentmind.com/topics/cognitive-architectures)  
4. Cognitive Architectures for Language Agents \- OpenReview, accessed December 31, 2025, [https://openreview.net/forum?id=1i6ZCvflQJ](https://openreview.net/forum?id=1i6ZCvflQJ)  
5. Neuro Symbolic Architectures with Artificial Intelligence for Collaborative Control and Intention Prediction \- GSC Online Press, accessed December 31, 2025, [https://gsconlinepress.com/journals/gscarr/sites/default/files/GSCARR-2025-0288.pdf](https://gsconlinepress.com/journals/gscarr/sites/default/files/GSCARR-2025-0288.pdf)  
6. Distinctive properties of biological neural networks and recent advances in bottom-up approaches toward a better biologically plausible neural network \- Frontiers, accessed December 31, 2025, [https://www.frontiersin.org/journals/computational-neuroscience/articles/10.3389/fncom.2023.1092185/full](https://www.frontiersin.org/journals/computational-neuroscience/articles/10.3389/fncom.2023.1092185/full)  
7. (PDF) A Standard Model of the Mind: Toward a Common Computational Framework Across Artificial Intelligence, Cognitive Science, Neuroscience, and Robotics \- ResearchGate, accessed December 31, 2025, [https://www.researchgate.net/publication/322123676\_A\_Standard\_Model\_of\_the\_Mind\_Toward\_a\_Common\_Computational\_Framework\_across\_Artificial\_Intelligence\_Cognitive\_Science\_Neuroscience\_and\_Robotics](https://www.researchgate.net/publication/322123676_A_Standard_Model_of_the_Mind_Toward_a_Common_Computational_Framework_across_Artificial_Intelligence_Cognitive_Science_Neuroscience_and_Robotics)  
8. A Proposal to Extend the Common Model of Cognition with Metacognition \- ResearchGate, accessed December 31, 2025, [https://www.researchgate.net/publication/392530155\_A\_Proposal\_to\_Extend\_the\_Common\_Model\_of\_Cognition\_with\_Metacognition](https://www.researchgate.net/publication/392530155_A_Proposal_to_Extend_the_Common_Model_of_Cognition_with_Metacognition)  
9. Cognitive Architectures for Language Agents (CoALA): Standard method to build AI Agents | by Darshan Tank | Medium, accessed December 31, 2025, [https://medium.com/@darshantank\_55417/cognitive-architectures-for-language-agents-coala-standard-method-to-build-ai-agents-f4b85704924e](https://medium.com/@darshantank_55417/cognitive-architectures-for-language-agents-coala-standard-method-to-build-ai-agents-f4b85704924e)  
10. Large-scale cognitive model design using the Nengo neural simulator \- University of Waterloo, accessed December 31, 2025, [https://compneuro.uwaterloo.ca/files/publications/sharma.2016.pdf](https://compneuro.uwaterloo.ca/files/publications/sharma.2016.pdf)  
11. CogTwin: A Hybrid Cognitive Architecture Framework for Adaptable and Cognitive Digital Twins \- IJCAI, accessed December 31, 2025, [https://www.ijcai.org/proceedings/2025/1032.pdf](https://www.ijcai.org/proceedings/2025/1032.pdf)  
12. BrainTransformers: SNN-LLM \- arXiv, accessed December 31, 2025, [https://arxiv.org/html/2410.14687v2](https://arxiv.org/html/2410.14687v2)  
13. A Proposal to Extend the Common Model of Cognition with Metacognition \- arXiv, accessed December 31, 2025, [https://arxiv.org/html/2506.07807v1](https://arxiv.org/html/2506.07807v1)  
14. \[Literature Review\] A Proposal to Extend the Common Model of Cognition with Metacognition \- Moonlight, accessed December 31, 2025, [https://www.themoonlight.io/en/review/a-proposal-to-extend-the-common-model-of-cognition-with-metacognition](https://www.themoonlight.io/en/review/a-proposal-to-extend-the-common-model-of-cognition-with-metacognition)  
15. A Proposal to Extend the Common Model of Cognition with Metacognition \- arXiv, accessed December 31, 2025, [https://arxiv.org/html/2506.07807v2](https://arxiv.org/html/2506.07807v2)  
16. Towards Emotion in Sigma: From Appraisal to Attention \- AGI Conference, accessed December 31, 2025, [https://agi-conf.org/2015/wp-content/uploads/2015/07/agi15\_rosenbloom.pdf](https://agi-conf.org/2015/wp-content/uploads/2015/07/agi15_rosenbloom.pdf)  
17. Emotion in the Common Model of Cognition \- CORE Scholar, accessed December 31, 2025, [https://corescholar.libraries.wright.edu/cgi/viewcontent.cgi?article=1563\&context=psychology](https://corescholar.libraries.wright.edu/cgi/viewcontent.cgi?article=1563&context=psychology)  
18. Bridging Generative Networks with the Common Model of Cognition, accessed December 31, 2025, [https://ojs.aaai.org/index.php/AAAI-SS/article/download/27709/27482/31760](https://ojs.aaai.org/index.php/AAAI-SS/article/download/27709/27482/31760)  
19. PySigma: Towards Enhanced Grand Unification for the Sigma Cognitive Architecture | Request PDF \- ResearchGate, accessed December 31, 2025, [https://www.researchgate.net/publication/357638056\_PySigma\_Towards\_Enhanced\_Grand\_Unification\_for\_the\_Sigma\_Cognitive\_Architecture](https://www.researchgate.net/publication/357638056_PySigma_Towards_Enhanced_Grand_Unification_for_the_Sigma_Cognitive_Architecture)  
20. Cognitive Architectures for Language Agents \- arXiv, accessed December 31, 2025, [https://arxiv.org/abs/2309.02427](https://arxiv.org/abs/2309.02427)  
21. CoALA: Awesome Language Agents \- GitHub, accessed December 31, 2025, [https://github.com/ysymyth/awesome-language-agents](https://github.com/ysymyth/awesome-language-agents)  
22. Cognitive Architectures for AI Agents (CoALA): Explained \- Cognee, accessed December 31, 2025, [https://www.cognee.ai/blog/fundamentals/cognitive-architectures-for-language-agents-explained](https://www.cognee.ai/blog/fundamentals/cognitive-architectures-for-language-agents-explained)  
23. Generative Agents: Interactive Simulacra of Human Behavior \- arXiv, accessed December 31, 2025, [https://arxiv.org/pdf/2304.03442](https://arxiv.org/pdf/2304.03442)  
24. \[PDF\] Generative Agents: Interactive Simulacra of Human Behavior | Semantic Scholar, accessed December 31, 2025, [https://www.semanticscholar.org/paper/Generative-Agents%3A-Interactive-Simulacra-of-Human-Park-O%E2%80%99Brien/5278a8eb2ba2429d4029745caf4e661080073c81](https://www.semanticscholar.org/paper/Generative-Agents%3A-Interactive-Simulacra-of-Human-Park-O%E2%80%99Brien/5278a8eb2ba2429d4029745caf4e661080073c81)  
25. An architectural framework for Generative Agents | by Daniele Nanni \- Medium, accessed December 31, 2025, [https://medium.com/@daniele.nanni/from-npcs-to-generative-agents-part-2-d09d3af37738](https://medium.com/@daniele.nanni/from-npcs-to-generative-agents-part-2-d09d3af37738)  
26. Modeling realistic human behavior using generative agents in a multimodal transport system: Software architecture and Application to Toulouse \- arXiv, accessed December 31, 2025, [https://arxiv.org/html/2510.19497v1](https://arxiv.org/html/2510.19497v1)  
27. Generative Agents: Interactive Simulacra of Human Behavior \- 3D Virtual and Augmented Reality, accessed December 31, 2025, [https://3dvar.com/Park2023Generative.pdf](https://3dvar.com/Park2023Generative.pdf)  
28. Explore Generative AI Agents that can Remember, Reflect, and Plan Actions | Towards AI, accessed December 31, 2025, [https://towardsai.net/p/l/explore-generative-ai-agents-that-can-remember-reflect-and-plan-actions](https://towardsai.net/p/l/explore-generative-ai-agents-that-can-remember-reflect-and-plan-actions)  
29. Cognitive Kernel-Pro: A Framework for Deep Research Agents and Agent Foundation Models Training \- arXiv, accessed December 31, 2025, [https://arxiv.org/pdf/2508.00414](https://arxiv.org/pdf/2508.00414)  
30. Agent-Pro: Learning to Evolve via Policy-Level Reflection and Optimization \- ACL Anthology, accessed December 31, 2025, [https://aclanthology.org/2024.acl-long.292.pdf](https://aclanthology.org/2024.acl-long.292.pdf)  
31. agentrefine: enhancing agent generaliza \- arXiv, accessed December 31, 2025, [https://arxiv.org/pdf/2501.01702](https://arxiv.org/pdf/2501.01702)  
32. Reflexion Agent 101 \- Cognitive Class, accessed December 31, 2025, [https://cognitiveclass.ai/courses/reflexion-agent-101](https://cognitiveclass.ai/courses/reflexion-agent-101)  
33. Iterative Refinement with Self-Feedback \- OpenReview, accessed December 31, 2025, [https://openreview.net/pdf?id=S37hOerQLB](https://openreview.net/pdf?id=S37hOerQLB)  
34. Cognitive Architecture, accessed December 31, 2025, [https://cogarch.ict.usc.edu/](https://cogarch.ict.usc.edu/)  
35. Towards Emotion in Sigma: From Appraisal to Attention \- ResearchGate, accessed December 31, 2025, [https://www.researchgate.net/publication/277305312\_Towards\_Emotion\_in\_Sigma\_From\_Appraisal\_to\_Attention](https://www.researchgate.net/publication/277305312_Towards_Emotion_in_Sigma_From_Appraisal_to_Attention)  
36. THE ECONOMICS OF ENERGY EFFICIENCY: HUMAN COGNITION VS. AI LARGE LANGUAGE MODELS | Ecoforum Journal, accessed December 31, 2025, [https://ecoforumjournal.ro/index.php/eco/article/view/2770](https://ecoforumjournal.ro/index.php/eco/article/view/2770)  
37. (PDF) The economics of energy efficiency: human cognition Vs. AI Large Language Models, accessed December 31, 2025, [https://www.researchgate.net/publication/392200925\_The\_economics\_of\_energy\_efficiency\_human\_cognition\_Vs\_AI\_Large\_Language\_Models](https://www.researchgate.net/publication/392200925_The_economics_of_energy_efficiency_human_cognition_Vs_AI_Large_Language_Models)  
38. Introduction to the Semantic Pointer Architecture \- Nengo, accessed December 31, 2025, [https://www.nengo.ai/nengo-spa/v1.1.1/user-guide/spa-intro.html](https://www.nengo.ai/nengo-spa/v1.1.1/user-guide/spa-intro.html)  
39. Releases · xchoo/spaun2.0 \- GitHub, accessed December 31, 2025, [https://github.com/xchoo/spaun2.0/releases](https://github.com/xchoo/spaun2.0/releases)  
40. Spaun 2017-07-05 documentation, accessed December 31, 2025, [https://xchoo.github.io/spaun2.0/](https://xchoo.github.io/spaun2.0/)  
41. nengo/nengo-spa: Implementation of the Semantic Pointer Architecture for Nengo \- GitHub, accessed December 31, 2025, [https://github.com/nengo/nengo-spa](https://github.com/nengo/nengo-spa)  
42. NengoSPA 2.0.1.dev0 docs, accessed December 31, 2025, [https://www.nengo.ai/nengo-spa/](https://www.nengo.ai/nengo-spa/)  
43. BrainTransformers: SNN-LLM, accessed December 31, 2025, [https://arxiv.org/abs/2410.14687](https://arxiv.org/abs/2410.14687)  
44. Spiking Brain Compression: Exploring One-Shot Post-Training Pruning and Quantization for Spiking Neural Networks \- OPT 2025: Optimization for Machine Learning, accessed December 31, 2025, [https://opt-ml.org/papers/2025/paper82.pdf](https://opt-ml.org/papers/2025/paper82.pdf)  
45. \[2506.03996\] Spiking Brain Compression: Exploring One-Shot Post-Training Pruning and Quantization for Spiking Neural Networks \- arXiv, accessed December 31, 2025, [https://arxiv.org/abs/2506.03996](https://arxiv.org/abs/2506.03996)  
46. Understanding CLARION \- A computational cognitive architecture \- IndiaAI, accessed December 31, 2025, [https://indiaai.gov.in/article/understanding-clarion-a-computational-cognitive-architecture](https://indiaai.gov.in/article/understanding-clarion-a-computational-cognitive-architecture)  
47. Enhancing Computational Cognitive Architectures with LLMs ... \- arXiv, accessed December 31, 2025, [https://arxiv.org/abs/2509.10972](https://arxiv.org/abs/2509.10972)  
48. LIDA (cognitive architecture) \- Wikipedia, accessed December 31, 2025, [https://en.wikipedia.org/wiki/LIDA\_(cognitive\_architecture)](https://en.wikipedia.org/wiki/LIDA_\(cognitive_architecture\))  
49. Research \- HRILab Tufts, accessed December 31, 2025, [https://hrilab.tufts.edu/research/](https://hrilab.tufts.edu/research/)

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAYCAYAAAAlBadpAAAAy0lEQVR4Xu2SMQ8BURCER6XSqiVahd8gWr3/4g8olCqVH6KlUGkQnUonR0hEEGaz7708e+/UivuSSS4zs5fbzQElI+pMvZ1u1JF6RF7Dl4vwRcsM6jdtECOFuTVJB5qtbeDpQwtdG5AJNJsaP7BB+pOFonUCqUKbelJ74+eQQbnwklpRd+dV41IKv68cJmbr/J/skC4NoX7dBjGpfYUr1K/YIEYKC2ui+KWBAbTQswHyw+F5TF2oDHrlE/XyoaMFHThA//fad1zy53wAhPQ9J2j9tisAAAAASUVORK5CYII=>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABEAAAAYCAYAAAAcYhYyAAAAzklEQVR4Xu2QsQqBYRSGj2SSG8BoYnEBymIwKZtRLkGySJJLMCmDW5FyAyarndWieN/vPz+n4xvM+p968nvO1+f8RDIyfqcJN7Co30twDscwlx4CU7iDFdMCBXiAPfiEK0kOkoW2OjzDPCxrq+qZwF4/h5IMl59R2IjtYhphm9jAtQl/iUPLKNK4DVvD9QAHR9e4gb+Em/r2hoNupKWva9vVtcBA4reztSOto893OzjJ9yWx/6Nl2gzWzEwecG0D2MKba4Svwov6fpDxt7wA+DAuJEA6mfoAAAAASUVORK5CYII=>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAkAAAAZCAYAAADjRwSLAAAAlElEQVR4XmNgGAU0A5eA+AUQ/wNiNyB+CMSGyAr+A3EdGh+E4eAjugAQPEMXA3GeIwtAxb7BOCFQgXS4NASAxGphnB1QAWSgAhVjhwlMgQoggyXoYtxoAsFQ/g8kMTBwhkqAsA+UbkBWgA7UGCCKONElkMF6Bkw3woE4EBczIKzNRJWGAEkgdgdiJyB2AeIAVGm6AQAwrybsyxK/hQAAAABJRU5ErkJggg==>

[image4]: <data:image/png;base64,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>

[image5]: <data:image/png;base64,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>

[image6]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAXCAYAAAA7kX6CAAAArUlEQVR4XmNgGDngPxS/B+LXQPwGiN8B8Q8kORhGAb24JJDAfAYc8l8YIBJ70CWQAFaNIACz1RxdAgo2ATETuiAI2DDgd7IYEHOjC8LAEQZEQJEMYLayoksQAl+BWA9dkBC4BcQJ6IJQUA/EvOiCILCOARJfuMAHdAEQKAHii+iCSICDAUtoOwLxbyBWB2INKNZigPjTF4gXM+CIprdA/J0BovkfA0IRNjwKaAYATQ4zuHyTHsAAAAAASUVORK5CYII=>

[image7]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFEAAAAXCAYAAABzjqNHAAAChUlEQVR4Xu2Yu2sUURTGj4r4Vnwk+CQgqKAgIkoQjI02Fgo+QUTsBB+RBKwsbbTQxkbwHxAJKbRIwN5GBftUAS0UCytBRNHzce4Nky87c8+dnV0Duz/4WOY7c+5+e5O5c2dE+vRZ7OxTXWGzh7io2suml0eqv6onqgGq9RKHVJNic3GPaknQdJrNBkGgm2xmsEb1Rizne9WS+eVsUnmuin2Xm/ViDau50CYvVL/ExoZuzS+72SHWvyocbw7HS+fO8JGTZ7dkTiIu3zqhckiFruKH6iV5H1Q/ycshlWeXZM7Jdsmc9RqkQleB3svk3Q9+XVJ5toqds5wLZQxJe4E8pEKXcUKs9zj514O/iXwvqTzx6lzBhTL2yOKdxDGx3sPkXwr+MPleUnk2ip2zlgtlYMHtxiTeZtPBA7Heg+SfCz7uonXw5ME5T9lkjqk+qn6r1lEtgjvhEaewUS8DgUbZdHBDrBf7tyLYFMM/Sb4XT564a3mrOkq1OS6oPqm+q5ZRLTKkOuvUSOhpBcLcZdNBXBPxBy9yLfjY/tTBkwfr4RfVjOoM1RYwLd25nLG+5YIfgt5O3J1TeXDOczbLOCDtBfKA8cfZDOBJCRnKQC+vTVPBL5Iap0hVHpB9Y9kpCwM1yRax8R9zQezxDbWq72/1X4fj84VjzziRqjyRuMVx7xO3ie/Lc5lQfVN9Flt78flV7NGryCvVLHkMdhB/wieytroUU+N484C42XY/ow9KZkMHeMdGTZoaJ/vq3CDWEB/w/wdZgStoapzsFxAADbyN6BZ4xYV1ql2aGgfEfWgWr8Wa8HJ2JdU6DR47m6CJcbAWPhObi4dUc3NKWi/avcId1X42+3SIf8q7oo+B+FsHAAAAAElFTkSuQmCC>