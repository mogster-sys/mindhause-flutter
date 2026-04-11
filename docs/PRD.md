# MindHause — Product Requirements Document

> **Status:** Active
> **Version:** 1.0
> **Platform:** Android, iOS
> **Framework:** Flutter (app shell) + Godot 4 (3D palace engine)
> **Repository:** github.com/mogster-sys/mindhause
> **Privacy Model:** All on-device, no backend

---

## 1. Vision Statement

MindHause transforms productivity into a spatial, sensory, and psychological experience. Instead of lists or Kanban boards, users explore a first-person 3D environment — a "memory palace" — where every task, idea, and goal is a tangible object placed inside rooms they navigate, organise, and inhabit.

The app is an **organiser first**. To-dos, notes, calendars, goals. The spatial and game layers exist to serve that purpose — making the organisational act intuitive, memorable, and engaging by leveraging how the human brain actually works: spatially, physically, and narratively.

> "Turn your mind into a place you can walk through."

### 1.1 Why It Works

- **Spatial memory encoding:** The method of loci (ancient mnemonic technique) has robust evidence for improving recall. People remember *where* things are better than what's written on a list.
- **Embodied cognition:** Interaction and navigation enhance retention and engagement.
- **Gamification:** Progress feedback loops trigger intrinsic motivation better than checklists for certain personality types.
- **Accessibility:** Flips instantly to a clean, conventional organiser for when the game layer isn't wanted or appropriate.

### 1.2 Who It's For

- Anyone who finds traditional task lists overwhelming, forgettable, or boring
- Neurodivergent users (ADHD-friendly spatial organisation)
- Gamers who want productivity woven into play
- Students and knowledge workers who benefit from spatial memory techniques

---

## 2. Core Principles

1. **Organiser first, game second.** Every game feature must serve the organisational goal. If it doesn't help someone manage their tasks, notes, or goals, it doesn't belong.
2. **Instant flip.** A user must be able to switch from palace mode to a clean, flat organiser in one tap. Not everyone wants to play a game every time they need to check a to-do.
3. **All on-device.** No backend. No accounts required. User data stays on the device. Privacy is not negotiable.
4. **Fun features are user-selectable.** Monsters, the cat companion, gamification elements — all opt-in. The user configures their experience.
5. **Physical embodiment.** Every task, note, or event has a physical representation in the palace, even if it's just a post-it note placed on a surface.
6. **Big house, room to move.** The palace is not a single room demo. It's a full, large house with corridors, wings, and rooms — enough space to run, explore, and feel immersed.

---

## 3. Product Modes

### 3.1 Palace Mode (First-Person 3D — Godot)

The core experience. User navigates a large Greco-Roman house in first-person (WASD + mouse / touch joystick on mobile). Tasks exist as physical objects on placement surfaces (desks, shelves, wall hooks, pedestals). Rooms correspond to categories, wings to projects, and corridors to timelines.

### 3.2 Organiser Mode (Flat UI — Flutter)

A conventional, polished task/calendar/note interface. Lists, cards, calendar views, search, filters. Everything in the palace is accessible here and vice versa. This is what you'd show your boss, use on the train, or flip to when you don't have time for exploration.

### 3.3 Map Mode (Flutter)

When a task or appointment has a location, opening its associated "door" in the palace reveals a view of that real-world location (satellite/map imagery). In organiser mode, this is a standard map view. The idea: open a door in your palace and see *where you need to be* in two days.

---

## 4. The House

### 4.1 Layout Philosophy

The house is large — a proper two-storey Greco-Roman villa with wings, courtyards, corridors, a basement, and generous proportions. Not so large it becomes tedious to traverse, but large enough that spatial memory has room to work and there's space to run. Users should develop a mental map of their house over time. Ceilings are high, hallways are wide, rooms are spacious.

### 4.2 Floor Plan

