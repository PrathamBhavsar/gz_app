---
type: Rule
title: Doc Sync
description: Keep the code map, feature registry, and this brain in sync with file changes.
tags: [docs, sync, code-map]
timestamp: 2026-07-04
---

* When you **add / move / delete** a `.dart` file, update [`references/code-map.md`](../references/code-map.md)
  and the feature registry in the **same** change (project `CLAUDE.md` rule).
* When a route/screen/model/rule changes, update the matching brain page and append to [log.md](../log.md).
* Find files via the code map — avoid blind grepping (project rule).

See [OKF Maintenance](../workflows/okf-maintenance.md).
</content>
