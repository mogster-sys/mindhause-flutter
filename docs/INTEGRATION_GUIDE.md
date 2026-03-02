# MindHause — Flutter + Godot Integration Guide

> Step-by-step checklist for connecting the Flutter organiser and the Godot palace into a single app. This covers what's automated, what's manual, and what order to do things in.

---

## Current State

As of 2026-02-15:

- **Flutter side:** Fully functional organiser with Drift database, Riverpod state management, GoRouter navigation, and four feature screens (Tasks, Projects, Notes, Settings). Compiles clean with zero analysis errors.
- **Godot side:** Complete project with all scripts AND all scene files (.tscn) pre-built as text. 10 rooms, player, HUD, cat, doors, surfaces, task objects — all wired up. The Godot editor just needs to open the project and run it.
- **Shared:** Both sides target the same SQLite database file (`mindhause.sqlite` in the app's documents directory).

### What's Already Built (No Editor Work Needed)

All of these were generated as plain-text .tscn files — Godot will parse them automatically when you open the project:

| Scene | Path | Contents |
|-------|------|----------|
| **Root** | `scenes/rooms/house.tscn` | Main scene — instances Player, Cat, HUD, MonsterSystem, RoomsContainer |
| **Player** | `scenes/player/player.tscn` | CharacterBody3D, Camera3D (fov 75), RayCast3D (8m range), CapsuleShape3D |
| **HUD** | `scenes/ui/hud.tscn` | Reticule dot, InfoPanel (task title/priority/due/monster), InteractHint, FadeOverlay |
| **Cat** | `scenes/characters/cat.tscn` | CharacterBody3D, CapsuleMesh (orange), NavigationAgent3D, AnimationTree |
| **Door** | `scenes/elements/door.tscn` | BoxMesh door, Area3D trigger, AnimationPlayer |
| **Surface** | `scenes/elements/placement_surface.tscn` | StaticBody3D, BoxMesh, collision — used as desks/shelves/walls/etc. |
| **Task Object** | `scenes/objects/task_object.tscn` | RigidBody3D — spawned by room_manager for each task in the database |
| **Foyer** | `scenes/rooms/foyer.tscn` | 12×5×10m marble hall, chandelier lights, 3 surfaces, doors to all ground-floor rooms + stairs |
| **Study** | `scenes/rooms/study.tscn` | 8×4×8m dark wood, desk lamp + overhead, desk/shelf/frame, door to foyer |
| **Library** | `scenes/rooms/library.tscn` | 10×6×12m tall room, 3 reading lamps, table/shelves/display, doors to foyer + garden |
| **Kitchen** | `scenes/rooms/kitchen.tscn` | 8×4×8m stone floor, counter CSG, counter/table/notice board, doors to foyer + workshop |
| **Workshop** | `scenes/rooms/workshop.tscn` | 10×4×10m industrial, workbench CSG, bench/tool wall/floor area, door to kitchen |
| **Garden** | `scenes/rooms/garden.tscn` | 14×6×14m open courtyard (no ceiling), DirectionalLight3D sunlight, fountain, bench/planter/pedestal, door to library |
| **Bedroom** | `scenes/rooms/bedroom.tscn` | 8×4×8m cozy, bed CSG (purple), nightstand/desk/shelf, stairs to foyer + door to gymnasium |
| **Gymnasium** | `scenes/rooms/gymnasium.tscn` | 12×5×12m training hall, wood beam, bench/trophies/chalkboard, doors to bedroom + treasury |
| **Treasury** | `scenes/rooms/treasury.tscn` | 6×4×6m vault, gold trim + spotlights, pedestal/display/wall mount, door to gymnasium |
| **Cellar** | `scenes/rooms/cellar.tscn` | 10×3.5×10m underground, stone pillars, torch lights, table/shelf/floor, stairs to foyer |

### Room Layout

```
                     UPPER FLOOR
    [Bedroom] ←→ [Gymnasium] ←→ [Treasury]
        ↕ stairs

                     GROUND FLOOR
    [Library] ←→ [FOYER] ←→ [Study]
        ↕              ↕
    [Garden]     [Kitchen] ←→ [Workshop]
                       ↕ stairs

                     BASEMENT
                   [Cellar]
```

---

## Integration Checklist

### A. Get Godot Running Standalone First

Everything is pre-built. You just need to open the project, install one plugin, and hit play.

- [ ] **1. Open the project in Godot 4.3+**
  - Launch Godot → click **Import** (not New or Scan)
  - Navigate to `mindhause/godot_palace/` and select `project.godot`
  - Click **Import & Edit**
  - Godot will scan all the .tscn and .gd files automatically — this takes a few seconds

- [ ] **2. Install godot-sqlite plugin**
  - Download from: https://github.com/2shady4u/godot-sqlite/releases
  - You want the latest release ZIP for Godot 4.x
  - Extract it so you get `godot_palace/addons/godot-sqlite/` with the native libraries inside
  - Back in Godot: **Project → Project Settings → Plugins** tab → find "godot-sqlite" → tick **Enable**
  - This provides the `SQLite` class used by `database_bridge.gd`

- [ ] **3. Verify autoloads are registered**
  - Go to **Project → Project Settings → Autoload** tab (or press Ctrl+Shift+A)
  - You should see three entries (defined in project.godot):
    - `GameState` → `res://scripts/autoload/game_state.gd`
    - `DatabaseBridge` → `res://scripts/autoload/database_bridge.gd`
    - `TimeOfDay` → `res://scripts/autoload/time_of_day.gd`
  - If they're missing, click **Add** for each: browse to the script path, set the node name, click Add

- [ ] **4. Set the main scene**
  - **Project → Project Settings → General** tab → search for "main scene" (or look under Application → Run)
  - Set it to `res://scenes/rooms/house.tscn`
  - This should already be set in project.godot but verify it

- [ ] **5. Verify input actions**
  - **Project → Project Settings → Input Map** tab
  - These should already exist from project.godot:
    - `move_forward` (W), `move_back` (S), `move_left` (A), `move_right` (D)
    - `interact` (E / left-click), `pause` (Escape)
  - If missing, add them manually with those keys

- [ ] **6. Hit Play (F5)**
  - You should spawn in the Foyer with a crosshair reticule
  - WASD to move, mouse to look
  - Walk toward a wall where a door is — the cat should follow you around
  - The room_manager loads the foyer first, then transitions when you interact with doors

- [ ] **7. (Optional) Bake navigation meshes**
  - This is only needed for proper cat pathfinding. Without it the cat uses direct movement.
  - To add: open a room scene → Add Child Node → NavigationRegion3D → select it → in the Inspector add a NavigationMesh resource → click **Bake NavigationMesh** in the toolbar above the viewport
  - Do this for each room you want the cat to navigate smoothly in

### B. Export Godot as a Library

This is the step that turns Godot from a standalone app into an embeddable component.

- [ ] **Android: Export as AAR**
  ```
  Godot Editor → Project → Export → Add Android preset
  - Enable "Use Gradle Build"
  - Export as: android_release.aar (or debug variant)
  ```
  - The AAR goes into `android/app/libs/` in the Flutter project
  - Add to `android/app/build.gradle`:
    ```gradle
    dependencies {
        implementation fileTree(dir: 'libs', include: ['*.aar'])
    }
    ```

- [ ] **iOS: Export as XCFramework**
  ```
  Godot Editor → Project → Export → Add iOS preset
  - Export as framework
  ```
  - Place in `ios/Frameworks/`
  - Add to Xcode project via `ios/Runner.xcworkspace`

### C. Create the Flutter ↔ Godot Bridge

- [ ] **Create `lib/services/godot_bridge_service.dart`**
  ```dart
  // Method channel for Flutter → Godot communication
  class GodotBridgeService {
    static const _channel = MethodChannel('com.mindhause/godot');

    // Tell Godot the database path
    Future<void> setDatabasePath(String path) async {
      await _channel.invokeMethod('setDatabasePath', {'path': path});
    }

    // Enter palace mode
    Future<void> enterPalace({String? room}) async {
      await _channel.invokeMethod('enterPalace', {'room': room ?? 'foyer'});
    }

    // Exit palace mode (called from Godot side)
    void onExitPalace(VoidCallback callback) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'exitPalace') callback();
      });
    }
  }
  ```

- [ ] **Create `lib/features/palace/palace_view.dart`**
  - Uses `AndroidView` / `UiKitView` to embed the Godot runtime
  - Manages lifecycle (pause Godot when organiser is active)
  - Passes database path on launch

- [ ] **Add palace route to `app.dart`**
  ```dart
  GoRoute(
    path: '/palace',
    builder: (context, state) => const PalaceView(),
  ),
  ```

- [ ] **Add "Enter Palace" button to the app shell / task list**

### D. Shared Database Path

Both Flutter and Godot must access the **same SQLite file**. The path resolution:

| Platform | Path |
|----------|------|
| **Android** | `getApplicationDocumentsDirectory()` → typically `/data/data/com.mindhause.app/files/` |
| **iOS** | `getApplicationDocumentsDirectory()` → typically `/var/mobile/Containers/Data/Application/.../Documents/` |
| **Desktop (dev)** | `getApplicationDocumentsDirectory()` → OS-specific documents folder |

- Flutter resolves this via `path_provider` (already imported)
- Godot resolves this via `OS.get_data_dir()` (already in `database_bridge.gd`)
- On Android/iOS, these resolve to the same app sandbox directory

**Critical:** Pass the resolved path from Flutter to Godot via the method channel on palace launch. Don't let Godot guess — Flutter knows the authoritative path.

### E. Build Pipeline

The full build flow once integration is complete:

```
1. godot_palace/ → Export AAR (Android) + XCFramework (iOS)
2. Copy AAR → android/app/libs/
3. Copy XCFramework → ios/Frameworks/
4. flutter build apk --release  (or: flutter build ios --release)
5. Result: single app binary with both Flutter UI and Godot palace
```

For development:
- **Organiser work:** `flutter run` — palace button shows "Coming soon" or a placeholder
- **Palace work:** Open `godot_palace/` in Godot editor, run standalone
- **Integration testing:** Full export → embed → build flow

### F. Platform View Setup (Android)

The Android-specific embedding requires:

- [ ] **Create `android/app/src/main/kotlin/.../GodotPlatformView.kt`**
  - Extends `PlatformView`
  - Hosts the Godot `SurfaceView`
  - Handles lifecycle callbacks

- [ ] **Register the platform view factory in `MainActivity.kt`**

- [ ] **Add to `AndroidManifest.xml`:**
  ```xml
  <meta-data
      android:name="godot_project_path"
      android:value="res://project.godot" />
  ```

### G. Platform View Setup (iOS)

- [ ] **Create `ios/Runner/GodotPlatformView.swift`**
  - Implements `FlutterPlatformView`
  - Hosts the Godot `UIView`

- [ ] **Register in `AppDelegate.swift`**

---

## Integration Order (Recommended)

1. **Get Godot running standalone** (Section A) — most of the work
2. **Export as library** (Section B) — one-time setup per platform
3. **Create bridge service** (Section C) — small amount of Dart code
4. **Wire up the database path** (Section D) — critical but simple
5. **Platform view setup** (Section F/G) — boilerplate, follow the pattern
6. **Test the full flow** — create task in organiser → see it in palace

---

## Collision Layer Reference

| Layer | Bit | Used By |
|-------|-----|---------|
| 1 | World geometry | CSG walls/floors/ceilings (use_collision = true) |
| 2 | Player | player.tscn CharacterBody3D |
| 4 | Task objects | task_object.tscn RigidBody3D |
| 8 | Doors | door.tscn trigger Area3D |
| 16 | Cat | cat.tscn CharacterBody3D |
| 32 | Monsters | (reserved for monster_system) |
| 64 | Surfaces | placement_surface.tscn StaticBody3D |

The player's InteractRay has collision_mask = 124 (layers 4+8+16+32+64), meaning it detects task objects, doors, the cat, monsters, and surfaces — but not walls or itself.

---

## Known Gotchas

### Database Locking
SQLite allows multiple readers but only one writer. Since Flutter and Godot won't be writing simultaneously (user is in one mode or the other), this isn't a problem in practice. But if you ever have background writes (e.g., monster evolution timer in Godot while Flutter is active), use WAL mode:

```sql
PRAGMA journal_mode=WAL;
```

Drift enables this by default. The Godot SQLite plugin may need it set explicitly.

### Godot Lifecycle on Mobile
When Flutter covers the Godot view (switching to organiser mode), the Godot runtime should be **paused**, not destroyed. Destroying and recreating it is expensive. The platform view implementation should handle `onPause()` / `onResume()` properly.

### Asset Size
The Godot export can be large (30-80MB depending on assets). For the app store:
- Use Android App Bundles (AAB) instead of APK — Google Play handles device-specific asset delivery
- Compress textures aggressively (ETC2 for Android, ASTC for iOS)
- Consider loading room assets on demand rather than bundling everything

### Touch Input Conflict
When the Godot view is active, it needs to capture touch events. When Flutter is active, Godot should NOT consume touches. The platform view's `hitTestBehavior` should be set to `PlatformViewHitTestBehavior.opaque` when palace is active.

---

## Reference Repos

| Repo | Contents | URL |
|------|----------|-----|
| **mindhause** (this repo) | Flutter organiser + Godot palace | github.com/mogster-sys/mindhause |
| **MindHause** (original Godot) | Nearly empty Godot project (superseded) | github.com/mogster-sys/MindHause |
| **mindhause-spaces** | React landing page with theme textures + cats | github.com/mogster-sys/mindhause-spaces |

The original MindHause Godot repo can be archived — everything is now in `godot_palace/` within this monorepo.

---

*Integration guide for MindHause. Updated 2026-02-15.*
