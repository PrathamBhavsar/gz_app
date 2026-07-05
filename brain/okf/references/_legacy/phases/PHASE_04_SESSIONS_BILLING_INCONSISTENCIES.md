# Phase 4 — Sessions, My-Bookings & Billing — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- Backend enum strings are snake_case / alias-heavy (`in_progress`, `super_admin`, `paid`), while older Flutter parsing expected exact enum names. Phase 4 updated `lib/models/enums.dart` normalization to accept snake_case and the `paid -> completed` payment-status alias.

## Missing / renamed endpoints or constants
- Added missing player constants in `lib/core/api/api_constants.dart`:
  - `playerBookingDetail`
  - `playerSessionDetail`
  - `playerSessionLogs`

## Model ↔ JSON field mismatches (nullable, casing, types)
- Session log status parsing was failing on backend `in_progress` values before enum normalization.

## Registry ↔ code drift fixed
- Added real Sessions data layer:
  - `lib/features/sessions/data/repositories/sessions_repository.dart`
  - `lib/features/sessions/data/repositories/bookings_repository.dart`
  - `lib/features/sessions/data/repositories/billing_repository.dart`
- Added live Sessions application layer:
  - `lib/features/sessions/application/activity_hub_notifier.dart`
  - `lib/features/sessions/application/active_session_notifier.dart`
  - `lib/features/sessions/application/billing_notifier.dart`
  - `lib/features/sessions/application/booking_detail_notifier.dart`
  - `lib/features/sessions/application/payment_notifier.dart`
  - `lib/features/sessions/application/session_detail_notifier.dart`
  - `lib/features/sessions/application/session_logs_notifier.dart`
  - `lib/features/sessions/application/session_ui_models.dart`
- Replaced the old generated Sessions runtime provider implementation with a compatibility export file:
  - `lib/features/sessions/presentation/providers/session_runtime_providers.dart`
- Deleted stale generated file:
  - `lib/features/sessions/presentation/providers/session_runtime_providers.g.dart`
- Synced `brain/code_map.md` with the new files.

## Dummy data removed (file:line)
- `lib/features/sessions/presentation/screens/sessions_screen.dart` now reads from `activityHubNotifierProvider` instead of hardcoded provider state.
- `lib/features/sessions/presentation/screens/billing_history_screen.dart` now reads from `billingNotifierProvider` instead of inline dummy rows.
- `lib/features/sessions/presentation/screens/booking_detail_screen.dart` now reads from `bookingDetailNotifierProvider` and uses command notifiers for cancel/check-in actions.
- `lib/features/sessions/presentation/screens/check_in_screen.dart` now reads from live booking detail state and triggers real check-in.
- `lib/features/sessions/presentation/screens/payment_screen.dart` now reads live booking detail state and triggers real booking payment.
- `lib/features/sessions/presentation/screens/active_session_detail_screen.dart` now reads from `activeSessionNotifierProvider`.
- `lib/features/sessions/presentation/screens/session_history_detail_screen.dart` now reads from `sessionDetailNotifierProvider`.
- `lib/features/sessions/presentation/screens/session_logs_screen.dart` now reads from `sessionLogsNotifierProvider`.
- `lib/features/sessions/presentation/screens/active_session_screen.dart` now reads from `activityHubNotifierProvider` instead of legacy dummy content.

## Open TODOs / deferred
- Widget coverage added for the main live read surfaces:
  - `test/features/sessions/presentation/sessions_screen_test.dart`
  - `test/features/sessions/presentation/billing_history_screen_test.dart`
- Plan-aligned notifier tests added:
  - `test/features/sessions/application/activity_hub_notifier_test.dart`
  - `test/features/sessions/application/booking_actions_notifier_test.dart`
- No remaining Phase 4 implementation TODOs in the player Sessions/Billing scope.
