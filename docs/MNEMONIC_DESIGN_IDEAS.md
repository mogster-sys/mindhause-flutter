# Mnemonic Systems → MindHause Design Ideas

> How the five classic mnemonic systems (Method of Loci, Major, Dominic, PAO,
> 12 Categories) could inform MindHause's features and positioning.

---

## The Big Insight

MindHause is ALREADY a Method of Loci app — but it doesn't know it yet.
Right now it's positioned as "task planner in a 3D house." That's the MVP.
But the mnemonic framework suggests a much deeper product:

**MindHause isn't just a task app that uses a palace metaphor.
It's a universal memory palace that happens to start with tasks.**

The 10 rooms are loci. The task objects are memory images. The cat is a
retrieval cue. The themes are mood contexts. Everything already maps.

---

## Feature Ideas by System

### 1. Method of Loci → Already Built (Enhance It)

**What we have:** 10 rooms, placement surfaces, task objects at fixed locations.

**What we could add:**

- **Loci awareness:** Let users consciously place objects at specific spots
  (not just "assign to room"). The desk vs the shelf vs the wall hook matters
  for recall. Surface choice = loci precision.

- **Mental walk mode:** A guided first-person walkthrough that visits every
  object in a fixed route order (door → clockwise around room). This is
  literally the Method of Loci retrieval step. Could be a "daily review"
  feature: the cat leads you on a morning walk through your tasks.

- **Route consistency:** The room visit order should be predictable and stable.
  Users who always enter rooms in the same order (foyer → study → library...)
  build stronger spatial associations. The map/floor plan reinforces this.

- **Placement memory feedback:** "You placed this task on the study desk 3
  days ago" — remind users WHERE things are, not just WHAT they are. The
  spatial cue is the recall trigger.

### 2. Major System / Dominic / PAO → "Study Mode" or "Learn Mode"

These number-encoding systems don't map to tasks, but they map to a potential
**learning mode** where MindHause becomes a study tool, not just a planner.

**Concept: "Study Palace"**

- Users create custom palaces (or sub-rooms) for learning material
- Each room = a topic/chapter
- Each surface/locus = a fact, concept, or card
- Objects aren't tasks but **memory cards** with a front (the vivid image
  the user creates) and back (the actual fact)
- Spaced repetition built in: the palace dims/decays objects you haven't
  reviewed, brightens ones you recalled successfully
- The cat leads you to items due for review (just like it leads to overdue
  tasks — same mechanic, different domain)

**Why this matters for the business:**
- Massively expands the audience: students, language learners, med students,
  bar exam, anyone who memorizes
- The medical study plan example shows how naturally this maps: one palace
  per subject, rooms per sub-topic, objects per fact
- Differentiation: no other memory palace app is also a real 3D walkthrough.
  Anki is flat cards. MindHause would be Anki-in-a-building.

### 3. 12 Mnemonic Categories → Room Semantics / Smart Filing

The 12 categories (People, Places, Numbers, Words, Concepts, Events, Objects,
Actions, Emotions, Senses, Time, Space) suggest that rooms could have
**semantic roles** beyond just "work" or "personal."

**Current room semantics (task-focused):**
- Study = work, Library = notes, Kitchen = household, etc.

**Enhanced room semantics (mnemonic-aware):**
- Each room could support MULTIPLE category types
- When you place an item, the room context helps encode it:
  - A **person's name** placed in the foyer (where you greet people)
  - A **number/date** placed in the treasury (where you count things)
  - A **concept** placed in the library (where you read)
  - An **event** placed in the garden (where things grow over time)

This is subtle but powerful: the room choice itself becomes a mnemonic cue.
The app could gently suggest: "This looks like a date — Treasury might help
you remember it" or "This is a person — try the Foyer."

### 4. Spaced Repetition + Palace Decay

The monster system already does something like this: neglected tasks decay
and eventually become monsters. The same mechanic works for memory:

- **Fresh items glow** (just placed, just reviewed)
- **Aging items dim** (due for review but not urgent)
- **Neglected items decay** (overdue for review — visual dust, cobwebs)
- **Forgotten items become ghosts** (failed recall — transparent, flickering)

The cat could nudge: "There's something dusty on the library shelf" = you
have a flashcard due for review.

The review itself: walk to the object, look at it, try to recall the answer
before tapping. Tap to reveal. Rate your recall (easy/hard/forgot). Standard
spaced repetition, but embodied in 3D space.

### 5. The Cat as Retrieval Guide

In mnemonic practice, the hardest part isn't encoding — it's retrieval.
The cat is perfectly positioned as a **retrieval cue system:**

- **Morning walk:** Cat leads you through rooms in a fixed order, pausing
  at each item due for attention (task or memory card)
- **Nudge toward weak items:** Cat sits on or near items you've struggled
  to recall, making them more salient
- **Purr on successful recall:** Positive reinforcement when you remember
- **Hiss at decay:** Warning that something is slipping away

---

## Positioning Shift

### Current: "Task planner in a 3D house"
Good for v1. Gets the app out the door. Clear value prop.

### Future: "Your mind palace — for everything"
Tasks, habits, notes, study material, vocabulary, dates, any knowledge.
The house is the universal container. The mnemonic systems are the encoding
methods. The spaced repetition is the retention engine.

### The Unlock
MindHause doesn't need to teach users the Major System or PAO. Those are
power-user techniques. What it DOES need to do:

1. **Make spatial placement intentional** (where you put things matters)
2. **Support visual/vivid encoding** (rich object types, customizable images)
3. **Build in retrieval practice** (daily walk, spaced review, cat nudges)
4. **Let the palace grow** (custom rooms, sub-rooms, personal loci)

The 10-room structure is the starter palace. Power users will want to build
their own wings, floors, and annexes. That's the expansion path.

---

## Immediate Low-Effort Wins (v1 Scope)

Things that could ship with the current architecture:

1. **Cat morning walk** — Cat leads you room-to-room showing today's tasks.
   (Just a scripted sequence visiting rooms with items flagged for today.)

2. **Placement matters** — Show surface name when viewing a task:
   "Study → Writing Desk → Slot 3". Reinforce the spatial association.

3. **Room entry order** — Always suggest/default to the same room visit
   sequence (matching the floor plan layout). Builds route consistency.

4. **"Where was it?" quiz** — Occasionally, when showing a task notification,
   ask "Which room is this in?" before showing it. Lightweight retrieval
   practice that strengthens the spatial memory.

5. **Marketing angle** — Position around the science: "Built on the Method of
   Loci, the same technique used by memory champions." This is true and
   compelling. Link to the research on spatial memory and hippocampal encoding.

---

## Long-Term Vision: Study Palace Mode

If MindHause ever adds a "Learn" mode alongside "Plan" mode:

- **Custom palace builder** — Users define rooms, name loci, place cards
- **Import from Anki** — Bring existing flashcard decks into the palace
- **Spaced repetition engine** — SM-2 or FSRS algorithm scheduling reviews
- **Visual encoding assistant** — AI suggests vivid images for abstract facts
- **Subject palaces** — Pre-built room layouts for common study domains
  (anatomy, law, languages, history) that users can adopt and customize
- **Group palaces** — Shared palaces for study groups (everyone walks the
  same palace, discussion on shared loci)

This would make MindHause unique in both the productivity AND edtech spaces.
No other app combines 3D spatial memory with task management AND study tools.
