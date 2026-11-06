# Review: *The Demon Is a Learner: The Mathematics* (draft of 5 Nov 2026)

Scope: `notes/the-demon-is-a-learner-mathematics.md`, with effort on the new material: §7 last paragraph, §8, §9, the Einstein-relation and H-theorem parts of §10.2, §10.3 and §12. Checked against `scripts/figures/demon_is_a_learner.py`, `citecheck-demon-mathematics-2026-11-05.md`, the essay, and the previous page. Every derivation was reworked by hand. Several were also checked numerically, and the figure script was rerun with extra diagnostics: 12 mechanical seeds, 120 random-pair seeds, a twin-trajectory measurement of error growth. The Crooks ratio was checked on a three-state chain, and the Boltzmann symmetrization by Monte Carlo.

Overall: the derivations in §8, §9.1–9.3, §10.2, §10.3 and §12.7–12.8 are right, including every sign in Boltzmann's collision map and in the mirror theorem. Every number quoted for Figures 2 and 3 reproduces. The trouble is in what the prose concludes from some of them. The two most serious findings are conceptual: where §9.7 places the arrow, which §12.10 contradicts, and what the pair correlations of §9.4 show. Findings are ranked most severe first.

---

## A. Physics and mathematics

**A1. "In the word *Markov*" is the wrong place for the arrow, and §12.10 contradicts it.** (§9.7, para 2)
- *Problem.* The Markov property is symmetric in time. Past and future are independent given the present, so a Markov chain read backward is again Markov, and it can be driven by noise independent of the current state. §12.10 exhibits such a process: a reversed diffusion with fresh noise at every step, in which $D(\rho\|\pi)$ rises. So "randomness independent of the state it hits" does not give the arrow. What gives it is that the kernel is fixed in advance and leaves $\pi$ invariant, so it knows nothing about $\mu_t$. The backward kernels depend on $\mu_t$ (through the score, in §12.10). That dependence is the tuning §9.4 denies to ordinary gases, and it makes a better parallel than the one the page draws.
- *Fix.* "Where did the arrow come in this time? In the kernel, which is fixed in advance and leaves $\pi$ alone. The word *Markov* is not enough, since a Markov chain read backward is again Markov. But its backward kernels depend on $\mu_t$, as the score does in §12.10. A kernel fixed in advance says that the randomness applied at step $t$ knows nothing of the distribution it acts on. That is the Stosszahlansatz for a bath: the molecule arriving at the system has not met it before."

**A2. The pair correlations of §9.4 measure a transient of the single-speed start, and the contrast between the two runs is noise.** (§9.4, para "The asymmetry can be measured on the pairs themselves")
- *Problem, first part.* The quoted numbers reproduce for seed 1, but the sentence reads as a general signature of the ansatz. It is not one. At equilibrium the statistic shows no asymmetry at all: the collision map preserves $ff_*B\,dv\,dv_*\,dn$ (§9.3), so outgoing pairs have exactly the distribution of incoming ones. Measured in the random-pair run from 8 to 16 collisions per disk, 30 seeds: before $-0.104\pm0.002$, after $-0.110\pm0.002$. In the last quarter of the page's forward run the values are already $-0.13$ and $-0.25$. The $-0.66$ arises because the first collisions are between disks of energy near $1/2$, so a pair's energies have a nearly fixed sum and splitting it gives near-perfect anticorrelation.
- *Problem, second part.* "The random-pair run gives $-0.07$ … and its slight correlation before collision comes from fast pairs colliding more often" implies a difference between the runs. Over seeds, the first 1,000 collisions give:

  | run | before | after |
  |---|---|---|
  | random pairs, 120 seeds | $-0.026$, s.d. $0.037$ | $-0.654$, s.d. $0.020$ |
  | random pairs without speed weighting | $-0.003$ | $-0.656$ |
  | mechanical, 12 seeds | $-0.057$, s.d. $0.017$ | $-0.689$, s.d. $0.021$ |

  So the page's $-0.03$ and $-0.07$ are single-seed draws, and the order reverses on average. The speed-weighting explanation is right in sign, but it applies to both runs. A small mean difference between the two runs remains, which I did not diagnose (the lattice start of the mechanical run is one candidate).
