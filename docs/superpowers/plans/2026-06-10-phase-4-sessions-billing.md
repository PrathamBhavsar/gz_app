# Phase 4 Sessions Billing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Sessions feature's dummy state with live API-backed repositories and Riverpod notifiers, then wire the Phase 4 sessions, booking, payment, billing, and logs screens to real backend data.

**Architecture:** Keep the existing repo convention from phases 1-3: `Widget -> Notifier -> Repository -> ApiClient -> API`, with shared manual models in `lib/models/`. Use `AsyncNotifier` for read surfaces, explicit `Notifier` action states for payment/cancel/check-in mutations, and reuse the existing screens with focused UI refactors instead of broad redesign.

**Tech Stack:** Flutter, `flutter_riverpod`, shared `ApiClient`, manual JSON models, `go_router`, shared loading and error widgets.

---

### Task 1: Data contracts and repository layer

**Files:**
- Create: `lib/features/sessions/data/repositories/sessions_repository.dart`
- Create: `lib/features/sessions/data/repositories/bookings_repository.dart`
- Create: `lib/features/sessions/data/repositories/billing_repository.dart`
- Modify: `lib/core/api/api_constants.dart`
- Modify: `lib/models/api_responses.dart`
- Modify: `lib/models/domain_billing.dart`
- Modify: `brain/phases/PHASE_04_SESSIONS_BILLING_INCONSISTENCIES.md`

- [ ] **Step 1: Write failing repository/model tests**

Create focused tests for Phase 4 response parsing and repository edge cases:
- `test/features/sessions/data/sessions_phase4_models_test.dart`
- `test/features/sessions/data/sessions_phase4_repository_test.dart`

Coverage:
- parse billing list payload into rows
- parse session logs payload into rows
- missing active store throws `ValidationException`
- booking pay/cancel/check-in paths interpolate `storeId` and `id`

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/sessions/data/sessions_phase4_models_test.dart test/features/sessions/data/sessions_phase4_repository_test.dart`

Expected:
- fails because repository files/providers or parsing helpers do not exist yet

- [ ] **Step 3: Implement repository and model support**

Add Phase 4 endpoints if missing:
- player booking detail
- player session detail
- player session logs

Implement repositories with:
- `assertConnection()`
- `_store()` helper using `activeStoreIdProvider`
- list/object payload extraction helpers matching earlier phases
- typed `ApiException` for missing expected payloads

- [ ] **Step 4: Re-run repository/model tests**

Run: `flutter test test/features/sessions/data/sessions_phase4_models_test.dart test/features/sessions/data/sessions_phase4_repository_test.dart`

Expected:
- all tests pass

### Task 2: Application state for hub, details, billing, and actions

**Files:**
- Create: `lib/features/sessions/application/session_ui_models.dart`
- Create: `lib/features/sessions/application/activity_hub_notifier.dart`
- Create: `lib/features/sessions/application/booking_detail_notifier.dart`
- Create: `lib/features/sessions/application/active_session_notifier.dart`
- Create: `lib/features/sessions/application/session_detail_notifier.dart`
- Create: `lib/features/sessions/application/billing_notifier.dart`
- Create: `lib/features/sessions/application/payment_notifier.dart`
- Modify: `lib/features/sessions/presentation/providers/session_runtime_providers.dart`

- [ ] **Step 1: Write failing notifier tests**

Create:
- `test/features/sessions/application/activity_hub_notifier_test.dart`
- `test/features/sessions/application/booking_actions_notifier_test.dart`

Coverage:
- hub load separates active, upcoming, and past items
- payment action moves `Initial -> Loading -> Success/Error`
- active session notifier refreshes from repository instead of static state

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/sessions/application/activity_hub_notifier_test.dart test/features/sessions/application/booking_actions_notifier_test.dart`

Expected:
- fails because notifiers do not exist yet

- [ ] **Step 3: Implement notifiers and compatibility provider exports**

Implement:
- `AsyncNotifier` read providers for hub/detail/billing/session logs
- explicit action notifier for pay/cancel/check-in flows
- 30s polling for active session
- compatibility exports or lightweight wrappers in `presentation/providers/session_runtime_providers.dart` so existing screens can be migrated incrementally without codegen

- [ ] **Step 4: Re-run notifier tests**

Run: `flutter test test/features/sessions/application/activity_hub_notifier_test.dart test/features/sessions/application/booking_actions_notifier_test.dart`

Expected:
- all tests pass

### Task 3: Wire Sessions and Billing UI to live data

**Files:**
- Modify: `lib/features/sessions/presentation/screens/sessions_screen.dart`
- Modify: `lib/features/sessions/presentation/screens/booking_detail_screen.dart`
- Modify: `lib/features/sessions/presentation/screens/check_in_screen.dart`
- Modify: `lib/features/sessions/presentation/screens/payment_screen.dart`
- Modify: `lib/features/sessions/presentation/screens/active_session_detail_screen.dart`
- Modify: `lib/features/sessions/presentation/screens/session_history_detail_screen.dart`
- Modify: `lib/features/sessions/presentation/screens/session_logs_screen.dart`
- Modify: `lib/features/sessions/presentation/screens/billing_history_screen.dart`

- [ ] **Step 1: Write failing widget tests for primary read states**

Create:
- `test/features/sessions/presentation/sessions_screen_test.dart`
- `test/features/sessions/presentation/billing_history_screen_test.dart`

Coverage:
- loading uses `GzLoadingView`
- repository error uses `PageErrorDisplay`
- empty lists show empty-state error
- populated state renders rows from notifier data

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/sessions/presentation/sessions_screen_test.dart test/features/sessions/presentation/billing_history_screen_test.dart`

Expected:
- fails because screens still render static data

- [ ] **Step 3: Implement UI wiring**

Wire all read screens with `.when(...)` and action screens with `ref.listen(...)` for snackbars. Remove hardcoded lists/constants from screens and route all actions through notifiers.

- [ ] **Step 4: Re-run widget tests**

Run: `flutter test test/features/sessions/presentation/sessions_screen_test.dart test/features/sessions/presentation/billing_history_screen_test.dart`

Expected:
- all tests pass

### Task 4: Brain sync and full verification

**Files:**
- Modify: `brain/code_map.md`
- Modify: `brain/phases/PHASE_04_SESSIONS_BILLING_INCONSISTENCIES.md`

- [ ] **Step 1: Update brain artifacts**

Reflect new `features/sessions/data/` and `features/sessions/application/` files and record any endpoint/model mismatches discovered during implementation.

- [ ] **Step 2: Run phase verification**

Run:
- `flutter test test/features/sessions`
- `flutter analyze lib/features/sessions lib/core/api lib/models`

Expected:
- test run passes
- analyze exits clean
