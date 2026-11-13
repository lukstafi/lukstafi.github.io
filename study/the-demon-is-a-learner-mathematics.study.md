---
title: "Study notes: The Demon Is a Learner: The Mathematics"
essay: the-demon-is-a-learner-mathematics
track: learners-and-uncertainty
reviewed-against: "817f678"
requires:
  - {at: the-standard-of-motion-mathematics#one-bracket-three-mechanics, for: "the Hamiltonian, the divergence of a flow and Liouville's theorem, from which this page starts"}
  - {at: the-demon-is-a-learner, for: what the derivations are for, strength: helpful}
  - {at: the-bookmaker-is-a-learner-mathematics, for: "the LMSR cost function and its conjugate, met here as a log-partition function and negative entropy", strength: helpful}
  - {at: how-does-a-policy-improve, for: "Lagrange multipliers as prices, and the tilt of a prior", strength: helpful}
introduces:
  - {term: macrostate and microstate, at: entropy-counts}
  - {term: temperature as an exchange rate, at: temperature-is-an-exchange-rate, gloss: "the energy that buys one nat of entropy"}
  - {term: Gibbs state, at: the-gibbs-state}
  - {term: free energy, at: free-energy}
  - {term: Stosszahlansatz, at: counting-collisions}
  - {term: total correlation, at: the-entropy-that-rises-is-a-marginal}
  - {term: H-theorem for a Markov chain, at: an-h-theorem-for-any-markov-chain}
  - {term: fluctuation–dissipation relation, at: friction-from-a-hamiltonian-bath}
  - {term: entropy production, at: with-thermal-noise}
  - {term: log-Sobolev inequality, at: with-thermal-noise}
  - {term: nonequilibrium free energy, at: information-as-work}
  - {term: information bottleneck, at: information-as-work}
  - {term: detailed balance, at: detailed-balance-lets-you-sample-without-knowing-z}
  - {term: fluctuation theorem and Jarzynski equality, at: the-jarzynski-equality-is-annealed-importance-sampling}
  - {term: thermodynamic length, at: thermodynamic-length-sets-the-schedule}
  - {term: mean field and the cavity method, at: mean-field-and-the-cavity}
uses:
  - {term: "Liouville's theorem", from: the-standard-of-motion}
  - {term: Hamiltonian vector field, from: the-standard-of-motion-mathematics}
  - {term: liquidity parameter, from: the-bookmaker-is-a-learner}
  - {term: overdamped limit, from: the-demon-is-a-learner}
  - {term: Polyak–Łojasiewicz condition, from: the-demon-is-a-learner}
  - {term: Boltzmann's assumption, from: the-demon-is-a-learner}
  - {term: coarse graining, from: the-demon-is-a-learner}
  - {term: Landauer's principle, from: the-demon-is-a-learner}
  - {term: Kolmogorov complexity, from: the-demon-is-a-learner}
  - {term: score, from: the-demon-is-a-learner}
  - {term: exponential tilt, from: how-does-a-policy-improve}
  - {term: temperature as a Lagrange multiplier, from: how-does-a-policy-improve}
  - {term: cost-function market and the LMSR, from: the-bookmaker-is-a-learner}
  - {term: conjugate representation of a cost function, from: the-bookmaker-is-a-learner-mathematics}
---

These questions cover the spine of the page: given Liouville's theorem, how entropy can change and who pays when it does. As on the page, entropies are in nats and Boltzmann's constant is 1, except where a question says otherwise.

### The small parameter {kind=derive at=the-overdamped-limit}

Rescale $m\ddot x = F(x) - \gamma\dot x$ for a force with stiffness scale $k$. What is the small parameter, and why does Tikhonov's theorem apply? For a spring, compute the two decay rates at $\varepsilon = 0.1$ and at the threshold of overdamping, and compare them with the rate of the reduced equation.

::: answer
With time measured in the slow unit $\gamma/k$, the equation becomes $\varepsilon X'' + X' = \varphi(X)$ with $\varepsilon = mk/\gamma^2$. As a system it is $X' = U$, $\varepsilon U' = \varphi(X) - U$. For fixed $X$ the fast equation has the equilibrium $U = \varphi(X)$ with eigenvalue $-1/\varepsilon < 0$, so it attracts. After an initial layer of duration $O(\varepsilon)$, solutions follow $X' = \varphi(X)$, that is $\dot x = F/\gamma$. For the spring the roots are $\lambda_\pm = (-1\pm\sqrt{1-4\varepsilon})/2\varepsilon$. At $\varepsilon = 0.1$ they are $-1.127$ and $-8.873$, against the reduced rate $-1$. At the threshold $\varepsilon = 1/4$ both equal $-2$, so the first-order law is off by a factor of 2 there.
:::

### Entropy counts {kind=compute at=entropy-counts}

Twenty distinguishable balls go into two boxes. Count the microstates of the macrostates $(10, 10)$ and $(15, 5)$, and compare $\ln W$ with $N\,H(p)$. What does the comparison say entropy is? Why do typical macrostates dominate?

::: answer
$W = \binom{20}{10} = 184{,}756$ and $\binom{20}{5} = 15{,}504$, so $\ln W$ is $12.13$ and $9.65$. $N\,H(p)$ is $20\ln 2 = 13.86$ and $20\times0.562 = 11.25$. Stirling's formula is rough at $N = 20$, and the differences agree better: $2.48$ against $2.62$. Boltzmann's entropy $\ln W$ is Shannon's entropy per ball times $N$. It is the length of the description still lacking once the macrostate is known. A macrostate with $H$ lower by a fixed $\delta$ has fewer microstates by a factor of $e^{-N\delta}$, and with $N$ near $10^{23}$ no fluctuation reaches it.
:::

### Temperature and free energy {kind=derive at=entropy-temperature-and-free-energy}

Two bodies share a fixed total energy. Derive what they come to share, and say what $T$ buys. Then show why a system in a bath minimizes $F = E - TS$ and not $E$. Check $F = -T\ln Z$ for a system with two states, of energies $0$ and $1$, at $T = 1$.

::: answer
The counts of microstates multiply and the entropies add, so the likeliest split maximizes $S_A(E_A) + S_B(E_{\text{tot}} - E_A)$, which gives $dS_A/dE_A = dS_B/dE_B$. That shared quantity defines $1/T = \partial S/\partial E$. $T$ is the energy that buys one nat, and heat $Q$ raises a bath's entropy by $Q/T$. A system that changes by $\Delta E$ and $\Delta S$ with no work done hands the bath heat $-\Delta E$, so $\Delta S_{\text{tot}} = \Delta S - \Delta E/T = -\Delta F/T$. The second law for system and bath together says that $F$ does not rise. For the two states, $Z = 1 + e^{-1} = 1.368$ and $p = (0.731,\ 0.269)$, so $E = 0.269$, $S = 0.582$ and $E - TS = -0.313 = -\ln Z$.
:::

### The H-theorem {kind=derive at=the-theorem}

Give the idea of the proof that $H = \int f\ln f\,dv$ does not rise under Boltzmann's equation. What does equality force?

::: answer
For any function $\varphi$ of velocity, $\frac{d}{dt}\int\varphi f\,dv$ is an integral of $\varphi\,[f'f_*' - ff_*]\,B$ over collisions. Two relabelings keep its value, each with unit Jacobian and each leaving $B$ unchanged. Swapping the balls replaces $\varphi$ by $\varphi_*$. Exchanging a collision with its reverse replaces it by $\varphi'$ and flips the sign of the bracket. Averaging the four forms replaces $\varphi$ by $\frac14(\varphi + \varphi_* - \varphi' - \varphi_*')$. With $\varphi = \ln f + 1$ the integrand is $-\frac14(f'f_*' - ff_*)\ln\frac{f'f_*'}{ff_*}\,B \le 0$, because $(a-b)\ln(a/b)\ge 0$. Equality needs $ff_* = f'f_*'$ for every collision, so $\ln f$ adds up to the same total before and after, a combination of mass, momentum and energy: the Maxwell distribution $f\propto e^{-|v-u|^2/2T}$.
:::

### The mirror theorem {kind=argue at=where-the-arrow-came-from}

The proof uses three ingredients. Which one is not symmetric in time, and what theorem results from replacing it with its mirror image? Where does the page then locate the arrow, and why is an uncorrelated state "not itself directed"?

::: answer
The swap and the reverse collision hold in either direction of time. The ansatz does not. Assume independence on outgoing pairs instead. Each incoming pair continues as the outgoing pair with the same density, so the loss term becomes $f'f_*'$ and the gain term $ff_*$, the right side of Boltzmann's equation changes sign, and $H$ rises. That theorem is equally rigorous, and both assumptions can hold at once only in equilibrium. Mechanics does not choose between them, which is what Loschmidt's reversal, Zermelo's recurrence and Burbury's Condition A each point out. So the arrow lies in the initial conditions: a gas prepared by ordinary means has no correlations tuned to its future. Extended backward from an uncorrelated state, entropy would rise into the past too. The direction comes from placing the special state at the beginning.
:::

### The entropy that rises is a marginal {kind=state at=the-entropy-that-rises-is-a-marginal}

Let $S_N$ be the entropy of all $N$ balls and $S$ the entropy of one. For a gas that starts uncorrelated, state the identity that says where the entropy of the H-theorem goes, and derive it. How does the ansatz read in its light?

::: answer
Define the total correlation $C(t) = N\,S(t) - S_N(t) \ge 0$, the divergence of the joint distribution from the product of its marginals. $S_N$ is constant by Liouville's theorem and $S_N(0) = N\,S(0)$, so $N\bigl(S(t) - S(0)\bigr) = C(t)$. Every nat gained, summed over the balls, is a nat stored in correlations among them. Nothing has been lost from the gas. The ansatz is then an act of forgetting: it says that each incoming pair carries none of the correlation that earlier collisions made. Entropy rises because a bounded description keeps $f$ and discards the rest.
:::

### An H-theorem for any chain {kind=compute at=an-h-theorem-for-any-markov-chain}

State the H-theorem for a Markov kernel and the idea of its proof. Check it on the two-state chain that leaves state 1 with probability $0.1$ and state 2 with probability $0.2$, started from $\mu = (1, 0)$. Where does the arrow enter?

::: answer
For any two distributions and any kernel, $D(\mu P\,\|\,\pi P) \le D(\mu\,\|\,\pi)$. The proof is the chain rule: the divergence between the joint laws of a state and its successor equals $D(\mu\|\pi)$, because both use the same kernel, and it also equals $D(\mu P\|\pi P)$ plus a nonnegative term for the backward conditionals. Here the stationary distribution is $\pi = (2/3,\ 1/3)$. $D(\mu\|\pi) = \ln 1.5 = 0.405$, and after one step $\mu P = (0.9,\ 0.1)$ with divergence $0.150$. The arrow enters with a kernel chosen without reference to $\mu_t$: the randomness applied at each step knows nothing of the distribution it acts on, which is the Stosszahlansatz for a bath. For stochastic gradient descent the assumption is that each minibatch is drawn fresh. Entropy itself is guaranteed to rise only when $\pi$ is uniform.
:::

### Friction from a closed system {kind=explain at=friction-from-a-hamiltonian-bath}

A particle is coupled to many harmonic oscillators, and the whole is closed and Hamiltonian. What does the particle's own equation contain once the oscillators are solved out? When does the bath's term become noise, and what relation ties it to the friction? What does a finite bath do to the arrow?

::: answer
The exact equation has the force $-V'$, a friction with memory $-\int_0^t\Gamma(t-s)\,\dot x(s)\,ds$, and a term $\xi(t)$ that is a fixed function of the bath's initial state. $\xi$ becomes noise when we stop tracking those initial conditions. With the bath started in its Gibbs state, $\langle\xi(t)\,\xi(s)\rangle = T\,\Gamma(t-s)$: noise and friction have the same kernel because they come from the same oscillators. This is the fluctuation–dissipation relation, derived and not assumed. In the limit of a continuous bath $\Gamma\to2\gamma\,\delta$, and the equation is Langevin's. The arrow came in with a bath that started uncorrelated with the particle and has too many frequencies for anything to come back. With evenly spaced frequencies a distance $\Delta$ apart, the cosines realign at $t = 2\pi/\Delta$ and a particle that had come to rest is kicked back up, which is Zermelo's objection in a bath.
:::

### Two routes to Landauer's bound {kind=derive at=what-forgetting-costs}

Derive Landauer's bound twice: from the entropy balance of overdamped Langevin dynamics, and from the free energy of a distribution out of equilibrium. With Boltzmann's constant $1.38\times10^{-23}$ J/K, evaluate the bound for one bit at $300$ K.

::: answer
*Balance.* With probability current $J = -\gamma^{-1}(\rho\nabla L + T\nabla\rho)$, the system's entropy rate plus the heat rate over $T$ is $\int\gamma|J|^2/(T\rho) \ge 0$. Integrated over a process, $\Delta S_{\text{sys}} + Q/T \ge 0$: if the system's entropy falls by $\Delta$ nats, at least $T\Delta$ of heat goes to the bath, and one bit is $\ln 2$ nats.

*Free energy.* Substituting $\ln\pi = -\beta E - \ln Z$ gives $F[\rho] = F_{\text{eq}} + T\,D(\rho\|\pi)$. An unknown bit is spread evenly over two wells, in equilibrium. Resetting it reaches a state concentrated in one well, for which $D(\rho\|\pi)$ is higher by $\ln 2$, so it takes work of at least $T\ln 2$. The mean energy is unchanged, so the work leaves as heat. Run the other way, this is Szilard's engine.

In joules, $1.38\times10^{-23}\times300\times\ln 2 = 2.9\times10^{-21}$.
:::

### From Still's cycle to the bottleneck {kind=derive at=information-as-work}

Still's engine writes a memory $M$ of the data $X$ at temperature $T$ and extracts work at $T' > T$ from a variable $Y$. Give the best net work, the efficiency, and the condition for producing any work. Show that minimizing the bound on the dissipated heat is the information bottleneck, and read off the price of an irrelevant nat.

::: answer
Writing dissipates at least $T\,I_{\text{mem}}$ and extraction turns at most $T'\,I_{\text{rel}}$ of heat into work, with $I_{\text{mem}} = I[M, X]$ and $I_{\text{rel}} = I[M, Y]$. The best net work is $T'\,I_{\text{rel}} - T\,I_{\text{mem}}$ on a heat intake of $T'\,I_{\text{rel}}$, so $\eta = 1 - \frac{T}{T'}\frac{I_{\text{mem}}}{I_{\text{rel}}}$: Carnot's limit minus $\frac{T}{T'}\frac{I_{\text{irrel}}}{I_{\text{rel}}}$. The engine produces work only if $I_{\text{rel}}/I_{\text{mem}} \ge T/T'$. The net heat dissipated over a cycle is at least $T\,I_{\text{mem}} - T'\,I_{\text{rel}}$. Minimizing that bound over $p(m\mid x)$ is $\min\ I[M, X] - \alpha\,I[M, Y]$ with $\alpha = T'/T$, the information bottleneck. Splitting $I_{\text{mem}} = I_{\text{irrel}} + I_{\text{rel}}$ shows the objective as $I_{\text{irrel}} - (\alpha - 1)\,I_{\text{rel}}$: an irrelevant nat costs 1, and a relevant nat earns $\alpha - 1$ net of its own writing.
:::

### Algorithmic bounds {kind=derive at=algorithmic-bounds}

For a computable distribution $P$, prove both sides of $0 \le \sum_x P(x)\,K(x) - H(P) \le K(P) + O(1)$. Then prove the bound on $K(x_t)$ for a state evolving by a computable map $f$, and say what a bijective $f$ adds.

::: answer
*Lower bound.* The shortest programs form a prefix-free code, so by Kraft's inequality their average length is at least $H(P)$.

*Upper bound.* Describe $x$ by a description of $P$ followed by the Shannon–Fano codeword for $x$ under $P$, of length $\lceil-\log_2 P(x)\rceil$. Averaging gives $H(P) + K(P) + O(1)$.

*Dynamics.* A program for $x_t$ can consist of a shortest program for $x_0$, self-delimiting descriptions of $f$ and of $t$, and a fixed routine that applies $f$ $t$ times. So $K(x_t) \le K(x_0) + K(f) + K(t) + O(1)$, with $K(t) \le \log_2 t + 2\log_2\log_2 t + O(1)$. If $f$ is a computable bijection the argument runs backward too, so the complexity can neither rise nor fall by more than these terms. At the moment of reversal the gas of Figure 2 has the complexity of its initial state, up to these terms, although its one-ball statistics have nearly reached the Maxwell value.
:::

### Ten tools {kind=recall at=the-tools-side-by-side}

Section 12 takes ten tools from statistical mechanics. For each, name what it does in learning: the partition function; Gibbs's variational principle; the Legendre transform and the Maxwell relations; Laplace's method; fluctuation and response; detailed balance; the Jarzynski equality; thermodynamic length; mean field and the cavity; the time reversal of a diffusion.

::: answer
- *Partition function.* Its logarithm gives means and covariances by differentiation: softmax, exponential families, Fisher information, the two-phase learning rule.
- *Gibbs's variational principle.* The evidence lower bound is the negative of a free energy; also EM, regularized objectives and PAC-Bayes.
- *Legendre transform.* Conjugate duality; a penalty and a trust region are Legendre partners; a cost-function market is path-independent.
- *Laplace's method.* The Occam factor, BIC, flat minima.
- *Fluctuation and response.* Score-function gradients, and a temperature for SGD, $T_{\text{eff}} = \eta\sigma^2/2B$.
- *Detailed balance.* MCMC, simulated annealing and SGLD; only ratios of $\pi$ appear, so $Z$ cancels.
- *Jarzynski and Crooks.* Annealed importance sampling, with the gap of the evidence lower bound as dissipated work.
- *Thermodynamic length.* Schedules for annealing and for the noise of diffusion models.
- *Mean field and the cavity.* Variational inference, belief propagation, thresholds of capacity.
- *Time reversal.* Diffusion models.
:::

### Reversing a diffusion {kind=derive at=reversing-a-diffusion}

Give the drift of the time reversal of $dx = -\nabla V\,dt + \sqrt{2T}\,dW$ and check it. What does the drift reduce to at equilibrium? Why can a bath not supply it? How does the ledger of a trained score network differ from Szilard's?

::: answer
The paths read backward are a diffusion with the same noise and the drift $\nabla V + 2T\,\nabla\ln\rho_t$ (Anderson). To check, the forward Fokker–Planck equation in reverse time is $\partial_s\rho = -\nabla\cdot(\rho\nabla V) - T\Delta\rho$, and $-T\Delta\rho = -\nabla\cdot(2T\rho\,\nabla\ln\rho) + T\Delta\rho$, so the stated drift with the same noise gives the same path of densities. With $\pi\propto e^{-V/T}$ the drift is $-\nabla V + 2T\,\nabla\ln(\rho_t/\pi)$. At equilibrium the second term vanishes and the reversed film is the same process, which is detailed balance. Out of equilibrium the correction depends on $\rho_t$, the dependence §9.7 denies to a bath's kernel, and the forward process dissipates exactly as fast as the reverse needs correcting. A trained network holds the score $\nabla\ln\rho_t$ as statistical knowledge of a population and looks at nothing. A demon gains work from what it knows, while a physical run of the reversal would cost at least $T\,D(\rho_{\text{data}}\|\pi)$ of work, the total entropy production of the forward run.
:::

### Where a tool stops {kind=limits at=a-toolbox-for-learners}

The toolbox marks where a transfer from physics stops. Give the caveat attached to each of: temperature as regularization strength; flat minima; the temperature of SGD; thermodynamic length for diffusion models; the exponential average in Jarzynski's equality.

::: answer
- The $T$ of a regularized objective is statistical. It has no bath and pays no joules.
- A rescaling of a rectifier network's weights makes a minimum as sharp as you like without changing the function. The Hessian depends on coordinates. Width alone is not the invariant, and width measured against a prior is.
- $T_{\text{eff}}$ is derived for isotropic gradient noise. Anisotropic noise means the stationary state is not Gibbs.
- The formula assumes a full relaxation at each step, which a diffusion model does not have. What carries over to noise schedules is the path and its Fisher length.
- Rare paths with low work dominate the average. An accurate estimate needs a number of samples of the order of $e^{D}$, with $D$ the dissipation of the reverse process. For the evidence lower bound that is $D(p(z\mid x)\|q)$, the divergence variational inference does not minimize.
:::
