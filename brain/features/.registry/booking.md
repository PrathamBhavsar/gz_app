# Feature Registry: Booking Flow
> TARGET SPEC — not yet implemented

## Reality Check
Only presentation screens exist today:
- `lib/features/booking/presentation/screens/slot_selection/booking_slot_selection_screen.dart`
- `lib/features/booking/presentation/screens/availability/booking_availability_screen.dart`
- `lib/features/booking/presentation/screens/system_selection/booking_system_selection_screen.dart`
- `lib/features/booking/presentation/screens/summary/booking_summary_screen.dart`
- `lib/features/booking/presentation/screens/success/booking_success_screen.dart`

No `data/` or `application/` folders exist under `lib/features/booking/`.

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/booking/data/repositories/booking_repository.dart` | Availability, booking creation, payment, cancel, check-in | No |
| `lib/features/booking/data/repositories/systems_repository.dart` | Available systems for the active store | No |
| `lib/features/booking/application/systems_notifier.dart` | Systems list and periodic refresh | No |
| `lib/features/booking/application/availability_notifier.dart` | Slot availability state | No |
| `lib/features/booking/application/booking_notifier.dart` | Multi-screen flow accumulation | No |
| `lib/features/booking/application/booking_form_notifier.dart` | Submit booking action state | No |
| `lib/features/booking/application/booking_summary_ui_notifier.dart` | Local summary UI selections | No |

## Planned Endpoints
- `GET /stores/:storeId/systems/available`
- `GET /stores/:storeId/bookings/availability`
- `POST /stores/:storeId/bookings`
- `POST /stores/:storeId/bookings/:id/pay`

## Notes
- This is the target Phase 3 shape, not an implemented record.
- Wallet and campaigns integration for the booking summary screen depends on later wallet work and should be tracked in the phase inconsistency file when Phase 3 begins.
