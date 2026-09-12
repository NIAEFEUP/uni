## Local Storage

Three separate storage layers, each for a distinct purpose. Using the wrong one for a given type of data causes either security issues or lost data.

| Data type | Storage | Class |
|-----------|---------|-------|
| Entity data (profiles, schedules, …) | ObjectBox | `Database()` |
| UI flags, filters, cache timestamps | SharedPreferences | `PreferencesController` |
| Session / credentials | Keychain/Keystore (encrypted) | `FlutterSecureStorage` via `PreferencesController` |

Never put credentials or tokens in ObjectBox or SharedPreferences — always use `FlutterSecureStorage`.

---

### `FlutterSecureStorage` — silent `deleteAll()` on read error

`PreferencesController.getSavedSession()` wraps the secure storage read in a try-catch:

```dart
try {
  value = await _secureStorage.read(key: _userSession);
} catch (err) {
  await _secureStorage.deleteAll();  // ← deletes ALL secure data
  return null;
}
```

Any error — hardware fault, keychain locked, OS upgrade — will silently wipe all stored credentials. This is intentional to avoid the app being stuck in a broken state. Do not wrap `getSavedSession()` in a try-catch that suppresses this, and do not store data in secure storage that cannot be re-entered by the user.

---

### ObjectBox — code generation is mandatory

After adding or modifying any class annotated with `@Entity()`:

```bash
dart pub run build_runner build --delete-conflicting-outputs
```

Without this, the generated `objectbox.g.dart` is stale. The code compiles, but the new/changed fields are **not persisted** — silent data loss at runtime.

Commit the generated `objectbox.g.dart` and `objectbox-model.json` files.

---

### ObjectBox — `@Transient()` for computed fields

Fields that should not be stored in the database must be annotated with `@Transient()`. They are populated after loading from the DB:

```dart
@Entity()
class Profile {
  @Id()
  int dbId = 0;

  @Transient()
  List<Course> courses = [];  // populated separately from Database().courses
}
```

If you add a relational field without `@Transient()`, ObjectBox will try to persist it and fail at code generation or runtime.

---

### Migrations — always increment the version

When changing an ObjectBox entity schema or a stored preference format:

1. Add a new static method in `migrations/migrations.dart`
2. Add a `case` in `MigrationController.runMigration(int version)`
3. Increment `MigrationController.currentPreferencesVersion`

```dart
// migrations.dart
static Future<void> migrateToV4() async {
  // migration logic
}

// migration_controller.dart
static const currentPreferencesVersion = 4;  // was 3

case 3:
  await Migrations.migrateToV4();
```

Without incrementing the version, existing users never run the new migration.

---

### `PreferencesController` — check before adding a new key

The class has 30+ private `static const` key strings. Before adding a new one, search for an existing equivalent — toggle keys, filter arrays, and date keys are easy to duplicate accidentally.

Cache timestamp keys are **generated automatically** from `runtimeType.toString()` by `CachedAsyncNotifier` — never create them manually in `PreferencesController`.

The two `StreamController.broadcast()` fields (`onStatsToggle`, `onHiddenExamsChange`) are the only reactive hooks in preferences — any new reactivity should use the same pattern.
