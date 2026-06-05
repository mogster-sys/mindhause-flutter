# MindHause — Business Plan

## 1. What this document is

The full operating plan: product, model, operations, milestones, the team needed to ship and grow it. Pulls from PRD, ARCHITECTURE, and asset/integration recon docs already in the repo; folds them into an investable narrative.

For positioning copy and channel strategy, see `04-Marketing-Plan.md`. For unit economics, see `09-Financial-Projections.md`.

---

## 2. Mission

Build a productivity app that respects spatial cognition, respects privacy absolutely, and respects the user's wallet — for people whose brains don't work in straight lines.

## 3. Product (Built / Designed / Planned status)

### Core spatial layer (Built)
- 10 rooms × 3 floors: Foyer (hub), Study, Library, Kitchen, Bedroom, Cellar, Workshop, Garden, Gymnasium, Treasury
- First-person navigation, head bob, footsteps, door transitions (cooldown-protected against bounce)
- 8 cat models, one per theme, shared 27-bone skeleton + animation set
- Monster evolution system (4-stage decay: Healthy → Neglected → Corrupting → Monster; defeat = complete the task)
- Theme system (8 themes; `themed_geometry` group on CSG nodes; runtime swap)
- In-memory data layer with `DatabaseBridge` autoload + `_ensure_initialized()` guards

### Task system (Built — Flutter side / Designed — Godot binding)
- Tasks, subtasks, projects, goals, habits, notes, calendar, focus timer (Flutter, working)
- 10 symbolic object types: scroll, book, candle, statue, letter, blueprint, plant, post-it, jar, key
- 6 visual states per object: New / In progress / Urgent / Completed / Neglected / Corrupting
- Surface-based placement system (`placement_surface.tscn` instances in each room)

### Integrations (Designed)
- SQLite as single source of truth, both Flutter + Godot reading/writing
- Flutter↔Godot embedding via platform view
- DecisionLens-as-module (frameworks rendered on themed wall surfaces in Library + Garden; see `docs/integration/decisionlens_integration.md`)

### Audio (Designed / Planned)
- 19 base SFX present (doors, footsteps, monsters, UI, task interactions)
- 8 ambient music tracks (1 per theme) — sourcing path documented; Greco-Roman = Suno-generated + Sculptunes-Rome Sonniss layer
- Cat sounds (meow/purr/hiss/chirp) — Sonniss has a cat meow file already extracted
- 8 chime SFX (per-theme timepieces) — sourcing planned via Freesound

### Out-of-scope for v1
- Multiplayer / shared palaces
- AI generation of new themes
- Smartwatch / external sensor integration
- Web app at parity with mobile (web is stretch)

---

## 4. Operating model

### 4.1 Team (current and needed)

**Current**: Solo founder (Mogie Dick) — design, product, Flutter, GDScript, Godot scene authoring, asset acquisition pipeline, business strategy.

**Hires needed for v1 ship** [FILL with target hire timing once funded]:
- **3D artist / Blender generalist** (contractor) — to produce hero pieces the asset pipeline flagged as custom-only (clepsydra, astronomical clock, incense clock, pillar clock, cuckoo clock, ionic column, bust statue). Estimated 60-80 hours total. Or one-time contract per piece.
- **Audio producer** (contractor or one-time) — for the 8 ambient music tracks if Suno/Pixabay sourcing doesn't hit the bar
- **Marketing / community** [post-launch, part-time]

**Hires desirable post-launch** [FILL]:
- Backend engineer (only if the product evolves toward optional cloud sync, which is currently OUT of scope)
- iOS/Android specialist for store optimisation and platform-specific polish

### 4.2 Tools / vendors / costs (real)

| Item | Provider | Cost | Cadence |
|---|---|---|---|
| Apple Developer Program | Apple | $99 | annual |
| Google Play Developer | Google | $25 | one-time |
| Domain | [FILL] | ~$15 | annual |
| Email | Google Workspace or similar | ~$6 | monthly per user |
| Asset library (existing) | Quaternius / Kenney / Poly Haven / AmbientCG / Sonniss | $0 | one-time download |
| Optional paid asset upgrades | Binbun bundle ($26), Synty packs ($15-175), KitBash3D ($95-245 or Cargo $59/mo) | $26-900 | one-time or sub |
| Trademark filings | [FILL country class] | ~$300-700 per class per country | one-time |
| Privacy policy / ToS templates | iubenda, Termly, or solicitor | $0-1000 | one-time |
| Crash / observability (Sentry free tier) | Sentry | $0 | monthly until volume |
| Analytics — DELIBERATELY NONE | — | $0 | — |

