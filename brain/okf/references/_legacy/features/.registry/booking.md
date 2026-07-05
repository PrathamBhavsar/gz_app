# Feature Registry: Booking Flow
> TARGET SPEC — not yet implemented

## Reality Check
Phase 3 wiring now exists for the core booking flow:
- `lib/features/booking/data/repositories/booking_repository.dart`
- `lib/features/booking/data/repositories/systems_repository.dart`
- `lib/features/booking/application/booking_notifier.dart`
- `lib/features/booking/application/systems_notifier.dart`
- `lib/features/booking/application/availability_notifier.dart`
- `lib/features/booking/application/booking_form_notifier.dart`
- `lib/features/booking/application/booking_payment_notifier.dart`
- `lib/features/booking/presentation/booking_presenters.dart`
- `lib/features/booking/presentation/screens/slot_selection/booking_slot_selection_screen.dart`
- `lib/features/booking/presentation/screens/availability/booking_availability_screen.dart`
- `lib/features/booking/presentation/screens/system_selection/booking_system_selection_screen.dart`
- `lib/features/booking/presentation/screens/summary/booking_summary_screen.dart`
- `lib/features/booking/presentation/screens/success/booking_success_screen.dart`

Summary-time campaigns and credit redemption are now handled inside the booking flow via the booking repository + summary UI notifier.

## Planned Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/booking/data/repositories/booking_repository.dart` | Availability, booking creation, payment, cancel, check-in | Yes |
| `lib/features/booking/data/repositories/systems_repository.dart` | Available systems for the active store | Yes |
| `lib/features/booking/application/systems_notifier.dart` | Systems list and periodic refresh | Yes |
| `lib/features/booking/application/availability_notifier.dart` | Slot availability state | Yes |
| `lib/features/booking/application/booking_notifier.dart` | Multi-screen flow accumulation | Yes |
| `lib/features/booking/application/booking_form_notifier.dart` | Submit booking action state | Yes |
| `lib/features/booking/application/booking_payment_notifier.dart` | Success-screen payment action state | Yes |
| `lib/features/booking/application/booking_summary_ui_notifier.dart` | Summary campaigns, credit balance, selected campaign, credits to redeem | Yes |
| `lib/features/booking/application/system_types_notifier.dart` | Loads store system types for filter chips | Yes |

## Planned Endpoints
- `GET /stores/:storeId/systems/available`
- `GET /stores/:storeId/bookings/availability`
- `POST /stores/:storeId/bookings`
- `POST /stores/:storeId/bookings/:id/pay`

## Notes
- Booking flow now uses `bookingNotifierProvider` as the shared cross-screen state container for system type filter, date, slot, selected system, and selected payment method.
- `bookingPayment` endpoint was reconciled to `/stores/:storeId/bookings/:id/pay`.
- `booking_summary_ui_notifier.dart` owns campaign selection and credit redemption UI state, while `bookingNotifierProvider` owns cross-screen flow state.
- `BookingRepository` now also includes `cancelBooking()` and `checkInBooking()` methods so later session-detail screens can reuse the same booking transport layer.
