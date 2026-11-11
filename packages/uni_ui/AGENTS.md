# uni_ui

Reusable Flutter UI components and the theme for the uni app. It has **no app state**: no Riverpod, no SIGARRA, no storage. `uni_app` imports it as `package:uni_ui/...`. Repo-wide rules are in the [root AGENTS.md](../../AGENTS.md).

## Commands (run inside `packages/uni_ui`)

```bash
flutter pub get
dart format . && flutter analyze .
```

There are no tests in this package yet. Check changes by running `uni_app` and viewing the screens that use the widget, in light **and** dark mode.

## What lives here

- `lib/theme.dart`: app theme, shared colors, badge colors, system overlay styles.
- `lib/icons.dart`: shared icon registry.
- `lib/common/`: shared shape and decoration helpers.
- `lib/common_widgets/`: generic reusable widgets.
- `lib/cards/`, `lib/calendar/`, `lib/courses/`, `lib/modal/`, `lib/navbar/`, `lib/tabs/`, `lib/timeline/`: feature-specific UI pieces.

## Rules

- A widget belongs here only if it's generic: data comes in through constructor parameters and events go out through callbacks. If it needs a provider, it belongs in `uni_app`.
- **No hardcoded user-facing strings.** Text comes in as parameters, because translations live in `uni_app`.
- Use `Theme.of(context).colorScheme` and the existing tokens in `theme.dart` before adding new colors.
- Keep internal imports as `package:uni_ui/...`.
- Match the existing style: Material 3, rounded shapes, card-like surfaces.
- Keep public APIs small. Only add a parameter if several callers need it. Renaming or removing a parameter breaks `uni_app`, so update its call sites in the same change.
- No new dependencies unless Flutter plus the current packages can't do it cleanly.
- Put new widgets in the nearest existing folder. If a change affects several widgets, change the shared helper in `common/` or `theme.dart` instead.
