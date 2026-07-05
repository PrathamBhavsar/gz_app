---
type: System
title: Responsive & Theme
description: Custom responsive primitives and design tokens — no flutter_screenutil.
resource: file://lib/core/responsive
tags: [responsive, theme, design-tokens]
timestamp: 2026-07-04
---

# Responsive (`lib/core/responsive/`)
* `breakpoints.dart` — width breakpoints.
* `responsive_builder.dart` — adapts layout to the current breakpoint (phone/tablet/wide).

No `flutter_screenutil`; size from theme + these primitives directly.

# Theme (`lib/core/theme/`)
`app_colors.dart`, `app_spacing.dart`, `app_typography.dart`, `app_theme.dart` — the design tokens.
Screens use these tokens, not hard-coded colors/sizes.

# Shared widgets (`lib/shared/widgets/`)
Reusable primitives + shared states: `page_error_display.dart`, `gz_loading_view.dart`, overlays like
`otp_input_sheet.dart`, `store_selector_sheet.dart`. See [UI System rule](../rules/ui-system.md).
</content>
