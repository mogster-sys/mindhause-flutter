# MindHause - Architecture Document

> **Framework:** Flutter 3.38.x / Dart 3.10.x
> **State Management:** TBD (based on PRD complexity)
> **Backend:** TBD
> **Target Platforms:** Android, iOS, Web

---

## Project Structure

```
mindhause/
├── docs/                  # Project documentation
│   ├── PRD.md            # Product Requirements Document
│   ├── ARCHITECTURE.md   # This file
│   └── CHANGELOG.md      # Release notes
├── lib/                   # Dart/Flutter source
│   ├── main.dart         # App entry point
│   ├── app/              # App-level config, theme, routing
│   ├── features/         # Feature modules
│   ├── shared/           # Shared widgets, utils, models
│   └── services/         # API, storage, platform services
├── test/                  # Unit & widget tests
├── assets/               # Images, fonts, animations
├── android/              # Android platform code
├── ios/                  # iOS platform code
└── web/                  # Web platform code
```

## Architecture Decisions

*Will be populated after PRD review.*
