"""Figures for notes/the-demon-is-a-learner-mathematics.md.

Run from the repository root:

    uv run --with matplotlib --with numpy python scripts/figures/demon_is_a_learner.py

Three figures (numbered 2-4 on the page, which continues the previous page's
Figure 1):

1. Hard disks with specular walls, simulated event by event: entropy of the
   one-particle energy distribution forward, after a reversal of all
   velocities in double precision, and after a reversal from rounded velocities;
   beside it a direct
   simulation Monte Carlo run, which draws colliding pairs at random and so
   imposes Boltzmann's independence before collision. Prints the correlation of
   the two energies in a colliding pair, before and after collision.
2. A loss with a deep narrow well and a shallow wide one, and its Gibbs density
   at two temperatures.
3. An Ornstein-Uhlenbeck diffusion of a bimodal density, forward and reversed
   with the exact score.
"""

import pathlib

import matplotlib

matplotlib.use("svg")
import matplotlib.pyplot as plt  # noqa: E402
import numpy as np  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/images"

BG = "#fffff8"
INK = "#2b2b2b"
MUTED = "#6b6b6b"
GRID = "#e4e4dc"
TEAL = "#258983"
ORANGE = "#c97537"

plt.rcParams.update({
    "figure.facecolor": BG,
    "savefig.facecolor": BG,
    "axes.facecolor": BG,
    "text.color": INK,
    "axes.labelcolor": INK,
    "axes.edgecolor": MUTED,
    "xtick.color": MUTED,
    "ytick.color": MUTED,
    "font.size": 10,
    "svg.fonttype": "none",
})


def tidy(ax):
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.tick_params(length=3)


# --- Figure 1: hard disks ---------------------------------------------------

N = 2000
SIGMA = 0.0045  # disk diameter, box of side 1
TAU_R = 4.0  # collisions per disk before the reversal
EDGES = np.linspace(0, 4, 31)
ROUND = 6  # decimal places kept by the bounded demon


def disk_start(seed=1):
    rng = np.random.default_rng(seed)
    n = int(np.ceil(np.sqrt(N)))
    g = (np.arange(n) + 0.5) / n
    x = np.array([(a, b) for a in g for b in g])[:N] + rng.uniform(-0.1, 0.1, (N, 2)) / n
    th = rng.uniform(0, 2 * np.pi, N)
    return x, np.c_[np.cos(th), np.sin(th)]


def pair_times(x, v, i):
    dx, dv = x - x[i], v - v[i]
    b = (dx * dv).sum(1)
    v2 = (dv * dv).sum(1)
    c = (dx * dx).sum(1) - SIGMA**2
    disc = b * b - v2 * c
    t = np.full(len(x), np.inf)
    m = (b < 0) & (disc > 0)
    t[m] = c[m] / (-b[m] + np.sqrt(disc[m]))
    t[i] = np.inf
    return t


def wall_times(x, v):
    r = SIGMA / 2
    t = np.full(x.shape, np.inf)
    p, n = v > 0, v < 0
    t[p] = (1 - r - x[p]) / v[p]
    t[n] = (r - x[n]) / v[n]
    return t


def entropy(v):
    e = (v * v).sum(1) / 2
    c, _ = np.histogram(e, bins=EDGES)
    p, w = c / c.sum(), np.diff(EDGES)
    m = p > 0
    return -(p[m] * np.log(p[m] / w[m])).sum()


def simulate(x, v, stop):
    """Run until `stop(collisions)`; return state, trace, colliding-pair log."""
    x, v = x.copy(), v.copy()
    p = np.vstack([pair_times(x, v, i) for i in range(N)])
    w = wall_times(x, v)
    trace, log, coll = [(0, entropy(v))], [], 0
    while not stop(coll):
        ij = np.unravel_index(np.argmin(p), p.shape)
        wk = np.unravel_index(np.argmin(w), w.shape)
        tp, tw = p[ij], w[wk]
        dt = min(tp, tw)
        x = x + v * dt
        p -= dt
        w -= dt
        if tp <= tw:
            i, j = ij
            n = x[j] - x[i]
            n /= np.linalg.norm(n)
            a = (v[i] - v[j]) @ n
            pre = (v[i] @ v[i] / 2, v[j] @ v[j] / 2)
            v[i] -= a * n
            v[j] += a * n
            log.append((pre, (v[i] @ v[i] / 2, v[j] @ v[j] / 2)))
            touched = [i, j]
            coll += 1
            if coll % 25 == 0:
                trace.append((coll, entropy(v)))
        else:
            i, k = wk
            v[i, k] = -v[i, k]
            touched = [i]
        w[touched] = wall_times(x[touched], v[touched])
        for t in touched:
            pt = pair_times(x, v, t)
            p[t, :] = pt
            p[:, t] = pt
        if tp <= tw:
            p[ij] = np.inf
            p[ij[::-1]] = np.inf
    return x, v, np.array(trace), log


