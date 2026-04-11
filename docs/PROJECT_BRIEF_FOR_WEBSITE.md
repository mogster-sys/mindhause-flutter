# MindHause — Project Brief for Website Copy

## What It Is

MindHause is a **first-person 3D memory palace productivity app**. It's a full-featured task planner (tasks, projects, goals, habits, notes, calendar) wrapped inside a house you physically walk through. You place your tasks on shelves, desks, and walls as 3D objects. You walk room to room to manage your life.

**Tagline options:**
- "Turn your mind into a place you can walk through."
- "A first-person memory palace organiser."
- "Your tasks live somewhere. Walk through them."

## The Core Insight

Traditional task apps are flat lists. Human memory is spatial. The Method of Loci (memory palace technique) has been used since ancient Greece — you remember things by placing them in rooms of an imagined building. MindHause makes that literal: your tasks ARE objects in rooms.

The study holds your work tasks. The kitchen holds your shopping and meal plans. The bedroom holds your personal routines. You don't scroll through lists — you walk through your life.

## Who It's For

**Primary audience:** People with ADHD, executive function challenges, or anyone who finds traditional productivity apps overwhelming, boring, or forgettable.

**Why this audience:**
- Spatial over sequential: rooms and objects vs infinite scrolling lists
- Novelty through exploration: a 3D world is inherently more engaging than a text interface
- Gentle redirection: a cat nudges you toward overdue tasks instead of aggressive notifications
- Externalised anxiety: neglected tasks visually decay into monsters — making the invisible cost of procrastination tangible and defeatable

**Secondary audience:** Anyone who's tried every task app and bounced off them all. Gamification-curious productivity users. People who like the idea of Notion/Todoist but can't stick with it.

## How It Works

### The House
A Greco-Roman villa (default theme) with **10 rooms across 3 floors**:

**Ground Floor:**
- **Foyer** — Hub room, daily overview, quick capture
- **Study** — Work tasks, deadlines, projects
- **Library** — Notes, ideas, reading list, research
- **Kitchen** — Shopping, meals, recipes, household

**Upper Floor (via stairs):**
- **Bedroom** — Personal routines, health, sleep
- **Gymnasium** — Fitness, goals, habits
- **Treasury** — Finance, budgets, savings goals

**Basement:**
- **Cellar** — Archive, completed tasks, long-term storage
- **Workshop** — DIY, creative projects, builds
- **Garden** — Long-term goals, growth, reflection

### Task Objects
Tasks appear as **physical 3D objects** on placement surfaces (desks, shelves, pedestals, walls). 10 object types:
- Scrolls, books, candles, statues, letters, blueprints, seed/plants, post-its, jars, keys

Each has **6 visual states** that change over time:
1. **New** — glowing, fresh
2. **In progress** — steady, warm
3. **Urgent/overdue** — pulsing red
4. **Completed** — golden, satisfied glow
5. **Neglected** — dusty, dim
6. **Corrupting** — dark tendrils, pre-monster

### The Cat Companion (Optional)
An AI cat that lives in the house. It's not a gimmick — it's a **soft prioritisation system**:
- **Leads you to urgent tasks** by walking toward them, pausing, looking back
- **Purrs when you complete tasks** (positive reinforcement)
- **Hisses at monster tasks** (warning system)
- **Naps on completed work** (satisfaction feedback)
- **Has a Tamagotchi-like emotional state** that reflects your productivity
- Different breed per theme (Turkish Angora for Greco-Roman, British Shorthair for Victorian, Sphynx for Sci-Fi, etc.)

### Monster Tasks (Optional, Toggleable)
Neglected tasks don't just sit there — they **evolve into monsters**:
1. **Healthy** → 2. **Neglected** (visual decay) → 3. **Corrupting** (spreads to nearby objects) → 4. **Monster** (creature haunts the room)

You defeat monsters by **completing the task**. This makes procrastination tangible and gives completing overdue tasks a satisfying "boss fight" quality.

Sensitivity is adjustable: Gentle (weeks before monsters), Normal (days), Strict (hours). Or turn monsters off entirely.

### Two Modes
- **Palace Mode** — Walk through your house in first-person 3D (Godot engine)
- **Organiser Mode** — Flip to a traditional Flutter task manager (lists, calendar, filters, search)

