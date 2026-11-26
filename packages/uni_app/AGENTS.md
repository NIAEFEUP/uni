# uni_app

The Flutter app. It uses Riverpod for state, ObjectBox for local data, and gets everything from SIGARRA by scraping HTML/JSON or through OIDC. Repo-wide rules and CI checks are in the [root AGENTS.md](../../AGENTS.md).

## Commands (run inside `packages/uni_app`)

```bash
flutter pub get
dart fix --apply && dart format . && flutter analyze .
flutter test                                  # all tests
flutter test test/unit/path/to/file_test.dart # one file

# Code generation (ObjectBox, JsonSerializable, Mockito), then commit the output
dart run build_runner build --delete-conflicting-outputs

# Localization, after editing lib/l10n/*.arb
dart pub global activate intl_utils 2.1.0
dart pub global run intl_utils:generate
```

Lints: `leancode_lint` + `custom_lint` (`analysis_options.yaml`). Generated files are excluded from analysis.

## Architecture

```
lib/
  view/                 widgets (Riverpod consumers); never call fetchers/controllers directly
  model/
    providers/riverpod/ CachedAsyncNotifier subclasses: state + cache
    entities/           ObjectBox @Entity models (plain data)
  controller/
    fetchers/           HTTP → entity; use parsers
    parsers/            HTML/JSON response → entity
    local_storage/      ObjectBox Database, PreferencesController, migrations/
    networking/         NetworkRouter: builds SIGARRA URLs
  http/client/          CookieClient, TimeoutClient, …
  session/              auth: credentials flow + federated (OIDC) flow
  sigarra/              typed SIGARRA endpoint definitions
  l10n/                 intl_en.arb, intl_pt_PT.arb
  generated/            intl output, never edit
  utils/                constants, navigation_items.dart, formatters
```

Data flow: `view` → `ref.watch(xyzProvider)` → `CachedAsyncNotifier` → fetcher → parser → entity → saved in ObjectBox.

### Providers: `CachedAsyncNotifier<T>` (`model/providers/riverpod/cached_async_notifier.dart`)

Every network-backed provider extends it. `build()` does the following:
1. Loads from storage (ObjectBox).
2. If the data is valid and the cache timestamp (SharedPreferences, key from `runtimeType`) is within `cacheDuration`, returns it.
3. Otherwise calls `loadFromRemote()`. If that fails and cached data exists, it falls back to the cache silently.

Template:

```dart
final xyzProvider = AsyncNotifierProvider<XyzNotifier, Xyz?>(XyzNotifier.new);

class XyzNotifier extends CachedAsyncNotifier<Xyz?> {
  @override
  Duration? get cacheDuration => const Duration(hours: 1);

  @override
  Future<Xyz?> loadFromStorage() async => Database().xyz;

  @override
  Future<Xyz?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future); // read, not watch
    if (session == null) return null;
    final data = await XyzFetcher().fetch(session);
    Database().saveEntity(data);
    return data;
  }
}
```

- Pull-to-refresh → `refreshRemote()`. Discard local data (e.g. on logout) → `invalidate()`.
- After any `await`, check `ref.mounted` before touching `state`, or use the base class's `_updateState`/`_updateError`.

### Storage: pick the right layer

| Data | Where |
|---|---|
| Entities (profile, schedule, exams…) | ObjectBox, `Database()` |
| Preferences, filters, cache timestamps | SharedPreferences via `PreferencesController` |
| Session / credentials / tokens | `FlutterSecureStorage` via `PreferencesController` (never ObjectBox/SharedPreferences) |

Changing an `@Entity` or a stored preference format means you must:
1. Run `build_runner` and commit `objectbox.g.dart` + `objectbox-model.json`.
2. Add a migration in `controller/local_storage/migrations/migrations.dart`, add a `case` in `MigrationController`, and **increment `currentPreferencesVersion`**. If you skip the increment, existing users never run the migration.

Fields that must not be persisted need `@Transient()`.

### Auth (`session/`)

Two flows, both producing an immutable `Session` (update it with `copyWith`). Failures throw `AuthenticationException`.
- **Credentials** (`flows/credentials/`): POST username/password to SIGARRA.
- **Federated** (`flows/federated/`): OIDC Authorization Code + PKCE against U.Porto's IdP. Then `SigarraOidc().token()` exchanges the access token for SIGARRA cookies. Realm and client id are in `utils/constants.dart`. Refresh uses the refresh token stored in `credential`.

### Networking

Never hardcode SIGARRA URLs. Use `NetworkRouter.getBaseUrl(faculty)` / `NetworkRouter.getBaseUrlsFromSession(session)`, which build `https://sigarra.up.pt/{faculty}/{lang}/…`.

### UI, text and navigation

- Generic widgets with no providers belong in `uni_ui` ([guide](../uni_ui/AGENTS.md)). Feature widgets that read providers stay here. Use theme tokens from `uni_ui/lib/theme.dart`, not hardcoded colors.
- Every user-facing string goes in **both** `lib/l10n/intl_en.arb` and `lib/l10n/intl_pt_PT.arb`, then regenerate. Use `S.of(context).key`.
- Routes: `NavigationItem` enum in `utils/navigation_items.dart` (`faculties:` restricts a route to some faculties) + the `transitionFunctions` map in `main.dart`.
- Create a widget class rather than a helper function that returns a widget. Use `ListView.builder` for long lists. Dispose controllers in `dispose()`.

## Gotchas

- **SIGARRA always returns HTTP 200**, even when login fails. Parse the HTML instead: success has `<meta http-equiv="refresh">`, failure has `p.aviso-invalidado` / `p.erro-nota`.
- **`CookieClient` takes a lambda:** `cookies: () => session.cookies`. If you pass the value, the cookies go stale after a session refresh.
- **Parsers fail silently.** CSS selectors are hardcoded, so if SIGARRA changes its markup the parser returns `[]` with no exception. Test parsers with real captured HTML (`test/integration/resources/*.html`). Assert on types and required fields, not on exact counts.
- **Some pages have two layouts.** For example, `parser_courses.dart` handles both `.estudantes-caixa-lista-cursos` and `.tabela-longa`. Check both branches when debugging.
- **JSON number types vary.** The schedule's `aula_duracao` is `int` for whole hours and `double` otherwise, so check with `is double` instead of casting with `as int`.
- **An empty result counts as "not loaded."** `CachedAsyncNotifier` treats `[]`/`{}`/`null` as invalid cache, so a user with genuinely no data triggers a network fetch on every cold start.
- **Secure storage wipes itself on read errors.** `PreferencesController.getSavedSession()` calls `deleteAll()` if the read fails. Don't suppress that, and don't store anything there that the user can't re-enter.
- **Check `PreferencesController` before adding a key.** It already has many keys, so look for an existing one first. Cache timestamp keys are created automatically, so never add them by hand.

## Tests

- `test/unit/` holds models, providers and view tests. `test/integration/` holds end-to-end-ish flows with HTML resources. Mocks are generated with Mockito (`@GenerateNiceMocks`) → run `build_runner`.
- Test parsers by building a real `http.Response` from a captured HTML file.
