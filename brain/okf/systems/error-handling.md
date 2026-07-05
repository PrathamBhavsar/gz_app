---
type: System
title: Error Handling
description: Typed AppException from the backend error envelope, surfaced via shared error UI.
resource: file://lib/core/errors/app_exception.dart
tags: [errors, exceptions, ui]
timestamp: 2026-07-04
---

# `lib/core/errors/`
* `app_exception.dart` — the typed exception the [ApiClient](api-transport.md) throws when the backend
  returns `{ success:false, error:{ code, message, details } }`. Carries the backend error `code` (e.g.
  `BOOKING_OVERLAP`, `INSUFFICIENT_CREDITS`) so notifiers can branch or show a friendly message.
* `error_snackbar.dart` — shared snackbar helper for transient errors.

# Flow
Repository/ApiClient throws `AppException` → notifier catches it, moves its `AsyncValue` to error →
the screen renders the error state (`page_error_display.dart`) with retry. The full error-code catalogue
is the backend's [error handling](../references/backend-brain-link.md). See [Error Handling rule](../rules/error-handling.md).
</content>
