# Registry: Admin Operations Feature
> IMPLEMENTED — Phase 9 live admin operations wiring is in place

## Reality Check
The admin operations slice now has a real data layer, application state, and live presentation wiring:
- `lib/features/admin/data/repositories/admin_dashboard_repository.dart`
- `lib/features/admin/data/repositories/admin_sessions_repository.dart`
- `lib/features/admin/data/repositories/admin_bookings_repository.dart`
- `lib/features/admin/application/admin_dashboard_notifier.dart`
- `lib/features/admin/application/admin_sessions_notifier.dart`
- `lib/features/admin/application/admin_bookings_notifier.dart`
- `lib/features/admin/application/admin_booking_detail_notifier.dart`
- `lib/features/admin/application/admin_session_command_notifier.dart`
- `lib/features/admin/application/admin_booking_command_notifier.dart`
- `lib/features/admin/application/admin_walk_in_notifier.dart`
- `lib/features/admin/presentation/screens/operations/admin_dashboard_screen.dart`
- `lib/features/admin/presentation/screens/operations/session_management_screen.dart`
- `lib/features/admin/presentation/screens/operations/booking_management_screen.dart`
- `lib/features/admin/presentation/screens/operations/admin_booking_detail_screen.dart`
- `lib/features/admin/presentation/screens/operations/walk_in_booking_screen.dart`

## Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/admin/data/repositories/admin_dashboard_repository.dart` | Dashboard analytics + live systems floor feed | Yes |
| `lib/features/admin/data/repositories/admin_sessions_repository.dart` | Admin session list/detail/logs + pause/resume/end/extend actions | Yes |
| `lib/features/admin/data/repositories/admin_bookings_repository.dart` | Admin bookings list/detail + check-in/cancel + walk-in creation | Yes |
| `lib/features/admin/application/admin_dashboard_notifier.dart` | Dashboard `AsyncValue<AdminDashboardData>` | Yes |
| `lib/features/admin/application/admin_sessions_notifier.dart` | Session management `AsyncValue<AdminSessionsData>` keyed by selected system | Yes |
| `lib/features/admin/application/admin_bookings_notifier.dart` | Bookings list state with date/status filters | Yes |
| `lib/features/admin/application/admin_booking_detail_notifier.dart` | Booking detail by id | Yes |
| `lib/features/admin/application/admin_session_command_notifier.dart` | Session mutation commands | Yes |
| `lib/features/admin/application/admin_booking_command_notifier.dart` | Booking mutation commands | Yes |
| `lib/features/admin/application/admin_walk_in_notifier.dart` | Walk-in creation flow | Yes |

## Endpoints In Use
- `GET /stores/:storeId/analytics/dashboard`
- `GET /stores/:storeId/systems/live`
- `GET /stores/:storeId/sessions`
- `GET /stores/:storeId/sessions/active`
- `GET /stores/:storeId/sessions/:id`
- `GET /stores/:storeId/sessions/:id/logs`
- `POST /stores/:storeId/sessions/:id/pause`
- `POST /stores/:storeId/sessions/:id/resume`
- `POST /stores/:storeId/sessions/:id/end`
- `POST /stores/:storeId/billing/:sessionId/bill`
- `POST /stores/:storeId/sessions/:id/extend`
- `GET /stores/:storeId/bookings`
- `GET /stores/:storeId/bookings/admin/:id`
- `POST /stores/:storeId/bookings/:id/check-in`
- `POST /stores/:storeId/bookings/:id/cancel`
- `POST /stores/:storeId/bookings/walk-in`
- `WS /ws/stores/:storeId/live`

## Notes
- The operations screens now render loading, error, empty, and data states instead of inline sample rows.
- WP1 parity fix corrected admin booking detail to the admin-auth `/bookings/admin/:id` route; existing detail UI and command flows were reused unchanged.
- `AdminLiveService` is now exposed via Riverpod and used to trigger refreshes from live store events.
- `BookingModel` and `SessionModel` were extended with optional display fields (`userName`, `systemName`, payment metadata, billed amount) because admin endpoints are expected to return richer payloads than the player flows.
- Walk-in submission currently sends `systemId`, `duration`, optional `paymentMethod`, and optional customer identifiers. If backend payload requirements differ, update `AdminBookingsRepository.createWalkInBooking`.
- WP3 parity fix chains `POST /sessions/:id/end` with `POST /billing/:sessionId/bill` inside the existing `adminSessionCommandNotifierProvider` so the end-session UX now matches the screen copy and backend split contract.
