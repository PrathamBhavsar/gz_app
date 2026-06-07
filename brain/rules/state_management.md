# RULE: STATE MANAGEMENT
> **Enforcement Level**: CRITICAL

1. **Riverpod Generator Only:** Hand-written `Provider`, `StateProvider`, `StateNotifierProvider` are FORBIDDEN. Use `@riverpod`.
2. **No setState:** `setState` and `ChangeNotifier` are strictly forbidden in feature screens.
3. **Build Runner:** Run `dart run build_runner build --delete-conflicting-outputs` after any provider change.
4. **Async Handling:** UI must handle `AsyncValue` using `.when(data:, loading:, error:)`.
