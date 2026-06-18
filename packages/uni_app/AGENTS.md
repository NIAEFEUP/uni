## Development Commands

### Setup & Dependencies
```bash
# Get all dependencies
flutter pub get
```

### Code Quality & Formatting
```bash
# Auto-format code (required before commit)
dart format .

# Fix common issues automatically
dart fix --apply

# Run linter analysis (required before commit)
dart analyze .

# Run all quality checks
dart fix --apply && dart format . && dart analyze .
```

### Code Generation
```bash
# Generate localization from .arb files
dart pub global activate intl_utils 2.1.0
dart pub global run intl_utils:generate

# Generate ObjectBox ORM code (auto-run on pub get usually)
dart pub run build_runner build --delete-conflicting-outputs
```

### Testing & Debugging
```bash
# Run all unit and widget tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run with coverage
flutter test --coverage
```

---

## Development Guidelines & Rules

### Never Commit
- `.env` files or any file with secrets (API keys, tokens, credentials)
- Uncommented debug code (`print()` statements, debugPrint)
- Code that fails format, linter, or test checks
- Large test data files or binary assets

### Code Quality Standards
**BEFORE COMMITTING - Run in order:**
1. `dart fix --apply` — Auto-fix common issues
2. `dart format .` — Format all code
3. `dart analyze .` — Check for lint violations
4. `flutter test` — Run all tests
5. Verify all pass before pushing

### Localization (Multi-Language Support)
**Never hardcode strings for UI or error messages!**

**Pattern:**
1. Add string to `/l10n/app_pt.arb` (Portuguese)
2. Add corresponding string to `/l10n/app_en.arb` (English)
3. Run: `dart pub global run intl_utils:generate`
4. Use in code:
```dart
import 'package:uni/generated/l10n.dart';

// In widget build method
Text(S.of(context).myStringKey);
```

### URLs & Endpoints
**Never hardcode URLs or base paths!**

- Use `NetworkRouter.getUrls()` from `/controller/networking/network_router.dart`
- See example in `fees_fetcher.dart`
- URLs are automatically adjusted per faculty/session
- Base URL pattern: `https://sigarra.up.pt/{faculty}/{language}/`

### Data Fetching Pattern
**Never call fetchers directly from UI!**

```dart
// Correct — in a widget:
ref.watch(profileProvider).whenData((profile) {
  return ProfileWidget(profile);
});

// To force refresh:
ref.refresh(profileProvider);

// Wrong — don't do this:
final profile = await ProfileFetcher().fetch(session);
```

### Data Persistence Rules
- **User preferences** (theme, language) → `SharedPreferences` via `PreferencesController`
- **Entity data** (profiles, schedules, etc.) → `ObjectBox` (auto-initialized)
- **Session/credentials** → `FlutterSecureStorage` (Keychain on iOS, Keystore on Android — encrypted by the OS)
- **Notification state** → JSON file in `getApplicationDocumentsDirectory()` via `NotificationTimeoutStorage`
- **Temporary files** → `cache/` directory; auto-cleanup after 7 days via `cleanup.dart`
- Never store sensitive data in ObjectBox or SharedPreferences — use `flutter_secure_storage`

### Architecture Rules
- **Controllers** call fetchers, manage business logic
- **Providers** wrap controllers with caching & reactive state
- **Views** only use providers (never call controllers directly)
- **Models** contain entities, converters, services (pure data layer)
- Use `CachedAsyncNotifier<T>` for all network-dependent data

### Adding Features Checklist
- [ ] Add data model/entity if needed
- [ ] Create fetcher if data comes from network
- [ ] Create parser if scraping HTML responses
- [ ] Wrap fetcher with Riverpod provider + caching
- [ ] Add localized strings to `.arb` files
- [ ] Create/update view screens
- [ ] Add route to `utils/navigation_items.dart`
- [ ] Run format, linter, analyze, tests
- [ ] Create migration if database schema changed

---

## Project Structure

Our working files are in `/lib` folder with the following architecture:

### `main.dart` - Application Entry Point

