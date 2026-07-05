---
type: Module
title: Sessions (Player)
description: The player's activity hub — bookings/sessions list, check-in, payment, active + history detail, billing, logs.
resource: file://lib/features/sessions
tags: [sessions, bookings, billing, check-in]
timestamp: 2026-07-04
---

# Responsibilities
Everything after a booking exists: track bookings/sessions, check in, pay, watch the active session,
review history, billing, and logs. Notifiers: `activity_hub_notifier`, `active_session_notifier`,
`booking_detail_notifier`, `payment_notifier`, `session_detail_notifier`, `session_logs_notifier`,
`billing_notifier`. Repositories: `bookings_repository`, `sessions_repository`, `billing_repository`.
Runtime providers: `presentation/providers/session_runtime_providers.dart`.

# Screens

| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 20 | SessionsScreen | `/sessions` (tab) | `GET /stores/:storeId/sessions/my`, `GET /stores/:storeId/bookings/my` |
| 21 | ActiveSessionScreen | `/sessions/active` | active-session bootstrap (legacy route, kept) |
| 22 | BookingDetailScreen | `/sessions/booking/:id` | `GET /stores/:storeId/bookings/:id`, `POST .../cancel` |
| 23 | CheckInScreen | `/sessions/booking/:id/check-in` | `POST /stores/:storeId/bookings/:id/check-in` |
| 24 | PaymentScreen (sheet) | `/sessions/booking/:id/pay` | `POST /stores/:storeId/bookings/:id/pay` |
| 25 | ActiveSessionDetailScreen | `/sessions/active/:id` | `GET /stores/:storeId/sessions/:id` |
| 26 | SessionHistoryDetailScreen | `/sessions/history/:id` | `GET /stores/:storeId/sessions/:id` |
| 27 | BillingHistoryScreen | `/sessions/billing` | `GET /stores/:storeId/billing/my` |
| 28 | SessionLogsScreen | `/sessions/logs/:id` | `GET /stores/:storeId/sessions/:id/logs` |

# Notes
Check-in turns a confirmed booking into an active session (backend creates the session). Billing history
is read-only; a charge can be challenged via [disputes](disputes.md) (deep-link carries `billingId`).
See [Check-in → Active Session flow](../flows/check-in-active-session.md).
</content>
