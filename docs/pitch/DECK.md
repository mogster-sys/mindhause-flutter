# MindHause — VC Pitch Deck (draft)

> Draft slide content for a VC raise. Format: deck + 30–90s embedded video.
> Voice per PROJECT_BRIEF: warm but sharp, show-don't-tell, house metaphor is the hook.
>
> **🔴 YOU MUST SUPPLY** (I can't invent these): market sizing numbers, team bios, financials/projections, the raise amount + use of funds, any traction metrics. Placeholders marked `[FILL]`.

---

## Slide 1 — Title

# MindHause
### Turn your mind into a place you can walk through.

*A first-person memory palace productivity app.*

[FILL: your name / title, contact, date]

*(Visual: a single hero still from the kitted Library — warm marble, golden light, the cat on the reading table.)*

---

## Slide 2 — The Problem

### Every task app is the same flat list. That's why you've quit all of them.

- Todoist, Notion, Things, Apple Reminders — different paint, same infinite scroll.
- For the people who need them most — ADHD, executive-function challenges — flat lists are **actively hostile**: no novelty, no spatial anchor, nothing to make the invisible cost of avoidance *visible*.
- The result: a graveyard of abandoned productivity apps on every phone.

> "Tried every task app? They all blur together because they're all the same flat list."

---

## Slide 3 — The Insight

### Human memory is spatial. We've known this for 2,000 years.

- The **Method of Loci** — the memory palace — dates to ancient Greece. You remember things by placing them in rooms of a building you walk through.
- Memory champions still use it. It works because the brain evolved for *places*, not bullet points.
- **No productivity app has ever made this literal.** Until now.

---

## Slide 4 — The Product

### MindHause: your tasks live in a house you walk through.

- Your to-dos, notes, goals, and habits become **physical 3D objects** — scrolls, books, candles, keys — placed on shelves and desks across the rooms of a navigable home.
- The **study** holds your work. The **kitchen** holds your shopping. The **garden** holds your long-term goals. You don't scroll your life — you walk through it.
- Underneath, it's a **complete task manager**: tasks, projects, goals, habits, notes, calendar, focus timer.

---

## Slide 5 — DEMO (the moment)

### *[EMBED 60–90s VIDEO HERE]*

The continuous Library → Garden glide: warm marble scholar's library, the cat by a scroll, then out into a sunlit fountain courtyard with cypress against a golden sky.

*Speaker note: let the video breathe. Don't narrate over the whole thing. This is the "I want to be in there" moment — it does the selling.*

*(See VIDEO_SCRIPT.md for the shot breakdown.)*

---

## Slide 6 — How It Works: Objects That Live and Decay

### Tasks aren't checkboxes. They're objects with a life cycle.

Each task object has **6 visual states** that change over time:
1. **New** — glowing, fresh
2. **In progress** — steady, warm
3. **Urgent** — pulsing red
4. **Completed** — golden glow
5. **Neglected** — dusty, dim
6. **Corrupting** — dark tendrils

You feel your workload. You can *see* what you're avoiding.

---

## Slide 7 — Engagement That Serves the User

### A cat that nudges. Monsters you can defeat.

**The cat** (optional): a soft prioritisation system, not a gimmick. It walks toward urgent tasks, purrs when you complete them, hisses at decaying ones. Tamagotchi-like state reflects your productivity.

**Monster tasks** (optional, toggleable): neglected tasks decay into creatures that haunt the room. You defeat them by *completing the task* — turning procrastination into a satisfying boss fight.

> "Neglect breeds monsters. Completion defeats them."

Both fully toggleable. Gamification as a tool, never manipulation.

---

## Slide 8 — Two Modes, One Tap

### Palace for engagement. Planner for speed.

- **Palace Mode** — walk your house in first-person 3D (Godot engine)
- **Organiser Mode** — flip to a fast, conventional list/calendar view (Flutter)

Same data, two views. The palace makes you *want* to engage; the planner lets you bulk-edit at speed. One tap between them.

---

## Slide 9 — Who It's For

### Built for brains that don't work in straight lines.

- **Primary:** People with ADHD / executive-function challenges — [FILL: cite ADHD adult prevalence ~5–6% globally; verify your source]. Vastly underserved by flat-list apps.
- **Secondary:** Serial task-app quitters. Gamification-curious productivity users. The "I love the idea of Notion but can't stick with it" crowd.

[FILL: TAM/SAM/SOM. Anchor points to research: global productivity-software market size, ADHD-app niche, mobile game-adjacent productivity. Don't assert numbers you haven't sourced.]

---

## Slide 10 — Why We Win

| | Flat-list apps | MindHause |
|---|---|---|
| Structure | Infinite scroll | Spatial rooms + objects |
| Engagement | Notifications | A world you want to enter |
| Avoidance | Invisible | Visible (decay → monsters) |
| Privacy | Cloud accounts | 100% on-device, no accounts |
| Pricing | Subscriptions | One-time unlock, no subs ever |

**Defensibility:** the spatial engine + content system (10 rooms × 8 themes × object/state system) is real production work that a flat-list competitor can't bolt on. Privacy-first + no-subscription is a positioning a VC-funded incumbent structurally won't copy.

---

## Slide 11 — Business Model

### Free to try. One-time unlock. No subscription, ever.

- **Free tier:** Foyer + 2 rooms, basic cat, default theme
- **One-time unlock (~$5–8):** full house (10 rooms), all object types, full cat, focus mode
- **Theme packs (~$1–3 each):** 8 themes as optional IAP, or a discounted bundle
- **Never:** subscriptions, ads, data selling

[FILL: unit economics — what conversion % free→paid do you model? ARPU? The "no subscription" stance is a strong differentiator but VCs will probe LTV. Have an answer for "why not subscription."]

---

## Slide 12 — Privacy as Moat

### Your mind palace is yours alone.

- Zero data collection. No analytics. No accounts. No cloud. Local SQLite only.
- For an audience storing their entire mental load, **trust is the product.**
- This isn't a footnote — for the ADHD/privacy-conscious user it's a primary reason to choose us, and a wedge incumbents (whose models depend on data + engagement farming) can't follow.

---

## Slide 13 — Status & Roadmap

### Engine is real. ~60–70% structurally complete.

**Done:**
- 10 rooms built (geometry, doors, lighting, navigation)
- Cat companion system (6 modules), monster evolution system
- 8 themes defined; first theme (Greco-Roman) at production-grade — *that's the video you just saw*
- Player movement, transitions, footsteps, database bridge

**Roadmap:** [FILL dates]
1. Finish Greco-Roman vertical slice → store-ready
2. Flutter ↔ Godot embedding + SQLite integration
3. Remaining 7 theme skins (engine done, content per theme)
4. Beta → launch

*(Visual: the 8 theme hero images as a roadmap strip.)*

---

## Slide 14 — Team

[FILL: founder bio(s). VCs invest in people. Why are YOU the person to build this — relevant background, why this problem, prior shipping experience. If solo, address execution capacity directly.]

---

## Slide 15 — The Ask

### [FILL: raising $X to achieve Y by Z]

[FILL: use of funds breakdown — e.g. % to finish engine/themes, % to launch/marketing, % runway months. What milestone does this round get you to? What's the next round's story?]

---

## Appendix slides (have ready, don't present unless asked)

- Technical architecture (Flutter + Godot 4 + SQLite, on-device)
- Full 8-theme gallery
- Competitive deep-dive
- The Method-of-Loci research basis
- Asset/production pipeline (shows operational maturity — the recon + acquisition system)
