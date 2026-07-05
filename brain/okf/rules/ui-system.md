---
type: Rule
title: UI System
description: Mandatory data states, design tokens, and responsive primitives.
tags: [ui, states, theme, responsive]
timestamp: 2026-07-04
---

* **Every data-bound screen renders four states: loading, error, empty, data.** Use the shared widgets
  (`gz_loading_view.dart`, `page_error_display.dart`) and an explicit empty state.
* Size and style from **theme tokens** (`lib/core/theme/`) and **responsive primitives**
  (`lib/core/responsive/`) — no hard-coded colors/sizes, no `flutter_screenutil`.
* Reuse `lib/shared/widgets/` primitives and overlays (sheets) instead of re-rolling them.

See [Responsive & Theme](../systems/responsive-and-theme.md).
</content>
