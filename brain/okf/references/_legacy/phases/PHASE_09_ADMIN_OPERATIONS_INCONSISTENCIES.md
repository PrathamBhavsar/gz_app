# Phase 9 — Admin Operations — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- The repo only had admin constants for `sessions/active`, `session/:id`, and booking action endpoints. Phase 9 added `GET /stores/:storeId/sessions`, `POST /stores/:storeId/sessions`, and `GET /stores/:storeId/bookings/:id` constants to match the plan.
- `AdminLiveService` was implemented but not wired to any provider before this phase. Phase 9 now exposes it through Riverpod and refreshes dashboard/session screens from live events instead of leaving it orphaned.

## Missing / renamed endpoints or constants
- Added `ApiConstants.sessionsList`, `ApiConstants.sessionCreate`, `ApiConstants.bookingDetail`, and `ApiConstants.bookingUpdate`.

## Model ↔ JSON field mismatches (nullable, casing, types)
- `BookingModel` needed optional admin display fields (`userName`, `systemName`, `durationMinutes`, `paymentMethod`, `paymentStatus`, `paymentReference`) because admin booking UIs need richer data than player flows.
- `SessionModel` needed optional admin display fields (`userName`, `systemName`, `billedAmount`) for session management cards and billing summaries.
- Current parsing accepts both snake_case and camelCase for the new display fields because local docs and existing model conventions are mixed.

## Registry ↔ code drift fixed
- Added `brain/features/.registry/admin_operations.md` because Phase 9 previously had no admin registry entry despite now having a real repository/notifier layer.
- Updated `brain/code_map.md` with the new `lib/features/admin/data/repositories/` and `lib/features/admin/application/` files plus the wired operations screens.

## Dummy data removed (file:line)
- `lib/features/admin/presentation/screens/operations/admin_dashboard_screen.dart`
- `lib/features/admin/presentation/screens/operations/session_management_screen.dart`
- `lib/features/admin/presentation/screens/operations/booking_management_screen.dart`
- `lib/features/admin/presentation/screens/operations/admin_booking_detail_screen.dart`
- `lib/features/admin/presentation/screens/operations/walk_in_booking_screen.dart`
- `lib/features/admin/presentation/screens/operations/cancel_booking_sheet.dart`
- `lib/features/admin/presentation/screens/operations/end_session_sheet.dart`
- `lib/features/admin/presentation/screens/operations/extend_session_sheet.dart`

## Open TODOs / deferred
- Backend runtime verification is still needed for the exact walk-in payload shape. The current client sends `duration` plus optional `userName` / `phone` fields in addition to documented `userId`, `systemId`, and `paymentMethod`.
- Backend runtime verification is still needed for admin booking/session display fields (`userName`, `systemName`, payment metadata). The UI now consumes them if present and falls back to ids when absent.
- `POST /stores/:storeId/sessions` is defined in constants for Phase 9 completeness but the current flow uses `POST /stores/:storeId/bookings/walk-in` for the walk-in screen.
- Second-pass static verification is complete (`dart analyze` clean, dummy-data grep clean), but backend-backed runtime verification is still pending against a live Phase 9 API.