```
BASEMENT (Below Ground)
├── Cellar                    Deferred/someday items
├── Vault / Treasury          Completed/archived items, achievements
└── Catacombs (stretch)       Deep archive, very old items

GROUND FLOOR
├── Foyer / Atrium            Central hub, today's dashboard
├── Main Hallway              Connects all ground floor rooms
│   └── Timeline Corridor     Doors to future appointments (map views)
├── Study                     Work tasks, professional projects
├── Library                   Notes, reference material, ideas
├── Kitchen / Pantry          Shopping lists, meal plans, nutrition
├── Workshop                  Creative projects, DIY, builds
├── Garden / Courtyard        Long-term goals, habits (open air, central)
└── Guest Room(s)             User-created custom rooms (see 4.6)

UPPER FLOOR (First Floor)
├── Upper Landing / Gallery   Connects upper rooms, display area
├── Bedroom                   Personal tasks, self-care
├── Gymnasium                 Fitness goals, health tracking, exercise programs
├── Observatory (stretch)     Calendar overview, time-based planning
└── Spare Room(s)             User-created custom rooms (see 4.6)
```

### 4.3 Room Structure

| Room | Floor | Purpose | Example Objects |
|------|-------|---------|-----------------|
| **Foyer / Atrium** | Ground | Dashboard — today's overview, urgent items | Sundial (current time), message board, day's scrolls, notice boards |
| **Study** | Ground | Work tasks, professional projects | Scrolls, ledgers, ink wells, desk items, picture frames, wall boards |
| **Library** | Ground | Notes, reference material, ideas | Books, manuscripts, reading nooks, notice boards |
| **Kitchen / Pantry** | Ground | Shopping lists, meal plans, nutrition | Ingredient jars, recipe scrolls, pantry shelves, pinned recipes |
| **Workshop** | Ground | Creative projects, DIY, builds | Tools, blueprints, material bins, pinned schematics |
| **Garden / Courtyard** | Ground | Long-term goals, growth, habits | Growing plants (habit streaks), stone tablets (milestones) |
| **Main Hallway** | Ground | Navigation hub | Doors to rooms, picture frames, notice boards |
| **Timeline Corridor** | Ground | Time-based navigation | Doors = points in time; open a door to see where an appointment is (map imagery) |
| **Bedroom** | Upper | Personal tasks, self-care, rest | Journal, wardrobe items, bedside notes, picture frames |
| **Gymnasium** | Upper | Fitness goals, health tracking, exercise programs | Training equipment, body stat plaques, workout scrolls, progress boards |
| **Upper Gallery** | Upper | Display and connection | Picture frames, achievement displays, connects upper rooms |
| **Treasury / Vault** | Basement | Completed/archived items, achievements | Trophies, sealed chests, completed relics |
| **Cellar** | Basement | Deferred/someday items | Dusty objects, cobwebbed corners |

### 4.4 Placement Surfaces

Every room has surfaces where task objects can be placed:
- **Desks and tables** — primary work surfaces
- **Shelves** — organised storage, categorised rows
- **Wall hooks and boards** — pinned notes, quick-reference items
- **Pedestals and plinths** — highlighted/important items
- **Picture frames** — display task titles, notes, or images on walls. Abundant throughout the house. Can be written on or updated. Function as visual reminders you see while passing through.
- **Notice boards / cork boards** — large writable surfaces that hold multiple pinned items. Every major room should have at least one. Can display lists, priorities, or free-form notes.
- **Chalkboards / slate tablets** — writable surfaces for brainstorming, scratchpad notes, temporary lists. Erasable.
- **The floor** — unsorted, "inbox" overflow (subtle nudge to organise)

The house should be **rich with writable and displayable surfaces**. Picture frames line hallways, notice boards hang in every room, and there's always somewhere nearby to pin a thought. The spatial arrangement IS the organisation system.

Users can pick up and move objects between surfaces and rooms to organise as they see fit.

### 4.5 Doors, Stairs, and Navigation

- Doors connect rooms. Walking up and pressing interact (E / tap) opens them.
- **Staircases** connect floors. Walk up/down to transition between ground, upper, and basement levels. Animations keep orientation clear.
- Some doors in the Timeline Corridor lead to **time-based views** — opening a door shows a map/satellite image of where a future appointment takes place (derived from Google Maps / OpenStreetMap imagery).
- Doors can optionally be locked by monster tasks blocking access (if gamification is enabled).

### 4.6 Custom Rooms (User-Created)

Users can spawn new rooms for organisation purposes that don't fit the predefined categories. Custom rooms:
- Appear as empty rooms connected to the hallway (ground floor) or upper landing
- Start with basic surfaces (desk, shelf, notice board, picture frames)
- User names them and assigns a category/colour
- Use the existing placement system — no special mechanics, just flexible space
- Can be deleted (items return to the Foyer inbox)
- Think of the predefined rooms as a crafting system for structured organisation; custom rooms are freeform workspace

