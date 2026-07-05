---
type: Module
title: Notifications (Player)
description: The player notification inbox + preferences, fed by REST and the realtime WS.
resource: file://lib/features/notifications
tags: [notifications, inbox, realtime]
timestamp: 2026-07-04
---

# Responsibilities
Show the inbox, mark read, and reflect realtime pushes. Notifiers: `notifications_notifier`,
`notification_detail_notifier`. Repository: `notifications_repository.dart`. Realtime via
[`player_ws_service`](../systems/websockets.md). Backend: [notifications](../references/backend-brain-link.md).
Preferences UI lives in [profile](profile.md) (NotifPrefs).

# Screens

| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 33 | NotificationsScreen | `/notifications` | `GET /notifications`, `PATCH /notifications/:id/read`, `POST /notifications/read-all` |

# Notes
Opened as a full-screen route or as a deep-link overlay (`gzapp://notifications` sets a pending overlay
then lands on home — see [Navigation](../systems/navigation-routing.md)). `reference_type/id` deep-link to
the relevant screen. See [Notification handling flow](../flows/notification-dispatch-consume.md).
</content>
