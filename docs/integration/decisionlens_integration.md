# DecisionLens × MindHause — Integration Design (Portal Model)

**Status:** Design only. No code written.
**Last revised:** 2026-05-27 — collapsed from the earlier over-architected version to the user-corrected **portal model**.

---

## 1. Vision

Two discrete apps that compose well.

- **MindHause** stays MindHause — the task palace. Untouched in architecture, scope, or stack. Its 10 rooms, cat, theme system, monster system are unchanged.
- **DecisionLens** stays DecisionLens — a Flutter app implementing 5 decision frameworks (SWOT, Decision Matrix, Eisenhower, NASA TLX, McKenna 9-Square Support Circle). Works perfectly well on its own.

The integration is a **portal**: a wall surface in a MindHause room that displays a decision tool. The portal is just a screen-within-a-screen — architecturally a 3D surface, content-wise whatever's easiest to render in that surface.

That's it. Days of work, not weeks.

---

## 2. The portal — what it actually is

A portal is a `MeshInstance3D` (or `SubViewportContainer` mounted in 3D) embedded into a room's wall, framed/styled per the room's theme:

- In the **Library**, the portal is a Victorian-style polished wood frame around the surface, with a felt mat below
- In the **Study**, the portal is a chalkboard with brass trim
- In the **Greco rooms**, the portal is a polished marble plaque with bronze edging
- In the **Sci-Fi**, the portal is a glass holo-panel with cyan trim
- Etc per theme

Inside the portal, the content is one of two implementations (your call, after the proof-of-concept tells us which feels right):

| Option | What it is | When it fits |
|---|---|---|
| **A. Godot-native UI** | The decision tool reimplemented as Godot `Control` nodes on a `SubViewport`. Methods spec is source of truth; this is just another expression of it. | Simpler. No cross-engine work. Style matches the room natively. Better path if the decision tool's UI is simple (NASA TLX with pairwise comparisons, Eisenhower drag-drop, SWOT typed input). |
| **B. Embedded Flutter content** | Render the existing DecisionLens screen into a texture, display on the portal surface. | More work (Flutter rendering to Godot texture is non-trivial). Worth it only if a specific tool's existing Flutter UI is too rich to want to rebuild (less likely once we look at each tool). |

**My recommendation**: pick A (Godot-native) by default. The decision methods are simple. Reimplementing them is hours per tool, not days. The portal becomes truly room-native rather than a flat Flutter UI plonked into a 3D scene.

---

## 3. Method specs are the source of truth

The reference files that matter (from the DecisionLens dossier, `business-package/reference-materials/`):

| Method | Source spec | Mechanical complexity |
|---|---|---|
| **SWOT** | Standard 4-quadrant analysis | Text fields × 4 quadrants. Trivial. |
| **Decision Matrix** | Weighted criteria × options scoring | Rows × columns × weights. Tabular UI. |
| **Eisenhower Matrix** | Urgent × Important quadrants | 2×2 with movable task cards. |
| **NASA TLX** | 6-dimension rating + pairwise comparisons | Per `repo-VISION-NOTES.md`: the **pairwise comparison** flow (15 paired choices) is the UX upgrade to ship, NOT the 6 sliders. Build the improved version. |
| **McKenna 9-Square (Support Circle)** | `repo-mckenna-problem-solving-technique.md` | 9 photo placements + 4-phase guided flow (reframing questions → 9-square → expert perspective → future visualisation). The contemplative one. Garden-friendly. |

Source of truth lives in DecisionLens repo + reference docs. The MindHause-side implementation is "another expression of the same method." No data duplication required — neither app needs to know about the other's internals; the portal renders the method, the user uses it.

---

## 4. Tool → room mapping

Same affinity as the earlier design — the rooms are good thinking-contexts for the tools:

| Room | Tool | Why |
|---|---|---|
| **Study** | Eisenhower Matrix | Work tasks, urgent×important sorting |
| **Library** | SWOT | Notes, ideas, analysis |
| **Workshop** | NASA TLX | DIY, effort, cognitive load — pairwise comparison flow |
| **Treasury** | Decision Matrix | Weighing, scoring, valuation |
| **Garden** | McKenna 9-Square Support Circle | Contemplation; 9 paving spots around the fountain; photos placed by the user |

