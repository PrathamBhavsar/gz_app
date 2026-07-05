---
type: Flow
title: Check-in → Active Session
description: From a confirmed booking to a live, tracked, and billed session.
tags: [flow, session, check-in, billing]
timestamp: 2026-07-04
---

```
Sessions (/sessions) ─▶ BookingDetail (/sessions/booking/:id) ─▶ CheckIn (.../check-in)
   GET sessions/my + bookings/my    GET bookings/:id            POST bookings/:id/check-in
      │
      ▼
ActiveSessionDetail (/sessions/active/:id) ─play─▶ HistoryDetail (/sessions/history/:id) + BillingHistory (/sessions/billing)
   GET sessions/:id                                 GET sessions/:id                 GET billing/my
```

1. The player's activity hub ([sessions](../modules/sessions.md)) lists bookings + sessions.
2. **Check-in** (`POST /bookings/:id/check-in`) — the backend creates a live session; the app shows the **active session** with a running timer.
3. Ending is admin/agent-driven server-side; the app reflects `completed` and shows [billing history](../modules/sessions.md) and [session logs](../modules/sessions.md).
4. A disputed charge routes to [Disputes](disputes.md) with a prefilled `billingId`.

Mirrors backend [booking→session→billing](../references/backend-brain-link.md).
</content>
