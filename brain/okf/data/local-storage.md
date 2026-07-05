---
type: Data Model
title: Local Storage
description: What the app persists on-device — auth tokens and the active store.
tags: [storage, persistence, tokens]
timestamp: 2026-07-04
---

The app persists a small amount of state locally:

* **Auth tokens** — access + refresh for the player and admin sessions, in `lib/core/auth/token_storage.dart`. Read by `ApiClient` for the bearer header; restored on boot by the splash flow. See [Auth & Token](../systems/auth-and-token.md).
* **Active store** — the player's selected store, persisted by `active_store_notifier` so store-scoped calls know `:storeId` across launches. See [home](../modules/home.md).

All other data is fetched live from the backend per screen (no offline cache beyond these).
</content>
