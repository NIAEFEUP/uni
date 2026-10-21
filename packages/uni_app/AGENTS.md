# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Dependencies
flutter pub get

# Code quality (run in this order before committing)
dart fix --apply && dart format . && dart analyze .

# Tests
flutter test
flutter test test/path/to/test_file.dart   # single file

# Code generation (ObjectBox, JsonSerializable, Mockito)
dart pub run build_runner build --delete-conflicting-outputs

# Localization — after editing .arb files in /l10n/
dart pub global activate intl_utils 2.1.0
dart pub global run intl_utils:generate
```

Linter: `leancode_lint` + `custom_lint`. Generated files (`**.g.dart`, `**.mocks.dart`, `**/generated/**`) are excluded from analysis and must be committed.

## Architecture

The app is a Flutter/Riverpod app that scrapes [SIGARRA](https://sigarra.up.pt/) (University of Porto's academic portal). It never calls a backend we own — all data comes from HTML scraping or OIDC.

### Layer overview

```
view/          → Riverpod consumer widgets; never call fetchers or controllers directly
model/
  providers/   → CachedAsyncNotifier subclasses; reactive state + cache management
  entities/    → ObjectBox @Entity models (pure data)
controller/
  fetchers/    → HTTP + HTML → entity; implement SessionDependantFetcher
  parsers/     → HTML → entity (called by fetchers)
  local_storage/ → ObjectBox DB, SharedPreferences, migrations
  networking/  → NetworkRouter; builds Sigarra URLs from session
http/client/   → AuthenticatedClient (cookie injection), TimeoutClient
session/       → two auth flows (credentials vs federated OIDC)
sigarra/       → typed Sigarra endpoint definitions
```

### `CachedAsyncNotifier<T>`

All network-backed providers extend this. On `build()`:
1. Loads from ObjectBox (storage).
2. If cache timestamp (in SharedPreferences) is expired or data is empty, fetches from network.
3. On network failure, falls back to last known cached value.

Call `ref.watch(xyzProvider)` in widgets; `ref.refresh(xyzProvider)` to force reload; never instantiate fetchers from views.

### Authentication flows (`/session/`)

Two flows, both expose `Session` (immutable — use `copyWith` to update):

- **Credentials** (`flows/credentials/`): POST username/password to SIGARRA; parse HTML for success/failure; cookies injected via `CookieClient`.
- **Federated** (`flows/federated/`): OIDC Authorization Code + PKCE against UP's IdP; exchanges access token for SIGARRA cookies via `SigarraOidc().token()`.

Always pass cookies as a lambda `() => session.cookies` — not the value — so they're fresh after session refresh.

### URL construction

Never hardcode SIGARRA URLs. Use `NetworkRouter.getBaseUrl(faculty)` or `NetworkRouter.getBaseUrlsFromSession(session)`. Pattern: `https://sigarra.up.pt/{faculty}/{language}/{endpoint}`.

### Data persistence

| Data | Storage |
|---|---|
| Entity data (profiles, schedules, …) | ObjectBox (`Database()`) |
| User preferences, cache timestamps | `SharedPreferences` via `PreferencesController` |
| Credentials / session tokens | `flutter_secure_storage` |
| Notification state | JSON file in `documents/` via `NotificationTimeoutStorage` |
| Temporary files | `cache/` directory; auto-cleaned after 7 days |

### Database schema migrations

`MigrationController.runMigrations()` runs on launch. When changing an ObjectBox `@Entity`, add a migration step to `migrations/migrations.dart` and increment `MigrationController.currentPreferencesVersion`.

### Localization

All UI strings go in `l10n/app_pt.arb` (Portuguese) and `l10n/app_en.arb` (English), then run `intl_utils:generate`. Use as `S.of(context).myKey` — never hardcode strings.

### Navigation

Routes are declared in `NavigationItem` enum (`utils/navigation_items.dart`) and wired in `main.dart`'s `transitionFunctions` map. Navigate with `Navigator.of(context).pushNamed('/route')`. Some routes are faculty-gated via `NavigationItem.faculties`.

### UI / Design system

Components live in the sibling `uni_ui` package. Use tokens from `uni_ui/lib/theme.dart` — no hardcoded colors, typography, or spacing. Generic reusable widgets (no providers) → `uni_ui`. Feature-specific widgets (depend on providers) → `uni_app`. Never import Material directly in `uni_app`.
