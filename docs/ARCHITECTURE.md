# MindHause — Architecture Document

> **Framework:** Flutter 3.38.x / Dart 3.10.x (app shell + organiser) + Godot 4.x / GDScript (3D palace)
> **State Management:** Riverpod
> **Storage:** SQLite (on-device, shared between Flutter and Godot)
> **Backend:** None — all on-device, privacy-first
> **Target Platforms:** Android (primary), iOS (primary), Web (secondary), Desktop (stretch)

---

## 1. Architecture Overview

MindHause is a **hybrid application** — a Flutter app that embeds a Godot 4 runtime for the 3D palace experience. Each half owns its domain:

```
┌──────────────────────────────────────────────────────┐
│                    Flutter App Shell                  │
│                                                      │
│  ┌─────────────────┐      ┌────────────────────────┐ │
│  │  Organiser Mode  │      │     Palace Mode         │ │
│  │   (Flutter UI)   │◄────►│   (Embedded Godot)      │ │
│  │                  │      │                         │ │
│  │ • Task lists     │      │ • First-person 3D       │ │
│  │ • Calendar       │      │ • Room navigation       │ │
│  │ • Projects/Goals │      │ • Object interaction    │ │
│  │ • Notes          │      │ • Monster AI            │ │
│  │ • Search/Filter  │      │ • Cat companion         │ │
│  │ • Map views      │      │ • Lighting/audio        │ │
│  │ • Settings       │      │ • Focus mode (3D)       │ │
│  └────────┬─────────┘      └───────────┬────────────┘ │
│           │                            │              │
│           ▼                            ▼              │
│  ┌─────────────────────────────────────────────────┐  │
│  │            Shared SQLite Database                │  │
│  │                                                  │  │
│  │  tasks • projects • goals • habits • notes       │  │
│  │  rooms • surfaces • settings • user_prefs        │  │
│  └─────────────────────────────────────────────────┘  │
│                                                      │
│  ┌─────────────────────────────────────────────────┐  │
│  │            Platform Services Layer               │  │
│  │                                                  │  │
│  │  Notifications • Calendar API • File I/O         │  │
│  └─────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘
```

### 1.1 Why Hybrid?

| Concern | Flutter alone | Godot alone | Hybrid |
|---------|--------------|-------------|--------|
| First-person 3D | Cannot do it | Excellent | Godot handles it |
| Native app UI | Excellent | Passable at best | Flutter handles it |
| Maps/geospatial | Native widgets | Needs WebView hack | Flutter handles it |
| Calendar/notifications | Native APIs | Custom plugins per platform | Flutter handles it |
| Cross-platform mobile | Android + iOS + Web | Android + iOS + Web | Both contribute |
| App store deployment | Standard | Non-standard for "apps" | Flutter wraps everything |
| Performance on mobile | Excellent for UI | Excellent for 3D | Each does what it's good at |

### 1.2 Data Boundary

The **SQLite database** is the single source of truth. Both Flutter and Godot read and write to it:

- Flutter writes: task CRUD, project management, settings changes, calendar imports
- Godot writes: object positions, room assignments, monster state, last interaction timestamps
- Both read: everything they need for their respective views

There is no complex IPC. The database is the bridge. When the user flips between modes, the active mode reads current state from SQLite.

---

## 2. Flutter Side — App Shell and Organiser

### 2.1 Technology Choices

| Concern | Choice | Rationale |
|---------|--------|-----------|
| **State Management** | Riverpod | Type-safe, testable, compile-time checked. Current Flutter community standard |
| **Database** | Drift (SQLite) | Type-safe Dart SQLite wrapper, generates query code, migrations built in |
| **Routing** | GoRouter | Declarative, deep-link support, Flutter team maintained |
| **Maps** | flutter_map + OpenStreetMap | No API key required, free tiles, on-device friendly |
| **Calendar** | device_calendar | Reads native calendar on-device (no cloud) |
| **Notifications** | flutter_local_notifications | On-device scheduling, no push server needed |
| **Theming** | Material 3 with custom theme | Matches Greco-Roman warmth, adaptable for future skins |

### 2.2 Project Structure (Flutter)

