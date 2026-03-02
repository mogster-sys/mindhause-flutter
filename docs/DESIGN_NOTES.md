# MindHause — Design Notes & Creative Rationale

> Working notes on *why* things are the way they are. The PRD says what; this says why and how we got there.

---

## Why a Memory Palace (and Why It Actually Works)

The method of loci is one of the oldest and most robust mnemonic techniques we have. The science is straightforward: **spatial memory is disproportionately strong in humans**. We evolved to remember *where* things are (food, shelter, danger) far more reliably than abstract sequences (lists, dates, priorities).

Most productivity apps fight this. They present flat lists and expect you to maintain a mental index. MindHause flips it: you remember where you *put* the task — on the desk in the study, pinned to the notice board in the kitchen, growing in the garden. The spatial arrangement *is* the organisation.

This isn't gamification for gamification's sake. It's leveraging how memory actually works.

### Why First-Person Matters

This was a pivotal decision. The first-person perspective is non-negotiable because:

1. **Spatial encoding requires embodiment.** Viewing a map of rooms from above doesn't trigger the same memory pathways as *walking through* them. The sense of "I am here, the task is over there" is what makes loci work.
2. **Engagement.** First-person creates presence. You're *in* the house, not looking at a diagram of it.
3. **Interaction.** Picking up objects, placing them on surfaces, walking through doors — these physical actions reinforce the memory associations.
4. **The monsters need to chase you.** That sentence alone justifies the perspective.

This is why the project is hybrid Flutter + Godot rather than pure Flutter. Flutter cannot do first-person 3D. Godot can, and it does it well on mobile.

---

## The Cat — Design Philosophy

The cat is possibly the most important design element in the game layer. Here's why it works the way it does:

### Friendly Coercion, Never Aggression

The cat exists because **people respond better to gentle, persistent nudging than to alarms and notifications**. A notification says "DO THIS NOW." A cat sitting next to a task, looking at you, says "hey... this thing exists... just so you know." One triggers anxiety. The other triggers a warm decision.

The cat is:
- **Always your friend.** Never punishing. Never angry.
- **A soft prioritiser.** It gravitates toward what matters most, but you can ignore it completely.
- **Ambient, not urgent.** The HUD handles instant information. The cat handles slow, atmospheric guidance.

### Cat Behaviour Breakdown

| Behaviour | Purpose | Feel |
|-----------|---------|------|
| Leads player to task | Prioritisation | Helpful, gentle |
| Pauses and looks back | "Are you following?" | Patient, not nagging |
| Purrs after task completion | Positive reinforcement | Warm, rewarding |
| Sleeps when tasks are handled | "You're on top of things" | Calm, affirming |
| Hisses at monsters | Early warning system | Protective, alert |
| Knocks things off shelves | Ambient charm | Alive, funny, real |
| Can be petted | Pure delight | No function, just nice |
| Naps on surfaces | Inhabits the space | Makes the house feel lived-in |

### Cat vs Monsters — The Dynamic

When both systems are enabled, they create a natural tension:

- **Cat hisses → player notices → investigates → finds the corrupting task.** The cat is a living alarm system that doesn't feel like an alarm.
- **Hissing intensity scales with severity.** Soft growl for slightly neglected. Full arched-back hissing for a monster.
- **Cat retreats from full monsters.** It won't go near the worst ones. This signals "this is serious."
- The interplay creates **emergent storytelling**: you walk into the study, the cat is hissing at the desk, you look over and see a darkened, cracking scroll — oh no, the client brief has been festering for a week.

### Tamagotchi Element

The cat has a simple emotional state (happiness + energy) that decays slowly and is boosted by player interaction. This creates:

- A reason to visit the palace even when tasks are under control
- A secondary engagement loop that doesn't require productivity pressure
- A subtle indicator of how engaged you've been (sad cat = you've been away a while)

This is deliberately lightweight. It's not a full pet sim — just enough emotional texture to make the cat feel like a companion rather than a tool.

### Future: Cat as Notification Avatar (iOS)

iOS 16.1+ introduced **Live Activities** (Lock Screen and Dynamic Island) and iOS 17+ added **Interactive Widgets** — both allow app state to surface outside the app with custom visuals. The idea: **the theme's cat delivers your notifications.**

- If you're running the Greco-Roman theme, your marble cat appears on the Lock Screen nudging you about a due task.
- Cyber-Lab theme? A neon holographic cat.
- Noir? A shadowy alley cat.
- The cat's expression/pose could reflect urgency: sleeping for low-priority, alert ears for high, arched-back hissing if a monster has formed.

