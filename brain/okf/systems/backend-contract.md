---
type: System
title: Backend Contract
description: The response envelope, auth, store-scoping, and enum conventions the app depends on.
tags: [api, backend, contract, envelope]
timestamp: 2026-07-04
---

The app is a client of `gz_ideation`. Contract rules the repositories rely on:

* **Base URL** comes from `ApiConstants` ([API Transport](api-transport.md)).
* **Success envelope:** `{ success, message, data }`. **Paginated:** `{ success, data, meta:{ total, page, limit, totalPages } }`.
* **Error envelope:** `{ success:false, error:{ code, message, details } }` → thrown as [`AppException`](error-handling.md).
* **Auth:** bearer access token + refresh token; admin JWT additionally carries `storeId`/`role`.
* **Store scoping:** most player endpoints are nested under `/stores/:storeId/...`; the [active store](../modules/home.md) supplies `:storeId`.
* **Enums are snake_case** on the wire; parsed by the extensions in [`enums.dart`](../data/enums.md).
* **Backend truth** is `gz_ideation/src/modules/*/index.ts` and its [brain](../references/backend-brain-link.md) — not stale API docs.

Per-endpoint mapping (screen → backend route) is in each [module page](../modules/index.md); the exhaustive
inventory is [references/ux-flow](../references/ux-flow.md) and the [backend parity](../references/backend-parity.md) notes.
</content>
