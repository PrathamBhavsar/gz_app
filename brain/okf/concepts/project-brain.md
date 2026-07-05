---
type: Concept
title: Project Brain
description: What the Gaming Zone app is, the two clients, and the strict layered architecture.
tags: [overview, flutter, architecture]
timestamp: 2026-07-04
---

# What this is

`gz_app` is the **Gaming Zone** Flutter frontend — one codebase, two experiences:

* **Player app** — discover stores, book slots, check in, run/track sessions, pay, manage wallet
  credits, get notifications, edit profile, file disputes.
* **Admin dashboard** — live operations, session/booking management, walk-ins, systems, pricing,
  billing/payments, credits, campaigns, disputes, analytics — always scoped to the admin's store.

It talks to the [backend](../references/backend-brain-link.md) (`gz_ideation`) over REST + WebSockets.

# Stack (from `.ai_index.md`)

| Concern | Choice |
| --- | --- |
| State | `flutter_riverpod` — plain `Provider`, `Notifier`, `AsyncNotifier`. **No Riverpod codegen.** |
| HTTP | `http` via `lib/core/api/api_client.dart`. API access stays **below** the notifier layer. |
| Models | Hand-written classes in `lib/models/` with manual `fromJson`. **No freezed / json_serializable.** |
| Routing | `go_router`; route constants + path builders in `lib/core/navigation/routes.dart`. |
| Sizing/UI | Custom responsive primitives in `lib/core/responsive/`; theme tokens in `lib/core/theme/`. No `flutter_screenutil`. |

# The layered architecture (the one rule to remember)

```
Widget ──▶ Notifier (application/) ──▶ Repository (data/repositories/) ──▶ ApiClient ──▶ Backend
```

Every API-bound feature keeps this order. `lib/models/` is the shared model layer for **both** clients.
Data-bound screens must render all four states: **loading, error, empty, data**. See [rules/](../rules/index.md).

# Layout

* `lib/core/` — shared infrastructure ([systems](../systems/app-shell-and-entry.md)).
* `lib/models/` — shared models + enums ([data](../data/index.md)).
* `lib/shared/widgets/` — reusable UI + shared states.
* `lib/features/<feature>/` — `data/repositories/`, `application/` (notifiers), `presentation/screens/`.

Current reality: API integration Phases 1–13 landed — every feature is wired to the live backend
(Player + Admin), WebSockets connected. Parity fixes WP1–WP4 applied (see [Backend Parity](../references/backend-parity.md)).
</content>
