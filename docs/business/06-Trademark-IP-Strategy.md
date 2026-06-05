# MindHause — Trademark & IP Strategy

## 1. Scope

What needs protecting, in priority order:
1. **The product name** (MindHause, plus reasonable backups)
2. **The logo / wordmark** (once designed — currently using default Godot icon)
3. **The 3D content / scene compositions** (copyright by default; licensed assets handled per their terms)
4. **The source code** (copyright by default; private repo)
5. **Tagline** ("Your tasks live somewhere" — secondary trademark consideration)

This doc covers trademark first (the most actionable now), then briefly copyright/trade dress/open-source posture.

---

## 2. Name analysis — "MindHause"

**Spelling**: deliberately non-standard ("Hause" not "House") — borrows German *Haus* phonetically. Stylistic choice. **Search and protect both spellings.**

### 2.1 Distinctiveness assessment

On the Abercrombie spectrum:
- **Generic** (least protectable): "TaskApp"
- **Descriptive**: "MemoryPalace" — actively used in the technique's name; likely refused as merely descriptive
- **Suggestive** (good — protectable + meaningful): "MindHause" — evokes mental space + Bauhaus modernism + German precision
- **Arbitrary / Fanciful** (most protectable): "Lyra", "Halcyon"

**MindHause sits in the suggestive band** — strong enough to register, meaningful enough to market. Acceptable.

### 2.2 Clearance search — do this BEFORE filing

Required searches per jurisdiction:
1. **Australia** (IP Australia, ATMOSS database)
2. **United States** (USPTO TESS / Trademark Electronic Search System)
3. **EU** (EUIPO eSearch+)
4. **United Kingdom** (IPO trade mark search)
5. **Common law / web search**: Google "MindHause" + "Mind Hause" + "MindHouse" (the more-likely-collisioned spelling)
6. **App store searches**: Apple App Store + Google Play for both spellings
7. **Domain availability**: mindhause.com, .app, .ai, .io, mindhouse.* as defensive considerations

**Output**: a clearance memo listing any close marks (same class, same channel of trade), with a go / consider-rebrand / hard-no recommendation.

[FILL: actual clearance status. If hits, list each + similarity analysis.]

### 2.3 Filing classes

For a 3D mobile productivity app with potential adjacent content:

| Class | Nice Class | Covers | Filing priority |
|---|---|---|---|
| **Class 9** | Downloadable software (mobile applications) | The Flutter+Godot app itself | **HIGH — file first** |
| **Class 41** | Education / entertainment services, gaming software | The 3D / gamified experience angle (cat, monsters, themes) | **MEDIUM — file second, broadens defence** |
| **Class 42** | SaaS / software design + development services | Future-proofing for any cloud-optional layer (Class 42 has been broadened to include downloadable SaaS in some jurisdictions) | **LOW — file if budget** |

**Recommended filing sequence**:
1. Australia (home jurisdiction, lower fees) — Class 9, then Class 41 — establishes priority date
2. US (largest market) — Class 9 + 41 via Madrid Protocol within 6 months of AU filing (uses AU priority date)
3. UK + EU — Madrid Protocol designation in the same filing
4. Defer other jurisdictions until traction warrants

### 2.4 Cost estimate (rough, USD-equivalent)

| Step | Estimated cost |
|---|---|
| AU filing (Class 9) | ~AUD $250-330 per class via TM Headstart, +legal review if not DIY |
| AU filing (Class 41) | ~AUD $250-330 |
| US filing (Class 9 + 41 via Madrid) | ~$700-1,200 (Madrid fees + USPTO fees) |
| UK + EU designation via Madrid | ~$600-1,000 combined |
| Solicitor review (recommended for at least the US filing) | $500-2,000 |
| **Total to defensible position across AU/US/UK/EU** | ~$3,000-5,500 |

[FILL: actual budget allocation from raise.]

---

## 3. Backup name candidates (if MindHause is refused or pre-registered)

In order of preference:

| Name | Notes |
|---|---|
| **Loci** | The Latin term for the memory palace technique. Short. Memorable. Trademark risk: short common-word marks are notoriously difficult to defend; likely existing registrations in adjacent classes. |
| **Halcyon Rooms** | Evokes peaceful + ancient. Compound is more defensible. |
| **PalaceMind** | Reverses MindHause. Trademark risk: likely-existing registration; pivot only if needed. |
| **Mneme** | Greek for memory. Very short — same defensibility issue as Loci. |
| **Atrium** | Suggests entry to a space. Probably contested heavily. |
| **Vestibule** | More distinctive than Atrium. Memorable. Unusual. |
| **Domus** | Latin for house. Defensible. Slight risk of "domu" + tech blend confusion. |

**Recommended search order**: MindHause → Loci → Halcyon Rooms → Vestibule.

[FILL: founder preferences + which names survive the clearance search.]

---

## 4. Tagline / slogan trademark

Slogans CAN be trademarked but the bar is high (must function as a source identifier, not merely descriptive).

**Slogan candidates worth considering**:
- "Your tasks live somewhere." — strong, novel; possible candidate
- "Walk through your to-do list." — descriptive, likely refused
- "Not another list app." — comparative, problematic

[FILL: choose one tagline; assess separately after primary name is filed.]

