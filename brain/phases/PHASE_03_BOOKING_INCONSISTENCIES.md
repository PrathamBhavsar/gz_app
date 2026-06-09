# Phase 3 — Booking — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- Reconciled `ApiConstants.bookingPayment` from `/stores/{storeId}/bookings/{id}/payment` to backend contract `/stores/{storeId}/bookings/{id}/pay`.

## Missing / renamed endpoints or constants
- Added `ApiConstants.bookingsAvailability` for `GET /stores/:storeId/bookings/availability`.

## Model ↔ JSON field mismatches (nullable, casing, types)
- Extended `SystemModel` to parse `price_per_hour` / `pricePerHour` so booking screens can render live pricing.
- Extended loyalty models to accept alternate backend field names (`balance`, `discount_value`, `type`, `redemption_count`) used by credits/campaign endpoints.

## Registry ↔ code drift fixed
- `brain/code_map.md` updated for new booking `data/`, `application/`, and shared presentation helper files.
- `brain/features/.registry/booking.md` updated from target-only status to implemented Phase 3 core flow status.

## Dummy data removed (file:line)
- `lib/features/booking/presentation/screens/slot_selection/booking_slot_selection_screen.dart`
- `lib/features/booking/presentation/screens/availability/booking_availability_screen.dart`
- `lib/features/booking/presentation/screens/system_selection/booking_system_selection_screen.dart`
- `lib/features/booking/presentation/screens/summary/booking_summary_screen.dart`
- `lib/features/booking/presentation/screens/success/booking_success_screen.dart`

## Accepted carry-forward items
- Local total shown on booking summary is an estimate only; the backend remains authoritative for final pricing after campaign and credit application.
- Availability filtering now uses `systemTypeId`, but the UI no longer exposes the older platform-only chip model from the initial prototype.