- *Fix.* "The asymmetry can be measured on the pairs themselves while the gas relaxes. Take the first quarter of the forward run, when most disks still have nearly their starting energy, and correlate the energies of the two disks in each colliding pair. Before collision the correlation is small, about $-0.03$, and after collision about $-0.66$, because two disks sharing a nearly fixed sum of energy split it. The random-pair run gives the same picture. In both, the small value before collision comes from fast pairs colliding more often, and it moves by about $0.03$ from seed to seed. In the last quarter of the reversed run the numbers swap: $-0.66$ before collision, $-0.03$ after. The reversed gas is the gas for which the mirror theorem holds. The measure works only away from equilibrium. In a Maxwell gas collisions preserve $ff_*B$, so outgoing pairs look like incoming ones, and both correlations sit near $-0.10$."

**A3. "Both cannot hold of the same gas for long" is not the right statement.** (§9.4, para 2)
- *Problem.* If both assumptions hold at one instant, the collision term equals its own negative, so it vanishes and the gas is in equilibrium, where both can hold indefinitely. Out of equilibrium they cannot hold together even for a moment. "For long" gets both cases wrong. "The two objections to Boltzmann said as much" is also loose: Loschmidt and Zermelo argued that mechanics cannot deliver monotonicity, not that the two ansätze exclude each other.
- *Fix.* "Both can hold at once only in equilibrium, where the collision term vanishes. Mechanics itself does not choose between them, and that is the point of two objections to Boltzmann." (This also fixes E4.)

**A4. With $E$ the negative log posterior, $Z$ is 1, not the evidence.** (§12.4, "*In learning.*")
- *Problem.* A normalized posterior has $Z = 1$. The energy must be the negative log of the joint, $-\ln p(D\mid w)p(w)$, the unnormalized posterior. The section's own formulas also use $L$, not $E$.
- *Fix.* "Take $T = 1$ and let $L$ be the negative log joint, $-\ln p(D, w)$, the posterior before normalizing. Then $Z$ is the evidence for a model…"

**A5. The squared length in §12.10 is off by $4T^2$ as written.** (§12.10, para 2)
- *Problem.* "Its squared length under $\rho$, times $T$, is the entropy production." The grammatical antecedent is the second term, $2T\nabla\ln(\rho_t/\pi)$, whose squared length is $4T^2 I$. Times $T$ that gives $4T^3 I$. The entropy production at $\gamma = 1$ is $T\,I$ (§10.2). The claim is true only of $\nabla\ln(\rho_t/\pi)$ without the prefactor. Checked on a Gaussian OU relaxation: $2.25$ against a literal $9$ at $T = 1$.
- *Fix.* "The second term is $2T$ times the field $\nabla\ln(\rho_t/\pi)$ of §10.2. That field's squared length under $\rho$, times $T$, is the entropy production of the forward process. In terms of the correction $c$ itself, the rate is $\mathbb E_\rho|c|^2/4T$, which is the rate at which forward and reversed paths diverge, as §12.7 leads one to expect."

**A6. The Kac ring fails at $t = N$, not first at $t = 2N$.** (§9.6, para 2)
- *Problem.* After $N$ ticks every ball has crossed every marker once, so each colour is flipped by $(-1)^M$, with $M$ the number of markers. The imbalance is back at full size at $t = N$, with sign $(-1)^M$. Checked with $N = 1000$: $M = 100$ gives $+1000$ at $t = N$, and $M = 101$ gives $-1000$. The citecheck (item 4) notes the period $N$ for even $M$. "Fails entirely at $t = 2N$" names the wrong first failure, and it sits awkwardly with the preceding "much shorter than $N$".
- *Fix.* "…and it fails entirely at $t = N$, where the imbalance comes back whole, with its sign flipped if the number of markers is odd."

