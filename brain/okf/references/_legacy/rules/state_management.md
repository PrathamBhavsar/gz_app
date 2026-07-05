# RULE: STATE MANAGEMENT
> **Enforcement Level**: CRITICAL

1. **Riverpod Style:** Use plain `flutter_riverpod` providers. `Notifier`, `AsyncNotifier`, `Provider`, and `.family` variants are the default tools in this repo.
2. **Read Screens:** Data-loading screens should expose `AsyncValue<T>` and render via `.when(data:, loading:, error:)`.
3. **Action Flows:** Submit/login/mutate flows should use a `Notifier` with explicit state classes such as `Initial`, `Loading`, `Success`, and `Error`.
4. **No setState for app state:** Local widget-only concerns may use `StatefulWidget`, but feature/application state belongs in Riverpod notifiers.
5. **Refresh and Polling:** Refresh methods should use `AsyncValue.guard`. Timer-based polling must register cleanup with `ref.onDispose`.