---

## 5. Task Objects — Physical Embodiment

### 5.1 Object Types

Every planner item becomes a physical object. The type encodes what it is:

| Object | Represents | Visual |
|--------|-----------|--------|
| **Scroll** | Standard task/to-do | Rolled parchment |
| **Book** | Note/reference/long-form | Bound volume |
| **Candle** | High-priority/urgent item | Lit flame, warm glow |
| **Statue/Relic** | Goal or milestone | Stone/bronze figure |
| **Letter** | Appointment/calendar event | Sealed envelope |
| **Blueprint** | Project (contains sub-tasks) | Rolled architectural plan |
| **Seed/Plant** | Habit (grows with streak) | Pot → sprout → plant → tree |
| **Post-it note** | Quick capture/unclassified | Coloured sticky paper |
| **Jar/Bottle** | Recurring task | Refilling vessel |
| **Key** | Blocker/dependency | Ornate key |

### 5.2 Object States

Objects visually change to communicate status:

| State | Visual Effect |
|-------|--------------|
| **New/Unread** | Slight shimmer or sparkle |
| **In Progress** | Warm ambient glow |
| **Urgent/Overdue** | Pulsing red aura, increasing intensity |
| **Completed** | Golden glow, then can be placed in Treasury |
| **Neglected** | Dust accumulates, cobwebs form |
| **Corrupting (pre-monster)** | Darkening, cracks appearing, shadows gathering |

### 5.3 Interaction

- **Look at** → highlight outline, show title tooltip
- **Interact (E / tap)** → open detail panel (title, description, due date, priority, subtasks, notes)
- **Pick up** → carry to another surface/room
- **Place down** → set on any placement surface
- **Complete** → mark done; object transforms to golden/completed state
- **Archive** → move to Treasury
- **Delete** → object dissolves/burns away

### 5.4 Data Model

```json
{
  "id": "task_001",
  "title": "Finish client brief",
  "description": "Draft and send the Q1 brief to Acme Corp",
  "type": "task",
  "priority": "high",
  "status": "todo",
  "due_date": "2026-03-01T09:00:00",
  "created_at": "2026-02-15T10:00:00",
  "last_interaction": "2026-02-15T10:00:00",
  "room": "study",
  "surface": "desk_main",
  "object_type": "scroll",
  "position": [12.4, 1.2, -6.8],
  "project_id": "proj_acme",
  "tags": ["client", "writing"],
  "subtasks": [
    {"id": "sub_001", "title": "Gather Q1 metrics", "done": false},
    {"id": "sub_002", "title": "Draft outline", "done": true}
  ],
  "recurrence": null,
  "location": null,
  "monster_state": "none",
  "notes": ""
}
```

---

## 6. Monster Tasks (Optional — User-Selectable)

### 6.1 Concept

Tasks that a user avoids or leaves overdue don't suddenly spawn as monsters. They **slowly evolve**. A neglected scroll gathers dust, then darkens, then cracks appear, shadows gather around it — and eventually, if ignored long enough, it detaches from its surface and becomes a roaming creature in the house.

This represents procrastination made literal. The task is now chasing you.

### 6.2 Evolution Timeline

1. **Healthy** — normal object appearance (0–48hrs past due)
2. **Neglected** — dust, cobwebs, slight dimming (2–5 days overdue)
3. **Corrupting** — dark aura, cracks, ambient whispers (5–10 days overdue)
4. **Monster** — detaches from surface, becomes a roaming creature that follows and "attacks" the player (10+ days overdue)

### 6.3 Monster Behaviour

- Monsters patrol near their original room but will chase the player if spotted
- "Attack" = screen vignette flash, stress sound, HUD message ("This task is hunting you...")
- Monsters don't kill the player — they create discomfort and block access to rooms
- To defeat a monster: interact with it (E / tap) → opens the task detail panel. Complete the task → monster dissolves with a satisfying victory effect

### 6.4 Toggleable

The entire monster system is opt-in. Users can:
- Disable monsters entirely (tasks just stay as objects with visual neglect cues)
- Set monster sensitivity (how quickly tasks evolve)
- Enable/disable monster chasing behaviour
- Keep visual corruption but disable the roaming creature stage

---

## 7. The Cat Companion (Optional — User-Selectable)

### 7.1 Concept