**A7. $f$ has two normalizations.** (§9.2–9.3, §9.5)
- *Problem.* The Boltzmann equation as written needs $f$ to count balls per unit volume: the cylinder holds a *number* of balls, and there is no density factor in $B$. §9.3 then calls $-\int f\ln f$ "the entropy of one particle", and §9.5 uses $S_N(0) = N\,S(0)$, both of which need $\int f = 1$. With $\int f = n$ the integral is $n(S - \ln n)$. The theorem is unaffected, since $n$ is constant, but the identity of §9.5 is stated with a different $f$ from the equation.
- *Fix.* In §9.1: "the density $f(v, t)$ of velocities, normalized to 1, with $n$ balls per unit volume." In §9.2: "With $B = n\sigma^2((v - v_*)\cdot n)_+$". Choose another letter for the number density, because $n$ is the unit vector, and adjust the sentence on the cylinder.

**A8. The second term of $F_i$ is not $-T$ times the entropy of the basin.** (§12.4)
- *Problem.* $F_i = \langle L\rangle - TS_i$, and $\langle L\rangle = L_i + dT/2$, by the equipartition statement two sentences later. So the Gibbs entropy is $S_i = \ln\bigl[(2\pi T)^{d/2}(\det H_i)^{-1/2}\bigr] + d/2$. The second term of $F_i$ omits the $d/2$. It equals $-T$ times the log of the basin's effective volume. The $d/2$ cancels between basins of equal dimension, so Figure 3's caption is right.
- *Fix.* "The second term of $F_i$ is $-T$ times the logarithm of the basin's effective volume. The Gibbs entropy is that logarithm plus $d/2$, a constant that drops out when two basins of equal dimension are compared."

**A9. "A diffusion model is a trained demon" is stronger than the parallel.** (§12.10, para 5)
- *Problem.* A demon measures a system and extracts work. A score network measures nothing: the reverse drift is a time-dependent force field, a preset protocol with no feedback on the particular sample beyond its position. The ledger also runs the other way. Run physically at temperature $T$, generation lowers the entropy of the system and must cost at least $T\,D(\rho_{\text{data}}\|\pi)$ of work, whereas the demon gains. The valid part of the parallel is that stored knowledge of a population replaces knowledge of each path. "The accounts stay in balance" then cites results about storage and error, not a work balance.
- *Fix.* "A diffusion model resembles a demon in one respect: stored knowledge does the sorting. Maxwell's demon sorts molecules by looking at each one. A trained score network looks at nothing, and holds statistical knowledge of a population in its weights. … Its ledger runs the other way from Szilard's. The demon gains work from what it knows, while a physical run of the reversal would cost at least $T\,D(\rho_{\text{data}}\|\pi)$."

**A10. "Falls at every step, with no further condition on the chain" is false as stated.** (§9.7, para 1)
- *Problem.* The inequality is non-strict. For a permutation of states with uniform $\pi$, or the identity kernel, the divergence never moves. Cover's theorem says "non-increasing". $D$ is also not a distance.
- *Fix.* "If $\pi$ is stationary, the divergence from $\mu_t$ to $\pi$ never rises, with no further condition on the chain. It falls strictly once the chain mixes." In the last sentence of the paragraph, "the quantity that cannot rise".

**A11. "In both, the assumption becomes exact in the limit" fails for sparse graphs in glassy phases.** (§12.9, para 3)
- *Problem.* A sparse random graph has long loops, but that alone does not make the cavity assumption exact. Below a spin glass transition, or past the clustering threshold of a hard problem, long loops carry correlations collectively. Neighbours of a removed site stay correlated, replica symmetry breaks, and belief propagation is no longer exact on a locally tree-like graph. So the parallel with a dilute gas holds only where correlations decay. The next paragraph's "in the regime where its assumption holds" concedes this implicitly.
- *Fix.* "In both, the assumption becomes exact in the limit, provided correlations decay with distance. Short of the limit, what spoils it is correlation coming back around a short cycle. A sparse graph has one further failure with no counterpart here: below a spin glass transition, many long loops together keep distant spins correlated."

