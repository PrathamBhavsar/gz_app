---
type: Concept
title: Open Knowledge Format (OKF)
description: The conventions this bundle follows, shared with the backend brain.
tags: [okf, meta, convention]
timestamp: 2026-07-04
---

This `brain/okf/` directory is an OKF bundle: one concept per Markdown file with YAML frontmatter
(`type`, `title`, `description`, `tags`, `timestamp`, optional `resource`); relative links form the graph.

# Shared taxonomy

Both `gz_app/brain/okf/` and `gz_ideation/brain/okf/` use the same folders so the common brain can
cross-reference them 1:1:

`concepts/` · `systems/` · `modules/` · `data/` · `flows/` · `rules/` · `workflows/` · `references/`

# Keeping it true

The Flutter source is the truth. When a route, screen, model, or rule changes, update the matching brain
page in the **same** change (and the [code map](../references/code-map.md) per project rule) and append to
[log.md](../log.md). See [OKF Maintenance](../workflows/okf-maintenance.md).
</content>
