# Prediction-markets essay: fact check (2026-10-28)

Leads came from research-pm-industry-2026-10-28.md and research-pm-literature-2026-10-28.md. Each item is checked against the primary or best available source. Papers were read in full text (arXiv / author PDFs) where noted.

1. **Kalshi combos.**
   - Launch: **CORRECTED.** Kalshi self-certified multileg contracts with the CFTC around Sept 2–4, 2025, aiming for NFL Week 1. The first customizable parlays went out as an unannounced "stealth" release on two Monday-night games in September 2025, and at scale on Sept 29, 2025 (Sportico). The beta was limited to select NFL games in the app. The full rollout to all users came about Dec 15–16, 2025 (Mansour: over $100M in the first week). Safe wording: "a beta from September 2025, opened to all users in December 2025." URLs: https://sbcamericas.com/2025/09/03/kalshi-parlay-style-event-contracts-nfl/ ; https://www.sportico.com/business/sports-betting/2025/kalshi-nfl-parlays-volume-1234873711/ ; https://www.covers.com/industry/kalshi-combo-event-contracts-raises-prediction-market-stakes-december-16-2025
   - 58% / 13%: **CONFIRMED.** CNBC, "How event contract bundles are boosting volume on prediction markets," 2026-10-06: combos were 58% of Kalshi trading volume in September but under 13% of transactions, **per Dune data**. The average cash per contract was about 9¢ on combos and under 47¢ on singles. https://www.cnbc.com/2026/10/06/prediction-market-combo-contract-volume.html (CNBC returns 403 to fetchers, so this was confirmed via search excerpts.)
   - RFQ: **CONFIRMED.** Kalshi Help Center: "Combo prices are determined through a Request For Quote (RFQ) system." If nobody quotes, the order does not fill. https://help.kalshi.com/markets/combos ; developer docs (RFQs work on any market, combos included; all combo markets are high-volatility markets with shorter windows): https://docs.kalshi.com/getting_started/rfqs

2. **Polymarket US Combos.** **CONFIRMED, with a refinement.** QCX self-certified the "Combinatoric Athletic Outcome Contract" (CAOC) on 2026-05-20. The first trade (private test) was on 2026-08-05. DeFi Rate first saw the builder open to regular app users on **Wed Aug 19, 2026**, so use "mid/late August." https://defirate.com/news/polymarket-us-launches-parlay-style-combos-ahead-of-football-season/
   - RFQ: **CONFIRMED.** A user's Request starts an auction among connected market makers, who return executable Quotes. The best Quote is shown, and the user has 10 s to sign. https://docs.polymarket.com/market-makers/combos
   - 51.5%: **CONFIRMED.** For Oct 5–11, 2026, the CAOC family was $1.45B of $2.82B, **51.52%** of Polymarket US trade volume. DeFi Rate calls CAOC "a non-additive subset." https://defirate.com/news/kalshi-hits-record-19-billion-week-as-polymarket-us-triples-fall-trade-volume/

3. **Oddpool census.** **CONFIRMED.** "Zero quotes, from zero makers, across every non-sports category we tried" (all 96 RFQs were accepted by the server). There were 13 distinct quote_creator_ids on 126 sports RFQs, and two "backbones" each answered roughly half of requests. The single correlation-aware maker is the authors' inference from latency ("our reading"). Ritesh Malpani, 2026-05-28. https://www.oddpool.com/research/kalshi-rfq-market-makers

4. **Saguillo et al.** **CONFIRMED.** "A realized estimate of 40 million USD of profit extracted" across both arbitrage types. Data: markets resolved **April 1, 2024 – April 1, 2025** (paper §3). AFT 2025, LIPIcs 354, 27:1–27:24. https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.AFT.2025.27 ; https://arxiv.org/abs/2508.03474

