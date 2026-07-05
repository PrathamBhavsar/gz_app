---
type: Data Model
title: Models
description: The hand-written model catalogue in lib/models/ (manual fromJson, no codegen), shared by both clients.
resource: file://lib/models
tags: [models, dto, parsing]
timestamp: 2026-07-04
---

# `lib/models/` — the one shared model layer
Every model is a plain Dart class with a manual `fromJson` (no freezed / json_serializable). Grouped by domain:

| File | Covers |
| --- | --- |
| `api_responses.dart` | Player-side response/envelope wrappers + pagination meta. |
| `api_responses_admin.dart` | Admin-side response wrappers. |
| `core.dart` | Core/shared primitives (store, user, pagination, etc.). |
| `domain_global.dart` | Cross-cutting domain models (stores, users). |
| `domain_systems.dart` | Systems, system types, availability. |
| `domain_billing.dart` | Bookings, sessions, billing, payments, disputes. |
| `domain_loyalty.dart` | Credits, campaigns, redemptions. |
| `domain_analytics.dart` | Dashboard/revenue/utilization/stats shapes. |
| `domain_admin.dart` | Admin-specific models (staff, config, commands). |
| `domain_misc.dart` | Notifications and other misc models. |
| `enums.dart` | All enums + parsers → [Enums](enums.md). |

# Rules
Repositories map backend JSON → these models; models never call the network. Parsing must tolerate the
backend [envelope](../systems/backend-contract.md) and snake_case enums. When the backend adds/changes a
field, update the matching model here. See [Data Layer rule](../rules/data-layer.md).
</content>
