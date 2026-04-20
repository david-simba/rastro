# design_system

Shared UI library for the Rastro app. Contains all colors, typography, spacing, and reusable widgets so every screen looks and feels consistent.

## What's inside

- **Theme** — light and dark `ThemeData` (`DsTheme.light` / `DsTheme.dark`), semantic color tokens (`DsThemeColors`), typography scale (`DsTypography`), and spacing/radius constants (`DsLayout`).
- **Widgets** — buttons, cards, badges, bottom sheets, a floating nav bar, a timeline, toasts, a search bar, text field, avatar, tab selector, toggle, loader, empty state, and more.

## How to use it

```dart
// 1. Apply themes in MaterialApp
MaterialApp(
  theme: DsTheme.light,
  darkTheme: DsTheme.dark,
)

// 2. Import and use any widget
import 'package:design_system/design_system.dart';

DsButton(label: 'Continue', onPressed: () {});
DsText('Hello', variant: TextVariant.title);
```

## Importing

Always import the barrel file — never import individual source files directly:

```dart
import 'package:design_system/design_system.dart';
```
