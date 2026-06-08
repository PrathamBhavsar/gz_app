# RULE: DATA LAYER
> **Enforcement Level**: CRITICAL

1. **Repository Pattern:** Data flow is `Widget -> Notifier -> Repository -> ApiClient -> API`. UI code must never call `ApiClient` directly.
2. **Repository Scope:** Each feature owns `data/repositories/*.dart`. Do not add a separate `service` layer unless there is a concrete shared transport concern the repository cannot hold cleanly.
3. **Connection Check:** Repository methods call `networkCheckerProvider.assertConnection()` before the API call.
4. **Models:** Use the shared manual model classes in `lib/models/`. Extend those files when fields or response wrappers are missing.
5. **Parsing:** Repositories call `ApiClient`, then parse JSON with the relevant `fromJson` constructor from `lib/models/`.
6. **Errors:** Do not swallow exceptions. `ApiClient` and `NetworkChecker` already emit typed `AppException` variants; let them propagate upward.
