# Flutter App — Master Architecture & Style Guide

## !! MANDATORY REFERENCE !!

**This file MUST be read and followed before making ANY change to this codebase.**

-   Creating a new page? Follow this file.
-   Editing an existing page? Follow this file.
-   Adding a widget? Follow this file.
-   Refactoring anything? Follow this file.

No exceptions. No guessing. No improvising outside these rules.

------------------------------------------------------------------------

## Role

You are a **senior Flutter architect** working on a production Flutter
application.

This project contains:

-   multiple screens/pages
-   API calls
-   repositories
-   heavy business logic
-   navigation via GoRouter
-   Riverpod for state management
-   reusable widgets
-   animations using flutter_animate
-   full responsive support (mobile + tablet)

Your job is to write code that is:

-   production-grade
-   predictable
-   modular
-   scalable
-   consistent
-   responsive across device sizes

The final code must look like it was written by **a senior Flutter
engineer**, not generated automatically.

No shortcuts. No AI slop.

------------------------------------------------------------------------

# Phase 1 — Mandatory Analysis (DO NOT SKIP)

Before writing or modifying code you must:

1.  Analyze the **entire project structure**
2.  Identify:
    -   pages
    -   API layers
    -   repositories
    -   navigation
    -   models
    -   reusable widgets
3.  Detect architectural issues:
    -   UI containing logic
    -   direct API calls from widgets
    -   inconsistent naming
    -   duplicated widgets
    -   navigation scattered across files
    -   missing loading/error states
    -   hardcoded colors, sizes, or spacing (violations of design tokens)
    -   missing responsive handling
4.  Produce a **Refactor Plan** that explains:
    -   what will change
    -   which files will move
    -   which layers will be created
    -   which components will be extracted

Do **NOT** start rewriting files until the plan is completed.

------------------------------------------------------------------------

# Phase 2 — Feature Based Architecture

Refactor the project into a **feature-first structure**.

```
lib/

core/
    api/
    network/
        connectivity_service.dart      ← stream-based connectivity + ping check
        network_checker.dart           ← manual check helper
    navigation/
    errors/
        app_exception.dart             ← typed exceptions
    utils/
    constants/
    animations/
    responsive/        ← breakpoints and responsive builder live here
    theme/             ← AppColors, AppSpacing, AppTypography live here

features/

    auth/
        login/
            login_page.dart
            login_notifier.dart
            login_state.dart
            login_repository.dart
            login_service.dart
            login_models.dart
            login_constants.dart
            login_widgets/
                login_mobile_layout.dart
                login_tablet_layout.dart

    tasks/
        task_list/
        task_detail/

shared/
    widgets/
        app_button.dart
        loading_view.dart
        page_error_display.dart        ← THE full-page error/offline widget
        empty_view.dart
    components/
    loaders/
```

------------------------------------------------------------------------

# Naming Standards (STRICT)

### Files

snake_case.dart

Examples:

    login_page.dart
    task_repository.dart
    task_notifier.dart
    task_state.dart
    connectivity_service.dart
    network_checker.dart
    page_error_display.dart
    slide_in_animation.dart
    login_mobile_layout.dart
    login_tablet_layout.dart

### Classes

PascalCase

Examples:

    LoginPage
    TaskRepository
    NetworkChecker
    ConnectivityService
    PageErrorDisplay
    SlideInAnimation
    LoginMobileLayout
    LoginTabletLayout

### Variables / Functions

camelCase

Examples:

    fetchTasks()
    submitForm()
    loadUserProfile()
    checkConnectivity()
    retryLoad()

### Riverpod Providers

Provider names must be explicit:

    taskNotifierProvider
    loginNotifierProvider
    userRepositoryProvider
    connectivityServiceProvider

------------------------------------------------------------------------

# Responsive Design (STRICT — ALL PAGES MUST COMPLY)

## Core Infrastructure

The app has a responsive system in `lib/core/responsive/`:

-   `breakpoints.dart` — defines `DeviceType` enum and breakpoint thresholds
-   `responsive_builder.dart` — provides `ResponsiveBuilderWidget` and `ResponsiveValue<T>`

**Breakpoints:**

    mobile  < 600px
    tablet  600px – 899px
    desktop ≥ 900px (treat same as tablet for this app)

## Rules

### 1. Every page MUST have separate layout widgets for mobile and tablet

Each page's widget folder must contain:

    feature_mobile_layout.dart
    feature_tablet_layout.dart

