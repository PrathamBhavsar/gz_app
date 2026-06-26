---
name: ui-system-enforcer
description: Use when creating, changing, or reviewing Flutter UI, screens, widgets, responsive layouts, design tokens, animations, skeletons, or visual states.
---

# UI System Enforcer

## Purpose

Keep UI work inside the project's design system so agents do not create attractive but inconsistent one-off widgets.

## Required Context

Use `brain-router`, then load:

- Master design system or component inventory.
- UI standards.
- Layout/responsive rules.
- Motion/loading/async-state rules if present.
- Real data reference or feature UX flow when available.

## UI Pass

1. Reuse existing shared widgets before creating new ones.
2. Use project color, spacing, radius, typography, icon, and motion tokens.
3. Respect the repo's breakpoint system; do not branch on raw `MediaQuery` unless the brain allows it.
4. Add loading, error, empty, and data states for data-bound components.
5. Use real field shapes from specs or API docs; avoid fake placeholder content.
6. Keep accessibility basics: readable contrast, touch targets, semantic labels for non-obvious controls.

## Common Violations

- Raw colors, raw text styles, raw icons, or magic spacing numbers.
- Inventing a button/card/sheet when a shared one exists.
- Building desktop/tablet/mobile layouts outside the approved layout primitive.
- Adding local keyboard-dismiss or bottom-nav hacks when global behavior already exists.
- Using generic animation chains when the project has approved reveal/state components.

## Review Output

Report issues as:

```text
P0/P1/P2 - <issue>
File: <path>
Fix: <specific design-system-compliant change>
```