**A12. "Three classical results are special cases" is followed by four, and two are not special cases.** (§10.3, para 2)
- *Problem.* Szilard and Landauer are cases of $F[\rho] = F_{\text{eq}} + T\,D$. Carnot uses no $D$ at all: the derivation given is the entropy balance of two baths. Kelly is a formal analogy, as the citecheck says (item 25).
- *Fix.* "Szilard's engine and Landauer's erasure are special cases, and Carnot's bound and Kelly's gambler run on the same exchange."

**A13. "Passing again and again over a fixed dataset breaks it" names the wrong cause.** (§9.7, last sentence)
- *Problem.* Drawing with replacement from a fixed dataset keeps the weight chain Markov, whatever the size of the dataset. What breaks the assumption is sampling without replacement, where a batch depends on which examples came earlier in the epoch.
- *Fix.* "Sweeping through a shuffled dataset epoch by epoch breaks it a little, since each batch then depends on the ones before."

**A14. The energy term is not only the misfit.** (§12.2, "*In learning.*")
- *Problem.* $\mathbb E_q[-\ln p(x, z)] = \mathbb E_q[-\ln p(x\mid z)] + \mathbb E_q[-\ln p(z)]$. The energy term holds the misfit and the code length of the weights under the prior. The essay's net cost, divergence plus misfit, regroups these with the entropy.
- *Fix.* "The energy term is the misfit plus the code length of the latent variables under the prior, and the entropy term is what bits back refunds. Hinton and van Camp make this identification in the essay."

**A15. "The shrinking happens along $p$" sits badly with §10.1.** (§7, "What the limit forgets")
- *Problem.* For a spring the two rates are $\lambda_{\text{slow}}\approx -k/\gamma$ and $\lambda_{\text{fast}}\approx -\gamma/m + k/\gamma$, which sum to $-\gamma/m$. Part of the contraction runs along the slow manifold, and it depends on the force. That part is what §10.1 computes as $-\operatorname{tr}\nabla^2L$ (over $\gamma$). A reader who has just been told "whatever the force" will stumble at §10.1, where the rate depends on the force.
- *Fix.* "Nearly all of the shrinking happens along $p$. The small remainder, of order $k/\gamma$, is the slow contraction along $x$ that §10.1 computes."

**A16. A demon keeps velocities, not correlations, and the figure shows less than "partway back".** (§9.5, last sentence)
- *Problem.* The script rounds velocities and keeps positions at full precision. The dotted curve follows the exact reversal for about 2.7 of the 4 collisions per disk, then bottoms out at $-0.04$ nats. It has recovered $0.32$ of the $2.29$ nats gained, about a seventh, because most of the rise came in the first collision.
- *Fix.* "…and Figure 2 shows what the forgotten correlations are worth. A demon that kept every position exactly and every velocity to six decimal places could run the gas back for about two and a half collisions per disk, which recovers a seventh of the entropy."

**A17. "After each collision" misdescribes the ansatz.** (§9.5, para 2)
- *Problem.* §9.2 states the ansatz for pairs about to collide. The description discards a correlation not at the moment of the collision that made it, but by treating later incoming pairs as independent.
- *Fix.* "It says that each incoming pair carries none of the correlation that earlier collisions made."

**A18. "Gases we can prepare" assumes an arrow, and a state at $t = 0$ obeys the ansatz in both directions.** (§9.4, last para)
- *Problem.* An uncorrelated state at time 0 has no correlations tuned to its past either, so Boltzmann's equation applies to it backward in time as well, and $H$ decreases away from $t = 0$ in both directions. What selects a direction is that this special state lies at the start of the history. "Prepare" presupposes the asymmetry between past and future. A physicist reading "the arrow lies in the initial conditions" will ask why the conditions are initial. The conclusion stands, but it should own this step.
- *Fix.* Add after the first two sentences: "An uncorrelated state is not itself directed: extended backward, entropy would rise from it into the past too. The direction comes from placing the special state at the beginning, which is what preparing a gas does, and which cosmology must explain for the universe as a whole."

