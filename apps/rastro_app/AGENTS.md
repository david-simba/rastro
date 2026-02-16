# AGENTS.md

This project follows a strict Feature-First Clean Architecture using:

- data / domain / presentation layers
- MVVM in presentation
- Riverpod for state management
- go_router for navigation
- No BLoC
- No extra infrastructure layer

All AI agents must follow these constraints.

---

# 1. Global Architecture

Dependency direction:

presentation  →  domain  ←  data

Domain is the center.
Both data and presentation depend on domain.
Domain depends on nothing.

---

# 2. Import Rules (Strict)

┌───────────────┬─────────────────────┬─────────────────────────────────────────┐
│     Layer     │     Can import      │              Cannot import              │
├───────────────┼─────────────────────┼─────────────────────────────────────────┤
│ domain/       │ Nothing (pure Dart) │ data/, presentation/, Flutter SDK       │
├───────────────┼─────────────────────┼─────────────────────────────────────────┤
│ data/         │ domain/             │ presentation/                           │
├───────────────┼─────────────────────┼─────────────────────────────────────────┤
│ presentation/ │ domain/             │ data/ (except through providers wiring) │
└───────────────┴─────────────────────┴─────────────────────────────────────────┘

Violating this rule is not allowed.

---

# 3. Wiring Exception (Composition Root)

Inside:

presentation/providers/

Riverpod providers may instantiate concrete implementations from data/
and bind them to contracts from domain/.

Example:
- MapRepositoryImpl (data)
- IMapRepository (domain)

This is the ONLY place where presentation touches data.

This file acts as the per-feature composition root.

No service locator (GetIt) is allowed.

---

# 4. Current Directory Structure (Authoritative)

lib/
├── main.dart
├── core/
│   ├── config/
│   │   └── app_config.dart
│   ├── providers/
│   │   └── core_providers.dart
│   └── utils/
│       └── geo_utils.dart
│
└── features/
└── map/
├── data/
│   ├── datasources/
│   │   └── simulation_datasource.dart
│   ├── mappers/
│   │   └── position_mapper.dart
│   └── repositories/
│       └── map_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── vehicle_position.dart
│   └── repositories/
│       └── i_map_repository.dart
│
└── presentation/
├── providers/
│   ├── map_notifier.dart
│   └── map_state.dart
├── screens/
│   └── map_screen.dart
└── widgets/
├── event_debug_list.dart
├── map_controls.dart
└── map_view.dart

This structure must be preserved.

---

# 5. Layer Responsibilities

## DOMAIN
- Pure Dart
- No Flutter
- No external packages
- Contains:
    - Entities
    - Repository contracts
- No business logic tied to frameworks

---

## DATA
- Implements repository contracts
- Contains:
    - Datasources (mock, remote, local)
    - Repository implementations
    - Mappers (DTO ↔ Entity)
- No UI logic

---

## PRESENTATION
- Flutter UI
- Riverpod Notifier / AsyncNotifier
- UI state classes
- Screens and widgets
- No direct datasource usage

Business logic must live inside Notifier, not widgets.

---

# 6. State Management Rules

- Riverpod only
- Notifier or AsyncNotifier
- ViewModel and Provider may live in same file
- No BLoC
- No Cubit
- No global mutable state

---

# 7. Design Philosophy

- Clean but pragmatic
- Production-ready
- No over-engineering
- No unnecessary abstraction
- No premature scalability layers
- Keep each feature isolated

---

Any code that breaks these rules must be rejected or refactored.