5. **Polymarket AMM → CLOB.**
   - Type: **CONFIRMED FPMM** (the Wikipedia "LMSR / Hanson" description is wrong). Polymarket's own `amm-maths` package (Nov 2020) contains only an `fpmm` module for "the Conditional Tokens Market Makers used by Polymarket." Its subgraph indexes the legacy markets as `fpmm-subgraph`. Legacy docs describe LP shares minting one token per outcome, which is the FPMM liquidity model. The forked contracts repo carries both FPMM and LMSR contracts. https://github.com/Polymarket/amm-maths ; https://github.com/Polymarket/polymarket-subgraph ; https://github.com/Polymarket/conditional-tokens-market-makers
   - CLOB date: **UNCONFIRMED from a primary source.** The CLOB client repos date from Oct 2021 – Feb 2022, and the legacy docs say "Not all questions on Polymarket have order books. Some will still use the AMM structure" (https://legacy-docs.polymarket.com/order-books). Secondary sources say the transition finished by Q4 2022. Safe wording: "moved to an order book during 2022."

6. **Susquehanna.** **CONFIRMED.** Business Wire, 2024-04-03, "Kalshi Onboards Its First Dedicated Institutional Market Maker": Susquehanna Government Products, LLLP (SIG). https://www.businesswire.com/news/home/20240403664852/en/Kalshi-Onboards-Its-First-Dedicated-Institutional-Market-Maker

7. **Cultivate Labs.** **CONFIRMED.** Ben Roesch, 2022-08-04. Four headings: "We want flexibility in forecast aggregation" (a price depends on the trade sequence, so a crowd forecast cannot be computed from a subset of forecasters); "Prediction market currency can be intimidating"; "Markets are ripe for manipulation" (duplicate accounts; markets created by people who can control the outcome); "We don't know what game people are playing." They also cite the cost of maintaining two systems. They concede market prices are about as accurate. The replacement is **opinion pools rewarded by a proper scoring rule**. The post links a Brier-score explainer but does not name Brier (or log) in the text, so say "proper scoring rule." https://www.cultivatelabs.com/posts/why-we-stopped-supporting-prediction-markets

8. **Inkling → Cultivate.** **CONFIRMED.** Inkling Markets was co-founded by Adam Siegel and Nate Kontny (YC, 2006). Kontny left in 2011. In 2015 Siegel and a new co-founder, **Ben Roesch**, formed the company that acquired Inkling's assets, Cultivate Labs. Siegel, "Inkling's final chapter," 2015-09-02: https://blog.inklingmarkets.com/2015/09/

9. **Volumes.**
   - Industry total: **CONFIRMED.** $79.6B notional in Sept 2026 (+56%). https://defirate.com/prediction-markets/volume/
   - Kalshi: **CONFIRMED.** $60.7B in Sept 2026 and **$325.0B for 2026 through Oct 28**. https://defirate.com/prediction-markets/volume/kalshi/
   - Kalshi 2025: **$23.8B** (KalshiData; secondary): https://www.kucoin.com/news/flash/kalshi-2025-trading-volume-hits-23-8-billion-surges-1108-year-on-year
   - Sports share: **CORRECTED/qualified.** ~85% holds only when Exotics/combos are counted as sports. Sports-only was ~53% for the week of June 8, 2026 (Dune; SGI Europe): https://www.sgieurope.com/technology/kalshi-booms-on-sports/121847.article

10. **Metaculus.**
    - Spring 2026 (Jan 7 – Apr 15): **CONFIRMED.** Bot team −1.25 vs Pros (95% CI −4.87 to 2.37, one-sided p=0.247, 99 questions; not significant). Prior scores: Q3 2024 −11.3, Q4 2024 −8.9, Q1 2025 −17.7, Q2 2025 −20.03. There was no Fall 2025 benchmark: Spring 2026 was the fifth. "Nine of the ten individual Pros beat every individual bot." https://www.lesswrong.com/posts/wZBbDqzfBjYG58CxK/futureeval-spring-results-pros-beat-bots-but-the-gap-is
    - Summer 2026 Cup: **CONFIRMED.** "Laertes and ManticAI finished 1st and 2nd overall, and FutureSearch finished 5th." Bots are not prize-eligible. 885 forecasters, 58 questions. Metaculus, 2026-09-18: https://www.metaculus.com/notebooks/45734/announcing-the-metaculus-cup-summer-2026-winners/

11. **ForecastBench.** **CONFIRMED.** FRI, 2026-07-16, "AI models have likely reached parity with superforecasters on ForecastBench": "several models are statistically indistinguishable from superforecaster-level accuracy." Equality was not rejected (Cassi p=0.41, xAI 0.15/0.16, DeepMind 0.14). https://forecastingresearch.substack.com/p/ai-models-have-likely-reached-parity

12. **Prophet Arena.** **CORRECTED framing.** Yang, Mahns, Li, Gu, Wu, Xu, arXiv 2510.17638, Table 2 (1,367 Kalshi events, forecasts under 3 h before resolution excluded):

    | Forecaster | Brier | ECE | Average return |
    |---|---|---|---|
    | GPT-5 | 0.184 | 0.042 | 0.943 |
    | Market baseline | 0.187 | 0.069 | 0.899 |

    So GPT-5 did lose about 6¢ per $1, but betting at market prices *also* loses (0.899), and the paper says frontier LLMs "consistently outperform the [market] in terms of calibration and market return." It calls the returns "promising." Do not write "lost money trading against prices" as a verdict on its forecasts. https://arxiv.org/abs/2510.17638

13. **Begin and Galanis.**
    - Begin: **CONFIRMED, with a caveat.** Begin, Gho, Muppavarapu, Tsay, Mohan, Shaik, Li, Sharma, Vaidheeswaran, "Preference Optimization Drives Monoculture in LLM Prediction Markets" (2026-06-25): ρ=0.70, N_eff≈1.4, and the 10-agent market (67.6%) fails to match a single agent (70.2%). Caveat: the questions are **TruthfulQA binary questions, not real forecasts**, and the main model is Llama 3.1 8B. https://arxiv.org/abs/2606.26583
    - Galanis: **CONFIRMED.** Aggregation fails "where more than two levels of interactive reasoning are required," and the markets are LMSR. v4 is dated 2026-09-25. https://arxiv.org/abs/2604.20050

14. **Bürgi, Deng, Whelan.** **CONFIRMED, with a title nuance.** The cover says "Makers or Takers: The Economics of the Kalshi Prediction Market" (GWU CER WP 2026-001, Feb 2026); the inner title page says "Makers and Takers…" (UCD, Jan 2026). Average **post-fee** returns are makers −9.64% and takers −31.46%. The sample is over 300,000 contracts. https://www2.gwu.edu/~forcpgm/2026-001.pdf

15. **Columbia wash trading.** **CONFIRMED ~25%; peak CORRECTED.** Sirolly, Ma, Kanoria, Sethi, "Network-Based Detection of Wash Trading" (SSRN 5714122, 2025-11-06, revised 2026-01-17; not peer-reviewed). The algorithm classifies "nearly 25% of Polymarket's historical volume" as wash. The trend began upward in July 2024 and **peaked at nearly 60% of weekly volume in December 2024**, not July. It fell below 5% by May 2025 and was back to about 20% in early Oct 2025. https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5714122

16. **Frongillo et al.** **CONFIRMED.** ITCS 2024, LIPIcs 287, 51:1–51:21. https://doi.org/10.4230/LIPIcs.ITCS.2024.51

17. **Chen, Goel, Pennock.** **CONFIRMED.** The general pricing problem for tournaments is #P-hard. Thm 3.3: O(n³) operations per trade for "team i wins game k," "…given they make it to that game," and "team i beats team j given they face off." STOC 2008. https://www.5harad.com/papers/tournaments.pdf
    - Side note: Fig. 1's network is "oriented in reverse of … the usual notion of causality," which matches the literature report.

18. **Chen et al. EC 2008.** **CONFIRMED, with a qualifier.** Cor. 12: worst-case loss ≤ b·n·ln(n) **in the limit ε→0** (trades split into small pieces). For ε>0 the bound "can grow arbitrarily large." Compare b·ln(n!) for exact LMSR. Method: PermELearn with Sinkhorn balancing. https://arxiv.org/abs/0802.1362

19. **Kroer et al. EC 2016.** **2^63 CONFIRMED; runtime CORRECTED.**
    - Data: the NCAA 2010 market, outcome space 2^63, 88k trades on 5k securities.
    - Method: Frank–Wolfe implementing a Bregman projection, with an IP solver as oracle.
    - Runtime: under a 30-minute limit, the full projection **first completed only after 45 of 63 games had settled**. Before that the market relied on partial-outcome propagation and LCMM. The literature report's "seconds per trade" is wrong.

    https://arxiv.org/abs/1606.02825

20. **Eisenberg & Gale.** **CONFIRMED** (Crossref): Edmund Eisenberg, David Gale, "Consensus of Subjective Probabilities: The Pari-Mutuel Method," Ann. Math. Statist. 30(1):165–168, March 1959. https://doi.org/10.1214/aoms/1177706369
