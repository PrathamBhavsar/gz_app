---
type: Rule
title: Error Handling
description: Surface backend failures as typed AppException and render the error state.
tags: [errors, exceptions]
timestamp: 2026-07-04
---

* `ApiClient`/repositories throw [`AppException`](../systems/error-handling.md) built from the backend
  `{success:false,error:{code,message,details}}`, preserving the backend `code`.
* Notifiers catch it, move their `AsyncValue` to error, and the screen shows the error state with retry.
* Branch on the `code` (e.g. `BOOKING_OVERLAP`, `INSUFFICIENT_CREDITS`) for specific UX; don't string-match messages.

See [Error Handling system](../systems/error-handling.md).
</content>
