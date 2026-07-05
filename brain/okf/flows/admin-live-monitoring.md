---
type: Flow
title: Admin Live Monitoring
description: The realtime dashboard fed by the store-live WebSocket plus polled live endpoints.
tags: [flow, admin, realtime, websocket]
timestamp: 2026-07-04
---

1. On the [admin dashboard](../modules/admin.md), `admin_live_service` opens the **store-live WS**
   (`/ws/stores/:storeId/live?token=<admin jwt>`) — see [WebSockets](../systems/websockets.md).
2. The backend `broadcastToStore` pushes events (session started/ended, system status) which update the
   live grid without a refetch.
3. Alongside the socket, `GET /systems/live` (heartbeat-based `isAgentOnline`, >2 min stale = offline) and
   `GET /sessions/active` (cached 30s) seed/repair the grid; `analytics/dashboard` fills the KPIs.
4. Tapping a system drills into [SessionManagement](../modules/admin.md) (via `?systemId=`) or system detail.

Mirrors the backend [realtime](../references/backend-brain-link.md) + [agent-offline-sync](../references/backend-brain-link.md).
</content>
