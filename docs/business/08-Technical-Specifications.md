# MindHause — Technical Specifications

## 1. Stack overview

Hybrid mobile architecture: **Flutter for the app shell + organiser, Godot 4 for the 3D palace, SQLite as the single shared data store.** All on-device. No backend.

| Layer | Technology | Purpose |
|---|---|---|
| App shell | Flutter 3.38.x / Dart 3.10.x | Organiser UI, calendar, settings, notifications, app navigation, IAP, store integration |
| State management | Riverpod | Reactive state for Flutter UI |
| Database | Drift (SQLite wrapper) | Type-safe Dart access to local SQLite |
| 3D engine | Godot 4.0.stable (Mobile profile) | First-person palace, navigation, cat AI, monsters |
| Embedding (Android) | `flutter_godot` package (or `FlutDot`) | PlatformView + Godot scene + two-way signal comms |
| Embedding (iOS) | `SwiftGodotKit` via custom Flutter PlatformView wrapper | SwiftUI/UIKit-native Godot embedding; ~30MB binary cost; **no iOS Simulator support — device-only testing**; requires `-lc++` linker flag + MetalFX.framework |
| Cross-engine comms | Signal-based (modelled on iOS NotificationCenter) | Two-way data between Flutter shell + Godot palace |
| Underlying | `libGodot` | Makes Godot embeddable as a library, not just standalone |
| Routing | GoRouter | Flutter-side navigation |
| Maps (where applicable) | flutter_map + OpenStreetMap | Outdoor / location-aware features (if needed; currently optional) |
| 3D shading | GDShader (Godot's shading language) | 8 themed shaders + painterly post-process |
| Platforms (primary) | Android (API 26+), iOS (15+) | Mobile-first |
| Platforms (stretch) | Web (PWA), Desktop (Windows/macOS) | Not v1 |

---

## 2. Architecture diagram (text form)

```
┌─────────────────────────────────────────────────────────────────────┐
│                          MINDHAUSE APP                              │
│                                                                     │
│  ┌──────────────────────────────┐    ┌──────────────────────────┐  │
│  │      FLUTTER (App Shell)     │    │     GODOT 4 (Palace)     │  │
│  │  ─────────────────────────   │    │  ──────────────────────  │  │
│  │  • Organiser mode UI         │    │  • 10 rooms (.tscn)      │  │
│  │  • Calendar / list views     │    │  • Cat (6 modules)       │  │
│  │  • Settings / themes         │    │  • Monster system        │  │
│  │  • Notifications (local)     │    │  • Theme switching       │  │
│  │  • IAP (StoreKit / Billing)  │    │  • Cinematic cameras     │  │
│  │  • Onboarding                │    │  • Painterly post-FX     │  │
│  │  • Settings export/import    │    │  • Audio                 │  │
│  └────────────┬─────────────────┘    └──────────┬───────────────┘  │
│               │                                  │                   │
│               │      Platform View bridge        │                   │
│               │   ◄──────────────────────────►   │                   │
│               │                                  │                   │
│               ▼                                  ▼                   │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │              LOCAL SQLITE DATABASE (Drift)                   │  │
│  │   ─────────────────────────────────────────────────────────  │  │
│  │   • tasks, projects, goals, habits, notes                    │  │
│  │   • themes, settings, focus_sessions                         │  │
│  │   • decisions, framework_analyses (DecisionLens integration) │  │
│  │   • decision_room_bindings (decisions ↔ rooms)               │  │
│  │   • Single source of truth, both engines read/write          │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │  NO BACKEND. NO CLOUD. NO ACCOUNTS. NO TELEMETRY.          │    │
│  └────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. Flutter side detail

### 3.1 Package conventions (`lib/`)
- `app/` — top-level routing + theming
- `features/` — feature-specific UI + business logic (one folder per feature: tasks, projects, calendar, etc.)
- `services/` — cross-cutting (database, notifications, IAP)
- `shared/` — widgets, models, utilities used across features
- `main.dart` — entry point

### 3.2 Key dependencies (current)
- `flutter_riverpod` — state management
- `drift` + `drift_dev` — SQLite ORM with code generation
- `go_router` — navigation
- `flutter_local_notifications` — local-only notifications
- `in_app_purchase` — IAP across iOS + Android
- `path_provider` — local filesystem access
- `intl` — localisation primitives (deferred — English-only at launch)

### 3.3 Build targets
- **Android**: minSdk 26 (covers ~98% of active devices), targetSdk current; AAB submission to Play Console
- **iOS**: minimum iOS 15 (covers ~95% of active devices); both iPhone + iPad universal
- **Architecture**: arm64 only (Android + iOS); 32-bit Android dropped for binary size

---

## 4. Godot side detail

### 4.1 Project structure (`godot_palace/`)
- `scenes/rooms/` — 10 room scenes (foyer/library/study/.../garden/.../treasury)
- `scenes/elements/` — door, placement_surface (reusable instances)
- `scenes/effects/` — painterly overlay
- `scenes/player/` — first-person controller
- `scenes/characters/cat.tscn` — cat companion
- `scripts/autoload/` — singletons (load order matters)
- `scripts/rooms/` — room manager
- `scripts/ai/` — monster system
- `models/` — cats, objects, furniture (canonical paths)
- `assets/` — vendor models, materials, textures (gitignored heavy folders)
- `shaders/` — 8 .gdshader files
- `audio/` — sfx (committed) + sonniss/ (gitignored — fetched separately)

### 4.2 Autoload load order (project.godot)
**Order matters. All other autoloads depend on DatabaseBridge.**
1. `DatabaseBridge` — gateway to the shared SQLite store
2. `TimeOfDay` — clock/lighting state
3. `GameState` — runtime palace state
4. `AudioManager` — sound playback orchestration
5. `ThemeManager` — applies materials via `themed_geometry` group

### 4.3 Key architectural conventions
- **Rooms** are separate `.tscn` files instantiated by `house.tscn` orchestrator
- **Wall doorways** are CSG subtraction operations (`operation = 2`) as children of wall nodes
- **Doors** auto-transition on `body_entered` with `GameState.door_cooldown` (2s) preventing bounce
- **Door hinge** placement: DoorPanel at x=-0.6 with children offset +0.6 (pivot at left edge)
- **Camera height** 1.6m for both head-bob centre and resting lerp target
- **Cat** lives in 6 modules (companion / brain / movement / animation / procedural / skin) plus per-theme cat_<theme>.glb model
- **Theme system** applies materials via the `themed_geometry` group on CSG nodes; runtime swap is non-destructive

### 4.4 Godot 4.0 gotchas (lessons learned, in memory)
- No `.is_empty()` — use `.size() == 0` or `== ""`
- No `maxf()`/`clampf()`/`absf()` — use `max()`/`clamp()`/`abs()`
- No `JSON.parse_string()` — use `JSON.new()` + `.parse()`
- No `not in` operator
- No `static var` — use autoload singletons for shared state
- No `emission_energy_multiplier` — use `emission_energy`
- `var x :=` fails when RHS returns Variant — use explicit types
- `.tscn` files use `;` (INI-style) for comments
- `.gd` files use `#` (Python-style) for comments — DON'T conflate
- Don't hand-craft UIDs in .tscn headers — crashes scene loader
- `.gdignore` files prevent Godot indexing folders (used to prevent 28GB Sonniss bundle import storm)

---

## 5. Data model (SQLite schema, current + planned)

### 5.1 Core tables (Built, with DecisionLens additions Designed)

```sql
-- Core productivity tables
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  notes TEXT,
  state TEXT CHECK(state IN ('new','in_progress','urgent','completed','neglected','corrupting')),
  project_id INTEGER REFERENCES projects(id),
  room_id TEXT,                -- which room the object lives in
  surface_id TEXT,             -- which placement_surface within that room
  object_type TEXT,            -- scroll / book / candle / statue / letter / blueprint / plant / post_it / jar / key
  created_at INTEGER, updated_at INTEGER, completed_at INTEGER, due_at INTEGER
);

CREATE TABLE projects (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  notes TEXT, color TEXT,
  created_at INTEGER, updated_at INTEGER
);

CREATE TABLE goals (
  id INTEGER PRIMARY KEY,
  title TEXT, target_date INTEGER,
  reflection TEXT,
  created_at INTEGER, updated_at INTEGER
);

CREATE TABLE habits (
  id INTEGER PRIMARY KEY,
  title TEXT, cadence TEXT, streak INTEGER,
  last_completed_at INTEGER, created_at INTEGER
);

CREATE TABLE notes (
  id INTEGER PRIMARY KEY,
  title TEXT, body TEXT,
  created_at INTEGER, updated_at INTEGER
);

CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT
);
-- Settings keys: theme, painterly_enabled, painterly_strength,
-- monster_sensitivity, cat_enabled, focus_duration

-- DecisionLens integration (Designed; Phase 1 of integration roadmap)
CREATE TABLE decisions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL, description TEXT,
  category TEXT,                -- quick_check / daily / short_term / long_term / life_changing
  status TEXT,                  -- draft / active / completed / archived
  confidence_score REAL,        -- 0.0 .. 1.0
  rag_override TEXT,            -- null | green | amber | red
  rag_override_note TEXT,
  created_at INTEGER, updated_at INTEGER, completed_at INTEGER
);

CREATE TABLE framework_analyses (
  id TEXT PRIMARY KEY,
  decision_id TEXT REFERENCES decisions(id) ON DELETE CASCADE,
  framework_type TEXT,          -- swot / matrix / eisenhower / tlx / support_circle
  data TEXT,                    -- JSON blob, framework-specific schema
  is_complete INTEGER,
  updated_at INTEGER
);

CREATE TABLE decision_room_bindings (
  decision_id TEXT REFERENCES decisions(id) ON DELETE CASCADE,
  room_id TEXT,
  surface_id TEXT,
  PRIMARY KEY (decision_id, room_id)
);
```

### 5.2 Migration discipline
- Drift handles schema versions via migration files
- Each schema change → new Drift migration → version bump → tested against existing app data
- Backwards-compatible reads where possible

---

## 6. Cross-engine data access

The `DatabaseBridge` autoload is the canonical Godot-side access point. All Godot scenes go through it; never direct SQL.

```
DatabaseBridge
  ├─ _ensure_initialized() — guard on every public method
  ├─ get_setting(key) / set_setting(key, value)
  ├─ list_tasks_in_room(room_id)
  ├─ update_task_state(task_id, state)
  ├─ get_decision(decision_id)
  ├─ upsert_framework_analysis(decision_id, type, data, is_complete)
  └─ ...
```

Flutter accesses the same database directly via Drift; no inter-process boundary needed because both Flutter and Godot are in the same process via the Platform View.

---

## 7. Performance budget

### 7.1 Frame rate targets
- **Mid-range device (e.g. Pixel 6, iPhone 12)**: 60fps locked in palace mode
- **Low-end device (e.g. Pixel 4, iPhone XR)**: 30fps acceptable in palace; 60fps in organiser
- **Tablet / iPad**: 60fps + higher resolution

### 7.2 Memory targets
- **App startup peak**: <250MB
- **Steady state (in palace, one room loaded)**: <400MB
- **Theme switch transient**: <500MB (no leaks across switches)

### 7.3 Storage targets
- **App binary**: <150MB initial download; theme packs as on-demand IAP downloads to keep base app slim
- **User data**: typical user <10MB SQLite even with years of use; pathological users <100MB

### 7.4 Battery
- **Idle in organiser mode**: negligible drain (no background work)
- **Active in palace mode for 10 min**: <5% battery (informal target; measured per device)

### 7.5 What we don't do (performance-protective)
- No always-on cat AI computation when palace is closed
- No background sync (because no cloud)
- No notifications about random app engagement; only user-requested
- No "the cat misses you" engagement-farming push notifications

---

## 8. Security model

### 8.1 Threat model
- **Adversary**: someone with physical access to the unlocked device
- **Asset to protect**: user's tasks, notes, decisions (their entire mental load)
- **Not in scope**: nation-state actors, sophisticated forensics on a stolen unlocked device

### 8.2 Defences
- **At rest**: SQLite database in app sandbox (OS-level protection: iOS data protection class, Android internal storage)
- **In transit**: no network transit by design; this entire category is N/A
- **In memory**: standard process isolation; no special protections beyond OS defaults
- **Optional future**: encrypted database (SQLCipher) for users who want belt-and-suspenders. Not v1.

### 8.3 What we explicitly don't do
- No analytics SDKs that might exfiltrate identifiers
- No crash reporting that includes user content (Sentry, if used, configured to mask user data)
- No remote configuration / kill-switches
- No A/B testing infrastructure (would require analytics)
- No usage telemetry of any kind

---

## 9. Accessibility

- **OS-level accessibility honoured**: Dynamic Type / large text (iOS), TalkBack / accessibility services (Android)
- **VoiceOver in organiser mode**: fully supported (Flutter widget tree is accessible)
- **Palace mode**: less accessible by nature (3D first-person is visual); we document this honestly in the accessibility statement and ensure the organiser mode is a complete alternative
- **Colour contrast**: WCAG AA target for all UI text; AAA where feasible
- **Reduced motion option**: disables head bob and camera transitions; respects OS-level "reduce motion" setting

---

## 10. Build & CI/CD

[FILL: specific CI/CD provider — Codemagic, GitHub Actions, Bitrise]

Pipeline (intended):
- Lint + analyze on push to any branch
- Unit tests on push to main + PRs
- Build artefacts (AAB + IPA) on tag
- TestFlight + Play Internal Track distribution from CI on release tags
- Manual promotion to production stores

---

## 11. Versioning & release

- **Semantic versioning**: MAJOR.MINOR.PATCH (e.g. 1.0.0 launch, 1.1.0 second theme pack, 1.0.1 bugfix)
- **Theme packs**: shipped as IAP-unlockable content, not separate app versions
- **Breaking changes**: deferred where possible; MAJOR bump if data model changes require migration

---

## 12. Observability without surveillance

We can't run analytics SDKs. We can:
- **App Store / Play Console first-party metrics** — installs, conversions, ratings (all aggregate, no PII)
- **Optional crash reporting (Sentry)** — configured to never report user-supplied content; sample crash stacktrace + device class only. Privacy policy discloses this clearly.
- **User feedback** via direct email and review responses — the qualitative truth-source
- **Beta channel** for pre-release signal

This is genuinely less data than typical product teams have. We pay that cost on principle and trust the qualitative loop.
