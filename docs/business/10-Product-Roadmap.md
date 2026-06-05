# MindHause — Product Roadmap

## 1. How to read this roadmap

Each phase is **gated**: it ships when its definition-of-done is met, not on a calendar. Calendar dates are targets, not commitments. Each item is tagged:

| Tag | Meaning |
|---|---|
| **Built** | Working code in current repo, validated on device |
| **Designed** | Specced in docs, not yet built |
| **Planned** | Acknowledged need, not specced |
| **Hypothesis** | Belief about value; will be tested |

---

## 2. Roadmap (gated, not date-bound)

### Phase 0 — Foundation (Built, as of 2026-05-18)
- ✅ 10 rooms with first-pass kit (materials/props/lighting/cinematic cameras), 7 of 8 themes shown
- ✅ Cat companion (6 modules), monster evolution system
- ✅ Theme switching system + `themed_geometry` group pattern
- ✅ Asset acquisition pipeline (verified vendor sources, tracking system)
- ✅ Pitch video pipeline (Library + Garden vertical slice → record-ready)
- ✅ Unified cinematic camera (10 scripts consolidated into one parameterized)
- ✅ DecisionLens sister app filed; integration design drafted

### Phase 1 — v1.0 Launch-Ready (Designed → Build)
*Target: Q3 2026 [FILL specific date]*
**Definition of done**: shippable to App Store + Google Play.

1. **Flutter↔Godot Platform View embedding** — one-tap palace↔organiser
2. **SQLite integration** via `DatabaseBridge` — both engines read/write same store
3. **Greco-Roman vertical slice** at production polish (Library + Foyer + Garden — already kitted; remaining: cat behaviour in scene context, audio bed in scene)
4. **Audio production** for Greco-Roman ambient (Suno + Sculptunes-Rome layered, ~3 min loop)
5. **Greco-Roman ambient SFX** for room interactions (footstep variation per surface, etc — most already present)
6. **Custom Blender pieces required for v1**: minimum the bust statue (Greco-Roman gold vault centrepiece), the Greco-Roman ionic column (Library entrance)
7. **In-Godot validation** of all 10 rooms — fix systematic placement issues from current first-pass kit
8. **App icon + store creative** (5 hero screenshots + 30-90s video + Apple/Google copy)
9. **Privacy Policy + ToS** finalised; Apple privacy nutrition labels + Google Data Safety completed
10. **Trademark filed in AU** (priority date); domain secured
11. **Beta on TestFlight + Play Internal** (~50 testers, 2-week cadence)

**Gate to ship**: 4.5+ star average from beta; zero P0/P1 bugs; founder confidence + Solicitor sign-off on legal docs.

### Phase 2 — v1.x Post-Launch Iteration (Planned)
*Target: Q3-Q4 2026 [FILL]*
**Definition of done**: stable, well-reviewed v1 with active user feedback loop.

1. Bug-fix cadence (weekly patch releases as needed)
2. ASO iteration based on actual download data
3. Founder podcast tour (3-5 ADHD/productivity podcasts)
4. First wave of organic content (8 cornerstone articles + supporting videos)
5. First paid acquisition test (small budget, single channel)
6. **Theme pack #2** — Victorian Scholar at production grade (uses asset pipeline pattern proved with Greco-Roman)
7. First $1k revenue month (KPI marker)

### Phase 3 — Theme Expansion (Planned)
*Target: Q4 2026 – Q2 2027 [FILL]*
**Definition of done**: 4 themes at production grade, healthy cadence demonstrated.

- Theme #3: Ryokan (Bedroom already kitted as concept; promote to v1 quality)
- Theme #4: Modern Loft (Kitchen already kitted as concept; promote)
- Each theme pack ships as IAP, ~quarterly cadence
- Per-theme cinematic video for marketing
- Per-theme ambient music bed

### Phase 4 — DecisionLens Module Integration (Designed → Build)
*Target: Q1-Q2 2027 [FILL]*
**Definition of done**: DecisionLens lives inside MindHause as a themed UI surface.