Same data, two views. One tap switches between them. The palace is for engagement and spatial memory. The organiser is for speed and bulk editing.

## 8 Themes (Skins)
The entire house can be reskinned. Each theme changes walls, floors, lighting, furniture style, cat breed, ambient music, and timepieces:

1. **Greco-Roman Classic** (default) — Marble, gold, terracotta, sundials
2. **Modern Loft** — Concrete, steel, LED displays, blue accents
3. **Victorian Scholar** — Dark wood, velvet, brass, grandfather clocks
4. **Sci-Fi Minimal** — White panels, cyan neon, holographic displays
5. **Gothic Cathedral** — Stone, iron, stained glass, astronomical clocks
6. **Japanese Ryokan** — Tatami, shoji screens, incense clocks
7. **Countryside Cottage** — Timber beams, plaster, cuckoo clocks
8. **Fallout Bunker** — Corroded steel, radiation green, salvaged equipment

## Key Differentiators
- **Spatial, not sequential** — Rooms and objects, not infinite lists
- **All on-device** — No accounts, no cloud, no backend. Your data never leaves your phone. Period.
- **No subscription** — Free base app (foyer + 2 rooms). One-time purchase unlocks full house. Theme packs as optional IAP. No ads ever.
- **ADHD-designed** — Built from the ground up for brains that bounce off conventional planners
- **Gamification that serves the user** — Cat and monsters are tools for engagement, not manipulation. Both fully toggleable.
- **Real productivity app underneath** — Tasks, subtasks, projects, goals, habits, notes, calendar, focus timer, quick capture. It's a complete organiser.

## Privacy & Monetisation

### Privacy
- Zero data collection
- No analytics
- No accounts or login
- No cloud sync (local SQLite only)
- No ads
- "Your mind palace is yours alone"

### Monetisation
- **Free tier:** Foyer + 2 rooms, basic cat, default theme
- **One-time unlock:** Full house (all 10 rooms), all task object types, full cat behaviours, focus mode (~$5-8)
- **Theme packs:** IAP per theme or discounted bundle (~$1-3 each)
- **Never:** Subscriptions, ads, data selling, feature gating behind recurring payments

## Technical Architecture (For Context)
- **Flutter** for the organiser UI, data layer, and app shell
- **Godot 4.0** for the 3D palace (embedded via platform view)
- **SQLite** as the single source of truth (both Flutter and Godot read/write)
- **Platforms:** Android (primary), iOS (primary), Web (stretch), Desktop (stretch)

## Current Development Status
- ~60-70% structurally complete
- All 10 rooms built with geometry, doors, lighting, navigation
- Cat companion system coded (6 modules)
- 8 themes defined with textures and colours
- Monster evolution system coded
- Door transitions, player movement, head bob, footsteps all working
- Database bridge working (in-memory fallback until SQLite plugin integrated)
- Flutter app scaffold exists but needs Godot embedding
- Still needed: better 3D models (furniture, cat), sound effects, music, Flutter integration, UI polish, app store prep

## Tone & Voice for Website
- **Warm but sharp** — Not corporate. Not cutesy. Smart and inviting.
- **Show, don't tell** — Lead with the spatial concept. Screenshots of the palace, not feature lists.
- **Address the pain directly** — "Tried every task app? They all blur together because they're all the same flat list."
- **The house metaphor is the hook** — Every piece of copy should reinforce "your tasks live in a place"
- **Privacy as a feature, not a footnote** — This audience cares. Lead with it in the right sections.
- **ADHD-friendly without being patronising** — Don't say "built for ADHD brains" in a way that feels like a label. Say "built for people whose brains don't work in straight lines."

## Key Phrases / Copy Seeds
- "Your tasks live somewhere."
- "Walk through your to-do list."
- "A house for your thoughts."
- "Not another list app."
- "Your mind palace is yours alone."
- "The cat knows what's overdue."
- "Neglect breeds monsters. Completion defeats them."
- "Every room is a context. Every object is a task."
- "Flip between palace and planner in one tap."
- "No accounts. No cloud. No subscription. Your data stays on your device."
