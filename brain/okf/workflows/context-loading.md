---
type: Workflow
title: Context Loading
description: The read order before implementing a Flutter change.
tags: [workflow, context, onboarding]
timestamp: 2026-07-04
---

# Before implementing
1. [Project Brain](../concepts/project-brain.md) + [Agent Operating Model](../concepts/agent-operating-model.md).
2. [Glossary](../concepts/glossary.md) — anchor on the right word.
3. The target [module](../modules/index.md) page → its screens, then the notifier + repository via the [code map](../references/code-map.md).
4. Relevant [rules/](../rules/index.md) and [systems/](../systems/index.md) (navigation, state, api-transport).
5. For an API change, cross-check the [backend brain](../references/backend-brain-link.md) and [backend parity](../references/backend-parity.md).

# Truth ordering
Flutter source is truth; the backend source (`gz_ideation`) is truth for the contract. Don't grep blindly —
use the [code map](../references/code-map.md) (project rule).
</content>