**A19. "A mixture of known Gaussians" holds only for linear drift.** (§12.10, "*In learning.*")
- *Problem.* The section's forward process has general $U$, with non-Gaussian transition densities. Diffusion models use Ornstein–Uhlenbeck-type forward processes, as Figure 4 does.
- *Fix.* "…since with a linear drift, as in Figure 4, $\rho_t$ is a mixture of known Gaussians around data points…"

**A20. The anisotropic Fokker–Planck term is not the Itô one.** (§10.2, para on anisotropic noise. Outside the new material, flagged because the statement is general.)
- *Problem.* The SDE of the essay is Itô, and it gives $\partial_i\partial_j(D_{ij}\rho)$. That differs from $\nabla\cdot(D\nabla\rho)$ by a drift $\rho\,\partial_jD_{ij}$ when $D$ varies with position, as it does for SGD.
- *Fix.* "…the diffusion term becomes $\nabla\cdot\nabla\cdot(D\rho)$ with a matrix $D(x)$…", checking the form against Chaudhari and Soatto.

**A21. Smaller points of statement.**
- §8.2, "this fixes its definition": equality at equilibrium fixes $T$ only up to a monotone function of $\partial S/\partial E$. The choice $1/T = \partial S/\partial E$ is pinned by Clausius's formula or the ideal gas. Write "and we define it by".
- §12.4: the Occam cost is *minus* the logarithm of the width ratio.
- §12.9, "A smooth family of Gibbs states has acquired a sharp transition": this holds as $N\to\infty$. At finite $N$ the Gibbs state is analytic in $\beta$ and has $m = 0$. Add "as $N\to\infty$".
- §9.3, "with no bath in sight": the other balls are the bath of §8.3. Write "with no external bath".
- §9.4, "so no pair has met before": random draws repeat pairs occasionally (about 16 among 8,000 collisions). The script's docstring has it right: no pair *remembers* meeting. Write "so a pair's history plays no part".
- §12.6, "added gradient noise": Welling and Teh inject Gaussian noise into the update. Minibatch gradient noise was already there. Write "added Gaussian noise to minibatch gradient steps".
- §12.5, "a test for whether a run has reached stationarity": the identity is necessary, not sufficient. Write "and a necessary test".
- §9.5, "Every nat gained in the one-ball entropy": the identity has a factor of $N$. Write "Every nat gained, summed over the balls, …".

Checked and correct:
- §7: the divergence $-\gamma/m$, and the time scale $m/\gamma$.
- §8.1: Stirling, and the $e^{-N\delta}$ factor.
- §8.2–8.4: the signs of $\Delta S_{\text{tot}}$ and $\Delta F$, and $F = -T\ln Z$.
- §8.3: both derivations of the Gibbs state, and the tilt.
- §9.1: the collision map, the involution, and the reflection in direction $(n, -n)/\sqrt2$, with unit Jacobian. Conservation of momentum and energy.
- §9.2: the cylinder, the sign convention for $n$ with $(v - v_*)\cdot n > 0$ on incoming pairs, the gain term with normal $-n$.
- §9.3: both relabellings map the domain to itself and preserve $B$ and the primes. The factor $\frac14$ and the sign. A Monte Carlo with a bimodal $f$ gives $-4.4\pm0.6$ for the direct form and $-4.6\pm0.1$ for the symmetrized one.
- §9.4: the mirror theorem. Under independence on outgoing pairs, loss $\to f'f_*'$ and gain $\to ff_*$, so the sign flips.
- §9.5: $I(t) = D(\text{joint}\|\text{product})$ and the identity.
- §9.6: $N\sigma^2$ fixed in 3D, and the factor $1 - 2\mu$.
- §9.7: the chain-rule proof, and the free-energy reading.
- §10.2: $D = T/\gamma$ follows from $J = \rho\nabla L(D/T - 1/\gamma)$. $J = -(T/\gamma)\rho\nabla\ln(\rho/\pi)$, and the rate of $D(\rho\|\pi)$. Entropy production $= (T/\gamma)I$. The decay rate $2\alpha T/\gamma$ under the stated log-Sobolev normalization. The Wasserstein gradient norm $T^2I$.
- §10.3: $F[\rho] = F_{\text{eq}} + TD$, Szilard, Landauer ($2.87\times10^{-21}$ J), Carnot, Kelly's rate.
- §12.1: all derivatives, the softmax Hessian, the two-phase gradient, cross-entropy as energy minus free energy.
- §12.2: the variational identity and the ELBO.
- §12.3: Legendre transform, Maxwell relation, conjugate of $A$, the market symmetry.
- §12.4: $Z_i$, $F_i$, equipartition, Schwarz.
- §12.5: $\beta\operatorname{Cov}(A, B)$, the score identity, $T_{\text{eff}} = \eta\sigma^2/2B$ against the Langevin noise $2T$ at $\gamma = 1$, Yaida's identity (simulated on a quadratic: $0.02624$ against $0.02627$), $dT$ on the Gibbs state.
- §12.6: detailed balance, Metropolis.
- §12.7: the Crooks ratio, Jarzynski, the divergence identity, all checked exactly on a three-state chain. The $K = 1$ case. The reverse divergence $D(p(z\mid x)\|q)$. The direction of the sample-size statement agrees with Chatterjee–Diaconis.
- §12.8: step dissipation $= D(\pi_{k-1}\|\pi_k)$, and $\mathcal L^2/2K$.
- §12.9: the mean-field equations, $T_c = J$, the message update.
- §12.10: Anderson's drift, and the rewriting with $\pi$.