Per the simplified integration model (see `docs/integration/decisionlens_integration.md`, updated):
1. DecisionLens migrated Hive → SQLite (joins MindHause's data store)
2. DecisionLens Flutter UI embedded as a themed wall surface in Library (or Study)
3. McKenna 9-square Support Circle placed in Garden as a contemplative surface
4. Cat behaviour extended to bridge analytical → contemplative work
5. RAG ambient lighting in rooms with active decisions (signature feature)

Sells **engine-as-platform** narrative; demonstrates MindHause is more than a task organiser.

### Phase 5 — Remaining Themes (Planned)
*Target: 2027 [FILL]*
- Theme #5: Gothic (Cellar already kitted concept)
- Theme #6: Sci-Fi Minimal (Gymnasium already kitted concept)
- Theme #7: Countryside Cottage (no concept room yet — would need re-theming or new room)
- Theme #8: Fallout Bunker (Workshop already kitted concept)

By end of 2027: 8 themes at production grade, complete theme catalogue.

### Phase 6 — Platform Expansion (Hypothesis → Designed)
*Target: 2028+ [FILL]*
Each additional layer extends MindHause's surface without rebuilding the engine.

- **Journalling module** (a Library shelf for journal entries, or dedicated alcove)
- **Meditation / breathwork module** (Garden as guided-meditation space)
- **Knowledge base / second-brain module** (Library with linked notes as books)
- **Household / shopping module** (Kitchen with pantry tracking — already conceptually mapped)
- **Web app** (companion view; not primary)
- **Desktop apps** (macOS/Windows; for power users)

Order of arrival driven by user signal post-launch.

### Phase 7 — Strategic Considerations (Hypothesis)
*Target: undefined*

- **Optional encrypted cloud backup** (user-encrypted, no server-side key access) — for users who want belt-and-suspenders; never default
- **Optional multi-device sync** via E2EE (similar to Standard Notes architecture) — power users with iPad + iPhone + Mac
- **MindHause Pro tier** could explore subscription pricing for premium cloud sync + household sharing features if user signal supports it. Not in v1-3 plan; the base app remains free + IAP regardless.
- **Acquisition / strategic partnership exploration** — only at sufficient scale to negotiate from strength

These are explicitly **post-product-market-fit** considerations. Not v1, not v2, not committed.

---

## 3. Visualised timeline (illustrative)

```
2026 Q2    Q3            Q4         2027 Q1    Q2         Q3-Q4       2028
───────────────────────────────────────────────────────────────────────────
[FOUNDATION] [PHASE 1 — V1.0 LAUNCH]
              ▼
              v1.0 ships
                 [PHASE 2 — POST-LAUNCH ITERATION]
                                    [PHASE 3 — THEME EXPANSION (3-4 themes)]
                                                  [PHASE 4 — DECISIONLENS]
                                                              [PHASE 5 — REMAINING THEMES]
                                                                          [PHASE 6 — PLATFORM LAYERS]
                                                                                       [PHASE 7]
```

[FILL: tighter dates once funded; current is illustrative.]

---

## 4. What's NOT on the roadmap

To stay honest:
- **Subscription tier for the base app** — not planned. The base app is free + one-time unlock + theme IAPs. A separate Pro tier (if ever) sits beside the base app, doesn't gate it.
- **Cloud-first features in v1-3** — privacy-first is core
- **AI-generated themes / objects** — interesting, but post-Phase 6 at earliest
- **Multiplayer / shared palaces** — single-user spatial cognition is the focus
- **Smartwatch / external sensor integration** — out of scope until base user demand demonstrates need
- **Backend / API for third parties** — would require infrastructure we don't have and don't want

---

## 5. Decision gates that could change the roadmap

| Gate | What it tests | What it changes |
|---|---|---|
| v1.0 first-month metrics | Does the spatial paradigm resonate broadly? | If conversion is below floor, narrow audience to ADHD-only; deepen ADHD positioning |
| First paid acquisition test (T+45) | Can paid channels work at our pricing? | If CAC ceiling is hit, double down on organic only; cut paid |
| DecisionLens integration prototype (Phase 4 Phase 0) | Does the embedded-UI pattern feel good in the spatial layer? | If clunky, defer DecisionLens integration; focus on theme expansion |
| Theme pack #2 attach rate (T+90) | Will users buy multiple themes? | Sets theme pack release cadence; if attach is low, slow theme schedule, pivot to platform layers |
| Y1 revenue trajectory vs expected | Does the financial model hold? | If far below, raise bridge funding or wind down; if far above, accelerate hires |

Each gate is intentional. The plan is to be wrong about something at each gate, and update.

---

## 6. Roadmap meta-principle

Ship the smallest thing that proves the next thing. Don't pre-build for a future we haven't validated. The engine substrate is intentionally generous because it's the moat — but every user-facing feature must earn its place in the next phase before it gets built.
