# RULE: ERROR HANDLING
> **Enforcement Level**: CRITICAL — Swallowed errors and untyped exceptions reaching UI are violations.

## THREE-LAYER CONTRACT

```
Service     → Calls ApiClient → AppClient throws typed AppException on HTTP errors
Repository  → Calls NetworkChecker → Calls Service → Propagates AppException (no catch needed)
Notifier    → Catches all exceptions → Updates state to error variant
Widget      → Reads state → Renders error state via PageErrorDisplay / AppPageError
```

---

## `AppException` TYPES

Location: `lib/core/errors/app_exception.dart`

```dart
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException({required this.statusCode, required this.message});
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Unauthorized']);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}
```

`ApiClient` maps HTTP errors automatically:
- `4xx` → `ValidationException` (message extracted from response body)
- `5xx` → `ApiException`
- `401` → triggers silent refresh, then `UnauthorizedException` if refresh fails
- Network failures → `NetworkException`

---

## `AppPageError` — UI ERROR MAPPING

Location: `lib/core/errors/app_exception.dart`

```dart
// Map any exception to a friendly UI error
final displayError = AppPageError.from(e);

// Pre-built statics
AppPageError.noInternet   // title: 'No Internet', icon: 'wifi_off'
AppPageError.empty        // title: 'Nothing here yet', icon: 'inbox'
```

`AppPageError.from(error)` handles: `NetworkException`, `ApiException`, `UnauthorizedException`, fallback.

---

## NOTIFIER — CATCH EXCEPTIONS

```dart
// AsyncValue state — use try/catch
Future<void> _fetch() async {
  state = const AsyncLoading();
  try {
    final repo = ref.read(myRepositoryProvider);
    final data = await repo.fetchSomething();
    state = AsyncData(data);
  } catch (e, st) {
    state = AsyncError(e, st);  // pass stackTrace too
  }
}

// Sealed state — use typed catch
Future<void> submit() async {
  state = const MyLoading();
  try {
    final result = await ref.read(repo).doSomething();
    state = MySuccess(result);
  } on ValidationException catch (e) {
    state = MyError(e.message);
  } catch (e) {
    state = MyError(e.toString());
  }
}
```

---

## WIDGET — SURFACE ERRORS

For `AsyncValue` state:
```dart
ref.watch(myProvider).when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (e, _) => PageErrorDisplay(
    error: AppPageError.from(e),
    onRetry: () => ref.read(myProvider.notifier).refresh(),
  ),
  data: (data) => MyContent(data: data),
);
```

For sealed state:
```dart
final state = ref.watch(myFormProvider);
if (state is MyError) {
  GZSnackBar.error(context, (state as MyError).message);
}
```

Use `ref.listen` to show snackbars — never call directly in `build()`:
```dart
ref.listen(myFormProvider, (_, next) {
  if (next is MyError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text((next as MyError).message),
        backgroundColor: AppColors.error,
      ),
    );
  }
});
```

---

## `PageErrorDisplay` WIDGET

Location: `lib/shared/widgets/page_error_display.dart`

```dart
PageErrorDisplay(
  error: AppPageError.from(e),
  onRetry: () => ref.read(provider.notifier).refresh(),
)
```

Use this for full-page error states (not inline field errors).

---

## `UnauthorizedException` — GLOBAL HANDLING

Handled inside `ApiClient.onLogout` callback (wired in `apiClientProvider`). On 401 with failed refresh:
1. `accessTokenProvider` cleared
2. `TokenStorage.clearAll()` called
3. UI should react to `authNotifierProvider` state change → router redirects to `/auth`

Do **not** manually handle `UnauthorizedException` in individual notifiers unless doing something custom.

---

## FORBIDDEN

| Violation | Why |
|---|---|
| Empty `catch {}` | Silent failure |
| `catch (e) { print(e); }` | Lost in production |
| Catching exceptions in Service (re-throw only) | Service should not hide errors |
| `showDialog` from Repository | No BuildContext in repos |
| `ScaffoldMessenger` called directly in `build()` | Causes setState-during-build errors |
| Swallowing `NetworkException` | Offline state must be visible |
