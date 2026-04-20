# rastro_app

Main Flutter application for Rastro — a real-time public transit tracker. Uses `design_system`, `live_map`, and `network` as local packages, and Firebase as the backend.

## What it does

- Shows a live map with 3D bus models that move in real time.
- Lets users browse routes and see their stops on a timeline.
- Authenticates users with email/password or Google Sign-In.
- Supports light and dark themes, persisted across sessions.

## Features

| Feature | What it covers |
|---|---|
| `auth` | Login, registration, and Google OAuth. Session persisted via Firebase Auth. |
| `home` | Dashboard with active vehicles, nearby stops, and quick actions. |
| `map` | Full-screen live map. Tracks a selected vehicle, draws its route, and shows stop pins. |
| `routes` | Paginated list of all available routes, filterable by tab. |
| `vehicles` | Real-time vehicle data from Firestore. |
| `stops` | Stop catalog fetched from Firestore. |
| `search` | Cross-feature search over routes and stops. |
| `profile` | User profile, theme toggle, feedback, and about screens. |

## Architecture

Each feature follows a three-layer structure:

```
feature/
├── data/          # Firestore datasources and repository implementations
├── domain/        # Entities and repository interfaces
└── presentation/  # Riverpod notifiers, screens, and widgets
```

The `core/` folder holds app-wide concerns: routing (`GoRouter`), providers, layout shell, and config.

## Environment

Config is loaded from `assets/config/.env.dev` at startup. Required keys:

```
APP_ENV=development
MAPBOX_ACCESS_TOKEN=pk.your_token
```
