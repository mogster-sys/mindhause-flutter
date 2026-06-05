# MindHause — Risk Assessment

## 1. Top 12 risks, ranked

Ranked by **likelihood × impact** to existence/trajectory of the product. Each has a current mitigation and an early-warning signal we'll monitor for.

---

### Risk 1 — App store discoverability for a novel paradigm
**Likelihood**: High. **Impact**: High. **Score: 9/10.**

Nobody types "memory palace organiser" into the App Store search. Novel paradigm = no organic search demand. Compounds with: $5-8 one-time-purchase ceiling on paid CAC.

**Mitigation**:
- Lean entirely on **content + community marketing** (cornerstone articles, ADHD podcasts, founder story, organic Reddit presence)
- ASO targeting adjacent terms ("ADHD productivity app", "no subscription task app", "Notion alternative") even though they're not literal descriptors
- The pitch video as the primary creative — visual paradigm explained in 5 seconds beats any text description

**Early-warning signal**: organic downloads <50/day at T+30 → marketing pivot needed.

---

### Risk 2 — ADHD audience conversion hypothesis fails
**Likelihood**: Medium. **Impact**: Very High. **Score: 9/10.**

We've **hypothesised** ADHD audiences convert above industry average for productivity apps. If they don't, the niche-first strategy collapses and the business case requires broader appeal.

**Mitigation**:
- Validate cheaply via beta: track free→paid conversion in the ADHD-recruited cohort vs general beta
- Have a "broader appeal" pivot ready: cosy-game crossover positioning, productivity-refugee general positioning, with screenshots and copy adapted
- The product works for both audiences; only the marketing emphasis changes

**Early-warning signal**: beta paid-conversion rate <3% within ADHD-specific recruitment cohort.

---

### Risk 3 — Founder bandwidth (solo team)
**Likelihood**: High (chronic). **Impact**: High. **Score: 9/10.**

Solo founder. Engineering, design, content, business, asset acquisition, store ops — all on one person. Burnout risk is real and historically the #1 killer of indie apps.

