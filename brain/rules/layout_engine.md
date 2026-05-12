# RULE: LAYOUT ENGINE
> **Enforcement Level**: CRITICAL — 3-breakpoint model only. Screen → Layout widget split is mandatory.

## THE LAW: THREE BREAKPOINTS

| Mode | Breakpoint | Navigation | Content |
|---|---|---|---|
| Mobile | `width <= 599` | BottomNavigationBar | Single-pane, full-width |
| Tablet | `600 <= width <= 899` | NavigationRail (left) | Master-Detail side-by-side |
| Desktop | `width > 899` | NavigationRail (wider) | Master-Detail side-by-side |

---

## MANDATORY SCREEN → LAYOUT SPLIT

Every feature screen uses this exact pattern:

```dart
// XScreen — thin coordinator (no Consumer, no state reads)
class XScreen extends StatelessWidget {
  const XScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const XMobileLayout(),
          DeviceType.tablet  => const XTabletLayout(),
          DeviceType.desktop => const XTabletLayout(), // tablet layout reused
        },
      ),
    );
  }
}
```

Layout widgets (`XMobileLayout`, `XTabletLayout`) are `ConsumerWidget`s — they own `ref.watch` and all provider reads.

---

## `ResponsiveBuilderWidget` — CANONICAL

```dart
// lib/core/responsive/responsive_builder.dart
class ResponsiveBuilderWidget extends StatelessWidget {
  const ResponsiveBuilderWidget({super.key, required this.builder});
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = Breakpoints.getDeviceType(context);
        return builder(context, deviceType);
      },
    );
  }
}
```

---

## PLAYER APP SHELL — 5 TABS

```
ShellRoute → MainPage → ResponsiveBuilderWidget
  Mobile:  MainMobileLayout (BottomNavigationBar)
  Tablet:  MainTabletLayout (NavigationRail)

Tab routes (inside shell):
  /home       → HomeScreen
  /book       → BookingSlotSelectionScreen
  /sessions   → SessionsScreen
  /wallet     → WalletScreen
  /profile    → ProfileScreen
```

Screens pushed outside shell (no BottomNav):
```
/home/search, /home/store/:slug
/book/systems, /book/summary, /book/success
```

---

## ADMIN APP SHELL — 4 TABS

```
ShellRoute → AdminShell → AdminMobileLayout

Tab routes (inside admin shell):
  /admin/dashboard   → AdminDashboardScreen   (Operations)
  /admin/analytics   → AdminAnalyticsScreen   (Analytics)
  /admin/pricing     → AdminManagementScreen  (Management)
  /admin/systems     → AdminStoreScreen       (Store)
```

---

## GLOBAL OVERLAYS (not routes — modal sheets)

```
NotificationCenter, NotificationDetailSheet, StoreSelectorSheet, OtpInputSheet
```

Use `showModalBottomSheet` or `showDialog` — do not register as GoRoutes.

---

## PERMITTED `MediaQuery` / `Breakpoints` USAGE

| Use | Permitted |
|---|---|
| Inside `ResponsiveBuilderWidget.builder` | ✅ |
| `Breakpoints.isMobile(context)` in layout widgets for minor tweaks | ✅ |
| `MediaQuery.paddingOf(context)` for safe area | ✅ |
| `MediaQuery.of(context).size.width > 600` in arbitrary widget | ❌ |
| `MediaQuery.sizeOf(context)` directly in feature screens | ❌ |

---

## FORBIDDEN

```dart
// ❌ Direct MediaQuery for layout branching in feature widgets
final width = MediaQuery.of(context).size.width;
if (width > 600) { ... }

// ❌ LayoutBuilder at app level without ResponsiveBuilderWidget
LayoutBuilder(builder: (ctx, constraints) {
  if (constraints.maxWidth > 600) { ... }
})

// ❌ Screen does its own Consumer/ref.watch (put in layout widget)
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider); // wrong place
```
