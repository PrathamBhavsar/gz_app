---
type: System
title: API Transport
description: The single ApiClient over package:http — base URL, bearer auth, envelope unwrapping.
resource: file://lib/core/api/api_client.dart
tags: [http, api-client, transport]
timestamp: 2026-07-04
---

# `lib/core/api/`
* `api_client.dart` — the one HTTP wrapper (built on `package:http`). Attaches the bearer token from
  [token storage](auth-and-token.md), sets JSON headers, performs GET/POST/PATCH/DELETE, and unwraps the
  backend [envelope](backend-contract.md) — returning `data` on success or throwing an [`AppException`](error-handling.md)
  built from the `error` object on failure.
* `api_constants.dart` — base URL + endpoint paths. **Base URL lives here**, not scattered in repos.

# Where it sits
Only **repositories** call `ApiClient`. A repository method: builds the path (often store-scoped
`/stores/:storeId/...`), calls the client, and maps the JSON into a hand-written model from
[`lib/models/`](../data/index.md). Notifiers call repositories; widgets call notifiers. See
[Data Layer rule](../rules/data-layer.md).
</content>