## B. Figures and script

The script was rerun with its own seeds. Confirmed for Figure 2: area fraction 3.18%, 2,000 disks, 4,000 collisions forward. Start value $\ln(4/30) = -2.015$. Maxwell line $1 - \ln 2 = 0.307$ (entropy of an exponential with mean $1/2$). End of the solid reversal $-1.99$. Speed error median $2.5\times10^{-8}$, share above $10^{-3}$ of 1.55%. Correlations $-0.029/-0.664$, $-0.065/-0.626$, $-0.664/-0.033$. Random-pair and mechanical curves agree to rms $0.036$ nats. Twin trajectories confirm "about a hundred" (the median error grows by a factor of 60 per collision per disk, the 90th percentile by 150, and double-precision reversal implies 130). They also confirm "after two and a half collisions per disk": at $\tau = 2.50$, 9.5% of disks have $|\Delta v|/|v| > 0.1$.

Confirmed for Figure 3: $T^* = 0.4/\ln 25 = 0.1243$, wide-well mass 0.6% and 72.0%. The domain truncation and the cut at $w = 0.1$ have no effect. The wells are narrow enough that the Gaussian estimate agrees to six digits.

Confirmed for Figure 4: seventy paths, the score of the mixture, the reverse drift $x + 2\,\text{score}$, the axis label. The start at $N(0, 1)$ differs slightly from $\rho_3$, whose modes sit at $\pm0.10$. That is immaterial.

**B1. Two numbers in the prose are not produced by the script.** "About a hundred" and "two and a half collisions per disk, a tenth of the disks … more than a tenth of their speed" appear in no output. They are right, but only for the vector velocity error: the share measured on speed alone is 6%. Add the twin run to the script, or write "off by more than a tenth of their speed, in velocity".

**B2. "Stays at the Maxwell value" (caption, dashed curve).** The curve rises from $-2.0$ like the solid one, and it levels at $0.298$ after about 5 collisions per disk, below the line at $0.307$ by the histogram's bias of $(m - 1)/2N\approx 0.007$. Write "and it rises to the Maxwell value and stays there". At the reversal the gas stands at $0.276$, so §11's "have reached the Maxwell value" is approximate. "Nearly reached" is honest.

**B3. Script detail, no effect on the page.** In `dsmc`, `vmax` is set from the single-speed start. About 2% of equilibrium pairs have relative speed above it and are accepted with probability 1, which clips the kernel. The effect is too small to see in the figure.

## C. Disagreements with the citation check