**Estimated all-in monthly burn pre-launch (solo, no salary draw)**: ~$50-100 (mostly subscriptions). **With assets + legal one-time**: ~$1,000-2,000.

**Estimated all-in monthly burn after first hire** [FILL hire cost]: salaries + the above.

### 4.3 Build infrastructure

- **VCS**: GitHub (mogster-sys/mindhause-flutter)
- **CI/CD**: [FILL — Codemagic, GitHub Actions, or Bitrise for Flutter mobile builds]
- **Distribution**: TestFlight + Google Play Internal Testing for beta; App Store + Google Play for production
- **Crash reporting**: Sentry (free tier)
- **No backend infrastructure** — privacy-by-design means no servers to scale, no AWS bill, no incident pages

### 4.4 Release model

- **v1.0 (target [FILL date])**: Greco-Roman theme at production grade, all 10 rooms walkable, full task system, organiser-mode parity, cat at full feature, monsters toggleable, focus mode
- **v1.x patches**: bug fixes, UX polish from launch feedback
- **v2.0 (target [FILL date])**: second theme at production grade (Victorian or Ryokan)
- **Subsequent theme packs**: roughly quarterly cadence as IAP releases

---

## 5. Milestones

| Milestone | Target date | Definition of done |
|---|---|---|
| Library + Garden vertical slice in Godot (Greco-Roman) | [FILL — done as of 2026-05-18] | Walkable, kitted, ambient music, recorded video for pitch |
| All 10 rooms first-pass kit | [FILL — done as of 2026-05-18] | Themes applied, props placed, cinematic cameras per room |
| First pitch video shipped | [FILL date] | 60-90s video edited + on website |
| Flutter↔Godot embedding works | [FILL date] | One-tap switch palace↔organiser, no crash |
| SQLite integration | [FILL date] | DatabaseBridge persists, both apps read/write same store |
| Beta build on TestFlight | [FILL date] | 50 testers, weekly bug-triage cadence |
| Privacy policy + ToS + store-required assets | [FILL date] | Apple/Google review-ready |
| **v1.0 store launch** | [FILL date] | Live on iOS + Android stores |
| First $1k revenue month | [FILL date] | Triggers re-evaluate of marketing spend |
| DecisionLens module integration v1 | [FILL date] | DecisionLens UI embedded in Library; McKenna in Garden; cat bridges |
| 8 themes all at production grade | [FILL date] | All theme IAPs purchasable |

---

## 6. Operations cadence

### Weekly
- Sprint review of progress against the active milestone
- Bug triage from beta / production crash reports
- One asset/content task moved forward (kit a room deeper, finish an audio bed, polish a feature)

### Monthly
- Financial close (cost actuals vs plan)
- Retention/conversion metrics review (post-launch)
- Roadmap re-prioritisation if signals demand

### Quarterly
- Strategic review: are we on the trajectory? Should pricing change?
- Theme pack release
- Marketing channel performance review

---

## 7. The platform play

MindHause is positioned as **a productivity app today, a spatial cognition platform tomorrow.** The DecisionLens integration is the first proof — frameworks rendered on themed surfaces inside MindHause rooms, cat bridging analytical and contemplative modes. Additional adjacent layers we could add over the engine without rebuilding it:

- **Journalling / mood tracking** — a room or alcove with a journal pedestal
- **Meditation / breathwork** — the Garden as a guided-meditation space
- **Knowledge base / second brain** — Library with linked notes as physical books on shelves
- **Shopping / household management** — Kitchen with pantry tracking (already mapped in the room design)

Each adjacent layer extends MindHause's total addressable surface without splitting the user across multiple apps. The engine is the moat.

---

## 8. What we will NOT do

To stay honest about scope:
- **Subscription pricing in v1** — not in the plan. Free base + theme IAPs is the v1 model. A separate paid tier (e.g. cloud sync, household sharing) could be explored post-launch if user signal supports it.
- **Backend / cloud sync as default** — privacy-first is the product. Optional encrypted backup is conceivable post-launch but never the default.
- **Ads or third-party SDKs that exfiltrate data** — ever
- **In-app purchases that gate basic functionality** — IAPs add themes or capabilities, never unlock features that should be free
- **AI-generated user content** — generated themes / objects are an interesting future but not v1
- **Multiplayer** — single-user spatial cognition is the focus