```
lib/
├── main.dart                        # App entry point
├── app/
│   ├── app.dart                     # MaterialApp + GoRouter setup
│   ├── theme.dart                   # App-wide theming (Greco-Roman palette)
│   └── constants.dart               # App-wide constants
│
├── features/
│   ├── tasks/
│   │   ├── data/
│   │   │   ├── task_repository.dart
│   │   │   └── task_model.dart
│   │   ├── domain/
│   │   │   └── task_entity.dart
│   │   └── presentation/
│   │       ├── task_list_screen.dart
│   │       ├── task_detail_screen.dart
│   │       ├── task_create_sheet.dart
│   │       └── widgets/
│   │
│   ├── projects/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── goals/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── habits/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── notes/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── calendar/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── palace/
│   │   └── palace_view.dart         # Embeds the Godot runtime
│   │
│   ├── map_mode/
│   │   └── presentation/
│   │       └── location_map_screen.dart
│   │
│   ├── quick_capture/
│   │   └── presentation/
│   │       └── quick_capture_sheet.dart
│   │
│   ├── search/
│   │   └── presentation/
│   │       └── search_screen.dart
│   │
│   └── settings/
│       ├── data/
│       └── presentation/
│           ├── settings_screen.dart
│           └── palace_preferences_screen.dart  # Monster/cat/focus toggles
│
├── shared/
│   ├── database/
│   │   ├── app_database.dart        # Drift database definition
│   │   ├── tables/                  # Table definitions
│   │   └── daos/                    # Data access objects
│   ├── models/                      # Shared data models
│   ├── widgets/                     # Reusable widgets
│   └── utils/                       # Helpers, formatters, extensions
│
└── services/
    ├── notification_service.dart
    ├── calendar_sync_service.dart
    └── godot_bridge_service.dart     # Communication with Godot runtime
```

### 2.3 Feature-First Architecture

Each feature module follows a **data / domain / presentation** split:

