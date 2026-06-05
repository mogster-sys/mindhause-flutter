# MindHause — Executive Summary

## The product

MindHause is a **first-person 3D memory-palace productivity app**. Your to-dos, notes, goals, and habits become physical objects placed inside the rooms of a navigable home you walk through. Beneath the spatial layer is a complete task manager — projects, subtasks, calendar, habits, focus timer, notes — and one tap flips between the **Palace** (immersive 3D) and **Organiser** (fast Flutter list/calendar) views.

> "Your tasks live somewhere. Walk through them."

## The insight

Traditional task apps are flat lists. Human memory is spatial. The Method of Loci (memory palace) has been used since ancient Greece because the brain evolved for *places*, not bullet points. Memory champions still use it. **No productivity app has ever made this literal.**

## Why this audience

**Primary**: people with ADHD or executive-function challenges. Flat lists are actively hostile for this brain — no novelty, no spatial anchor, nothing to make the invisible cost of avoidance *visible*. ADHD affects approximately 5–6% of adults globally [FILL: cite current source — APA, NIMH, or WHO]. Mobile productivity apps have a graveyard rate of >90% within 30 days; the audience is acutely underserved.

**Secondary**: serial task-app quitters across the broader productivity market — the "I love the idea of Notion but bounce off it" crowd.

## Differentiation (the moat)

1. **Spatial, not sequential** — rooms and objects, not infinite lists
2. **Visible avoidance** — neglected tasks decay into monsters you can defeat, making procrastination tangible
3. **100% on-device, no accounts, no cloud** — for users storing their entire mental load, trust is the product
4. **No subscription planned** — one-time unlock + optional theme packs. No ads. No data selling.
5. **Real productivity app underneath** — not a tech demo; the planner is complete

For a VC-funded incumbent, items #3 and #4 are structurally hard to copy without cannibalising recurring revenue. That asymmetry is defensible.

## Business model

- **Free tier:** Foyer + 2 rooms, basic cat, default Greco-Roman theme
- **One-time unlock (~$5–8):** full house (10 rooms), all object types, full cat behaviours, focus mode
- **Theme packs ($1–3 each, or bundle):** 8 themes as optional IAP (Greco-Roman, Modern Loft, Victorian, Sci-Fi, Gothic, Ryokan, Cottage, Fallout)
- **Not in the v1 plan:** subscriptions
- **Never:** ads, telemetry, data resale

## Current state (Built)

- **10 rooms** with full geometry, doors, lighting, navigation
- **Cat companion** (6 modules: companion / brain / movement / animation / procedural / skin)
- **Monster evolution** for neglected tasks (toggleable, sensitivity-adjustable)
- **8 themes** defined with textures and colour systems
- **First room kit at production grade** — Greco-Roman Library + Garden vertical slice
- **First-class asset pipeline** with verified vendor sources (see `docs/asset_recon_2026-05-10/`)

## Adjacencies (the platform play, planned)

**DecisionLens** (`/home/mogie/projects/decisionlens/`) is a sister Flutter app — 5 decision-making frameworks (SWOT, Eisenhower, Decision Matrix, NASA TLX, McKenna 9-Square Support Circle). The frameworks fit naturally into MindHause rooms as themed wall surfaces (analytical tools in the Library, contemplative McKenna 9-square in the Garden, cat bridging between them). This converts MindHause from "an organiser" to "a decision environment" — and signals that the engine supports a richer mode than task placement.

Integration design at `docs/integration/decisionlens_integration.md`. Estimated [FILL] days of focused work.

## The ask

[FILL: raise amount, valuation expectation, use of funds. Indicative breakdown to be confirmed:
- N% engineering (Flutter↔Godot embedding, SQLite integration, remaining theme kits)
- N% content (the other 7 theme kits at production grade, audio production, custom Blender for hero pieces)
- N% launch/marketing (Apple/Play store optimisation, organic content, paid acquisition test)
- N months runway to ship v1 + first paid theme]

## Bottom line

A productivity app that respects how its users' brains actually work, doesn't farm their data, doesn't extract a monthly subscription, and uses a 2,000-year-old memory technique nobody has ever made literal. Strong v1 exists; the engine supports adjacent capabilities (decision environment, integration with DecisionLens) that compound the moat.