- **C1. §12.9, "The assumption is Boltzmann's, moved from time to a graph."** Citecheck item 12: no source makes this comparison, and it "should be signposted". Write "Read this way, the assumption is Boltzmann's, moved from time to a graph."
- **C2. §12.10, Premkumar "reports that a perfectly trained network must store at least so much".** Item 22 gives "argues", and warns against saying it is proved. Write "argues that".
- **C3. §12.8, Chopin et al.** Item 20: the tempering step *is* entropic mirror descent with step $\gamma$, and that is a discretization of the Fisher–Rao gradient flow. The page has the tempering step discretizing mirror descent. Write "show that the tempering step $\mu_{n+1}\propto\mu_n^{1-\gamma}\pi^\gamma$ is a step of entropic mirror descent on $D(\mu\|\pi)$, which discretizes a gradient flow in the Fisher–Rao geometry." The sentence directly follows the friction metric, and the item warns against merging the two geometries. "Closer than an analogy" should say it concerns the Fisher metric of the discrete schedule, not the friction metric.
- **C4. §12.3, $A^*(\mu) = -H(\mu)$.** Item 9 asks for "on the interior of the mean-parameter set". Add those words.
- **C5. §10.3, Sagawa–Ueda.** Item 24: the bound is $-\Delta F + T\,I$. In an engine returning to its start, $\Delta F = 0$, so the page is right in context. Add "over a cycle".

Not in the citecheck: Jarzynski 2006 (Phys. Rev. E 73, 046105), Chatterjee–Diaconis 2018, Song et al. arXiv:2101.09258. All three resolve to the right works by Crossref and the arXiv API. I checked those records and the direction of the claims, not the full text.

## D. What an attentive reader would miss

- **D1. Energies against velocities, two dimensions against three.** The theorem is about $f(v)$ in three dimensions, and Figure 2 plots a histogram of energies of disks. Add one sentence: "For an isotropic gas of disks, $dv = dE\,d\theta$, so the energy entropy is the velocity entropy minus $\ln 2\pi$, and the same theorem holds in two dimensions with $\sigma\,dn$ in place of $\sigma^2\,dn$."
- **D2. One gas against an ensemble.** §9.5 speaks of a marginal of an ensemble, while Figure 2 has a single microstate. The bridge is §8.1: the histogram is a macrostate, and its entropy per disk is Boltzmann's. Say so, because otherwise "$S_N$ is constant" and "the curve rises" appear to be about different things.
- **D3. "Averaging the four forms."** Only two relabellings are named. Write out the four factors, $\ln f$, $\ln f_*$, $-\ln f'$, $-\ln f_*'$, over 4. The reader then sees the sum of logarithms form. "Since the collision term has zero integral" uses the same symmetrization with test function 1, so it comes logically after the relabellings.
- **D4. The collision invariants.** That mass, momentum and energy are the *only* quantities conserved is a theorem, and the page asserts it silently. A phrase is enough: "and a classical result says these are the only such quantities."
- **D5. "Most factors cancel" (§12.7).** Show the middle line, which is the one place the reader must think: the ratio is $\frac{\pi_K(x_K)}{\pi_0(x_0)}\prod_k\frac{\pi_k(x_{k-1})}{\pi_k(x_k)} = \prod_k\frac{\pi_k(x_{k-1})}{\pi_{k-1}(x_{k-1})}$. Each factor is $e^{-w_k}Z_{k-1}/Z_k$.
- **D6. $\langle W_{\text{diss}}\rangle$ (§12.7) is never defined.** Write "$W_{\text{diss}} = W - \Delta F$" at the displayed inequality.
- **D7. Anderson's formula is stated without a check.** One line does it. Reading the forward Fokker–Planck equation in reverse time gives $\partial_s\rho = -\nabla\cdot(\rho\nabla U) - T\Delta\rho$, and $-T\Delta\rho = -\nabla\cdot(2T\rho\nabla\ln\rho) + T\Delta\rho$. So the same noise with drift $\nabla U + 2T\nabla\ln\rho$ gives the same density path.
- **D8. Which $\pi$ satisfies a log-Sobolev inequality?** Add: "If $\nabla^2L\ge m$, then $\alpha = m/T$ (Bakry and Émery) and the rate is $2m/\gamma$, independent of $T$. For a double well, $\alpha$ is exponentially small in the barrier over $T$." This connects §10.2 to the barrier in §12.6.
- **D9. The essay's diffusion in §12.5.** The comparison with "the Langevin noise $2T$" depends on $\gamma = 1$ and on a formula not on this page. Display $dw = -\nabla L\,dt + \sqrt{\eta/B}\,\Sigma^{1/2}dW$ and state $\gamma = 1$.
- **D10. Noise schedules in §12.8.** The formula assumes each relaxation fully equilibrates to $\pi_k$. A diffusion model has no such relaxation between noise levels. Say what carries over: the path and its Fisher length, not the cost of a sequence of equilibrations.
- **D11. Conventions shift inside §12.** $T = 1$ in §12.7, $\gamma = 1$ in §12.10, $L$ and $E$ alternate in §12.4, and $U$ is internal energy in §12.3 and a potential in §12.10.
- **D12. Letters doing double duty.**
  - $H$ is entropy in §8.1 and §12.3 and *minus* entropy in §9. Say so at §9.3: "(Boltzmann's $H$ has the opposite sign to Shannon's.)"
  - $D$ is a diffusion coefficient and a divergence within §10.2.
  - $I$ is total correlation in §9.5 and Fisher information in §10.2.
  - $B$ is the collision kernel in §9, an observable and a batch size within §12.5.
  - $n$ is a unit vector in §9 and the number of classes in §12.1.
  - $\mu$ is a fraction in §9.6 and a distribution in §9.7.

