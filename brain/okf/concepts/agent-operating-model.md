---
type: Concept
title: Agent Operating Model
description: Load order and guardrails before changing the Flutter app.
tags: [agent, process, guardrails]
timestamp: 2026-07-04
---

# Before you change the app

1. Read [Project Brain](project-brain.md) and this file; follow [Context Loading](../workflows/context-loading.md).
2. Find files via [code map](../references/code-map.md) — **do not grep blindly** (project rule).
3. Identify the **module** under [modules/](../modules/index.md); read its page, then the screen,
   its notifier (`application/`), and its repository (`data/repositories/`).
4. Obey the [rules/](../rules/index.md): architecture layering, state, data-layer, UI system, navigation.

# Guardrails

* **Respect the layers:** `Widget → Notifier → Repository → ApiClient → API`. No `http`/`ApiClient` calls inside widgets or notifiers.
* **Routes live in `routes.dart`.** Don't hard-code path strings in screens — add a constant/path builder. See [Navigation](../systems/navigation-routing.md).
* **Models are hand-written** in `lib/models/` with manual `fromJson`. No freezed/json_serializable/codegen. Parse enums via `enums.dart` extensions.
* **Every data-bound screen renders loading / error / empty / data.** See [UI System rule](../rules/ui-system.md).
* **State sync:** when you add/move/delete a `.dart` file, update [code map](../references/code-map.md) and the feature registry in the **same** change (project `CLAUDE.md` rule).
* **Backend truth** is `gz_ideation/src/modules/*` (and its [brain](../references/backend-brain-link.md)), not stale API docs.

# After you change the app

* Update the affected [modules/](../modules/index.md) / [data/](../data/index.md) pages and append to [log.md](../log.md).
* If a route changed, update [Navigation](../systems/navigation-routing.md) and [references/ux-flow](../references/ux-flow.md).
</content>
