---
type: Flow
title: Discover → Book → Pay
description: The core player journey from finding a store to a confirmed, paid booking.
tags: [flow, booking, discovery, payment]
timestamp: 2026-07-04
---

```
Home (/home) ─▶ StoreDetail (/home/store/:slug) ─set active store─▶ Book (/book)
   GET /stores            GET /stores/:slug + systems/available + campaigns/active
      │
      ▼
Availability (/book/availability) ─▶ Systems (/book/systems) ─▶ Summary (/book/summary) ─▶ Success (/book/success)
   GET bookings/availability   GET systems/available    POST bookings           POST bookings/:id/pay
```

1. **Discover** in [home](../modules/home.md); opening a store sets the **active store** (supplies `:storeId`).
2. **[Booking flow](../modules/booking.md)**: pick slot → confirm availability → pick system → review price (backend `pricing/calculate`) → `POST /bookings` (under a Redis lock; `BOOKING_OVERLAP` handled) → **pay** to confirm.
3. Unpaid bookings expire server-side; the confirmed booking then lives in [sessions](../modules/sessions.md) for [check-in](check-in-active-session.md).

Mirrors the backend [booking→session→billing](../references/backend-brain-link.md) path.
</content>