## E. Style (AGENTS.md)

No chained semicolons in the new material. Every semicolon there is a true parallel pair or falls inside a citation.

- **E1. Unanchored and doing two jobs.** §9.5: "This is the essay's account of Ebtekar and Hutter's bound in its oldest form, and Figure 2 shows…" "This" has no clear referent. Split it (see A16 for the second half), with "Ebtekar and Hutter's bound, as the essay reads it, is the same point in modern form."
- **E2. Term before introduction.** §10.3: "A nat of divergence pays a bookmaker's trader $b$ and a demon $T$." On this page $b$ first appears here, and it is defined in §11 and §12.1. Write "a bookmaker's trader $b$, the market's liquidity parameter (§11)".
- **E3. Unnamed referent.** §9.4: "The proof used two facts about collisions." The reader cannot tell which. Write "The proof used two symmetries of a collision, the swap and the reverse collision, and both hold in either direction of time."
- **E4. New given as old.** §9.4: "the two objections to Boltzmann" before either is mentioned. See A3.
- **E5. Unanchored.** §12.3: "So thermodynamics divides what is transferred into a part that the state remembers and a part that it does not." "What is transferred" and the two parts are not identified. Either name them (the change in $F$ and the dissipated work) or cut the sentence.
- **E6. "It" with no antecedent.** §12.8: "It is the third geometry of the essay in a new role." The previous sentence's subject is schedules and a formula. Write "The Fisher metric here is the third geometry of the essay in a new role."
- **E7. Dangling participle.** §12.10: "Comparing with Figure 2, the mechanical demon needs…". Write "Compare Figure 2. The mechanical demon needs…"
- **E8. Unanchored.** §12.10: "The accounts stay in balance." Which accounts? Name them, or open with the next sentence.
- **E9. Dangling "which".** §12.2: "…what bits back refunds, which is Hinton and van Camp's identification in the essay." See A14.
- **E10. Loose word.** §8.4: "minimizes the sum." $E - TS$ is a difference. Write "minimizes $E - TS$".
- **E11. Unclear "we".** §9 opening: "In the seminar Piotr Biler ran around 2003 we derived…" The byline has two authors, one of them Claude, and *The Standard of Motion* tells of the same seminar with "I". Write "the seminar derived" or "I derived".