An ambient companion that makes the house feel alive and gently friendly. The cat is **not a nag** — it's a polite reminder, a warm presence, and a subtle prioritisation aid. Think of it as friendly coercion, never aggressive. The HUD provides instant information; the cat provides a softer, slower nudge for when you're wandering.

The cat is always your friend. Never a monster, never hostile, never punishing.

### 7.2 Core Behaviour

- **Rubbing and attention-getting:** The cat positions itself where it can be seen — sits near tasks that need attention, rubs against objects, meows softly. Like a real cat that wants something, except this one wants you to do your tasks.
- **Leading:** If the player seems to be wandering without purpose, the cat walks ahead toward a priority task, looks back, waits. If followed, it purrs and leads the way. It doesn't block or force — it invites.
- **Purring as confirmation:** When the player follows the cat to a task and engages with it, the cat purrs. Positive reinforcement, not negative pressure.
- **Sleeping as all-clear:** When tasks are in good shape, the cat curls up and sleeps somewhere cosy. Visual shorthand for "you're on top of things."
- **Ambient charm:** Occasionally knocks things off shelves, chases dust motes, sits in sunbeams. Makes the house feel inhabited and warm.
- **Can be petted:** Interact with the cat for a small reward sound and a brief purr animation. No functional effect, just nice.

### 7.3 Cat vs Monsters

When both the cat and monster system are enabled:
- The cat **hisses at monsters**. As a task corrupts and becomes more monstrous, the cat hisses louder and more frequently near it. This serves as both an early warning system and a signal of escalating urgency.
- The cat never attacks monsters — it reacts to them, avoids them, and draws the player's attention to them.
- The cat will not go near fully evolved monsters. If a monster is chasing the player, the cat retreats to a safe room.
- The cat's hissing intensity scales with monster severity — a slightly neglected task gets a soft growl; a fully corrupted monster gets dramatic hissing and arched-back posture.

### 7.4 Cat as Prioritisation Aid

When the cat is enabled, it acts as a **soft task selector / prioritiser:**
- The cat gravitates toward the highest-value next action (considering due date, priority, neglect duration)
- If multiple tasks compete, the cat picks one and sticks with it for a while (not frantically bouncing between tasks)
- The player can ignore the cat entirely — it never blocks progress or forces interaction
- The cat works alongside the HUD — the HUD is instant and explicit, the cat is ambient and suggestive

### 7.5 Toggleable

Users can enable/disable the cat entirely. If disabled, no companion is present. The HUD handles all task awareness independently.

---

## 8. Behavioural Nudge System

### 8.1 Time-of-Day Sync

The palace world mirrors real time from the user's timezone:
- **Morning:** Warm sunrise light through windows, birds ambient
- **Midday:** Bright, full light, active feel
- **Evening:** Golden hour, lamps begin to light
- **Night:** Moonlight, candle-lit rooms, quieter ambient

Sundials and clocks within the house show actual time, integrated playfully into the Greco-Roman aesthetic.

### 8.2 Context Sensitivity

The game adjusts its intensity based on context:
- **At home (default/inferred):** Full game features — monsters, exploration, companion, mini-games
- **On the go / quick access:** Organiser mode is default, palace available but simplified
- Users set their preference; no GPS required unless they opt into location features

### 8.3 Ambient Progress Feedback

- Completing tasks brightens the room, plays a gentle chime
- Many overdue tasks = dimmer ambient, subtle "murmur" audio
- Streak of completions = room fills with warm light, flowers bloom in garden
- Empty rooms (all done) = clean, peaceful, open space

### 8.4 Focus Mode (Mindflow)

A timed deep-work session:
- Toggle with F key / tap focus button
- The palace darkens except for the selected task object (spotlight effect)
- Pomodoro-style timer on HUD (configurable: 15/25/45 min)
- Reduced monster speed while in focus (or monsters pause)
- Session complete → gentle chime, brief room brightening, streak increment

---

## 9. HUD System (Palace Mode)

The HUD is the key to making the palace mode genuinely useful as a productivity tool, not just a pretty walkthrough. It provides instant, always-available information without breaking immersion.

### 9.1 Reticule / Crosshair

A small dot or subtle sighting reticule sits at the centre of the screen at all times in palace mode. This is the primary interaction pointer:

- **Passive scanning:** As the player looks around, the reticule naturally passes over objects. When it rests on a task object, the task's title and priority appear on the HUD immediately — no button press needed. The object also comes into visual focus (slight zoom, increased brightness/sharpness, depth-of-field blur on surroundings).
- **Quick read:** Just looking at a task tells you what it is. Sweep a shelf with your gaze and you've reviewed five tasks in two seconds.
- **Interact prompt:** When the reticule is on an interactable object (task, door, cat, notice board), an interact prompt appears: "[Tap] Inspect" or similar.
- **Priority colour:** The reticule dot can subtly shift colour to match the priority of whatever it's currently resting on (green = low, amber = normal, red = high, pulsing red = overdue).

### 9.2 HUD Elements

| Element | Position | Purpose |
|---------|----------|---------|
| **Reticule** | Centre | Interaction pointer, task scanning |
| **Task info strip** | Top or bottom | Shows title/priority/due of whatever the reticule is on |
| **Task count** | Top corner | "Open: 12 | Due Today: 3 | Monsters: 1" |
| **Room label** | Top | Current room name |
| **Focus mode indicator** | Top | Timer and status when focus mode is active |
| **Quick capture button** | Bottom corner | Tap to add a task without leaving palace |
| **Organiser flip button** | Bottom corner | One-tap switch to organiser mode |
| **Interaction prompts** | Near reticule | Context-sensitive: "Inspect," "Open Door," "Pet Cat" |
| **Monster warning** | Centre flash | Appears when a monster attacks ("Procrastination attack!") |
| **Cat indicator** | Subtle | Small icon when the cat is trying to lead you somewhere |

### 9.3 HUD and Cat Collaboration

When the cat is enabled, the HUD and cat work as complementary systems:
- The HUD tells you **what** (instant data, numbers, titles)
- The cat tells you **where to go** (spatial, ambient, directional)
- If the cat is leading the player somewhere, a small paw-print indicator appears on the HUD showing the cat's direction
- The HUD never waits for the cat — it's always instantaneous

### 9.4 Mnemonic-Informed HUD Features

MindHause is inherently a Method of Loci implementation — the rooms are loci, task objects are memory images, the cat is a retrieval cue, and themes are mood contexts. The following features explicitly leverage mnemonic science to strengthen spatial recall and make the palace a genuine memory tool, not just a metaphor.

#### Room Entry Banner

When the player enters a room, a styled banner appears at the top of the screen showing:
- The room's display name (large text)
- Active task count for that room

The banner fades in, holds for 2.5 seconds, then fades out. This reinforces the spatial association: you always know WHERE you are and WHAT is here.

#### Placement Confirmation (Spatial Address)

When a task object is placed on a surface, a toast notification appears showing the full spatial address:
- **Room > Surface > Slot** (e.g., "Study > Writing Desk > Slot 3")

When the reticle hovers over a surface, the hint shows the surface name and available slot count (e.g., "Writing Desk (6 free)"). This makes placement intentional — the user consciously registers WHERE they put something, which is the encoding step of the Method of Loci.

#### Retrieval Quiz ("Where Was It?")

After several room transitions (minimum 3, with a 15% random chance per transition), a quiz overlay appears:
- Shows a task title from a DIFFERENT room than the current one
- Asks "Which room is this in?"
- Presents 4 room name buttons (1 correct, 3 random wrong)
- Correct answer shows green "Correct!" feedback
- Wrong answer shows red "It's in [Room Name]" feedback
- Auto-dismisses after 2 seconds

This is lightweight retrieval practice — the most effective memory technique. The quiz is infrequent enough to not be annoying, but frequent enough to build strong room-task associations over time.

#### Cat Morning Walk (Guided Review)

The cat leads a daily review tour through all rooms that have active tasks:
- Follows a fixed route order (Foyer → Study → Library → Garden → Kitchen → Workshop → Bedroom → Gymnasium → Treasury → Cellar)
- In each room, the cat walks to each task object, pauses (2.5s) to let the player see it, then moves to the next
- After visiting all tasks in a room, the cat heads toward the door to the next room with tasks
- The player follows; the auto-transition door system handles room changes
- Walk completes with a celebratory purr and happiness boost

The walk auto-triggers at dawn/morning if there are active tasks (once per session). It can also be triggered manually via `GameState.morning_walk_requested`.

This is literally the retrieval step of the Method of Loci: walking a fixed route, visiting each locus in order.

#### Design Rationale