The main page file delegates to the correct layout using
`ResponsiveBuilderWidget`:

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) {
          return switch (deviceType) {
            DeviceType.mobile  => const LoginMobileLayout(),
            DeviceType.tablet  => const LoginTabletLayout(),
            DeviceType.desktop => const LoginTabletLayout(),
          };
        },
      ),
    );
  }
}
```

### 2. Never hardcode layout dimensions

Use `ResponsiveValue<T>` for any value that differs between breakpoints:

```dart
// WRONG
final columns = 2;
final padding = 16.0;

// RIGHT
final columns = ResponsiveValue<int>(mobile: 2, tablet: 3).getValueOf(context);
final padding = ResponsiveValue<double>(mobile: AppSpacing.md, tablet: AppSpacing.xl).getValueOf(context);
```

Use `Breakpoints` helpers for conditional logic:

```dart
if (Breakpoints.isTablet(context)) { ... }
if (Breakpoints.isMobile(context)) { ... }
```

### 3. Mobile layout rules

-   Single column. Full-width cards.
-   Bottom navigation / tab bar.
-   Padding: `AppSpacing.md` (16) horizontal.
-   Grid: 2 columns max for card grids.

### 4. Tablet layout rules

-   Multi-column where appropriate (2–3 columns).
-   Side-by-side panels where the design calls for it.
-   Increased padding: `AppSpacing.xl` (32) horizontal.
-   Grid: 3–4 columns for card grids.
-   Navigation can be a side rail or expanded bottom bar.

### 5. Responsive typography

Font sizes must scale with device type. Use `AppTypography` styles —
they are the single source of truth. Do not override font sizes inline
without a documented reason.

If a size must differ by breakpoint, define it in the layout widget
using `ResponsiveValue<double>`:

```dart
final titleSize = ResponsiveValue<double>(mobile: 24, tablet: 32).getValueOf(context);
```

### 6. Shared spacing and sizing across layouts

Both mobile and tablet layouts must import and use the same:

-   `AppSpacing` for all gaps and padding
-   `AppTypography` for all text styles
-   `AppColors` for all colors

No raw numbers. No raw color hex codes. No inline TextStyles that duplicate a token.

------------------------------------------------------------------------

# Design Tokens (STRICT — ZERO RAW VALUES ALLOWED)

## Colors — `lib/core/theme/app_colors.dart`

```dart
AppColors.background    // #0A0A0A  — page background
AppColors.surface       // #141414  — cards, bottom sheets
AppColors.surface2      // #1E1E1E  — skeleton background
AppColors.primary       // #FFFFFF  — primary text, icons
AppColors.secondary     // #2A2A2A  — secondary surfaces, borders
AppColors.textPrimary   // #FFFFFF
AppColors.textSecondary // #888888
AppColors.accent        // #F5F5F5
AppColors.border        // #2A2A2A
AppColors.error         // #FF4444
AppColors.success       // #44FF44
AppColors.rose          // #FF2D55  — accent highlights
AppColors.gold          // #FFD700  — premium highlights
```

**Never use** raw `Color(0xFF...)` values inline. Always reference `AppColors`.

## Spacing — `lib/core/theme/app_spacing.dart`

```dart
AppSpacing.xs   // 4
AppSpacing.sm   // 8
AppSpacing.md   // 16
AppSpacing.lg   // 24
AppSpacing.xl   // 32
AppSpacing.xxl  // 48

AppSpacing.borderRadius    // 12
AppSpacing.borderRadiusSm  // 8
AppSpacing.borderRadiusLg  // 16
```

**Never use** raw `double` literals for spacing or border radius.
Always use `AppSpacing` constants.

## Typography — `lib/core/theme/app_typography.dart`

```dart
AppTypography.headingLarge   // 32, w700
AppTypography.headingMedium  // 24, w600
AppTypography.headingSmall   // 18, w600
AppTypography.bodyLarge      // 16, w400
AppTypography.bodyMedium     // 14, w400
AppTypography.bodySmall      // 12, w400
AppTypography.caption        // 11, w400
AppTypography.button         // 14, w600
```

Font family is always `Satoshi` — set in `AppTypography`. Never specify
`fontFamily` inline.

**Never use** raw `TextStyle(fontSize: ...)` without starting from an
`AppTypography` token. Apply `.copyWith()` for color or weight overrides:

```dart
// WRONG
Text('Hello', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))

