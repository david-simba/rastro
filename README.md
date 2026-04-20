# Rastro

Real-time public transit tracker for mobile. Shows live bus positions on a 3D map, lets users explore routes and stops, and handles authentication — all in a multi-package Flutter monorepo.

<img width="1920" height="1440" alt="271shots_so" src="https://github.com/user-attachments/assets/a027dff6-563d-46d0-914b-30fb2732fe71" />

## Packages

| Package | Description |
|---|---|
| [`rastro_app`](./rastro_app) | Main Flutter application — screens, features, routing, and providers |
| [`live_map`](./live_map) | Live map widget with real-time 3D vehicle tracking, routes, and stop pins (Mapbox) |
| [`design_system`](./design_system) | Shared UI library — themes, colors, typography, and all reusable widgets |
| [`network`](./network) | HTTP client built on Dio — typed errors, `Result` type, and interceptors |

## Project structure

```
Rastro/
├── rastro_app/      # The app itself
├── live_map/        # Mapbox-based live map package
├── design_system/   # Component and token library
└── network/         # HTTP client package
```

## Getting started

```bash
# Install dependencies for all packages
cd rastro_app && flutter pub get
cd ../live_map && flutter pub get
cd ../design_system && flutter pub get
cd ../network && flutter pub get

# Run the app
cd rastro_app && flutter run
```

## Environment

Create `rastro_app/assets/config/.env.dev` before running:

```
APP_ENV=development
MAPBOX_ACCESS_TOKEN=pk.your_token_here
```

## Tech stack

- **Flutter + Dart** — cross-platform mobile
- **Riverpod** — state management
- **GoRouter** — navigation
- **Mapbox Maps Flutter** — map rendering
- **Firebase** (Auth + Firestore) — backend and authentication
- **Dio** — HTTP client
