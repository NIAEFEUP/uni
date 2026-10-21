# uni_ui

This package contains reusable Flutter UI components for the Uni app.
It is intentionally small, so keep guidance lightweight and practical.

## What lives here

- `lib/theme.dart` centralizes the app theme, shared colors, badge colors, and system overlay styles.
- `lib/icons.dart` exposes the shared icon registry used across components.
- `lib/common/` contains shared shape and decoration helpers.
- `lib/common_widgets/` contains generic reusable widgets.
- `lib/cards/`, `lib/calendar/`, `lib/courses/`, `lib/modal/`, `lib/navbar/`, `lib/tabs/`, and `lib/timeline/` group feature-specific UI pieces.

## Working rules

- Prefer small, reusable widgets over large composite widgets.
- Reuse `Theme.of(context).colorScheme` and existing theme tokens before introducing new colors.
- Keep internal imports using `package:uni_ui/...` paths.
- Match the existing style: Material 3, rounded shapes, and card-like surfaces are common patterns.
- Keep constructors and public APIs simple; only add parameters that are clearly useful to multiple callers.
- Avoid adding new dependencies unless a feature cannot be implemented cleanly with Flutter and the current packages.

## Editing expectations

- Make focused changes that stay close to the existing structure.
- Prefer adjusting shared helpers in `common/` or `theme.dart` when a change affects multiple widgets.
- If you add a new widget family, place it in the nearest existing folder instead of creating a new top-level area.
