# RULE: STATE MANAGEMENT
> **Enforcement Level**: CRITICAL — Zero tolerance.

## THE LAW: HAND-WRITTEN NOTIFIER PROVIDER ONLY

`flutter_riverpod` only. **No** `riverpod_annotation`. **No** `@riverpod`. **No** `build_runner`. **No** `part` files. All providers are hand-written.

---

## FORBIDDEN PATTERNS

```dart
// ❌ setState
setState(() => _count++);

// ❌ ChangeNotifier
class MyNotifier extends ChangeNotifier { ... }

// ❌ riverpod_annotation / generator
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'my_notifier.g.dart';
@riverpod
class MyNotifier extends _$MyNotifier { ... }

// ❌ Old StateNotifierProvider
final p = StateNotifierProvider<N, S>(...);

// ❌ ref.read in build()
final data = ref.read(someProvider); // inside Widget.build
```

---

## CORRECT PATTERNS

### Simple DI / service provider
```dart
final myServiceProvider = Provider<MyService>((ref) {
  return MyService(ref.watch(apiClientProvider));
});
```

### Async data fetch (AsyncValue state)
```dart
class StoreListNotifier extends Notifier<AsyncValue<List<StoreModel>>> {
  @override
  AsyncValue<List<StoreModel>> build() {
    _fetch();
    return const AsyncLoading();
  }

  Future<void> _fetch() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(storeRepositoryProvider);
      final res = await repo.fetchStores();
      state = AsyncData(res.data ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> refresh() => _fetch();
}

final storeListProvider =
    NotifierProvider<StoreListNotifier, AsyncValue<List<StoreModel>>>(
  () => StoreListNotifier(),
);
```

### Mutable form state (sealed class state)
```dart
sealed class BookingFormState { const BookingFormState(); }
class BookingFormInitial extends BookingFormState { const BookingFormInitial(); }
class BookingFormLoading extends BookingFormState { const BookingFormLoading(); }
class BookingFormSuccess extends BookingFormState {
  final BookingModel booking;
  const BookingFormSuccess(this.booking);
}
class BookingFormError extends BookingFormState {
  final Object error;
  const BookingFormError(this.error);
}

class BookingFormNotifier extends Notifier<BookingFormState> {
  @override
  BookingFormState build() => const BookingFormInitial();

  Future<void> submit(BookingRequest request) async {
    state = const BookingFormLoading();
    try {
      final booking = await ref.read(bookingRepositoryProvider).create(request);
      state = BookingFormSuccess(booking);
    } catch (e) {
      state = BookingFormError(e);
    }
  }
}

final bookingFormProvider =
    NotifierProvider<BookingFormNotifier, BookingFormState>(
  () => BookingFormNotifier(),
);
```

---

## STATE TYPE RULES

| Use case | State type |
|---|---|
| Data load (list, detail) | `AsyncValue<T>` |
| Form submission | Sealed class with Initial / Loading / Success / Error |
| Auth | Sealed class (see `auth_state.dart`) |
| Simple flag / value | `StateProvider<T>` |
| Service / DI | `Provider<T>` |

**Sealed class naming**: `XState` as sealed superclass, `XInitial`, `XLoading`, `XSuccess`, `XError` as subclasses.

---

## HANDLING `AsyncValue` IN UI

```dart
ref.watch(storeListProvider).when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (e, _) => PageErrorDisplay(error: AppPageError.from(e), onRetry: () => ref.refresh(storeListProvider)),
  data: (stores) => StoreList(stores: stores),
);
```

---

## WHERE LOGIC LIVES

| Location | Allowed | What |
|---|---|---|
| Notifier | ✅ | Business logic, state mutations, async ops |
| Repository | ✅ | Data access, API calls, model mapping |
| Service | ✅ | Raw API calls, JSON parsing only |
| Widget.build() | ❌ | Layout + rendering only |
| StatefulWidget | ⚠️ Only for AnimationController | AnimationController lifecycle |

---

## FILE NAMING

| Type | Pattern | Location |
|---|---|---|
| Notifier + state sealed class | `<name>_notifier.dart` | `features/<f>/presentation/providers/` |
| State-only file | `<name>_state.dart` | `features/<f>/presentation/providers/` |
| Simple/DI provider | co-located in service or repository file | `features/<f>/data/repositories/` or `data/services/` |

---

## CONNECTIVITY SIDE EFFECT

Subscribe to connectivity in Notifiers that load remote data. When reconnected after an error state, re-trigger the fetch:

```dart
StreamSubscription<bool>? _connectivitySub;

@override
MyState build() {
  _connectivitySub = ref.read(connectivityServiceProvider)
      .onConnectivityChanged
      .listen((isConnected) {
        if (isConnected && state is MyError) _fetch();
      });
  ref.onDispose(() => _connectivitySub?.cancel());
  // ...
}
```