// RIGHT
Text('Hello', style: AppTypography.headingMedium.copyWith(color: AppColors.textSecondary))
```

------------------------------------------------------------------------

# Page Layout Template (Copy This Pattern for Every New Page)

```
features/
  my_feature/
    data/
      models/
      providers/
    presentation/
      screens/
        my_feature_page.dart              ← entry point, delegates to layouts
      widgets/
        my_feature_mobile_layout.dart
        my_feature_tablet_layout.dart
        my_feature_card.dart              ← shared card used by both layouts
```

### `my_feature_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/responsive/breakpoints.dart';
import 'package:myapp/core/responsive/responsive_builder.dart';
import '../widgets/my_feature_mobile_layout.dart';
import '../widgets/my_feature_tablet_layout.dart';

class MyFeaturePage extends ConsumerWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilderWidget(
        builder: (context, deviceType) => switch (deviceType) {
          DeviceType.mobile  => const MyFeatureMobileLayout(),
          DeviceType.tablet  => const MyFeatureTabletLayout(),
          DeviceType.desktop => const MyFeatureTabletLayout(),
        },
      ),
    );
  }
}
```

### `my_feature_mobile_layout.dart`

```dart
class MyFeatureMobileLayout extends ConsumerWidget {
  const MyFeatureMobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: AppTypography.headingMedium),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemBuilder: (_, i) => const MyFeatureCard(),
          ),
        ],
      ),
    );
  }
}
```

### `my_feature_tablet_layout.dart`

```dart
class MyFeatureTabletLayout extends ConsumerWidget {
  const MyFeatureTabletLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemBuilder: (_, i) => const MyFeatureCard(),
          ),
        ],
      ),
    );
  }
}
```

------------------------------------------------------------------------

# UI Layer Rules

Page files may only contain:

-   Scaffold
-   Layout delegation (responsive builder)
-   Provider listeners
-   Navigation triggers

Widgets must NOT contain:

-   API calls
-   data transformations
-   validation chains
-   business logic

Widgets should only **render UI and trigger events**.

------------------------------------------------------------------------

# Riverpod State Architecture

Each feature must include:

    feature_page.dart
    feature_notifier.dart
    feature_state.dart
    feature_repository.dart
    feature_service.dart
    feature_constants.dart

State must be **immutable**.

Use:

    Notifier
    AsyncNotifier

------------------------------------------------------------------------

# Page States

Each page must support:

    loading
    success
    error
    empty
    noInternet

Preferred:

    AsyncValue<T>

If the screen has complex transitions:

```dart
enum PageStatus {
  initial,
  loading,
  success,
  error,
  empty,
  noInternet
}
```

Do not overengineer simple screens.

------------------------------------------------------------------------

# Connectivity & No-Internet System (MANDATORY — ALL PAGES)

## Overview

Every page must handle no-internet and API-error states using a
**unified full-page error display system**.

This system has three parts:

1.  `ConnectivityService` — global stream that watches real network state
2.  `NetworkChecker` — on-demand helper that does an actual ping
3.  `PageErrorDisplay` — shared full-page error widget used by every page

---

## Part 1 — ConnectivityService

**Location:** `lib/core/network/connectivity_service.dart`

Responsibilities:
-   Subscribe to `connectivity_plus` status changes
-   After any status change to "connected", perform a live ping to verify
    actual internet access (not just being on a LAN with no gateway)
-   Expose a `Stream<bool>` of real connectivity state
-   Auto-retry: when connectivity is restored, emit `true` so pages
    can automatically reload

```dart
/// lib/core/network/connectivity_service.dart

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  ConnectivityService() {
    _init();
  }

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onConnectivityChanged => _controller.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void _init() {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.none) {
        _emit(false);
      } else {
        // Always ping — being on WiFi does NOT mean internet works
        final reachable = await _ping();
        _emit(reachable);
      }
    });
  }

  /// Call this manually to get the current real state.
  Future<bool> checkNow() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _emit(false);
      return false;
    }
    final reachable = await _ping();
    _emit(reachable);
    return reachable;
  }

  /// Attempts a real DNS/socket connection to verify gateway access.
  Future<bool> _ping() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _emit(bool value) {
    _isConnected = value;
    _controller.add(value);
  }

  void dispose() => _controller.close();
}

/// Global Riverpod provider — use this everywhere
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});

/// Stream provider for easy watching in widgets
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged;
});
```

---

## Part 2 — NetworkChecker

**Location:** `lib/core/network/network_checker.dart`

A simple static helper used inside repositories and notifiers to guard
API calls before they run.

```dart
/// lib/core/network/network_checker.dart

