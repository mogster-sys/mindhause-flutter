# MindHause — Business & Investment Dossier

**Prepared:** 2026-05-26
**Owner:** Mogie Dick (mogie.dick@gmail.com)
**Repo:** github.com/mogster-sys/mindhause-flutter
**Codename:** MindHause (working title — see Trademark Strategy for naming considerations)
**Current branch state:** Flutter host + Godot 4.0 palace, ~60-70% structurally complete, pre-launch. Greco-Roman vertical slice through Foyer→Library→Garden at production-grade. All 10 rooms now themed (see `docs/asset_recon_2026-05-10/tracking.md`).

---

## What's in this dossier

| # | Document | Purpose |
|---|----------|---------|
| 00 | README (this file) | Index & how to use this pack |
| 01 | Executive Summary | One-page elevator pitch — start here |
| 02 | Business Plan | Full operating plan: model, ops, milestones |
| 03 | Investment Memo | What investors get — terms, use of funds, exit thesis |
| 04 | Marketing Plan & Go-To-Market | Positioning, channels, launch sequence |
| 05 | Competitor Analysis | Direct, indirect, adjacent — and the white space |
| 06 | Trademark & IP Strategy | Class 9/41/42 strategy, name candidates |
| 07 | Legal Framework | Privacy policy, ToS scaffolding, GDPR/CCPA/UK-DPA compliance — and why privacy is the moat, not a footnote |
| 08 | Technical Specifications | Architecture, stack, data model, build targets |
| 09 | Financial Projections | 3-year P&L, unit economics, sensitivity |
| 10 | Product Roadmap | Q3-26 through 2028, gated milestones (including DecisionLens integration) |
| 11 | Risk Assessment | Top 12 risks ranked, mitigation per risk |

---

## How to use this pack

**If you're evaluating the app's potential** (you, future you, or an advisor):
1. Read **01-Executive-Summary.md** (5 min)
2. Then **05-Competitor-Analysis.md** — see if the white space holds up
3. Then **09-Financial-Projections.md** — see if the unit economics make sense at scale

**If you're pitching investors / showing to a partner:**
1. Lead with **03-Investment-Memo.md**
2. Back it up with **02-Business-Plan.md** and **08-Technical-Specifications.md**
3. Show the existing pitch deck at `docs/pitch/DECK.md` + the Library→Garden video

**If you're filing trademarks:**
1. **06-Trademark-IP-Strategy.md** has the class list, candidate names, and the recommended filing sequence

**If you're about to launch:**
1. **04-Marketing-Plan.md** — positioning + 90-day launch sequence
2. **07-Legal-Framework.md** — store-required policies before submission

---

## Related artifacts in this repo

- `README.md` — Project root summary
- `docs/PRD.md` — Product Requirements Document (canonical product spec)
- `docs/ARCHITECTURE.md` — Technical architecture deep-dive
- `docs/PROJECT_BRIEF_FOR_WEBSITE.md` — Voice/positioning source for marketing copy
- `docs/THEME_REFERENCE.md` — 8-theme catalogue
- `docs/MNEMONIC_SYSTEMS_REFERENCE.md` — The memory-palace technique behind the product
- `docs/asset_recon_2026-05-10/` — Production asset acquisition tracker (shows operational maturity)
- `docs/pitch/DECK.md` — 15-slide VC deck (with `[FILL]` markers for data from this dossier)
- `docs/integration/decisionlens_integration.md` — DecisionLens-as-module integration design

---

## A note on numbers

Financial projections, market sizes, and conversion benchmarks in this pack are **modelled estimates** based on publicly reported industry benchmarks (Statista, App Annie / data.ai, Sensor Tower, RevenueCat State of Subscriptions). They are not forecasts — they are scenarios. Treat them as the framework against which to test assumptions, not as promises.

The cost projections are real (rounded). The revenue projections are illustrative.

---

## A note on what's already true vs. what's plan

| Status | What it means |
|--------|---------------|
| **Built** | Working code in the current repo, tested on device |
| **Designed** | Specced in this dossier or in `/docs/`, not yet built |
| **Planned** | Acknowledged need, not yet specced |
| **Hypothesis** | Belief about the market or user, untested |

Each section flags which is which so an investor or partner reading this can separate the product from the pitch.

**Right now (2026-05-26):**
- **Built**: 10 rooms with first-pass kit (materials/props/lighting/cinematic cameras), cat companion system (6 modules), monster evolution system, door transitions, theme switching, in-memory data layer
- **Designed**: SQLite integration, DecisionLens-as-module integration, audio production pipeline, app icon
- **Planned**: Flutter↔Godot embedding via platform view, store submission flow, full audio bed per theme
- **Hypothesis**: ADHD-targeted positioning converts above industry average for productivity apps; one-time-purchase pricing produces sustainable LTV vs subscription
