---
type: Rule
title: Architecture
description: The one-way data flow every API-bound feature must follow.
tags: [architecture, layering]
timestamp: 2026-07-04
---

```
Widget ──▶ Notifier (application/) ──▶ Repository (data/repositories/) ──▶ ApiClient ──▶ API
```

* Feature data flow is exactly this order; API access stays **below** the notifier layer.
* `lib/models/` is the **one** shared model layer for both Player and Admin.
* No `http`/`ApiClient` in widgets or notifiers; no business logic in widgets.
* A feature folder is `data/repositories/` + `application/` (notifiers) + `presentation/screens/`.

See [Project Brain](../concepts/project-brain.md) and [State Management](../systems/state-management.md).
</content>
