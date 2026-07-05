---
type: System
title: WebSockets
description: Two realtime clients — player notifications and admin store-live — mirroring the backend WS channels.
resource: file://lib/core/network
tags: [websocket, realtime, network]
timestamp: 2026-07-04
---

# `lib/core/network/`
* `player_ws_service.dart` — connects to the backend [player-notify channel](../references/backend-brain-link.md)
  (`/ws/users/:userId/notify?token=`); pushes realtime notifications into the [notifications](../modules/notifications.md) UI.
* `admin_live_service.dart` — connects to the [store-live channel](../references/backend-brain-link.md)
  (`/ws/stores/:storeId/live?token=`); drives the admin dashboard's live session/system grid.
* `connectivity_service.dart` / `network_checker.dart` — online/offline detection used to gate calls and reconnect sockets.

WS auth is via `?token=<jwt>` query param (browsers can't set WS headers). Both services answer `ping`
with `pong`. See [Admin Live Monitoring flow](../flows/admin-live-monitoring.md).
</content>
