---
type: Workflow
title: OKF Maintenance
description: Keep the bundle in sync when screens, routes, models, or rules change.
tags: [workflow, maintenance, sync]
timestamp: 2026-07-04
---

# When you change code, in the same change:
* **New/changed screen or route** → update the [module](../modules/index.md) page, [Navigation](../systems/navigation-routing.md), and [references/ux-flow](../references/ux-flow.md).
* **New/changed model or enum** → update [data/](../data/index.md).
* **New file moved/deleted** → update [code map](../references/code-map.md) + feature registry ([Doc Sync](../rules/doc-sync.md)).
* **New domain term** → add to the [Glossary](../concepts/glossary.md).
* **New API dependency** → confirm against the [backend brain](../references/backend-brain-link.md); note any gap in [backend parity](../references/backend-parity.md).
* Append a dated line to [log.md](../log.md); refresh [graph.mmd](../graph.mmd) / [viz.html](../viz.html) when pages are added/removed.
</content>
