# Citation check: qualitative theory passages (31 Oct 2026)

Scope: *The Standard of Motion*, the paragraphs beginning "Mendes defines stable theories" and "So stability depends on"; the companion *…: the mathematics*, §4, "**Structural stability of vector fields.**". Items for the sequel (singular perturbation, Łojasiewicz, Polyak) are in §9.

## Summary

| # | Claim | Verdict |
|---|---|---|
| 1 | Andronov & Pontryagin 1937 introduced structural stability; the companion's definition | VERIFIED for attribution. CORRECTED for the definition, which is Peixoto's modern form and not the 1937 one. Note the French title. |
| 2 | Peixoto 1962: on compact orientable surfaces, structurally stable = Morse–Smale | CORRECTED. The companion omits the "no other recurrence" condition, so as worded it includes the irrational flow on the torus. |
| 3 | Smale 1961: a generic perturbation of a gradient flow is Morse–Smale | VERIFIED in substance, CORRECTED in detail. Smale proves C¹-density (Theorem A) by perturbing the vector field, and the result is again a gradient field. Openness comes from structural stability. |
| 4 | Palis & Smale 1970: Morse–Smale ⇒ structurally stable in every dimension | VERIFIED |
| 5 | The gradient flow of a Morse function has a Lyapunov function, no periodic orbits, and hyperbolic equilibria | VERIFIED. Finiteness of the equilibria needs compactness. Gradient flows need not be Morse–Smale: the upright torus is the standard counterexample. |
| 6 | ẋ = p, ṗ = −x − εp: a stable focus "for every ε > 0" | WRONG for ε ≥ 2, where the origin is a node. The argument still works. |
| 7 | KAM; "Outside that class, dissipation destroys it" | VERIFIED for KAM. The dissipation sentence is fair if "it" means the positive-measure family of tori. It is too strong if read as "every torus", because isolated tori survive as attractors when a parameter is tuned. A small rewording fixes both texts. The companion's bullet heading overstates KAM as stability. |
| 8 | Mendes's quote | Skipped, as instructed. No issue seen. |
| 9 | Tikhonov 1952; Fenichel 1979; Łojasiewicz 1963; Polyak 1963; the overdamped limit as a Tikhonov application | All VERIFIED, with bibliographic data below. The overdamped limit is a textbook application, with one caveat about units. |

## 1. Andronov & Pontryagin (1937)

**Citation.** A. Andronov, L. Pontrjagin, "Systèmes grossiers", *Comptes Rendus (Doklady) de l'Académie des Sciences de l'URSS* / *Dokl. Akad. Nauk SSSR* **14**:5 (1937) 247–250. Russian title: «Грубые системы». The note was published in French. Wikipedia and Math-Net.Ru give pp. 247–250, and Pugh & Peixoto's Scholarpedia entry gives 247–251. "Rough", "coarse" and "grossier" are all renderings of the same word. In 1949 Lefschetz rendered *grubyi* as "structurally stable" in his translation of Andronov–Khaikin.

**What the 1937 note actually did** (Pugh & Peixoto, "Structural stability", *Scholarpedia* 3(9):4008, 2008, doi:10.4249/scholarpedia.4008). It treated a planar system ẋ = P, ẏ = Q on the disc D², with the field entering transversally across ∂D². The system is *rough* if for every ε > 0 there is a δ > 0 such that every perturbation (p, q) with |p|, |q| and their first derivatives below δ yields a system whose trajectories are carried onto the original ones by an **ε-homeomorphism**, one that moves each point by less than ε. Andronov and Pontryagin announced that roughness holds if and only if all singularities and closed orbits are hyperbolic and no trajectory joins two saddles. They gave no proof. De Baggis (1952) gave one, but it contained errors, and M. and M. C. Peixoto gave a correct proof in 1959.

**How the modern definition differs.** It is Peixoto's (1959 for the disc, 1962 for surfaces). It has three differences from the 1937 one:
- The setting is a compact manifold, with the C¹ topology on the space of vector fields, rather than a disc in the plane.
- The homeomorphism need not be close to the identity. Peixoto showed that on the disc the two definitions coincide, and later work (Robbin, Robinson, Mañé, Hu, Hayashi) shows that the ε-definition and the non-ε definition are equivalent in general.
- It is phrased as "X has a neighbourhood every member of which is topologically equivalent to X".