def past_last_event(x, v):
    """Drift a little past the last event, so that reversal starts between events."""
    w = wall_times(x, v).min()
    p = min(pair_times(x, v, i).min() for i in range(N))
    return x + v * 0.5 * min(w, p)


def corr(pairs):
    a = np.array(pairs)
    return np.corrcoef(a[:, 0], a[:, 1])[0, 1]


def dsmc(n_coll, seed=2):
    """Direct simulation Monte Carlo of hard disks: a pair chosen at random,
    accepted with probability proportional to its relative speed, impact
    parameter uniform. No pair remembers having met."""
    rng = np.random.default_rng(seed)
    _, v = disk_start(seed)
    trace, log, coll = [(0, entropy(v))], [], 0
    vmax = 6.0  # above any relative speed this gas reaches
    while coll < n_coll:
        i, j = rng.choice(N, 2, replace=False)
        g = v[i] - v[j]
        s = np.linalg.norm(g)
        if rng.uniform() * vmax >= s:
            continue
        b = rng.uniform(-1, 1)
        e = g / s
        n = np.sqrt(1 - b * b) * e + b * np.array([-e[1], e[0]])
        a = g @ n
        pre = (v[i] @ v[i] / 2, v[j] @ v[j] / 2)
        v[i] -= a * n
        v[j] += a * n
        log.append((pre, (v[i] @ v[i] / 2, v[j] @ v[j] / 2)))
        coll += 1
        if coll % 25 == 0:
            trace.append((coll, entropy(v)))
    return np.array(trace), log


def figure_disks():
    n_coll = int(TAU_R * N / 2)
    x0, v0 = disk_start()
    x1, v1, fwd, log_f = simulate(x0, v0, lambda c: c >= n_coll)
    x1 = past_last_event(x1, v1)
    x2, v2, back, log_b = simulate(x1, -v1, lambda c: c >= n_coll)
    # All speeds start at 1, so a disk's speed at the end measures the error.
    err = np.abs(np.linalg.norm(v2, axis=1) - 1)
    print(f"speed error after reversal: median {np.median(err):.1e}, "
          f"share above 1e-3 {(err > 1e-3).mean():.3f}, worst {err.max():.2f}")
    _, _, fuzzy, _ = simulate(x1, -np.round(v1, ROUND), lambda c: c >= n_coll)
    ans, log_a = dsmc(2 * n_coll)

    # Twin runs: how fast the rounding error grows along the reversed run.
    for t in (1.5, 2.0, 2.5, 3.0):
        c = int(t * N / 2)
        a = simulate(x1, -v1, lambda k: k >= c)[1]
        b = simulate(x1, -np.round(v1, ROUND), lambda k: k >= c)[1]
        e = np.linalg.norm(a - b, axis=1)
        print(f"reversed {t} collisions per disk: median velocity error {np.median(e):.1e}, "
              f"share above 0.1 {(e > 0.1).mean():.3f}")

    q = n_coll // 4
    print("corr pre/post, ansatz, first quarter:",
          corr([a for a, _ in log_a[:q]]), corr([b for _, b in log_a[:q]]))
    print("corr pre/post, disks, first quarter:",
          corr([a for a, _ in log_f[:q]]), corr([b for _, b in log_f[:q]]))
    print("corr pre/post, reversed, last quarter:",
          corr([a for a, _ in log_b[-q:]]), corr([b for _, b in log_b[-q:]]))

    tau = lambda c: 2 * c / N  # noqa: E731
    fig, ax = plt.subplots(figsize=(6.6, 3.3), constrained_layout=True)
    tidy(ax)
    ax.axvline(TAU_R, color=GRID, lw=1.2, zorder=0)
    ax.text(TAU_R + 0.08, -0.75, "all velocities\nreversed", color=MUTED, fontsize=8.5, va="bottom")
    ax.axhline(1 - np.log(2), color=MUTED, lw=0.8, ls=(0, (2, 3)))
    ax.text(0.05, 1 - np.log(2) + 0.05, "Maxwell distribution", color=MUTED, fontsize=8.5)
    ax.plot(tau(ans[:, 0]), ans[:, 1], color=ORANGE, lw=1.6, ls=(0, (5, 2)),
            label="independent before collision (random pairs)")
    ax.plot(tau(fwd[:, 0]), fwd[:, 1], color=TEAL, lw=2, label="hard disks, forward and then reversed")
    ax.plot(TAU_R + tau(back[:, 0]), back[:, 1], color=TEAL, lw=2)
    ax.plot(TAU_R + tau(fuzzy[:, 0]), fuzzy[:, 1], color=INK, lw=1.4, ls=(0, (1, 1.5)),
            label=f"reversed from velocities rounded to {ROUND} places")
    ax.set_xlim(0, 2 * TAU_R)
    ax.set_ylim(-2.4, 0.75)
    ax.set_xlabel("collisions per disk, cumulative")
    ax.set_ylabel("entropy of the energy histogram (nats)")
    ax.legend(frameon=False, fontsize=8.5, loc="lower left", bbox_to_anchor=(0.0, 0.02))
    fig.savefig(OUT / "demon-hard-disks-reversal.svg")
    plt.close(fig)


