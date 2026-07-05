---
type: Flow
title: Admin Operations
description: The daily counter workflow — monitor, manage sessions/bookings, walk-ins, bill, resolve.
tags: [flow, admin, operations]
timestamp: 2026-07-04
---

```
AdminDashboard (/admin/dashboard) ── live grid (WS) ──▶ SessionManagement (/admin/sessions)
   analytics/dashboard + systems/live                     sessions + sessions/active; end/extend/pause/resume
      │
      ├─▶ WalkIn (/admin/walk-in) ── POST bookings/walk-in ──▶ instant session
      ├─▶ BookingManagement (/admin/bookings) ── PATCH bookings/:id (extend)
      ├─▶ BillingPayments (/admin/billing) ── bill session, record payment, override (reason), refund
      └─▶ DisputeResolution (/admin/disputes) ── review → resolve (credit/refund/upheld)
```

1. Open on the [dashboard](../modules/admin.md) (live systems + today's metrics).
2. Run the floor: start walk-ins, manage/extend bookings, end/pause/resume sessions.
3. **End a session → generate its bill** (`POST /billing/:sessionId/bill`), then **record payment**; overrides need a reason (audited, immutable backend ledger).
4. Handle [disputes](../modules/admin.md): review → resolve (credit issued / refund logged / upheld).

All mutations run through `*_command_notifier`s exposing `admin_command_state`. Mirrors backend
[booking→session→billing](../references/backend-brain-link.md), [payment-and-refund](../references/backend-brain-link.md),
[dispute-resolution](../references/backend-brain-link.md).
</content>
