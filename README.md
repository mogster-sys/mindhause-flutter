# MindHause

> A first-person memory palace organiser — all the features of a task planner, wrapped in a house you walk through.

## What Is This?

MindHause is a productivity app where your to-dos, notes, goals, and habits live as physical objects inside a navigable 3D house. Instead of scrolling a list, you walk through rooms, pick up scrolls, place books on shelves, and organise your life spatially — the way human memory actually works.

Tasks you avoid slowly turn into monsters that chase you around.

A cat helps.

You can flip it back to a normal organiser in one tap.

## Architecture

**Hybrid: Flutter + Godot 4**

- **Flutter** — App shell, organiser UI, calendar, maps, settings, notifications
- **Godot 4** — First-person 3D palace, room navigation, object interaction, monsters, cat companion
- **SQLite** — Shared on-device database, no backend, no accounts, privacy-first

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full technical design.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| App Shell | Flutter 3.38.x / Dart 3.10.x |
| State Management | Riverpod |
| Database | Drift (SQLite) |
| 3D Engine | Godot 4.x / GDScript |
| Maps | flutter_map + OpenStreetMap |
| Routing | GoRouter |
| Platforms | Android, iOS (primary), Web (secondary) |

## Project Documentation

- [docs/PRD.md](docs/PRD.md) — Product Requirements Document (complete)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — Architecture and design decisions
- [docs/CHANGELOG.md](docs/CHANGELOG.md) — Release changelog

## Project Structure

```
mindhause/
├── docs/                    # PRD, Architecture, Changelog
├── lib/                     # Flutter/Dart source
│   ├── app/                 # App config, theme, routing
│   ├── features/            # Feature modules (tasks, projects, goals, etc.)
│   ├── shared/              # Database, models, widgets, utils
│   └── services/            # Notifications, calendar, Godot bridge
├── godot_palace/            # Godot 4 project (3D palace engine)
│   ├── scenes/              # Room scenes, player, objects, UI
│   ├── scripts/             # GDScript (player, AI, systems)
│   └── assets/              # 3D models, textures, audio
├── test/                    # Flutter tests
├── android/                 # Android platform (includes Godot AAR)
├── ios/                     # iOS platform (includes Godot framework)
└── web/                     # Web platform
```

## Getting Started

```bash
# Flutter organiser (standalone, palace shows placeholder)
flutter pub get
flutter run

# Godot palace (standalone, for 3D development)
# Open godot_palace/ in Godot 4 editor

# Full integration build
# 1. Export Godot as AAR/framework
# 2. flutter build apk / flutter build ios
```

## Development

The two halves can be developed independently:
- **Organiser work:** `flutter run` — standard Flutter development
- **Palace work:** Godot editor — standalone 3D scene testing
- **Integration:** Build Godot export, embed in Flutter, test mode switching

## License

TBD