# --- Figure 2: wide against narrow ------------------------------------------

KN, KW, DL = 200.0, 8.0, 0.2  # curvature of each well; extra depth of the wide well's floor


def loss(w):
    a = 0.5 * KN * (w + 1) ** 2
    b = DL + 0.5 * KW * (w - 1) ** 2
    s = 0.015
    return -s * np.logaddexp(-a / s, -b / s)


def figure_width():
    w = np.linspace(-1.75, 2.1, 3000)
    dw = w[1] - w[0]
    tstar = 2 * DL / np.log(KN / KW)
    print("crossover temperature", tstar)
    fig, axes = plt.subplots(2, 1, figsize=(6.0, 3.8), sharex=True, constrained_layout=True,
                             gridspec_kw={"height_ratios": [1, 1.25]})
    tidy(axes[0])
    tidy(axes[1])
    axes[0].plot(w, loss(w), color=INK, lw=1.6)
    axes[0].set_ylim(-0.03, 1.0)
    axes[0].set_ylabel("loss $L(w)$")
    axes[0].text(-0.84, 0.5, "deep, narrow", ha="left", color=MUTED, fontsize=9)
    axes[0].text(1, 0.6, "shallow, wide", ha="center", color=MUTED, fontsize=9)
    for t, c, ls in ((0.03, TEAL, "-"), (0.3, ORANGE, (0, (5, 2)))):
        p = np.exp(-loss(w) / t)
        p /= p.sum() * dw
        wide = p[w > 0.1].sum() * dw
        print(f"T={t}: mass in the wide well {wide:.3f}")
        axes[1].plot(w, p, color=c, lw=1.6, ls=ls, label=f"$T = {t}$: wide well holds {100 * wide:.0f}%")
    axes[1].set_ylabel(r"Gibbs density $e^{-L/T}/Z$")
    axes[1].set_xlabel("weight $w$")
    axes[1].set_ylim(0, None)
    axes[1].legend(frameon=False, fontsize=8.5, loc="upper right")
    fig.savefig(OUT / "demon-wide-narrow.svg")
    plt.close(fig)


# --- Figure 3: reversing a diffusion ----------------------------------------

MODE = 2.0
S0 = 0.25
HORIZON = 3.0
STEPS = 600


def score(x, t):
    """Exact score of the Ornstein-Uhlenbeck flow of a two-Gaussian mixture."""
    m = MODE * np.exp(-t)
    s2 = S0**2 * np.exp(-2 * t) + 1 - np.exp(-2 * t)
    a = -((x - m) ** 2) / (2 * s2)
    b = -((x + m) ** 2) / (2 * s2)
    w = 1 / (1 + np.exp(b - a))
    return (-(x - m) * w - (x + m) * (1 - w)) / s2


def figure_reverse():
    rng = np.random.default_rng(5)
    n = 70
    dt = HORIZON / STEPS
    t = np.linspace(0, HORIZON, STEPS + 1)

    sign = np.where(np.arange(n) < n // 2, 1.0, -1.0)
    x = np.empty((STEPS + 1, n))
    x[0] = sign * MODE + S0 * rng.standard_normal(n)
    for k in range(STEPS):
        x[k + 1] = x[k] - x[k] * dt + np.sqrt(2 * dt) * rng.standard_normal(n)

    y = np.empty((STEPS + 1, n))
    y[0] = rng.standard_normal(n)
    for k in range(STEPS):
        s = HORIZON - k * dt
        y[k + 1] = y[k] + (y[k] + 2 * score(y[k], s)) * dt + np.sqrt(2 * dt) * rng.standard_normal(n)
    won = y[-1] > 0
    print("reversed samples, mean |x| at the end:", np.abs(y[-1]).mean(),
          "std about the mode:", (np.abs(y[-1]) - MODE).std())

    fig, axes = plt.subplots(1, 2, figsize=(6.6, 2.9), sharey=True, constrained_layout=True)
    for i in range(n):
        axes[0].plot(t, x[:, i], lw=0.6, alpha=0.55, color=TEAL if sign[i] > 0 else ORANGE)
        axes[1].plot(t, y[:, i], lw=0.6, alpha=0.55, color=TEAL if won[i] else ORANGE)
    for ax in axes:
        tidy(ax)
        ax.set_xlim(0, HORIZON)
        ax.set_ylim(-3.6, 3.6)
    axes[0].set_title("forward: the noise forgets the start", fontsize=9.5, color=INK)
    axes[1].set_title("reversed: the score restores it", fontsize=9.5, color=INK)
    axes[0].set_ylabel("$x$")
    axes[0].set_xlabel("forward time $t$")
    axes[1].set_xlabel("reverse time $s = 3 - t$")
    fig.savefig(OUT / "demon-reverse-diffusion.svg")
    plt.close(fig)


if __name__ == "__main__":
    figure_disks()
    figure_width()
    figure_reverse()
