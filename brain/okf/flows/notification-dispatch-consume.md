---
type: Flow
title: Notification Handling
description: How the app receives, stores, and deep-links notifications.
tags: [flow, notifications, realtime, deep-link]
timestamp: 2026-07-04
---

1. **Register** — the app registers its FCM token (`PATCH /auth/me/device`) so the backend can push.
2. **Realtime** — while open, [`player_ws_service`](../systems/websockets.md) receives events over the player-notify WS and updates the [notifications](../modules/notifications.md) UI live.
3. **Durable** — every notification also exists as a backend row; the inbox `GET /notifications` shows history + `unreadCount`; `PATCH /:id/read` and `POST /read-all` mark read.
4. **Deep links** — `reference_type/id` (and the `gzapp://notifications` scheme) route the user to the relevant screen; the [router](../systems/navigation-routing.md) stashes a pending overlay and lands on `/home`.
5. **Preferences** — the player toggles channels/groups in [NotifPrefs](../modules/profile.md) (`PATCH /notifications/preferences`), which the backend honours before sending.

Mirrors backend [notification-dispatch](../references/backend-brain-link.md).
</content>
