---
type: Rule
title: State Management
description: Riverpod with plain Provider/Notifier/AsyncNotifier — no codegen.
tags: [riverpod, state]
timestamp: 2026-07-04
---

* Use `flutter_riverpod` with **plain** `Provider`, `Notifier`, `AsyncNotifier`. **No** `riverpod_generator` / codegen.
* One notifier per screen/flow in the feature's `application/`; mutations via dedicated `*_command_notifier`s.
* Expose loading/error/data through `AsyncValue` so the UI can render the mandatory states ([UI System](ui-system.md)).
* Notifiers call **repositories**, never `ApiClient`/`http` directly ([Architecture](architecture.md)).

See [State Management system](../systems/state-management.md).
</content>
