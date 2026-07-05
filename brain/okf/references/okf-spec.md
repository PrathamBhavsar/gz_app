---
type: Reference
title: OKF v0.1 Spec
description: OKF v0.1 defines knowledge bundles as Markdown concept files with YAML frontmatter and Markdown links.
resource: https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/SPEC.md
tags: [okf, spec]
timestamp: 2026-07-04
---

# Applied rules
* Each non-reserved Markdown file is one concept with YAML frontmatter including a required `type`.
* Root `index.md` declares `okf_version: "0.1"`; `index.md` and `log.md` are reserved.
* Internal links include `.md` and form graph edges.
* Consumers tolerate unknown types, missing optional fields, and broken links.

See [Open Knowledge Format concept](../concepts/open-knowledge-format.md).
</content>