---

## 5. Logo & wordmark

**Status**: Not yet designed. Current placeholder is Godot's default icon.

**Plan**:
- Design v1 logo+wordmark (use Cinzel font from the existing asset library as a typography anchor; Greco-Roman tie-in to default theme)
- Once final: file as a **figurative trademark** in the same classes as the wordmark (Class 9 + 41)
- Establish brand guidelines: primary mark, secondary mark, mono variants, clear space, minimum size

[FILL: target design completion date; designer hire.]

---

## 6. Copyright (default protection)

In most jurisdictions (AU, US, UK, EU under Berne Convention), copyright vests automatically on creation. No filing required.

**MindHause copyright coverage** (automatic):
- All source code (Flutter, Dart, GDScript)
- All scene compositions in Godot (.tscn files, scene hierarchies)
- All original artwork (once produced — currently mostly placeholder)
- All written content (docs, marketing copy, in-app text)

**Important to do**:
- **Copyright notices** in source files: `/* Copyright © 2026 [FILL legal entity]. All rights reserved. */`
- **README licence statement** clarifying the source is not open-source (it's source-available at most — see § 8)
- **EULA** in the app that grants users a licence to use, not ownership

---

## 7. Third-party asset licensing — what we use

| Asset source | Licence | Attribution required? | Commercial use? |
|---|---|---|---|
| Poly Haven (materials, plants) | CC0 | No (recommended) | Yes |
| AmbientCG (materials) | CC0 | No | Yes |
| Quaternius (Fantasy Props, Stylized Nature, Sushi, Sci-Fi Essentials) | CC0 | No (appreciated) | Yes |
| Kenney (Furniture Kit) | CC0 | No | Yes |
| Sonniss GDC Bundle | Sonniss Unlimited User Licence | No attribution required; no resale of raw files | Yes |
| Cinzel + Lora fonts | SIL Open Font Licence (OFL) | Yes (in OFL.txt distributed with the app) | Yes |
| Godot shaders (Ultimate Toon, Sky, Water with Caustics, Fog, Stained Glass, Candle, Parchment) | CC0 or MIT (per shader; documented in `tracking.md`) | Per-shader (MIT requires) | Yes |

**Action items**:
- Include OFL.txt for Cinzel/Lora in app bundle and in store-page licence info
- Include MIT licence notices for the MIT shaders in an in-app credits screen
- Include a "Credits & Licences" section in the app settings (also a trust signal)

[FILL: explicit credits-screen draft and which assets need attribution display in the in-app credits.]

---

## 8. Source code disclosure posture

The MindHause source code is **private (not open source)**. Rationale:
- The engine + content + system together is a defensible product; releasing source would invite trivial reskinning
- Specific algorithms (cat brain, monster evolution, theme management) represent meaningful R&D
- A private repo doesn't preclude future selective open-sourcing of components

**Posture for the future**:
- Some components (e.g. the `themed_geometry` group convention, the `DatabaseBridge` pattern, the per-room cinematic camera unified script) could be open-sourced as small contributions to the Godot community without affecting product defensibility
- Full source release is not currently planned and not promised

**Public commitments we DO make**:
- Privacy policy is public and human-readable
- Data export is always available to the user (their data, their device, their right to take it elsewhere)
- Asset attributions are public
- No telemetry / no analytics SDKs — verifiable claim

---

## 9. DecisionLens IP relationship

DecisionLens (`github.com/mogster-sys/decision-flow-vision`) is a separate product under the same ownership. The integration described in `docs/integration/decisionlens_integration.md` treats DecisionLens as a **module embedded in MindHause** via shared data + a themed UI surface.

**IP implications**:
- Both apps under common ownership simplifies inter-app licensing (no cross-licence needed; both are the same legal entity's work)
- Trademark filings: DecisionLens has its own separate marks strategy (see DecisionLens dossier `06-Trademark-IP-Strategy.md`). MindHause's marks do not need to claim DecisionLens.
- If MindHause is acquired, DecisionLens travels (as either co-acquisition or separate) — defining ownership clearly now via a holding entity is sensible

[FILL: confirm legal entity structure — single founder sole trader, Pty Ltd, etc. — and that both apps are clearly owned under it.]

---

## 10. Defensive monitoring

After registration, set up:
- **Trademark watch service** (most IP firms offer this for ~$200-500/year per jurisdiction) — catches confusingly similar marks filed by others
- **App store monitoring** — periodic searches for similar app names / paradigms (manual quarterly check is sufficient)
- **Domain watch** — defensive registration of mindhouse.* if budget allows; monitoring of name-collision domains

---

## 11. What we are not protecting

Honest scope:
- The **Method of Loci** itself — it's a 2,000-year-old public-domain technique
- The general idea of "spatial productivity app" — concepts aren't trademarkable
- The **8-theme catalogue** at the genre level (Greco-Roman, Victorian, etc.) — these are descriptive cultural categories
- Specific layouts of standard rooms (a library has bookshelves; we don't claim novelty there)

Our protectable IP is the **specific assembled product**: the name MindHause, the logo (once designed), the source code, the specific scene compositions, the cat behaviour algorithms, the monster evolution system, the integrated playable artefact.
