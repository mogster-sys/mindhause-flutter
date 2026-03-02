# Changelog

## [0.2.0] - 2026-02-15

### Added — Flutter
- Complete organiser UI: Tasks (list + detail + create), Projects, Notes, Settings screens
- Riverpod providers for all features (task filtering, project listing, notes, settings)
- Task card widget with priority indicators, due date formatting, monster badges
- Create task bottom sheet with priority chips, date picker, room dropdown
- GoRouter shell route with bottom navigation (Tasks, Projects, Notes, Settings)
- Material 3 Greco-Roman theme (marble, terracotta, bronze-gold, ink-dark)
- Palace screen placeholder (ready for Godot platform view embedding)
- Flutter-Godot bridge service with MethodChannel (enterPalace, pausePalace, taskSelected)
- "Enter Palace" FAB on app shell
- Palace route (/palace) with room parameter

### Added — Godot
- 11 GDScript files: player controller, room manager, HUD reticule, cat companion (7 states), monster system, database bridge, time-of-day lighting, doors, placement surfaces, task objects
- 17 scene files (.tscn) written as plain text — no editor work needed:
  - Root house scene wiring player, cat, HUD, monster system
  - Player (CharacterBody3D + Camera3D + RayCast3D)
  - Cat (CharacterBody3D + NavigationAgent3D + CapsuleMesh)
  - HUD (reticule, info panel, interact hint, fade overlay)
  - Door and placement surface element scenes
  - 10 rooms with CSG geometry, lighting, doors, surfaces:
    Foyer (12x5x10m), Study (8x4x8m), Library (10x6x12m), Kitchen (8x4x8m),
    Workshop (10x4x10m), Garden (14x6x14m open-air), Bedroom (8x4x8m),
    Gymnasium (12x5x12m), Treasury (6x4x6m), Cellar (10x3.5x10m)
- project.godot with autoloads, input map, collision layers, mobile renderer
- 8 theme texture sheets imported (Greco-Roman, Modern Loft, Victorian Scholar, Sci-Fi Minimal, Gothic Cathedral, Japanese Ryokan, Countryside Cottage, Fallout Bunker)

### Added — Documentation
- Design Notes (cat psychology, monster design, ADHD-friendly rationale, audio strategy)
- Asset Strategy (free resources, AI generation, production pipeline, budget)
- Integration Guide (step-by-step Godot setup, export as library, bridge wiring, gotchas)
- Theme Reference (8 themes with palettes, materials, lighting, cat familiars, Godot color values)
- Collision layer reference table
- Room layout diagram

### Fixed
- Drift seed data: Value vs plain String in insert companions
- DropdownButtonFormField deprecated value parameter
- Missing Room import in settings screen
- Non-nullable field null checks in settings screen
- SubtasksCompanion sortOrder default value handling
- Widget test updated for MindHauseApp

## [0.1.0] - 2026-02-15

### Added
- Complete Product Requirements Document (PRD) with full feature specification
- Architecture document defining Flutter + Godot 4 hybrid approach
- Database schema design (SQLite, on-device, privacy-first)
- Feature-first project structure with Riverpod state management
- 11-room house layout specification (Foyer through Cellar)
- Task object system with 10 object types and 6 visual states
- Monster task evolution system (neglect → corruption → monster)
- Cat companion specification
- Behavioural nudge system (time-of-day, focus mode, ambient feedback)
- Organiser mode feature set (tasks, projects, goals, habits, notes, calendar)
- Godot palace engine project structure
- Build pipeline for hybrid Flutter/Godot deployment

## [0.0.1] - 2026-02-14

### Added
- Initial Flutter project scaffold
- Project documentation structure (PRD, Architecture, Changelog)
- GitHub repository setup
- Android, iOS, and Web platform targets