- Loads `.env` for Plausible analytics (`PLAUSIBLE_URL`, `PLAUSIBLE_DOMAIN`)
- Initializes `SharedPreferences`, runs `MigrationController`, initializes ObjectBox
- Configures `Workmanager` for background tasks and `SentryFlutter` for error tracking
- Wrapped in `ProviderScope` (Riverpod) and `SentryFlutter`
- Initial route is `/splash` → resolves to `/area` (valid session) or `/login` (no session)

**Adding a New Route:**
1. Add entry to `NavigationItem` enum in `utils/navigation_items.dart`
2. Add route handler in `transitionFunctions` map in `main.dart`
3. Use `Navigator.of(context).pushNamed('/my_route')`

---

### `/model` - Data Layer & State Management

#### `/providers/riverpod/` - Riverpod State Providers
Most extend `CachedAsyncNotifier<T>` — checks cache timestamp in SharedPreferences before fetching from network.

Key providers:
- `sessionProvider` — authentication state
- `profileProvider` — user profile, courses, fees, print balance
- `lectureProvider` — timetable
- `examProvider` — exam schedule
- `calendarProvider` — academic calendar
- `restaurantProvider` — cafeteria menus
- `connectivityProvider` — network status (sync)
- `themeProvider` / `localeProvider` — UI preferences (sync)

**Caching:** if cache expired (> `cacheDuration`), fetches from network and updates timestamp. On network failure, falls back to cached data.

#### `/entities/` - ObjectBox Data Models
All decorated with `@Entity()`. Core entities: `Profile`, `Course`, `CourseUnit`, `Lecture`, `Exam`, `CalendarEvent`, `Restaurant`, `Location`, `News`, `Bus`.

---

### `/controller` - Business Logic & Data Fetching

#### `/fetchers/` - Data Sources
All Sigarra fetchers implement `SessionDependantFetcher`:
```dart
List<String> getEndpoints(Session session);
```

**Data flow:**
1. Fetcher builds Sigarra URL from session (faculty, language)
2. `AuthenticatedClient` injects cookies automatically
3. HTML response parsed via corresponding parser in `/parsers/`
4. Entity stored in ObjectBox; provider caches timestamp in SharedPreferences

#### `/local_storage/` - Persistence Layer
- `database/` — ObjectBox singleton (`Database().init()`)
- `preferences_controller.dart` — SharedPreferences wrapper (theme, locale, cache timestamps, favorite widgets)
- `migrations/` — Schema evolution scripts; run automatically on launch via `MigrationController`. **Always increment schema version when changing entities.**
- `file_offline_storage.dart` — File cache in `cache/` directory; cleaned up after 7 days
- `notification_timeout_storage.dart` — JSON file in `documents/` directory tracking last notification timestamps to prevent duplicate notifications

---

### `/http/` - HTTP Client Configuration

- `authenticated.dart` — Overrides `send()` to inject cookies on every request + handles 403/re-auth
- `timeout.dart` — Enforces 30-second timeout
- `cookie.dart` — Cookie storage and injection
- `callback.dart` — Request/response lifecycle hooks
- `utils.dart` — Cookie extraction from responses

Always use `authenticatedHttpClient` for Sigarra requests — never raw `http.Client`.

---

### `/sigarra/` - Sigarra Endpoint Definitions

Typed wrappers for Sigarra endpoints. Base URL built from `FacultyRequestOptions`:
- `SigarraHtml` — HTML endpoints (login, home, schedule, etc.)
- `SigarraOidc` — OIDC token endpoint for FederatedSession refresh

---

### `/view` - Presentation Layer

Each screen is a folder. Navigation via `Navigator.of(context).pushNamed()` with `PageTransition` animations.

Key shared files: `widgets/` (common components), `pages_layouts/` (reusable layouts), `locale_notifier.dart`, `theme_notifier.dart`.

---

## UI & Design System

UI components live in the `uni_ui` package. Key rules:

- **Never hardcode colors, typography, or spacing** — use tokens from `uni_ui/lib/theme.dart`
- **Before creating a new widget**, check if a component already exists in `uni_ui`
- **Generic/reusable widgets** (no providers, data via parameters) → create in `uni_ui`
- **Feature-specific widgets** (depend on providers, single screen) → create in `uni_app`
- Import Material only in `uni_ui`, not directly in `uni_app`

Available components: cards, modals, navbar, calendar, timeline, course widgets — see `uni_ui/lib/`