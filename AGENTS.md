# uni

uni is the mobile app (Flutter, Android + iOS) for students of the University of Porto, built by [NIFEUP](https://niaefeup.pt/). It has no backend of its own. All data comes from [SIGARRA](https://sigarra.up.pt/) (U.Porto's academic portal), either by scraping HTML/JSON or through U.Porto's OIDC login.

## Repository layout

This is a Dart **pub workspace** (root `pubspec.yaml` → `workspace:`). One `flutter pub get` at the root resolves every package.

| Package | Role | Guide |
|---|---|---|
| `packages/uni_app` | The app: screens, state, SIGARRA networking, auth, local storage | [`packages/uni_app/AGENTS.md`](packages/uni_app/AGENTS.md) |
| `packages/uni_ui` | Reusable UI components and the theme, with no app state | [`packages/uni_ui/AGENTS.md`](packages/uni_ui/AGENTS.md) |
| `packages/uni_lint` | `custom_lint` plugin with the project's custom lint rules | [`packages/uni_lint/AGENTS.md`](packages/uni_lint/AGENTS.md) |

**Before changing code in a package, read that package's `AGENTS.md`.** This file only holds what applies to the whole repo.

Dependency direction: `uni_app` → `uni_ui` → (dev) `uni_lint`. `uni_ui` must never depend on `uni_app`.

Other top-level folders: `.github/` (CI, PR template, CONTRIBUTING), `whatsnew/` (store release notes), `readme-src/` (README images).

## Toolchain

- Flutter version is pinned in `.fvmrc`. Use `fvm flutter …` (or the Nix dev shell from `flake.nix` / `.envrc`) so you don't build with a different SDK.
- Install the format hook once: `sh pre-commit-hook.sh` (runs `dart format` on staged files).

## Checks (same order as CI, `.github/workflows/format_lint_test.yaml`)

Run them from the repo root unless stated otherwise:

```bash
flutter pub get
dart format $(find . -type f -name "*.dart" -not -name "*.g.dart" -not -name "*.mocks.dart") --set-exit-if-changed
flutter analyze .
cd packages/uni_app && flutter test      # CI only runs tests for uni_app
```

A change is done only when all three pass.

## Repo-wide rules

- **Generated files** (`*.g.dart`, `*.mocks.dart`, `lib/generated/**`, `objectbox-model.json`) are never edited by hand. Regenerate them (see the package guide) and **commit** them.
- **User-facing text** must exist in both Portuguese and English (see `uni_app` l10n).
- **No new dependencies** unless there's no clean way to do it with what's already in the package's `pubspec.yaml`.
- Keep changes focused: no drive-by refactors or reformatting of unrelated files.

## Git and PRs

- Base branch is `develop` (not `master`).
- Branch names follow conventional branching: `feat/…`, `fix/…`, `chore/…`, `docs/…`.
- Commit messages follow conventional commits: `fix(ios): …`, `feat: …`.
- PRs fill in `.github/pull_request_template.md`. UI changes need screenshots, light + dark mode, PT + EN text, text zoom and screen sizes checked.
- Don't commit version bumps. CI does that (`Bump app version … [no ci]`).

More background: [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md) and the [project wiki](https://github.com/niaefeup/uni/wiki).
