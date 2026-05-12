# RULE: PERFORMANCE
> **Enforcement Level**: CRITICAL — Unnecessary rebuilds and missing `const` are violations.

## REBUILD ONLY WHAT CHANGED

### `const` everywhere possible
```dart
// ✅
const SizedBox(height: AppSpacing.md)
const PageErrorDisplay(error: AppPageError.noInternet, onRetry: null)

// ❌
SizedBox(height: AppSpacing.md)
```

Mark widgets `const` whenever all constructor args are compile-time constants.

---

### `ref.select` for partial state
```dart
// ✅ — rebuilds only when isLoading changes
final isLoading = ref.watch(
  myProvider.select((s) => s is MyLoading),
);

// ❌ — rebuilds on ANY state change
final state = ref.watch(myProvider);
final isLoading = state is MyLoading;
```

Use `ref.select` when a widget needs only one field from a complex state object.

---

### `ref.read` in callbacks, never in `build()`
```dart
// ✅
onTap: () => ref.read(myProvider.notifier).doSomething(),

// ❌
onTap: () {
  final data = ref.watch(myProvider); // WRONG — watch in callback
}
```

---

### `ref.listen` for side effects
```dart
ref.listen(myFormProvider, (_, next) {
  if (next is MyError) {
    ScaffoldMessenger.of(context).showSnackBar(...);
  }
});
```

Never trigger snackbars or dialogs directly in `build()`.

---

## LISTS — ALWAYS BUILDER

```dart
// ✅
ListView.builder(
  itemCount: items.length,
  itemBuilder: (_, i) => StoreCard(store: items[i]),
)

// ❌
ListView(children: items.map((s) => StoreCard(store: s)).toList())
```

For sliver lists: use `SliverList.builder` / `SliverList.separated`.

---

## SPLIT BIG WIDGETS

`build()` body > ~60 lines → extract to separate `StatelessWidget` classes (not local functions).

```dart
// ❌ Local function widget
Widget _buildStoreCard(StoreModel store) => Card(...);

// ✅ Class widget (enables const optimization)
class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store});
  final StoreModel store;
  @override
  Widget build(BuildContext context) => Card(...);
}
```

---

## IMAGE CACHING

This project does not have `cached_network_image`. Use `Image.network` with `cacheWidth`/`cacheHeight`:

```dart
Image.network(
  url,
  cacheWidth: 400,  // limit memory footprint
  fit: BoxFit.cover,
  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
)
```

If `cached_network_image` is added later, prefer `CachedNetworkImage`.

---

## ANIMATION CONTROLLER DISPOSE

```dart
@override
void dispose() {
  _controller.dispose(); // MANDATORY
  super.dispose();
}
```

Only use `StatefulWidget` for `AnimationController`. Everything else is `ConsumerWidget` or `StatelessWidget`.

---

## `MediaQuery.sizeOf` NOT `MediaQuery.of`

```dart
// ✅ — subscribes only to size changes
final width = MediaQuery.sizeOf(context).width;

// ❌ — subscribes to all MediaQuery changes (text scale, brightness, etc.)
final width = MediaQuery.of(context).size.width;
```

---

## WEBSOCKET — ACTIVE SESSION SCREEN

- Connect WebSocket on screen init
- Disconnect on screen dispose via `ref.onDispose`
- Exponential backoff: 1s → 2s → 4s → 8s → max 30s
- Fallback: poll `GET /stores/:storeId/sessions/:id` every 30s if WebSocket fails

---

## STREAM SUBSCRIPTIONS

Always cancel subscriptions in `ref.onDispose` (for Notifiers) or `dispose()` (for StatefulWidgets):

```dart
// In Notifier
ref.onDispose(() => _subscription?.cancel());
```

---

## FORBIDDEN

| Violation | Why |
|---|---|
| `ListView(children: [...])` for dynamic lists | Eager render, jank on large lists |
| `ref.watch` in callbacks or event handlers | Not reactive, causes issues |
| `ref.read` in `build()` for displaying data | Won't rebuild when data changes |
| Missing `AnimationController.dispose()` | Memory leak |
| `MediaQuery.of(context).size` in feature widgets | Overbroad subscription |
| Missing `const` on static widgets | Unnecessary instantiation per frame |
| Local function widgets (private `_buildX`) for large subtrees | Prevents const optimization |