import 'connectivity_service.dart';

class NetworkChecker {
  const NetworkChecker(this._service);

  final ConnectivityService _service;

  /// Returns true if internet is actually reachable right now.
  Future<bool> hasConnection() => _service.checkNow();

  /// Throws [NetworkException] if offline. Call before any API call.
  Future<void> assertConnection() async {
    final connected = await hasConnection();
    if (!connected) throw const NetworkException();
  }
}
```

---

## Part 3 — PageErrorDisplay Widget

**Location:** `lib/shared/widgets/page_error_display.dart`

This widget is the **single** full-page error/offline UI used by every
page in the app. It covers almost the entire screen.

Rules:
-   Uses `HugeIconWidget` (reused icon component) — large, centered
-   Shows a concise, human-readable message
-   Shows a single **Retry** button
-   Accepts an `AppPageError` which can be: `NetworkError`, `ApiError`,
    or `CustomError`
-   Never shows stack traces to the user

```dart
/// lib/shared/widgets/page_error_display.dart

import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_colors.dart';
import 'package:myapp/core/theme/app_spacing.dart';
import 'package:myapp/core/theme/app_typography.dart';
import 'package:myapp/shared/widgets/huge_icon_widget.dart';
import 'package:myapp/core/errors/app_exception.dart';

class PageErrorDisplay extends StatelessWidget {
  const PageErrorDisplay({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final AppPageError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIconWidget(
                icon: error.icon,
                size: 80,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                error.title,
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                error.message,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                    ),
                  ),
                  child: Text('Retry', style: AppTypography.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Part 4 — AppPageError Model

**Location:** `lib/core/errors/app_exception.dart`

```dart
/// lib/core/errors/app_exception.dart

// Typed exceptions for propagation through layers
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);
  final String message;
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message});
  final int statusCode;
  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);
  final String message;
}

class ValidationException implements Exception {
  const ValidationException(this.message);
  final String message;
}

// ─── UI-facing error model ────────────────────────────────────────────────────

/// Converts any exception into a displayable error for [PageErrorDisplay].
class AppPageError {
  const AppPageError({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final String icon; // HugeIcon key / asset name

  /// Map any exception to a friendly UI error.
  factory AppPageError.from(Object error) {
    if (error is NetworkException) {
      return const AppPageError(
        title: 'No Internet',
        message: 'Check your connection and tap Retry.',
        icon: 'wifi_off',
      );
    }
    if (error is ApiException) {
      return AppPageError(
        title: 'Something went wrong',
        message: error.message.isNotEmpty
            ? error.message
            : 'The server returned an error. Please try again.',
        icon: 'cloud_error',
      );
    }
    if (error is UnauthorizedException) {
      return const AppPageError(
        title: 'Session expired',
        message: 'Please log in again.',
        icon: 'lock',
      );
    }
    // Fallback for any untyped error
    return const AppPageError(
      title: 'Unexpected Error',
      message: 'Something went wrong. Please try again.',
      icon: 'alert_circle',
    );
  }
}
```

---

## Part 5 — Auto-Reconnect Pattern in Notifiers

When a page is in an error state due to connectivity, the notifier must
**watch the connectivity stream and automatically retry** when the
connection comes back.

```dart
/// Example inside any feature notifier

class MyFeatureNotifier extends AsyncNotifier<MyFeatureState> {
  StreamSubscription<bool>? _connectivitySub;

  @override
  Future<MyFeatureState> build() async {
    // Watch connectivity — auto-reload on reconnect
    _connectivitySub = ref
        .read(connectivityServiceProvider)
        .onConnectivityChanged
        .listen((isConnected) {
      if (isConnected && state.hasError) {
        // Only auto-retry if the page is currently in an error state
        load();
      }
    });

    ref.onDispose(() => _connectivitySub?.cancel());

    return _fetch();
  }

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<MyFeatureState> _fetch() async {
    // Guard every API call with a connectivity check
    await ref.read(networkCheckerProvider).assertConnection();
    final data = await ref.read(myFeatureRepositoryProvider).getData();
    return MyFeatureState(items: data);
  }
}
```

---

## Part 6 — How Pages Use PageErrorDisplay

Every layout widget (mobile and tablet) must handle the `error` state by
returning `PageErrorDisplay`. The retry callback calls the notifier's
`load()` method.

```dart
/// Inside a layout widget (e.g. my_feature_mobile_layout.dart)

@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(myFeatureNotifierProvider);

  return state.when(
    loading: () => const LoadingView(),
    error: (error, _) => PageErrorDisplay(
      error: AppPageError.from(error),
      onRetry: () => ref.read(myFeatureNotifierProvider.notifier).load(),
    ),
    data: (data) => data.items.isEmpty
        ? const EmptyView(message: 'Nothing here yet.')
        : _buildContent(data),
  );
}
```

**Rules:**
-   `PageErrorDisplay` always occupies the full content area (via `SizedBox.expand`)
-   Never show a Snackbar as the only error feedback for full-page failures
-   Snackbars are only for transient, non-blocking feedback (e.g. "Copied!")
-   The `onRetry` callback MUST re-check connectivity before re-calling the API

---

## Part 7 — Repository Layer Connectivity Guard

Every repository method that makes a network call must guard with
`NetworkChecker` before firing the request.

```dart
/// Example repository method
Future<List<Task>> fetchTasks() async {
  await _networkChecker.assertConnection();        // throws NetworkException if offline
  final response = await _apiClient.get('/tasks'); // throws ApiException on HTTP errors
  return response.map(Task.fromJson).toList();
}
```

Error propagation flow:

    NetworkChecker → throws NetworkException
    ApiClient      → throws ApiException / UnauthorizedException
    Repository     → lets exceptions propagate (no swallowing)
    Notifier       → catches via AsyncValue.guard → state becomes error
    Layout widget  → reads error → renders PageErrorDisplay

------------------------------------------------------------------------

# Repository Layer

Repositories handle:

-   data abstraction
-   response transformation
-   caching if needed
-   error handling (typed throws, no raw catches without re-throw)

UI must **never call services directly**.

Example:

    TaskRepository
    AuthRepository
    UserRepository

------------------------------------------------------------------------

# API Layer

API calls must live inside:

    core/api/
    services/

Examples:

    api_client.dart
    task_service.dart
    auth_service.dart

Responsibilities:

-   HTTP requests
-   response parsing
-   DTO conversion
-   HTTP status → typed exception mapping

------------------------------------------------------------------------

# Navigation Architecture

Navigation must be centralized.

Create:

    core/navigation/

Files:

    app_router.dart
    navigation_service.dart
    routes.dart

Navigation must be **triggered from UI**, but **navigation decisions
must live in state/controllers**.

Avoid navigation inside build logic.

------------------------------------------------------------------------

# Animation Architecture

Animations must be **reusable and configurable**.

## Global Animations

    core/animations/

Examples:

    slide_in_animation.dart
    fade_in_animation.dart
    scale_animation.dart
    page_transition.dart

Reusable example:

```dart
SlideInAnimation(child: widget)
```

## Animation Constants

Each feature must include timing in its constants file:

```dart
class MyFeatureConstants {
  static const animationFast   = Duration(milliseconds: 200);
  static const animationMedium = Duration(milliseconds: 400);
  static const animationSlow   = Duration(milliseconds: 700);
}
```

------------------------------------------------------------------------

# Shared UI Components

Reusable UI must be placed in:

    shared/widgets/

Required shared widgets:

    app_button.dart
    loading_view.dart
    page_error_display.dart   ← full-page error + offline widget (see above)
    empty_view.dart
    huge_icon_widget.dart     ← reused by PageErrorDisplay for all icons

Pages must reuse these widgets. No duplicating error UI per feature.

------------------------------------------------------------------------

# Error Handling

Errors must propagate through layers without being swallowed.

Flow:

    API → Service → Repository → Notifier → UI

Typed exceptions (`app_exception.dart`):

    NetworkException       ← no internet / ping failed
    ApiException           ← HTTP 4xx / 5xx responses
    UnauthorizedException  ← 401 / session expired
    ValidationException    ← bad input / form errors

UI must display **friendly errors** via `PageErrorDisplay`.

Rules:
-   Never swallow exceptions with empty catch blocks
-   Always rethrow or map to a typed exception
-   Never expose stack traces in the UI
-   Use `AppPageError.from(error)` to convert any exception to display-safe text

------------------------------------------------------------------------

# Logging

Create:

    core/utils/logger.dart

Avoid print statements.

------------------------------------------------------------------------

# New Page / Edit Page Checklist

Every new page and every significant edit to an existing page MUST
verify all items below before the task is considered done.

**Architecture**
- [ ] Page lives in the correct `features/<feature>/presentation/screens/` path
- [ ] State management is in a Riverpod notifier, not inside the widget
- [ ] No business logic or API calls inside widgets

**Responsive**
- [ ] Mobile layout widget exists (`_mobile_layout.dart`)
- [ ] Tablet layout widget exists (`_tablet_layout.dart`)
- [ ] `ResponsiveBuilderWidget` is used in the main page to switch layouts
- [ ] Mobile uses `AppSpacing.md` (16) horizontal padding
- [ ] Tablet uses `AppSpacing.xl` (32) horizontal padding
- [ ] Grid column counts differ between mobile and tablet
- [ ] All responsive values use `ResponsiveValue<T>` not raw ternary conditionals

**Design Tokens**
- [ ] All colors reference `AppColors.*` — zero raw hex values
- [ ] All spacing references `AppSpacing.*` — zero raw doubles
- [ ] All text styles start from `AppTypography.*` — zero raw `TextStyle(fontSize:...)`
- [ ] Border radii use `AppSpacing.borderRadius*` constants

**States**
- [ ] Loading state handled (skeleton or shimmer)
- [ ] Error state renders `PageErrorDisplay` with correct `AppPageError`
- [ ] Empty state handled with `EmptyView`
- [ ] No-internet state is covered by the error state via `NetworkException → AppPageError`
- [ ] Retry button in `PageErrorDisplay` calls notifier's `load()` method
- [ ] Notifier auto-retries when `ConnectivityService` emits `true` after an error

**Connectivity**
- [ ] Repository guards every network call with `NetworkChecker.assertConnection()`
- [ ] Notifier subscribes to `connectivityServiceProvider` stream
- [ ] Auto-reload triggers only when page is currently in an error state
- [ ] Ping-based check used — not just OS connectivity status

**Naming**
- [ ] Files are snake_case
- [ ] Classes are PascalCase
- [ ] Providers follow `featureNameProvider` pattern

------------------------------------------------------------------------

# Refactor Execution Steps

1.  Analyze project structure
2.  Identify features
3.  Build refactor plan
4.  Move files into feature structure
5.  Extract logic from widgets
6.  Create repositories/services
7.  Implement Riverpod notifiers
8.  Add loading/error/empty states
9.  Implement `ConnectivityService` + `NetworkChecker` in `core/network/`
10. Implement `PageErrorDisplay` and `AppPageError` in shared/
11. Wire `PageErrorDisplay` into every layout's error branch
12. Add auto-reconnect stream subscription to every notifier
13. Create mobile + tablet layout widgets for each page
14. Wire layouts through `ResponsiveBuilderWidget`
15. Apply design tokens (AppColors, AppSpacing, AppTypography) everywhere
16. Implement animation architecture
17. Standardize naming
18. Extract shared widgets
19. Remove duplicate logic
20. Run through the New Page Checklist for every page touched

------------------------------------------------------------------------

# Code Quality Rules

The final architecture must be:

-   modular
-   scalable
-   readable
-   consistent
-   predictable
-   responsive (mobile-first, tablet-enhanced)

Avoid:

-   God classes
-   huge widgets
-   duplicated logic
-   scattered helpers
-   navigation chaos
-   hardcoded sizes, colors, or spacing
-   single layouts that try to handle all device sizes in one widget tree
-   per-feature copies of error/offline UI (use `PageErrorDisplay` always)
-   Snackbars as the sole error feedback for full-page failures

------------------------------------------------------------------------

# Expected Result

After any change the affected area should have:

-   clean feature architecture
-   predictable Riverpod state flow
-   separate mobile and tablet layout widgets
-   all spacing/colors/typography from design tokens
-   reusable animations
-   centralized navigation
-   `PageErrorDisplay` for all error + offline states
-   auto-reconnect behavior on connectivity restore
-   ping-verified internet check (not just OS network status)
-   consistent naming
-   reusable UI components

The codebase must look like a **clean professional Flutter
architecture** that a senior engineer would be proud to ship.

------------------------------------------------------------------------

## AI Usage Rules

When using an AI assistant on this codebase:
- Always run Prompt 1 (Insight) before any code changes
- Always run Prompt 2 (Audit) before any refactor
- Never let the AI refactor more than ONE module per session
- Never let the AI mix Phase A (infrastructure) and Phase B (features) in one task
- Every AI-generated file must be checked against the New Page Checklist before accepting