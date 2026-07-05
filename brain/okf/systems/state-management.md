---
type: System
title: State Management
description: Riverpod without codegen — Notifiers/AsyncNotifiers in application/, one layer above repositories.
resource: file://lib/features
tags: [riverpod, state, notifier]
timestamp: 2026-07-04
---

# Riverpod, no codegen
State uses `flutter_riverpod` with **plain** `Provider`, `Notifier`, and `AsyncNotifier` — **no**
`riverpod_generator`/codegen. Each feature's `application/` folder holds its notifiers (e.g.
`home_notifier.dart`, `booking_notifier.dart`, `admin_dashboard_notifier.dart`).

# The layer contract
```
Widget ─watch/read─▶ Notifier (application/) ─▶ Repository (data/repositories/) ─▶ ApiClient
```
* Widgets never touch `ApiClient` or `http` directly; they watch a provider.
* Notifiers hold UI state and call repositories; they don't build HTTP requests.
* `AsyncValue`/`AsyncNotifier` drive the mandatory loading/error/empty/data states ([UI System](../rules/ui-system.md)).
* Command notifiers (e.g. `admin_*_command_notifier.dart`) encapsulate mutating actions and their result state (`admin_command_state.dart`).
* Cross-screen shared state: `active_store_notifier` (selected store), session runtime providers
  (`sessions/presentation/providers/session_runtime_providers.dart`), auth notifiers (drive the router).

See [State Management rule](../rules/state-management.md).
</content>