The cat bridges between rooms — when you've finished a SWOT in the Library, the cat may walk toward the Garden door, suggesting a McKenna pass on the same decision. (This is the existing cat-AI pattern extended; no new architecture.)

---

## 5. Build sequence

### Step 1 — Portal scene prototype (Godot only, ~1 day)
- A `Portal.tscn` scene: 3D frame + `SubViewportContainer` + the room-theme material override system
- Drop into Library as proof-of-concept (Greco-Roman frame, marble plaque style)
- Render a placeholder Godot UI inside the SubViewport — verify input (raycast → mouse events → SubViewport receives clicks) and visibility

**Definition of done**: a wall surface in the Library shows an interactive Godot UI you can click on while walking around the room.

### Step 2 — First tool implementation (Godot UI, ~1-2 days)
- Pick the smallest tool: probably **SWOT** (4 text fields in a 2×2; bog-standard Control nodes)
- OR **NASA TLX pairwise comparison** if you want to validate the improved UX flow
- Whichever, build it natively as Godot Control nodes in a SubViewport
- Wire input + data storage (where data lives is open — could be a small SQLite table inside MindHause; could be a shared file the user exports/imports from DecisionLens; could be both writing to the same SQLite if you want them to share decisions)

**Definition of done**: filling out the SWOT in the Library portal persists across scene reloads; the data is somewhere readable by both apps if/when the user wants that.

### Step 3 — Theme variants of the portal frame (~0.5 day per theme)
- Once the base portal works in the Library, kit the frame for the other rooms that house a tool (Study, Workshop, Treasury, Garden)
- Same SubViewport + UI inside; just the frame/material changes per room
- Garden's McKenna 9-square is the only one with substantially different geometry (9 walkable paving stones around the fountain, not a wall portal)

### Step 4 — Remaining tools (~1-2 days each)
- Implement the other 4 tools as Godot Control UIs
- Each room gets its tool

### Step 5 — Cat behaviour extension (~1 day)
- Cat AI gains "suggest portal interaction" — when the user enters a room with an active decision, the cat walks toward the portal
- Cat gains "suggest cross-room" — after a SWOT, the cat may walk toward the Garden door suggesting a McKenna pass

**Total realistic estimate: ~7-12 days of focused work** for the full portal integration across all 5 tools — substantially less than the earlier over-architected design. Step 1+2 alone is the proof point in 2-3 days.

---

## 6. What's explicitly OUT of scope

To stay honest about the simpler model:

- **Data unification between DecisionLens (Hive) and MindHause (SQLite)** — DEFERRED. Each app stores its decisions in its own format. If they need to share, do it via an explicit export/import or a small bridge — don't redesign DecisionLens's storage to match MindHause.
- **Real-time bi-directional sync** — overkill. If a user updates a decision in DecisionLens, they'll see it in MindHause next time they open the Library; that's good enough.
- **The `DecisionSurface` base class abstraction** — over-engineering for 5 tools. Just write 5 scenes.
- **RAG ambient lighting** — interesting feature but doesn't belong in this integration. Either build it into MindHause core (applies to tasks too) or skip it. Not part of this scope.
- **Reimplementing the DecisionLens UX revamp ("person-first" landing)** — that's DecisionLens's own work, not MindHause's. The portal just renders the tool; the wider UX problem is for DecisionLens to solve in its own app.

---

## 7. Open decisions

1. **Where does decision data live for the MindHause-side portals?** Three options: (a) MindHause's own SQLite with a `decisions` table; (b) read from DecisionLens's Hive store (cross-app file access, possible on Android, harder on iOS); (c) shared SQLite file both apps point at. Pick after Step 1 prototype tells us what the developer ergonomics look like.

2. **Which tool to build first** for Step 2? SWOT is the simplest mechanically (4 text fields). NASA TLX with the pairwise flow validates the improved UX from VISION-NOTES. McKenna 9-square is the most novel (walkable Garden geometry). The user's call.

3. **Cottage theme room placement** — irrelevant to integration but noted in parallel work.

---

## 8. Where this lives in the broader roadmap

The integration sits in **MindHause's Phase 4** (per `docs/business/10-Product-Roadmap.md`). It happens AFTER v1 launches, not before. Until v1 ships:
- DecisionLens stays standalone
- MindHause stays standalone
- This integration design sits ready

Both apps benefit from being usable on their own before they compose.