- **data/** — Repository implementations, data models (DB-facing), data sources
- **domain/** — Entities (pure Dart, no framework deps), business logic
- **presentation/** — Screens, widgets, Riverpod providers/notifiers

Features are independent. The task feature doesn't import from the project feature directly — shared data flows through the database and Riverpod providers.

---

## 3. Godot Side — Palace Engine

### 3.1 Technology

| Concern | Choice | Rationale |
|---------|--------|-----------|
| **Engine** | Godot 4.x | Free, MIT licensed, lightweight, mobile-friendly, GDScript |
| **Language** | GDScript | Python-like, fast iteration, no build step |
| **3D Renderer** | Godot Forward+ (desktop) / Mobile renderer (mobile) | Automatic quality scaling |
| **Physics** | Godot built-in | CharacterBody3D for player and monsters |
| **Navigation** | NavigationServer3D | Pathfinding for cat and monsters |

### 3.2 Godot Project Structure

```
godot_palace/
├── project.godot
├── scenes/
│   ├── Main.tscn                    # Root scene, loads house + player
│   ├── player/
│   │   └── Player.tscn              # CharacterBody3D + Camera3D + RayCast3D
│   ├── house/
│   │   ├── House.tscn               # Full house layout
│   │   ├── rooms/
│   │   │   ├── Foyer.tscn
│   │   │   ├── Study.tscn
│   │   │   ├── Library.tscn
│   │   │   ├── Bedroom.tscn
│   │   │   ├── Kitchen.tscn
│   │   │   ├── Gymnasium.tscn
│   │   │   ├── Workshop.tscn
│   │   │   ├── Garden.tscn
│   │   │   ├── Corridor.tscn
│   │   │   ├── Treasury.tscn
│   │   │   └── Cellar.tscn
│   │   └── elements/
│   │       ├── Door.tscn
│   │       ├── PlacementSurface.tscn # Desk, shelf, pedestal, wall hook
│   │       ├── Sundial.tscn
│   │       └── Torch.tscn
│   ├── objects/
│   │   ├── TaskObject.tscn          # Base interactable task object
│   │   ├── variants/
│   │   │   ├── Scroll.tscn
│   │   │   ├── Book.tscn
│   │   │   ├── Candle.tscn
│   │   │   ├── Statue.tscn
│   │   │   ├── Letter.tscn
│   │   │   ├── Blueprint.tscn
│   │   │   ├── Plant.tscn
│   │   │   ├── PostIt.tscn
│   │   │   ├── Jar.tscn
│   │   │   └── Key.tscn
│   │   └── MonsterTask.tscn         # Evolved task creature
│   ├── companions/
│   │   └── Cat.tscn                 # Cat companion with navigation AI
│   └── ui/
│       ├── HUD.tscn                 # In-palace overlay (task count, prompts)
│       ├── TaskPanel.tscn           # Inspect/edit task from within palace
│       └── FocusOverlay.tscn        # Focus mode visual treatment
│
├── scripts/
│   ├── player/
│   │   └── player.gd               # FPS movement, interaction, raycasting
│   ├── house/
│   │   ├── door.gd                  # Door open/close animation + interaction
│   │   └── placement_surface.gd     # Surface that accepts task objects
│   ├── objects/
│   │   ├── task_object.gd           # Base task object logic
│   │   └── monster_task.gd          # Monster behaviour, chasing AI
│   ├── companions/
│   │   └── cat.gd                   # Cat AI — wander, lead, sit near tasks
│   ├── systems/
│   │   ├── task_manager.gd          # Loads tasks from DB, spawns objects
│   │   ├── monster_system.gd        # Evolution timer, corruption logic
│   │   ├── lighting_cycle.gd        # Time-of-day based lighting
│   │   ├── focus_mode.gd            # Focus mode visual + timer
│   │   ├── audio_manager.gd         # Ambient, interaction, feedback sounds
│   │   └── db_bridge.gd             # SQLite read/write from Godot side
│   └── ui/
│       ├── hud.gd
│       └── task_panel.gd
│
├── assets/
│   ├── models/                      # 3D models (.glb / .gltf)
│   ├── textures/                    # Materials, surfaces
│   ├── audio/
│   │   ├── ambient/                 # Per-room ambient loops
│   │   ├── sfx/                     # Interaction sounds
│   │   └── music/                   # Time-of-day background
│   └── fonts/
│
└── export_presets/
    ├── android.cfg
    └── ios.cfg
```

### 3.3 Embedding Godot in Flutter

Godot 4 can export as:
- **Android:** An AAR (Android Archive) library
- **iOS:** A framework/XCFramework

Flutter embeds these via **platform views**:

```
Flutter App
  └── PlatformView (Android: SurfaceView / iOS: UIView)
        └── Godot Runtime
              └── Palace scene
```

The `palace_view.dart` widget in Flutter manages:
- Launching the Godot view when the user enters palace mode
- Passing the database path so Godot knows where to read/write
- Receiving signals when the user wants to exit back to organiser
- Handling lifecycle (pause/resume when switching modes)

### 3.4 Flutter ↔ Godot Communication

Communication is minimal by design. The database is the primary channel.

| Direction | Method | Purpose |
|-----------|--------|---------|
| Flutter → Godot | Method channel (platform) | "Enter palace," pass DB path, user settings |
| Godot → Flutter | Method channel (platform) | "Exit palace," "open task in organiser," "show map for location" |
| Both → DB | SQLite read/write | All data synchronisation |

No real-time streaming needed. When the user flips modes, the receiving side reads current state from SQLite.

---

## 4. Database Schema

All on-device. Single SQLite file at the app's documents directory.

### 4.1 Core Tables

```sql
-- Tasks, notes, events — everything is an "item"
CREATE TABLE items (
    id              TEXT PRIMARY KEY,
    title           TEXT NOT NULL,
    description     TEXT DEFAULT '',
    type            TEXT NOT NULL,  -- 'task', 'note', 'event', 'habit'
    priority        TEXT DEFAULT 'normal',  -- 'low', 'normal', 'high'
    status          TEXT DEFAULT 'todo',  -- 'todo', 'in_progress', 'done', 'archived'
    due_date        TEXT,  -- ISO 8601
    created_at      TEXT NOT NULL,
    updated_at      TEXT NOT NULL,
    last_interaction TEXT NOT NULL,
    completed_at    TEXT,
    room            TEXT,  -- FK to rooms.id
    surface         TEXT,  -- surface identifier within room
    object_type     TEXT DEFAULT 'scroll',
    position_x      REAL DEFAULT 0.0,
    position_y      REAL DEFAULT 0.0,
    position_z      REAL DEFAULT 0.0,
    project_id      TEXT,  -- FK to projects.id
    goal_id         TEXT,  -- FK to goals.id
    monster_state   TEXT DEFAULT 'none',  -- 'none', 'neglected', 'corrupting', 'monster'
    monster_evolved_at TEXT,
    recurrence_rule TEXT,  -- iCal RRULE format or null
    location_lat    REAL,
    location_lng    REAL,
    location_name   TEXT,
    notes           TEXT DEFAULT ''
);

CREATE TABLE subtasks (
    id          TEXT PRIMARY KEY,
    item_id     TEXT NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    title       TEXT NOT NULL,
    done        INTEGER DEFAULT 0,
    sort_order  INTEGER DEFAULT 0
);

CREATE TABLE tags (
    id      TEXT PRIMARY KEY,
    name    TEXT NOT NULL UNIQUE,
    color   TEXT
);

CREATE TABLE item_tags (
    item_id TEXT NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    tag_id  TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (item_id, tag_id)
);

CREATE TABLE projects (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT DEFAULT '',
    color       TEXT DEFAULT '#8B7355',
    room        TEXT,
    wing        TEXT,
    created_at  TEXT NOT NULL,
    archived    INTEGER DEFAULT 0
);

CREATE TABLE goals (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT DEFAULT '',
    target_date TEXT,
    status      TEXT DEFAULT 'active',  -- 'active', 'achieved', 'abandoned'
    created_at  TEXT NOT NULL
);

CREATE TABLE habits (
    id              TEXT PRIMARY KEY,
    item_id         TEXT NOT NULL REFERENCES items(id),
    frequency       TEXT NOT NULL,  -- 'daily', 'weekly', 'custom'
    current_streak  INTEGER DEFAULT 0,
    best_streak     INTEGER DEFAULT 0,
    last_completed  TEXT
);

CREATE TABLE habit_log (
    id          TEXT PRIMARY KEY,
    habit_id    TEXT NOT NULL REFERENCES habits(id) ON DELETE CASCADE,
    completed_at TEXT NOT NULL
);

-- Palace-specific
CREATE TABLE rooms (
    id              TEXT PRIMARY KEY,
    name            TEXT NOT NULL,
    display_name    TEXT NOT NULL,
    category        TEXT,  -- 'work', 'personal', 'health', 'creative', etc.
    description     TEXT DEFAULT '',
    unlocked        INTEGER DEFAULT 1,
    sort_order      INTEGER DEFAULT 0
);

CREATE TABLE surfaces (
    id          TEXT PRIMARY KEY,
    room_id     TEXT NOT NULL REFERENCES rooms(id),
    name        TEXT NOT NULL,  -- 'desk_main', 'shelf_left', 'wall_board'
    type        TEXT NOT NULL,  -- 'desk', 'shelf', 'wall', 'pedestal', 'floor'
    capacity    INTEGER DEFAULT 10,
    position_x  REAL DEFAULT 0.0,
    position_y  REAL DEFAULT 0.0,
    position_z  REAL DEFAULT 0.0
);

-- User preferences
CREATE TABLE settings (
    key     TEXT PRIMARY KEY,
    value   TEXT NOT NULL
);
```

### 4.2 Default Settings

```
monsters_enabled: true
monster_sensitivity: normal  -- slow, normal, fast
monster_chasing: true
cat_enabled: true
focus_duration: 25           -- minutes
theme: greco_roman
default_room: foyer
quick_capture_room: foyer
```

---

## 5. Key Architectural Decisions

### 5.1 No Backend

All data lives on-device in SQLite. No accounts, no cloud sync, no analytics. If the user wants to back up, they export the database file. Future cloud sync would be additive, not required.

### 5.2 Riverpod for State

Riverpod was chosen over BLoC, Provider, or GetX because:
- Compile-time safety (no runtime ProviderNotFoundException)
- Testable without widget tree
- Code generation reduces boilerplate
- Natural fit for the repository pattern
- Good async support for database operations

### 5.3 Drift for SQLite

Drift (formerly Moor) was chosen over sqflite or floor because:
- Type-safe query building in Dart
- Reactive streams (watch queries for live UI updates)
- Built-in migration support
- Both Flutter and Godot can access the same SQLite file (Godot via GDExtension or GDScript SQLite plugin)

### 5.4 Feature-First Module Structure

Features are self-contained modules rather than technical-layer grouping (no global `models/`, `screens/`, `controllers/` folders). This means:
- Adding a new feature doesn't touch existing code
- Features can be developed and tested independently
- Matches the modular nature of the product (each room/feature is independent)

### 5.5 Godot as Library, Not App

Godot doesn't run as a standalone app. It's compiled as a library embedded in the Flutter app. This means:
- Single app binary on the store
- Flutter controls the lifecycle
- User never sees Godot chrome/splash
- Clean transition between organiser and palace modes

---

## 6. Performance Considerations

### 6.1 Mobile 3D

The palace uses low-poly geometry with baked lighting where possible:
- Simple meshes for rooms (box geometry with arch/column details)
- Low-poly task objects (< 500 tris each)
- Texture atlasing to reduce draw calls
- Godot's Mobile renderer for phones (Forward+ for high-end)
- LOD on distant objects
- Rooms load/unload as player moves through doors (streaming)

### 6.2 Memory

- Only the current room + adjacent rooms are fully loaded
- Distant rooms are unloaded or reduced to placeholder geometry
- Task objects in unloaded rooms exist only in the database
- Target: < 200MB RAM for the palace view

### 6.3 Battery

- Palace mode is more battery-intensive than organiser mode
- Frame rate capped at 30fps on mobile (60 optional)
- Organiser mode uses standard Flutter rendering (minimal battery)
- Focus mode reduces rendering complexity (dark scene, one spotlight)

---

## 7. Testing Strategy

### 7.1 Flutter

- **Unit tests:** Business logic, repositories, Riverpod providers
- **Widget tests:** Individual screens and components
- **Integration tests:** Full user flows (create task → view in list → mark complete)
- **Database tests:** Schema migrations, CRUD operations, edge cases

### 7.2 Godot

- **Scene tests:** Object spawning, interaction triggers, door mechanics
- **AI tests:** Monster pathfinding, cat behaviour, edge cases
- **Performance tests:** Frame rate benchmarks on target devices

### 7.3 Integration

- **Cross-mode tests:** Create task in organiser → verify appears in palace (via DB)
- **Mode switch tests:** Enter palace → exit → verify organiser state correct

---

## 8. Build and Deploy

### 8.1 Repository Structure

```
mindhause/
├── docs/                    # Documentation (PRD, Architecture, Changelog)
├── lib/                     # Flutter/Dart source
├── test/                    # Flutter tests
├── android/                 # Android platform (includes Godot AAR)
├── ios/                     # iOS platform (includes Godot framework)
├── web/                     # Web platform
├── assets/                  # Flutter assets (images, fonts)
├── godot_palace/            # Godot project (separate directory)
│   ├── project.godot
│   ├── scenes/
│   ├── scripts/
│   ├── assets/
│   └── export_presets/
├── pubspec.yaml
└── README.md
```

### 8.2 Build Pipeline

1. **Godot export** → Compile palace as Android AAR + iOS framework
2. **Copy artifacts** → Place in `android/` and `ios/` platform directories
3. **Flutter build** → Standard `flutter build apk` / `flutter build ios`
4. **Result** → Single app binary containing both Flutter UI and Godot palace

### 8.3 Development Workflow

During development, the two sides can be worked on independently:
- **Organiser work:** Standard `flutter run` — palace view shows a placeholder
- **Palace work:** Open `godot_palace/` in Godot editor, run standalone for testing
- **Integration:** Build Godot export, embed in Flutter, test full flow

---

*Architecture document for MindHause. Updated 2026-02-15.*