This extends the cat's role from in-palace companion to **system-level companion** — it follows you out of the app. The notification isn't a generic badge; it's *your cat* telling you something. That emotional continuity is exactly what makes the cat work inside the palace, and there's no reason it shouldn't work outside it too.

**Implementation notes (for later):**
- Requires a WidgetKit extension (Swift) with shared App Group for data access
- Each theme needs a set of small cat illustration assets (idle, alert, hissing) at widget sizes
- Live Activities would work well for focus timer countdown (cat watching you work)
- Interactive Widgets could show "next task" with a tap-to-complete action
- Android equivalent: custom notification layouts with `RemoteViews`, or Glance widgets (Jetpack)

Not implementing now — noting for when the cat visual assets exist and platform extensions are in scope.

---

## Monsters — Why They Work

Monsters are **procrastination made literal**. The design rationale:

### Gradual Evolution Is Key

Tasks don't just *become* monsters. They slowly, visibly deteriorate:

1. **Healthy** → Normal object. All is well.
2. **Neglected** → Dust, cobwebs. Visual cue: "this has been sitting a while."
3. **Corrupting** → Dark aura, cracks, shadows. Something is wrong.
4. **Monster** → Detaches from surface, roams the room, chases you.

This gradient serves multiple purposes:
- **Early warning.** You see the dust before it becomes a problem.
- **Anxiety scaling.** Not a binary alarm — a slow build that mirrors real procrastination anxiety.
- **Player agency.** You can intervene at any stage. Interact with a dusty scroll and the clock resets.
- **Dramatic payoff.** When something does become a monster, it *means something*. You let it get there.

### Why Toggleable

Not everyone wants gamified anxiety in their task manager. The monster system is **entirely opt-in** with granular controls:

- Monsters on/off
- Chasing on/off (keep the visual corruption but no roaming)
- Sensitivity: gentle / normal / strict (how fast tasks evolve)

The principle: **the user configures their own level of discomfort.** Some people thrive on the urgency. Others just want the visual decay without the chase. Both are valid.

### Defeating Monsters

To "kill" a monster, you interact with it — which opens the task detail panel. Complete the task, and the monster dissolves with a satisfying victory effect. This is deliberate: **the only way to defeat procrastination is to do the thing**. No sword, no magic spell. Just... doing it.

---

## The House — Spatial Design Philosophy

### Why a Big House

The house needs to be large enough that:
1. **Spatial memory has room to work.** If everything is in one room, there's nothing to remember.
2. **Different areas feel different.** Walking into the study should *feel* like work mode. Walking into the garden should *feel* like growth and long-term thinking.
3. **Running from monsters is meaningful.** A tiny house doesn't create tension.
4. **There's room to explore.** Part of the appeal is that you have a *place* — your place — and you know it intimately.

### Why Greco-Roman

The default theme choice was deliberate:
- **Intellectual connotation.** Roman villas were associated with scholarship, philosophy, and organised thinking.
- **Method of loci is literally Roman.** The technique was invented for navigating Roman buildings. The theme honours the origin.
- **Warm, not cold.** Marble and terracotta create a warm, inviting palette. Not sterile minimalism.
- **Distinctive.** No one else has a Greco-Roman task manager. It's instantly recognisable.

### Placement Surfaces as Information Architecture

The house is deliberately **rich with writable and displayable surfaces**:
- Picture frames line hallways (visual reminders as you pass through)
- Notice boards in every room (pin multiple items, create visual clusters)
- Chalkboards for temporary brainstorming
- Desks and shelves for primary organisation
- The floor for unsorted items (a gentle nudge to organise)

The key insight: **the spatial arrangement IS the organisation system**. You don't file tasks into categories — you *place them in rooms*. The rooms are the categories. The surfaces within rooms are the sub-categories. And you remember where you put things because you physically put them there.

### Two Storeys + Basement

The three-level layout serves practical and emotional purposes:

| Floor | Emotional Register | Content |
|-------|-------------------|---------|
| **Upper** | Private, personal | Bedroom (self-care), Gymnasium (health), Gallery (display) |
| **Ground** | Active, daily | Foyer (dashboard), Study (work), Library (notes), Kitchen (nutrition), Workshop (creative), Garden (goals) |
| **Basement** | Archive, deferred | Treasury (completed/achievements), Cellar (someday/deferred items) |

Walking downstairs to archive a task in the Treasury creates a sense of closure. Descending further to the Cellar to defer something creates a sense of "putting it away." These spatial metaphors are intuitive — everyone understands "upstairs is private, downstairs is storage."

---

## HUD Reticule — Why a Crosshair in a Task Manager

The reticule seems odd for a productivity app, but it's actually the key to making palace mode *functional* rather than just pretty:

