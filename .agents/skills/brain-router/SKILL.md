---
name: brain-router
description: Use when starting any task in a Flutter repo that has a brain directory, CLAUDE.md, AGENTS.md, or rule-indexed project memory.
---

# Brain Router

## Purpose

Load the project brain before making assumptions. The brain is the source of truth for architecture, design rules, APIs, state management, routing, and feature registry requirements.

## Workflow

1. Read `CLAUDE.md` or `AGENTS.md` if present.
2. Read `brain/.ai_index.md` in full.
3. Classify the task intent: UI, state, API, model, routing, error handling, caching, performance, docs, or review.
4. Load only the rule files named by `brain/.ai_index.md` for that intent.
5. Check feature registry files before creating or moving code.
6. State the loaded context briefly before editing.

## Decision Rules

| Task | Minimum context |
|---|---|
| UI screen/widget | design system, UI standards, layout rules |
| Provider/notifier | state management rules |
| API/repository/model | data layer, API contract/reference, error handling |
| Route/navigation | navigation rules, route constants |
| Performance/media/cache | performance and caching rules |
| New feature | feature spec, registry template, relevant registry entry |

## Hard Stops

- Do not write Flutter code before reading `brain/.ai_index.md`.
- Do not invent patterns when a rule file defines one.
- Do not trust old memory over current brain files.
- If brain docs and code disagree, inspect code and report the drift before editing.

## Output Format

Before code changes, say:

```text
Loaded: <files>
Intent: <task type>
Constraints: <3-5 key rules>
Next: <edit/test plan>
```
