---
type: Module
title: Booking
description: The multi-step reservation flow — browse → time+system → summary → success.
resource: file://lib/features/booking
tags: [booking, reservation, flow]
timestamp: 2026-07-07
---

# Responsibilities
Guide the player from browsing systems to a confirmed, paid booking. Notifiers: `booking_form_notifier`,
`systems_notifier`, `system_types_notifier`, `booking_notifier`, `booking_payment_notifier`,
`booking_summary_ui_notifier`. Repositories: `booking_repository.dart`, `systems_repository.dart`.
Backend: [bookings](../references/backend-brain-link.md) + [systems](../references/backend-brain-link.md).

# Screens

| # | Screen | Route | Backend call | Notes |
| --- | --- | --- | --- | --- |
| 15 | BookingSlotSelectionScreen | `/book` (tab) | `GET /stores/:storeId/systems/available` | Browse systems + filter by type; entry point only, no time window yet. |
| 16 | BookingAvailabilityScreen | `/book/availability` | `GET /stores/:storeId/systems/available` | Pick a date + client-generated hourly time slot, then pick a system from the live-availability list for that window. |
| 18 | BookingSummaryScreen | `/book/summary` | `POST /stores/:storeId/bookings` | Review + price ([pricing/calculate]) → create booking. |
| 19 | BookingSuccessScreen | `/book/success` | `POST /stores/:storeId/bookings/:id/pay` | Confirm/pay → confirmed. |

# Notes
There is no `BookingSystemSelectionScreen`/`/book/systems` step anymore — picking the time slot and the
system happen on the same `BookingAvailabilityScreen`, both driven by `systems_notifier` re-fetching
`GET /systems/available` whenever `selectedSlot`/`selectedSystemTypeId` change. The backend has no endpoint
that buckets a day into hourly slots with a per-slot system count (`GET /bookings/availability` is a
boolean single-system/single-window check, not a slot list), so slot times are generated client-side
(`generateBookingSlotStarts` in `booking_presenters.dart`, hourly 10:00-23:00) rather than fetched.
Creating a booking is under a backend Redis lock (`BOOKING_OVERLAP` on clash). Unpaid bookings expire via
backend jobs. Post-booking the player manages it under [sessions](sessions.md) (detail/check-in/pay).
See [Discover → Book → Pay flow](../flows/discover-book-pay.md).
</content>