The companion's wording ("every vector field C¹-close to X is topologically equivalent to it…, preserving their direction") matches Scholarpedia's modern statement: "a homeomorphism h: M → M that sends the orbits of X to the orbits of Y, preserving the orientation of the orbits". The only problem is the attribution, which credits the modern compact-manifold form to the 1937 note.

**Essay** ("a notion due to Aleksandr Andronov and Lev Pontryagin (1937)"): VERIFIED as it stands.

**Companion: suggested wording.**
> A $C^1$ vector field $X$ on a compact manifold is *structurally stable* if every vector field $C^1$-close to $X$ is topologically equivalent to it: a homeomorphism carries the orbits of one onto the orbits of the other, preserving their direction. The notion is A. A. Andronov and L. S. Pontryagin's ("Systèmes grossiers", Dokl. Akad. Nauk SSSR 14 (1937) 247–250), stated for planar systems on a disc; the global form is M. Peixoto's.

## 2. Peixoto (1962)

**Citation.** M. M. Peixoto, "Structural stability on two-dimensional manifolds", *Topology* **1** (1962) 101–120, doi:10.1016/0040-9383(65)90018-2. The DOI really does contain "65". There is a two-page follow-up with the same title in *Topology* 2 (1963) 179–180, doi:10.1016/0040-9383(63)90032-6.

**Theorem** (Scholarpedia; Palis & de Melo, *Geometric Theory of Dynamical Systems*, Springer 1982, ch. 4). Let M be a compact orientable surface and r ≥ 1. A C^r vector field is structurally stable if and only if:
1. it has finitely many singular points, all hyperbolic;
2. it has finitely many closed orbits, all hyperbolic;
3. the α- and ω-limit set of every orbit is a singular point or a closed orbit;
4. no orbit joins two saddles.

Scholarpedia summarises the result as "hyperbolic periodic orbits, no other recurrence, and no saddle connections". It adds that "SS is open-dense" and that "for flows on surfaces, Peixoto's Theorem can be summarized as MS = SS and SS is generic." For non-orientable surfaces, density with r ≥ 2 is open except on the projective plane, the Klein bottle and the genus-3 surface (Gutierrez 1978). With r = 1, Pugh's closing lemma removes the orientability hypothesis.

**Problem in the companion.** "Finitely many hyperbolic equilibria and periodic orbits, no saddle connections" leaves out condition 3. Without it, the linear flow of irrational slope on the torus qualifies: it has zero equilibria and zero periodic orbits. Yet it is not structurally stable, since a rational slope nearby has closed orbits. The "Morse–Smale" label is correct, because Morse–Smale includes "only trivial recurrence", but the gloss after the colon is incomplete. "And so no centers" is correct, since a center is a non-hyperbolic equilibrium.

**Companion: suggested wording.**
> On compact orientable surfaces, M. Peixoto (1962) showed that the structurally stable flows are exactly the Morse–Smale ones, and that they are open and dense: finitely many equilibria and periodic orbits, all hyperbolic; every other orbit tends to one of them in both directions of time; no orbit joins two saddles. So there are no centers.

## 3. Smale (1961)

**Citation.** S. Smale, "On gradient dynamical systems", *Ann. of Math.* (2) **74**:1 (1961) 199–206, doi:10.2307/1970311, MR0133139. I checked this against an OCR of the JSTOR scan.

**What the paper proves.** Theorem A (verbatim): "Let f be a C^∞ function on a compact C^∞ manifold M^n with non-degenerate critical points. Suppose M is provided with a riemannian metric and that grad f is transversal to ∂M. Then grad f can be C¹ approximated by a vector field satisfying conditions (1) to (4)."

The conditions are:
- (1) near each singular point the field is locally the gradient of a function with a nondegenerate critical point;
- (2) the field is transversal to the boundary;
- (3) every ω-limit set lies among the singular points;
- (4) "the stable and unstable manifolds … have normal intersection with each other", that is, they are transversal.

Theorem B constructs a function f′ with the same critical points to which X is transverse. Smale's remark after it: "there is a riemannian metric on M such that grad f = X." The approximation is therefore again a gradient field, for a modified metric. Lemma 1.1 takes the perturbation to equal X near the singular points.

