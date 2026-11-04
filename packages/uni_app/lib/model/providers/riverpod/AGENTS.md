## Riverpod Providers

All data-fetching providers extend `CachedAsyncNotifier<T>` from `cached_async_notifier.dart`. Understanding its lifecycle and gotchas is essential before creating or modifying any provider.

---

### `CachedAsyncNotifier` lifecycle

`build()` runs in this order every time the provider is built:

1. Reads the last-update timestamp from `PreferencesController` (SharedPreferences)
2. Calls `loadFromStorage()` — reads from ObjectBox
3. If storage returned valid data **and** the cache timestamp is still within `cacheDuration`, returns the local data
4. Otherwise calls `refreshRemote()` → `loadFromRemote()`
5. On remote failure with valid cached data, falls back silently to the cached value

```
build()
  └─ loadFromStorage()
       ├─ cache valid? → return local data
       └─ cache expired or empty? → refreshRemote()
            ├─ success → update state + timestamp
            └─ failure + cached data exists → return cached data silently
```

---

### Critical gotcha: empty list = "not loaded"

`_invalidLocalData()` treats `[]`, `{}`, and `null` all as "no data", which forces a remote fetch. This is a known limitation (FIXME in the source).

**Consequence:** if a user genuinely has no data (e.g., no exams scheduled), the provider will hit the network on every cold start. Design entities and storage accordingly — if empty is a valid real state, consider wrapping in an Optional or using a nullable type.

---

### `ref.mounted` before every state update

All async operations must check `ref.mounted` before setting state. Without this, the provider will crash after the widget that triggered it is disposed:

```dart
// ✅
Future<void> doSomething() async {
  final result = await someAsyncCall();
  if (!ref.mounted) return;
  state = AsyncData(result);
}

// ❌ will throw after widget dispose
Future<void> doSomething() async {
  state = AsyncData(await someAsyncCall());
}
```

`_updateState()` and `_updateError()` in `CachedAsyncNotifier` already include this check — use them instead of setting `state` directly.

---

### `updateTimestamp: false` in `loadFromStorage`

When loading from local storage during `build()`, never update the cache timestamp. The timestamp should only advance when fresh remote data arrives. `_safeExecute` in `build()` always passes `updateTimestamp: false` for the storage call.

---

### Session dependency

Providers that need user data must read `sessionProvider` and return `null` if there is no active session:

```dart
@override
Future<T?> loadFromRemote() async {
  final session = await ref.read(sessionProvider.future);
  if (session == null) return null;
  // proceed with authenticated fetch
}
```

Do not use `ref.watch(sessionProvider)` inside `loadFromRemote` — use `ref.read(...future)`.

---

### Template for a new provider

```dart
final xyzProvider = AsyncNotifierProvider<XyzNotifier, Xyz?>(XyzNotifier.new);

class XyzNotifier extends CachedAsyncNotifier<Xyz?> {
  @override
  Duration? get cacheDuration => const Duration(hours: 1);

  @override
  Future<Xyz?> loadFromStorage() async => Database().xyz;

  @override
  Future<Xyz?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) return null;

    final data = await XyzFetcher().fetch(session);
    Database().saveEntity(data);
    return data;
  }
}
```

---

### `invalidate()` vs `refreshRemote()`

| Method | Clears state | Clears timestamp | Effect |
|--------|-------------|-----------------|--------|
| `invalidate()` | yes (`AsyncData(null)`) | yes | next `build()` will fetch from both storage and remote |
| `refreshRemote()` | sets `AsyncLoading` | no | goes directly to remote, skips storage |

Use `refreshRemote()` for pull-to-refresh. Use `invalidate()` only when the local data must be discarded (e.g., after logout).
