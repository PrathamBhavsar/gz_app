# RULE: UI STANDARDS
> **Enforcement Level**: CRITICAL

1. **Design Tokens:** Use `AppColors`, `AppTypography`, and `AppSpacing`. Avoid new raw `Color(0xFF...)` literals when an existing token fits.
2. **Sizing:** This repo does not use `flutter_screenutil`. Use direct doubles with the shared spacing/radius tokens and responsive helpers from `lib/core/responsive/`.
3. **Typography:** Start from `AppTypography` and override only what the screen actually needs.
4. **Loading and Error States:** Prefer shared primitives such as `GzLoadingView` and `PageErrorDisplay` instead of ad hoc placeholders.