**On the questions raised.**
- *What is perturbed.* Smale perturbs the vector field in the C¹ topology, leaving it unchanged near the critical points. The result is a gradient field for another metric (and a function f′). Modern treatments state the same fact as "for a fixed Morse function, a generic metric makes the gradient flow Morse–Smale". This is the Kupka–Smale theorem for gradient flows; see e.g. Banyaga & Hurtubise, *Lectures on Morse Homology* (Kluwer 2004), ch. 6. I took that reference from memory.
- *"Generic".* Smale proves density. Openness follows from structural stability, via Palis–Smale. So "Morse–Smale gradient fields are open and dense among gradient fields" is right, and Palis & de Melo ch. 4 treats it that way. The essay's "a generic gradient flow is structurally stable (Stephen Smale 1961; Jacob Palis and Smale 1970)" is correct in that open-dense sense, and the double citation is the right one.
- The companion's sentence "After a generic small perturbation its stable and unstable manifolds meet transversally" is acceptable but slightly off. A *generic* perturbation is not the point. The point is that an arbitrarily small one exists and can be kept inside the class of gradient flows.

**Companion: suggested wording** (merged with §5):
> For a Morse function $V$ on a compact manifold, the flow $\dot x = -\nabla V$ has a Lyapunov function, no periodic orbits, and finitely many equilibria, all hyperbolic. Its stable and unstable manifolds need not meet transversally (on an upright torus, the height function's two saddles are joined by an orbit), but an arbitrarily $C^1$-small perturbation, again a gradient flow for a modified metric, makes them do so, and the result is Morse–Smale (S. Smale, "On gradient dynamical systems", Ann. of Math. 74 (1961) 199–206).

## 4. Palis & Smale (1970)

**Citation.** J. Palis, S. Smale, "Structural stability theorems", in *Global Analysis* (Berkeley 1968), ed. S.-S. Chern and S. Smale, Proc. Sympos. Pure Math. **14**, AMS, 1970, pp. 223–231, doi:10.1090/pspum/014/0267603. Palis's own list gives pp. 223–232, and Crossref gives 223–231. A Russian translation appeared in *Matematika* 13:2 (1969) 145–155.

**Content** (Scholarpedia). "Although he and Jacob Palis proved that MS ⇒ SS (Palis and Smale 1970)…". The paper covers flows and diffeomorphisms on compact manifolds of any dimension. In the same paper Palis and Smale conjectured that structural stability is equivalent to Axiom A with strong transversality. Robbin, Robinson, Mañé, Hu and Hayashi later settled that conjecture. The earlier paper is J. Palis, "On Morse–Smale dynamical systems", *Topology* 8 (1969) 385–404, doi:10.1016/0040-9383(69)90024-X, which treated low dimensions. The converse fails in dimension ≥ 3: horseshoes and Anosov systems are structurally stable but not Morse–Smale, and structural stability is not dense (Smale 1966). **VERIFIED**, both the essay and the companion ("Morse–Smale flows are structurally stable in any dimension").

## 5. The gradient flow of a Morse function

**VERIFIED.** For ẋ = −∇_g V:
- dV/dt = −|∇_g V|²_g ≤ 0, with equality only at critical points. So V is a strict Lyapunov function, and no non-constant periodic orbit exists, because V would have to return to its starting value while strictly decreasing.
- At a critical point p the linearisation is −g⁻¹D²V(p) = −Hess_g V(p). It is self-adjoint with respect to g_p, so its eigenvalues are real. They are nonzero because p is nondegenerate. Hence p is hyperbolic, and its Morse index equals the dimension of its unstable manifold.
- Nondegenerate critical points are isolated. On a compact manifold there are therefore finitely many of them, and the companion should say "compact" here. Every ω-limit set is a single equilibrium.

The point to add is that these properties do not make the flow Morse–Smale. The height function on a torus standing on end has a saddle-to-saddle orbit, which breaks under perturbation. That is why Smale's Theorem A is needed (§3).

## 6. Damped oscillator

ẋ = p, ṗ = −x − εp has characteristic polynomial λ² + ελ + 1 = 0, so λ = (−ε ± √(ε² − 4))/2:
- for 0 < ε < 2, a stable focus (spiral);
- for ε = 2, a degenerate (improper) node;
- for ε > 2, a stable node, with no spiralling.

So "a stable focus for every ε > 0" is **WRONG** for ε ≥ 2. The argument does not depend on it. For every ε > 0 the origin is a hyperbolic sink, and foci and nodes are topologically equivalent; either way no orbit is closed, so no homeomorphism matches the portrait to the center.

A further, minor point: the example lives on ℝ², outside the compact-manifold definition. Scholarpedia has a compact version that also bears on the essay's next paragraph: "If X is the rotation vector field on the 2-sphere (its orbits are the latitudes and the poles) then X is structurally stable when considered in the subspace of 𝒳 consisting of divergence free vector fields, but it is not structurally stable in 𝒳." That is "stability depends on which perturbations one allows" in one line, with a source. The essay or the companion could use it.

**Companion: suggested wording.**
> The perturbation $\dot p = -x - \varepsilon p$ makes the origin an attracting equilibrium for every $\varepsilon > 0$ (a stable focus while $\varepsilon < 2$), and no homeomorphism carries closed orbits onto orbits that converge to a point.

Or minimally: "a stable focus for every small $\varepsilon > 0$".

The essay's "The slightest friction turns those orbits into spirals" is correct, since slight friction means a small ε.

## 7. KAM, and "dissipation destroys it"

**Citations.**
- A. N. Kolmogorov, "On the conservation of conditionally periodic motions under small perturbation of the Hamiltonian" (also translated "…for a small change in Hamilton's function"), *Dokl. Akad. Nauk SSSR* **98** (1954) 527–530.
- V. I. Arnold, "Proof of a theorem of A. N. Kolmogorov on the invariance of quasi-periodic motions under small perturbations of the Hamiltonian", *Uspekhi Mat. Nauk* 18:5 (1963) 13–40; *Russian Math. Surveys* **18**:5 (1963) 9–36, doi:10.1070/RM1963v018n05ABEH004130.
- J. Moser, "On invariant curves of area-preserving mappings of an annulus", *Nachr. Akad. Wiss. Göttingen Math.-Phys. Kl. II* (1962) 1–20. This is the twist-map version, under finite smoothness, originally C³³³ and later reduced.
- Survey: H. W. Broer, "KAM theory: the legacy of Kolmogorov's 1954 paper", *Bull. AMS* 41 (2004) 507–521. Pages from memory; the URL ams.org/bull/2004-41-04/S0273-0979-04-01009-2 was confirmed.

**Precise statement** (standard form). H(I, φ) = H₀(I) + εH₁(I, φ) on a domain in ℝⁿ × 𝕋ⁿ, with the following hypotheses:
- H is real-analytic, as in Kolmogorov and Arnold, or Cᵏ with k large enough;
- H₀ is nondegenerate: det ∂²H₀/∂I² ≠ 0 (Kolmogorov), or Arnold's isoenergetic condition, or Rüssmann's weaker condition;
- the frequencies ω = ∂H₀/∂I are Diophantine: |⟨k, ω⟩| ≥ γ|k|^(−τ) for all k ∈ ℤⁿ∖{0}, with τ > n − 1.

Conclusion: for |ε| small, every unperturbed torus with such a frequency persists as a slightly deformed invariant torus carrying quasi-periodic motion with the same frequencies. These tori form a Cantor family whose complement has measure tending to 0 as ε → 0. The standard estimate is O(√ε); I took that from memory, and it can be checked in Pöschel's "A lecture on the classical KAM theorem", Proc. Sympos. Pure Math. 69 (2001), arXiv:0908.2234.

**Essay** ("Within the class of Hamiltonian systems, the Kolmogorov–Arnold–Moser theorem shows that most of the regular motion of an integrable system survives small perturbations."): **VERIFIED.** Nondegeneracy is an unstated hypothesis, but leaving it implicit is fine in the essay.

**Companion** ("…with $H_0$ nondegenerate, … most invariant tori of $H_0$ persist, deformed, for small $\varepsilon$."): **VERIFIED.**

**"Outside that class, dissipation destroys it."** This needs two qualifications, and neither needs a long fix.
1. *What dissipation destroys.* A flow whose divergence is negative everywhere has no invariant set of positive finite volume. If A were invariant, vol(φ_t A) = vol(A), yet Liouville's formula forces vol(φ_t A) < vol(A). In the example, div = −ε. So the *family* of tori, which filled most of phase space, cannot survive, and in that sense "most of the regular motion" is destroyed. The essay's "it" refers to that, so the sentence is fair.
2. *Individual tori can survive.* Under dissipative perturbations, isolated quasi-periodic tori persist, typically as attractors, provided a parameter (a "drift" term) is tuned or one works in a family. The references:
   - Moser, "Convergent series expansions for quasi-periodic motions", *Math. Ann.* 169 (1967) 136–176, on modifying terms;
   - Broer, Huitema, Sevryuk, *Quasi-Periodic Motions in Families of Dynamical Systems*, LNM 1645 (Springer 1996);
   - R. C. Calleja, A. Celletti, R. de la Llave, "A KAM theory for conformally symplectic systems: efficient algorithms and their validation", *J. Differential Equations* **255**:5 (2013) 978–1049, doi:10.1016/j.jde.2013.05.001. For conformally symplectic systems (constant-rate dissipation, as in the companion's example), they prove that tori of Diophantine frequency exist "by adjusting the parameters". For n degrees of freedom this takes n parameters.

   Also, not every non-Hamiltonian perturbation is dissipative. Reversible and volume-preserving systems have their own KAM theories (Moser 1967; Sevryuk, LNM 1211, 1986). The essay says "dissipation" and not "every other perturbation", so this is a gloss only.

**Essay: suggested wording** (if a qualifier is wanted):
> Outside that class, dissipation destroys it: the tori can no longer fill phase space, and at most a few survive, as attractors.

The present sentence can also stay; it is defensible.

**Companion: suggested wording.**
> A dissipative perturbation contracts phase-space volume, so no invariant set of positive volume survives: the family of tori is destroyed. Isolated tori can persist as attractors when a parameter is tuned (R. Calleja, A. Celletti, R. de la Llave, J. Differential Equations 255 (2013) 978–1049).

**The bullet heading** "*Hamiltonian systems are stable only among Hamiltonian ones*" overstates the result. KAM is not structural stability, even within the Hamiltonian class. For n ≥ 2 degrees of freedom, an integrable system is not structurally stable among Hamiltonians: its resonant tori break into island chains and thin chaotic layers, which changes the topology of the portrait. What KAM gives is persistence of most tori in measure. The 1-degree-of-freedom case, and Scholarpedia's rotation on S² among divergence-free fields, are structurally stable within their class. Suggested heading: "*Hamiltonian systems keep most of their order, but only under Hamiltonian perturbations.*"

## 8. Mendes's quote

Skipped, as instructed. No issue seen in the wording.

## 9. For the sequel

**Tikhonov.** A. N. Tikhonov, «Системы дифференциальных уравнений, содержащие малые параметры при производных», *Mat. Sbornik* (N.S.) **31(73)**:3 (1952) 575–586 (Math-Net.Ru sm5548); English title "Systems of differential equations containing small parameters in the derivatives". EuDML lists it under the running volume number 73. Two precursors are Tikhonov, *Mat. Sb.* 22(64) (1948) 193–204 and 27(69) (1950) 147–156. I gave those from memory; the 1952 paper is the one standardly cited. **VERIFIED.**

Content: take ẋ = f(x, z), εż = g(x, z). Suppose the root z = φ(x) of g = 0 is an isolated, uniformly asymptotically stable equilibrium of the boundary-layer system dz/dτ = g(x, z), with x frozen, and suppose z(0) lies in its basin. Then on every finite interval [0, T], x_ε(t) → x̄(t), the solution of the reduced system ẋ = f(x, φ(x)), and z_ε(t) → φ(x̄(t)) uniformly on [δ, T]. An infinite horizon needs extra hypotheses; see Hoppensteadt, *Trans. AMS* 123 (1966), from memory.

**Fenichel.** N. Fenichel, "Geometric singular perturbation theory for ordinary differential equations", *J. Differential Equations* **31**:1 (1979) 53–98, doi:10.1016/0022-0396(79)90152-9. **VERIFIED** (Crossref). Content: a compact normally hyperbolic critical manifold of the fast system persists, for small ε, as a locally invariant slow manifold. It lies O(ε)-close to the critical manifold and has stable and unstable fibres.

**Łojasiewicz.** S. Łojasiewicz, "Une propriété topologique des sous-ensembles analytiques réels", in *Les Équations aux Dérivées Partielles* (Paris, 1962), ed. B. Malgrange, Colloques Internationaux du CNRS **117**, Éditions du CNRS, Paris, 1963, pp. 87–89. **VERIFIED** (Kurdyka 1998 bibliography; the pages come from Ablaev et al. 2023).

The inequality: if f is real-analytic near a and f(a) = 0, then |∇f(x)| ≥ c|f(x)|^θ near a, for some θ < 1. One may take θ ∈ [1/2, 1).

On the convergence consequence, Kurdyka (*Ann. Inst. Fourier* 48:3 (1998) 769–783, doi:10.5802/aif.1638) writes: "Łojasiewicz derived (see [Ł1], [Ł3]) from (Ł1) that all trajectories of −grad f are of finite length, when f is analytic in a neighborhood of a compact." Here [Ł1] is the 1963 note, and [Ł3] is "Sur les trajectoires du gradient d'une fonction analytique réelle", *Seminari di Geometria 1982–83*, Bologna 1984, 115–117. So the 1963 note is a correct citation for both the inequality and the convergence of bounded analytic gradient trajectories to a single critical point. The 1984 note is the usual companion citation.

**Polyak.** B. T. Polyak, «Градиентные методы минимизации функционалов», *Zh. Vychisl. Mat. Mat. Fiz.* **3**:4 (1963) 643–653. English: "Gradient methods for the minimisation of functionals", *USSR Comput. Math. Math. Phys.* **3**:4 (1963) 864–878, doi:10.1016/0041-5553(63)90382-3. **VERIFIED.**

The condition is f(x) − f* ≤ (1/2μ)|∇f(x)|². It gives global linear convergence of gradient descent without convexity, and it is the θ = 1/2 global case of Łojasiewicz's inequality. Ablaev, Beznosikov, Gasnikov et al., "About some works of Boris Polyak on convergence of gradient methods and their development" (arXiv:2311.16743), state that Polyak proposed it in 1963 and that it is "a special case of the Łojasiewicz inequality, proposed in the same year". They also cite T. Leżański, *Math. Ann.* 152 (1963) 271–274, as a third 1963 source.

The name "Polyak–Łojasiewicz" was popularised by H. Karimi, J. Nutini, M. Schmidt, "Linear convergence of gradient and proximal-gradient methods under the Polyak–Łojasiewicz condition", ECML PKDD 2016, LNCS 9851, 795–811, doi:10.1007/978-3-319-46128-1_50.

**The overdamped limit as a Tikhonov application.** **VERIFIED.** It is standard: textbook singular-perturbation examples, and the deterministic skeleton of the Smoluchowski–Kramers approximation. Write the equation m ẍ = F(x) − γẋ as ẋ = v, (m/γ) v̇ = F(x)/γ − v. The small parameter is ε = m/γ, and v is the fast variable. The boundary-layer system dv/dτ = F(x)/γ − v has the unique root v = F(x)/γ, with ∂g/∂v = −1, so it is uniformly exponentially stable from any initial velocity. Tikhonov's hypotheses therefore hold. The reduced system is ẋ = F(x)/γ, which is a gradient flow when F = −∇V. Velocities relax within an initial layer of duration ~m/γ.

One caveat for the essay. The quantity m/γ has units of time, so "m/γ → 0" should mean "small compared with the slow time scale γ/|∂F/∂x|". The dimensionless small parameter is m|∂F/∂x|/γ². For a spring of stiffness k it is mk/γ², and the overdamped regime begins at mk/γ² < 1/4, which is the node/focus threshold of §6 (ε ≥ 2 in units where m = k = 1).

## Sources consulted

- Pugh & Peixoto, "Structural stability", Scholarpedia 3(9):4008 (2008): http://www.scholarpedia.org/article/Structural_stability
- Wikipedia, "Andronov–Pontryagin criterion"; Math-Net.Ru present7496
- Smale 1961, JSTOR scan (OCR): https://www.math.utoronto.ca/mgualt/Morse%20Theory/smale%20gradient%20dynamical%20systems.pdf
- Crossref records for Peixoto 1962 (via MaRDI and Scilit), Palis–Smale 1970, Palis 1969, Fenichel 1979, Polyak 1963, Calleja–Celletti–de la Llave 2013, Karimi–Nutini–Schmidt 2016
- Math-Net.Ru: rm6404 (Arnold 1963), sm5548 (Tikhonov 1952)
- Kurdyka 1998, Numdam: https://www.numdam.org/item/AIF_1998__48_3_769_0
- Ablaev et al., arXiv:2311.16743
- Broer 2004, Bull. AMS: https://www.ams.org/bull/2004-41-04/S0273-0979-04-01009-2/
