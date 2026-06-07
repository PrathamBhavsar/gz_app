# RULE: ERROR HANDLING

1. **Three-Layer Contract:** - Repository catches `DioException`, throws `AppException`.
   - Notifier catches `AppException`, updates state. Never rethrows to UI.
   - Widget reads `AsyncValue` error state, renders ErrorView.
2. **Snackbars:** Trigger via `ref.listen` in UI, never inside the build method directly.