These features are informed by five mnemonic systems documented in `docs/MNEMONIC_SYSTEMS_REFERENCE.md`:
1. **Method of Loci** — the entire palace structure (rooms, surfaces, route order)
2. **Spatial encoding** — placement confirmation makes surface choice conscious
3. **Retrieval practice** — the quiz tests and strengthens room-task associations
4. **Route consistency** — the morning walk follows the same order every time
5. **Emotional context** — themes and time-of-day lighting provide mood-based encoding cues

Future expansion: Study Palace mode (flashcards placed in rooms with spaced repetition), custom palaces, and visual encoding assistance. See `docs/MNEMONIC_DESIGN_IDEAS.md`.

---

## 10. Input and Controls

### 10.1 Mobile (Primary Platform)

MindHause is principally a mobile app. Touch controls are the primary input method:

| Control | Implementation |
|---------|---------------|
| **Movement** | Virtual joystick (left thumb area) — standard mobile FPS pattern |
| **Look / Aim** | Touch-drag on right side of screen — swipe to look around |
| **Interact** | Tap button (right thumb area) or tap directly on highlighted object |
| **Quick capture** | Dedicated button on HUD — opens task entry overlay |
| **Focus mode** | HUD button toggle |
| **Flip to organiser** | HUD button — one tap |

The virtual joystick should be:
- Semi-transparent, non-intrusive
- Configurable size and position
- Auto-hiding when not in use (optional setting)
- Responsive with no dead zones

### 10.2 Desktop / Tablet (Secondary)

| Control | Implementation |
|---------|---------------|
| **Movement** | WASD keys |
| **Look** | Mouse movement |
| **Interact** | E key or left-click |
| **Quick capture** | Q key or HUD button |
| **Focus mode** | F key |
| **Flip to organiser** | Tab key or ESC |

### 10.3 In-Palace Task Entry

Users need to be able to enter tasks without leaving the palace. The quick capture flow:

1. Tap the quick capture button on HUD (or Q key on desktop)
2. A semi-transparent overlay appears — does NOT exit palace mode
3. Enter: title, optional priority, optional room assignment
4. Submit → a new task object materialises on the nearest available surface in the selected room (or the current room's default surface)
5. Overlay dismisses, player is back in the palace immediately

For more detailed task editing (description, subtasks, due dates, tags), the player can:
- Interact with the newly created object to open the full task panel
- Or flip to organiser mode for full editing capability

---

## 11. Organiser Mode Features (Flutter)

This is the full-featured planner that exists independently of the palace. Everything here syncs bidirectionally with the palace objects.

### 11.1 Tasks

- Create, edit, delete, complete tasks
- Title, description, due date, priority (low/normal/high), tags
- Subtasks/checklists within a task
- Assign to room/project
- Recurring task support (daily, weekly, monthly, custom)

### 11.2 Projects

- Group tasks under a project
- Each project maps to a wing/area in the palace
- Project progress bar (based on task completion)
- Project colour coding

### 11.3 Goals

- Long-term objectives (e.g., "Learn French," "Run a marathon")
- Represented as statues/relics in the Garden
- Linked to projects and habits that contribute to them
- Visual growth indicator (garden plants/vines)

### 11.4 Habits

- Recurring behaviours with streak tracking
- Represented as plants in the Garden (grows with streak, withers if broken)
- Configurable frequency and reminders

### 11.5 Notes

- Freeform text notes
- Represented as books in the Library
- Taggable, searchable

### 11.6 Calendar View

- Day/week/month views
- Events and task due dates shown together
- Location-aware events show map preview

### 11.7 Quick Capture

- Fast entry for tasks/notes without choosing room/details
- Objects appear in Foyer as "inbox" post-its until sorted

### 11.8 Search and Filter

- Full text search across all items
- Filter by room, project, priority, status, tags, date range

---

## 12. Integration (Future — On-Device Only)

### 12.1 Calendar Sync

- Read from Google Calendar, Apple Calendar (on-device API, not cloud)
- Calendar events become Letter objects in the palace
- Location events gain the "open door to map view" functionality

### 12.2 Notion/Obsidian (Future Consideration)

- Import/export capability
- Not a priority for initial release
- On-device only — no cloud sync service

---

## 13. Theme and Aesthetic

### 13.1 Default: Greco-Roman Villa

The launch skin. Stone halls, marble surfaces, columns, arches, mosaic floors, sundials, amphora, scrolls, oil lamps. Warm and intellectual. Not ruins — a living, well-maintained villa.

- Study feels like a study (dark wood desk, ink wells, heavy curtains)
- Gymnasium feels like a gymnasium (open air, training equipment, body stat plaques)
- Library feels like a library (floor-to-ceiling shelves, reading alcoves)
- Each room has distinct character appropriate to its function

### 13.2 Future Skins

Skins change the visual presentation but not the underlying structure:
- Cyber-lab / Sci-fi
- Noir office / Detective
- Dream realm / Surreal
- Minimal zen / Japanese
- Medieval castle

### 13.3 Audio

- Ambient environmental sound per room (fountain in courtyard, fire crackling in study)
- Subtle music that shifts with time of day
- Satisfying interaction sounds (scroll unrolling, book opening, chime on completion)
- Monster ambient sounds when corruption is active (distant rumbling, whispers)
- Cat sounds: purring, meowing, hissing (scaled to monster proximity)

---

## 14. Monetization

| Model | Description |
|-------|-------------|
| **Free base** | Full organiser + small house (subset of rooms) |
| **One-time purchase** | Full house, all rooms, all features. Paid app or IAP |
| **Theme packs** | Additional visual skins as IAP |
| **No subscription** | No ongoing cost, no cloud dependency |
| **No ads** | Ever |

### 14.1 Philosophy

The app respects the user. No dark patterns, no engagement farming, no data harvesting. You buy it, you own it, your data stays on your device.

---

## 15. Target Platforms

| Platform | Priority | Notes |
|----------|----------|-------|
| **Android** | Primary | Google Play |
| **iOS** | Primary | App Store |
| **Web** | Secondary | Demo/marketing version |
| **Desktop** | Stretch | Windows/macOS via Flutter |

---

## 16. Roadmap

### Phase 1: Foundation
- Flutter app shell with organiser mode (tasks, projects, notes, calendar)
- Godot 3D engine integration scaffold
- Shared SQLite database layer
- Basic palace: Foyer + Study + one corridor with stairs
- Task objects: scrolls, books, candles
- First-person navigation (touch joystick mobile / WASD desktop)
- HUD with reticule, task info, quick capture
- Instant flip between palace and organiser

### Phase 2: Full House
- All rooms on all three floors (ground, upper, basement)
- Full placement surface system (desks, shelves, picture frames, notice boards)
- All object types
- Door and staircase navigation
- Time-of-day lighting system
- Focus mode
- Custom room creation

### Phase 3: Life in the Palace
- Monster task evolution system (toggleable)
- Cat companion with full behaviour (toggleable)
- Cat-monster interaction (hissing)
- Cat morning walk (guided daily review tour)
- Mnemonic HUD features (room banner, placement confirmation, retrieval quiz)
- Habit tracking with garden growth
- Goal system with milestone relics
- Ambient progress feedback
- Audio system (environmental + interaction + cat + monster)

### Phase 4: Polish and Ship
- Greco-Roman visual style guide fully applied
- Performance optimisation for mobile
- Calendar integration (on-device)
- Writable surfaces (notice boards, chalkboards, picture frames)
- Search and filter
- Onboarding flow
- App Store and Google Play submission

### Phase 5: Expansion
- Additional theme skins
- Map mode (location-based door views with satellite imagery)
- Export/import (Notion, Obsidian)
- Desktop builds
- Community feedback iteration

---

## 17. Success Metrics

- User opens the app daily (organiser stickiness)
- User spends time in palace mode voluntarily (engagement quality)
- Task completion rate compared to conventional organisers
- Retention at 7/30/90 days
- App Store rating >= 4.5
- Zero data leaves the device without explicit user action

---

## 18. Risks and Mitigations

| Risk | Mitigation |
|------|-----------|
| 3D palace feels gimmicky | Organiser mode is fully standalone and excellent on its own. Palace is opt-in enhancement |
| Performance on low-end devices | Low-poly aesthetic, aggressive LOD, Godot lightweight renderer |
| Hybrid complexity (Flutter + Godot) | Clean data boundary via shared SQLite. Each side owns its domain |
| Scope creep | Features are modular. Each room, each game mechanic is independent |
| "Just another to-do app" | The spatial memory angle is genuinely novel and scientifically grounded |
| Mobile touch controls feel clunky | Standard FPS mobile patterns (virtual joystick + touch-look) are well-established. Configurable layout |

---

*This document is the single source of truth for MindHause product requirements. Updated 2026-02-15.*
