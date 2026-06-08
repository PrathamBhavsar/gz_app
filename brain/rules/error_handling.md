# RULE: ERROR HANDLING

1. **Three-Layer Contract:**
   - Repository and transport code throw typed `AppException` variants.
   - Notifiers convert those exceptions into `AsyncValue.error` or explicit action error states.
   - Widgets render `PageErrorDisplay` for read failures and snackbars for action failures.
2. **Read Errors:** Use `AppPageError.from(error)` to normalize repository, network, validation, and unexpected failures.
3. **Action Errors:** Trigger snackbars from `ref.listen(...)`, never from the build method.
4. **Retry:** Data-bound screens that can recover should expose a notifier `refresh()` or equivalent retry method.
