# Phase 2 Home Stores Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire the player home, store search, store detail, and store selector flows to live store APIs with persistent active-store state and zero inline dummy data.

**Architecture:** Add a `StoreRepository` in `features/home/data/repositories` and plain Riverpod notifiers in `features/home/application`. Keep parsing in the repository layer, use `AsyncValue` for read screens, use the shared `TokenStorage` + `activeStoreIdProvider` for persisted store context, and update the existing presentation screens/widgets to render loading, error, empty, and data states.

**Tech Stack:** Flutter, `flutter_riverpod`, `go_router`, existing `ApiClient`, `NetworkChecker`, manual `lib/models/*` parsing, shared error/loading widgets.

---

### Task 1: Foundation For Phase 2 Store APIs

**Files:**
- Modify: `lib/core/api/api_constants.dart`
- Create: `lib/features/home/data/repositories/store_repository.dart`

- [ ] Add missing public store endpoint constants for list/detail queries.
- [ ] Implement `StoreRepository` with list/search/detail/campaign/system methods.
- [ ] Keep response parsing defensive for both envelope-style `data` payloads and legacy keyed payloads like `stores`, `campaigns`, and `systems`.

### Task 2: Add Home Feature Application State

**Files:**
- Create: `lib/features/home/application/home_notifier.dart`
- Create: `lib/features/home/application/store_search_notifier.dart`
- Create: `lib/features/home/application/store_detail_notifier.dart`
- Create: `lib/features/home/application/active_store_notifier.dart`

- [ ] Implement `homeNotifierProvider` as `AsyncNotifier<HomeData>`.
- [ ] Implement `storeSearchNotifierProvider` with debounced query/filter state and refresh support.
- [ ] Implement `storeDetailNotifierProvider.family(slug)` returning store detail, campaigns, and systems.
- [ ] Implement `activeStoreNotifierProvider` to hydrate persisted selection and persist changes back to secure storage.

### Task 3: Wire Presentation To Real Data

**Files:**
- Modify: `lib/features/home/presentation/screens/home_screen.dart`
- Modify: `lib/features/home/presentation/screens/store_search/store_search_screen.dart`
- Modify: `lib/features/home/presentation/screens/store_detail/store_detail_screen.dart`
- Modify: `lib/shared/widgets/store_selector_sheet.dart`

- [ ] Remove dummy lists and replace with notifier-backed rendering.
- [ ] Add loading/error/empty/data handling using `GzLoadingView` and `PageErrorDisplay`.
- [ ] Ensure the detail screen sets the active store on the Book CTA before routing to `AppRoutes.book`.
- [ ] Reuse the new active-store selection flow in the shared selector sheet.

### Task 4: Sync Brain And Phase Tracking

**Files:**
- Modify: `brain/code_map.md`
- Modify: `brain/features/.registry/home.md`
- Modify: `brain/phases/PHASE_02_HOME_STORES_INCONSISTENCIES.md`

- [ ] Update the code map with the new `home/data` and `home/application` files.
- [ ] Mark the home registry against the new live implementation status.
- [ ] Record endpoint/model mismatches, remaining TODOs, and dummy-data removals in the Phase 2 inconsistency file.

### Task 5: Verification

**Files:**
- None

- [ ] Run `flutter analyze`.
- [ ] Review analyzer output and fix Phase 2 regressions before reporting status.
