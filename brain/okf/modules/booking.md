---
type: Module
title: Booking
description: The multi-step reservation flow — slot → availability → system → summary → success.
resource: file://lib/features/booking
tags: [booking, reservation, flow]
timestamp: 2026-07-04
---

# Responsibilities
Guide the player from picking a slot to a confirmed, paid booking. Notifiers: `booking_form_notifier`,
`availability_notifier`, `systems_notifier`, `system_types_notifier`, `booking_notifier`,
`booking_payment_notifier`, `booking_summary_ui_notifier`. Repositories: `booking_repository.dart`,
`systems_repository.dart`. Backend: [bookings](../references/backend-brain-link.md) + [systems](../references/backend-brain-link.md).

# Screens

| # | Screen | Route | Backend call | Notes |
| --- | --- | --- | --- | --- |
| 15 | BookingSlotSelectionScreen | `/book` (tab) | `GET /stores/:storeId/systems/available` | Choose time/slot. |
| 16 | BookingAvailabilityScreen | `/book/availability` | `GET /stores/:storeId/bookings/availability` | Confirm the window is free. |
| 17 | BookingSystemSelectionScreen | `/book/systems` | `GET /stores/:storeId/systems/available` | Pick the station. |
| 18 | BookingSummaryScreen | `/book/summary` | `POST /stores/:storeId/bookings` | Review + price ([pricing/calculate]) → create booking. |
| 19 | BookingSuccessScreen | `/book/success` | `POST /stores/:storeId/bookings/:id/pay` | Confirm/pay → confirmed. |

# Notes
Creating a booking is under a backend Redis lock (`BOOKING_OVERLAP` on clash). Unpaid bookings expire via
backend jobs. Post-booking the player manages it under [sessions](sessions.md) (detail/check-in/pay).
See [Discover → Book → Pay flow](../flows/discover-book-pay.md).
</content>
