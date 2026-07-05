---
type: Rule
title: Data Layer
description: Repositories + hand-written models; parse the backend envelope; no codegen.
tags: [data-layer, repository, models]
timestamp: 2026-07-04
---

* All network access lives in **repositories** (`data/repositories/`) calling `ApiClient`.
* Models are hand-written classes in `lib/models/` with manual `fromJson`. **No freezed / json_serializable / codegen.**
* Parse the backend [envelope](../systems/backend-contract.md) (`{success,message,data}` / paginated / error) and snake_case enums via [`enums.dart`](../data/enums.md).
* Store-scoped calls build `/stores/:storeId/...` from the [active store](../modules/home.md).
* On error, throw/propagate [`AppException`](error-handling.md) carrying the backend `code`.

See [API Transport](../systems/api-transport.md) and [Models](../data/models.md).
</content>