- **Passive scanning.** As you look around, the crosshair passes over objects and instantly shows their title and priority. Sweep a shelf with your gaze and you've reviewed five tasks in two seconds.
- **Priority colours.** The crosshair subtly shifts colour to match what you're looking at. Green/amber/red/pulsing-red gives you instant status at a glance.
- **Interact prompt.** Context-sensitive prompts appear when you can do something: "Inspect," "Open Door," "Pet Cat."
- **No mode switching.** You don't switch to "inspect mode" — just look at things.

The HUD and cat are deliberately complementary:
- **HUD = instant, explicit, data-driven** (what, when, priority)
- **Cat = slow, ambient, directional** (where to go, what to do next)

---

## Theme Reference: mindhause-spaces

The [mindhause-spaces](https://github.com/mogster-sys/mindhause-spaces) repository contains a React landing page that was built as a theme selector. Key reference material:

- **Theme texture samples:** Each theme option has associated textures/visuals that represent reasonable quality targets for the palace
- **Theme-specific cats:** Each theme variant had its own cat design/style — useful reference for the cat companion's visual identity
- **Colour palettes:** The website's theme selector shows the palette for each planned skin (Greco-Roman, Cyber-Lab, Noir, etc.)

When building the Godot palace's visual assets, use the mindhause-spaces site as a **mood board and quality reference** for textures, colours, and overall aesthetic tone.

---

## Why Flutter + Godot (Not Pure Anything)

The platform comparison that led to the hybrid decision:

| Approach | Pros | Cons | Verdict |
|----------|------|------|---------|
| **Flutter only** | Single codebase, great UI, native APIs | Cannot do first-person 3D. At all. | Dead end for palace |
| **Godot only** | Excellent 3D, free, cross-platform | Weak native UI, no proper list views, poor calendar/map widgets, non-standard app deployment | Dead end for organiser |
| **React Native + Three.js** | Web tech, large ecosystem | WebGL 3D on mobile is a battery/performance nightmare | Disqualified |
| **Unity** | Powerful 3D, mature | Heavy runtime, licensing cost, overkill for low-poly, expensive for indie | Disqualified |
| **Flutter + Godot hybrid** | Flutter does what it's good at (UI, native APIs, app shell), Godot does what it's good at (3D, physics, AI) | Two technologies to maintain, integration complexity | Winner — each half is best-in-class for its job |

The critical insight: **the data boundary is simple**. Both sides read/write to the same SQLite file. No complex IPC, no real-time streaming, no serialisation protocol. One writes, the other reads. When you flip modes, the receiving side loads current state. That's it.

---

## ADHD-Friendly Design Considerations

MindHause has natural appeal for neurodivergent users, particularly those with ADHD. This is by design:

- **Spatial over sequential.** ADHD brains often struggle with flat lists but thrive with spatial/visual organisation.
- **Novelty through exploration.** The palace provides novelty (a key ADHD motivator) without requiring new content — the user's own tasks create the novelty through spatial arrangement.
- **Cat companion as gentle redirection.** Instead of alarms (which trigger rejection sensitivity), the cat offers soft guidance.
- **Monsters as externalised anxiety.** ADHD procrastination anxiety is real but invisible. Making it literal (a monster) makes it actionable — you can "fight" it by doing the task.
- **Instant flip to organiser.** When the game layer is too much, one tap gets you to a clean, conventional interface. No cognitive overhead to switch modes.
- **Focus mode (Mindflow).** Built-in Pomodoro with dramatic visual treatment — the palace darkens, one task is spotlit. This creates the external structure that ADHD brains need to enter flow state.

---

## Audio Strategy

Audio is crucial for immersion but doesn't need to be custom-composed from day one:

### What You Need

| Category | Examples | Source Strategy |
|----------|----------|----------------|
| **Ambient per room** | Fountain (garden), crackling fire (study), birdsong (courtyard), rain on windows | Free ambient libraries (freesound.org, Sonniss GDC bundles) |
| **Interaction SFX** | Scroll unrolling, book opening, door creak, chime on completion | UI sound packs (Kenney, freesound) |
| **Cat sounds** | Purring, meowing, hissing (3 intensities) | Cat sound packs are abundant and free |
| **Monster sounds** | Distant rumbling, whispers, heartbeat (when chasing) | Horror ambient libraries |
| **Music** | Gentle background that shifts with time of day | Royalty-free ambient tracks, or AI-generated |

### Priority

1. Interaction SFX first (makes the app feel alive immediately)
2. Cat sounds (core to the companion experience)
3. Ambient loops (one per room, can start with 3-4 and expand)
4. Music last (nice-to-have, not essential for function)

---

*These notes capture the creative reasoning behind MindHause's design. They're companion material to the PRD and Architecture docs. Updated 2026-02-15.*