**Mitigation**:
- **Contractor strategy** for clearly-scoped one-off work (Blender hero pieces, audio production if Suno-only doesn't suffice, app icon design)
- **No premature hires** that add management overhead without proportional capability gain
- Discipline on scope: roadmap explicitly gates phases, doesn't run them concurrently
- Honest energy budgeting; sustainable cadence over heroic sprints

**Early-warning signal**: missed milestones for 2+ consecutive months without external blocker; founder reports burnout signals.

---

### Risk 4 — Apple or Google bundles a similar product into the OS
**Likelihood**: Medium-Low (Apple Reminders is the closest threat, currently flat-list). **Impact**: Very High. **Score: 7/10.**

If a major OS vendor builds a spatial productivity app at OS-level, it ships free and pre-installed.

**Mitigation**:
- MindHause's depth (8 themes, cat AI, monster system, DecisionLens integration, ADHD-specific affordances) is unlikely to be matched by an OS bundle
- Privacy/no-cloud stance is structurally harder for an OS vendor that already has accounts and cloud infrastructure
- Cross-platform parity (Android + iOS) hedges any single-platform vendor move

**Early-warning signal**: WWDC / Google I/O announcement of spatial productivity surface → reassess immediately.

---

### Risk 5 — 3D engine + Flutter↔Godot embedding adds complexity competitors don't carry
**Likelihood**: High (3D is harder than lists; embedding is real engineering). **Impact**: Medium. **Score: 7/10.**

Two related sub-risks:

**(a) 3D rendering quality issues**: Godot integration, scene composition bugs, per-device performance variance — many surfaces that flat-list competitors don't have. A small 3D glitch is more visible than a list-app's same-severity issue.

**(b) Flutter↔Godot embedding sharp edges**: Evaluated 2026-05-27. Embedding is production-viable, NOT foundational:
- **Android**: `flutter_godot` package or `FlutDot` — PlatformView with two-way comms. Known issue: GodotView occasionally ignores Flutter layout constraints (forum-documented, fixable).
- **iOS**: `SwiftGodotKit` (via custom Flutter PlatformView wrapper) — Christian Selig (Apollo dev) shipped a working integration May 2025. ~30MB binary cost. **No iOS Simulator support — device-only testing.**
- **Two-way comms**: signal-based, modelled on iOS NotificationCenter
- **Underlying**: `libGodot` makes Godot embeddable as a library, not just a standalone app

**Mitigation**:
- **Organiser mode is a complete alternative** — if 3D fails or feels glitchy, the user can flip to the planner and the app remains useful
- Per-device performance budgets enforced (60fps mid-range, 30fps low-end target)
- Reduced-motion option for users who don't want camera movement
- Heavy device testing matrix pre-submission
- Build the embedding prototype EARLY in Phase 1 (not late) so any sharp edge surfaces before depth of integration accumulates
- Budget ~2-3 weeks of focused engineering for the embedding work; treat the iOS Simulator gap as a real testing constraint (device-only CI required)

**Early-warning signal**: prototype embedding shows uncategorisable crashes; OR beta crash rate >1% per session in palace mode; OR >10% of reviews mention performance/stutter.

---

### Risk 6 — Subscription-fatigue thesis doesn't pay off
**Likelihood**: Medium. **Impact**: Medium. **Score: 6/10.**

We've bet that "no subscription" is a meaningful purchasing factor. If it's actually neutral or slightly negative (users uncertain about ongoing support without recurring revenue), the positioning weakens.

**Mitigation**:
- Test the messaging in beta + early reviews
- The position is layered: privacy + one-time + ADHD-fit; even if one pillar is weak, the others hold
- Pricing model is reversible: theme packs as IAPs can become an ongoing revenue stream that mimics subscription cadence without subscription friction

**Early-warning signal**: review/email feedback explicitly asking for subscription OR conversion improvements from positioning A/B tests on the website.

---

### Risk 7 — Asset pipeline costs balloon (especially custom 3D)
**Likelihood**: Medium. **Impact**: Medium. **Score: 5/10.**

Custom Blender hero pieces (clepsydra, astronomical clock, cuckoo, incense, pillar, ionic column, bust) could each take 5-15 hours. If a contractor doesn't deliver on time/budget or quality slips, theme pack ship dates slide.

**Mitigation**:
- **Documented asset acquisition pipeline** + **Pixel3D-style image-to-3D tools** for some pieces (TencentARC Pixel3D evaluated, may be sufficient for some hero pieces)
- Theme packs can ship with a subset of hero pieces, with stretch items in future updates — no theme pack blocks on a single asset
- Free-asset substitutes are documented per shopping-list item in `docs/asset_recon_2026-05-10/`

**Early-warning signal**: contractor missed deadline OR custom piece taking >2× estimate.

---

### Risk 8 — Privacy positioning becomes obsolete (regulatory or market shifts)
**Likelihood**: Low. **Impact**: High if it happens. **Score: 5/10.**

Privacy-as-moat works only if it remains differentiating. If regulation forces all apps to match our posture, our edge erodes. (This is a "good problem" for users but a moat-removal for us.)

**Mitigation**:
- The positioning has multiple legs (privacy + spatial + no-sub + ADHD-fit). Privacy is one of four.
- If everyone goes privacy-first, our **product depth** (cat, monsters, themes, spatial paradigm) still differentiates
- Stay informed on privacy regulation; be early on any future strengthening (e.g. EU AI Act extensions)

**Early-warning signal**: major competitor publicly drops cloud / accounts requirement.

---

### Risk 9 — DecisionLens integration distracts from core MindHause v1
**Likelihood**: Medium (founder owns both products). **Impact**: Medium. **Score: 5/10.**

DecisionLens integration is exciting and the architecture is interesting. Risk: founder spends cycles there instead of shipping MindHause v1.

**Mitigation**:
- Roadmap explicitly phases DecisionLens integration into Phase 4 (post-launch, post-Phase 2 iteration)
- Until v1 ships, DecisionLens integration is **design only** (the doc exists; no code written)
- Discipline: no integration code until MindHause v1 is live and stable

**Early-warning signal**: founder catches self writing integration code before v1 ships → stop, refocus.

---

### Risk 10 — Trademark conflict on "MindHause"
**Likelihood**: Medium (similar marks may exist in adjacent classes). **Impact**: Medium. **Score: 4/10.**

If clearance reveals a conflicting mark and we have to rebrand pre-launch, cost is significant (already-produced creative needs rework).

**Mitigation**:
- **Clearance search before any final asset production** that locks the name (icon, store creative, website)
- **Backup name candidates ranked** in `06-Trademark-IP-Strategy.md`
- If conflict found, rebrand cost is bounded (~1-2 weeks of creative rework + new trademark filing)

**Early-warning signal**: clearance search finds same-class same-channel hit.

---

### Risk 11 — Performance on low-end devices is unacceptable
**Likelihood**: Medium. **Impact**: Medium. **Score: 4/10.**

3D mobile rendering on a 2019-vintage low-end Android device may not hit 30fps even with the painterly stylisation we've chosen. If we have to drop low-end support, we shrink TAM.

**Mitigation**:
- Documented performance budget; Godot Mobile profile (already in use) is optimised for this
- LOD strategy + texture downscaling per device tier (planned but not built; revisit if needed)
- **Organiser mode is the universal fallback** — even on devices that can't run the palace, the planner works

**Early-warning signal**: device testing on 2019 Android shows <20fps in palace mode.

---

### Risk 12 — Founder personal circumstance change (illness, family, etc.)
**Likelihood**: Low (any given month) but compounds over multi-year build. **Impact**: Very High. **Score: 4/10.**

Solo founder with multi-year roadmap is exposed to personal life events that could pause or end the project.

**Mitigation**:
- **Documented everything** — this dossier, the PRD, the architecture, the asset pipeline, the integration plans — so the project is potentially transferable or pauseable without total loss
- Asset acquisition + recon documented to a degree that a future contractor or partner could pick up the work
- Source code in a private but maintained repo
- IP held in a clear legal entity for transferability

**Early-warning signal**: structural; no automatic warning. Mitigation is preparedness, not detection.

---

## 2. Risks NOT on the top 12 (intentionally lower priority)

These exist but are sufficiently low-probability or low-impact to not warrant active mitigation effort:

- **Engine choice (Godot) becomes unmaintained** — extremely unlikely for Godot 4.x in the relevant timeframe; would require multi-year deprecation
- **Flutter framework being deprecated by Google** — possible but slow; rewrite would take months but isn't catastrophic
- **A nation-state actor specifically targets MindHause users** — not in threat model; would require dramatic threat-model reassessment
- **Catastrophic SQLite corruption losing all user data** — well-tested edge case; mitigations standard (WAL mode, backups via export)

---

## 3. Risk monitoring cadence

- **Monthly**: review top 5 risks; check early-warning signals
- **Quarterly**: re-rank all 12; add new risks; retire resolved risks
- **Major event**: ad-hoc reassessment (a competitor move, a regulation change, a beta result)

---

## 4. Risk-aware decision principles

Operating principles that come from the risk profile:

1. **Bias to organic over paid** until paid CAC is validated (risks 1 + 6)
2. **Ship v1 before adjacent layers** (risk 9)
3. **Keep organiser mode functional** as the universal fallback (risks 5 + 11)
4. **Document everything** as bus-factor insurance (risk 12)
5. **Niche-first marketing** to validate quickest, broaden if signal supports it (risk 2)
6. **No premature hires** that add overhead before validation (risk 3)
7. **No premature scale spending** before unit economics prove out (risks 1 + 6)
8. **Privacy/no-sub as principle, not flag** — never quietly drop it under pressure (risk 8)

---

## 5. Investor honesty

This list is genuine — risks ranked by what could actually kill or stall the product. The honest framing for an investor:

> The biggest risks are (a) finding the audience, (b) confirming the conversion hypothesis, and (c) founder bandwidth. None are existential if the gates fire correctly and we update. If two of the top three risks fire negative, the business case requires a strategic reset — likely toward narrower audience focus, lower marketing spend, slower roadmap. That's a survivable contraction, not collapse. We've architected the product to fail gracefully (organiser mode standalone, modular features, no infrastructure to keep running) so a slow-build outcome is possible even if the venture-scale outcome isn't.

A reasonable seed investor should hear this and update probability estimates, not reflexively pass.
