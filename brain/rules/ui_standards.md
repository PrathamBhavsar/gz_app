# RULE: UI STANDARDS
> **Enforcement Level**: CRITICAL — Hardcoded colors, sizes without AppSpacing, missing AppTypography = violations.

## THE LAW: DESIGN TOKENS ALWAYS

Use `AppColors.*`, `AppSpacing.*`, and `AppTypography.*` for all styling. Never use raw values.

---

## DESIGN TOKENS

### Colors — `lib/core/theme/app_colors.dart`

```dart
abstract class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0A0A0A);   // screen bg
  static const Color surface    = Color(0xFF141414);   // card / sheet bg
  static const Color surface2   = Color(0xFF1E1E1E);   // elevated surface
  static const Color secondary  = Color(0xFF2A2A2A);   // chips, secondary buttons

  // Text
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF888888);
  static const Color accent        = Color(0xFFF5F5F5); // subtle highlight

  // UI
  static const Color primary = Color(0xFFFFFFFF);       // primary CTA color
  static const Color border  = Color(0xFF2A2A2A);       // dividers, borders

  // Status
  static const Color error   = Color(0xFFFF4444);
  static const Color success = Color(0xFF44FF44);
  static const Color rose    = Color(0xFFFF2D55);       // cancellations
  static const Color gold    = Color(0xFFFFD700);       // premium / credits
}
```

### Spacing — `lib/core/theme/app_spacing.dart`

```dart
abstract class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;

  static const double borderRadius   = 12.0;
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusLg = 16.0;
}
```

### Typography — `lib/core/theme/app_typography.dart`

Font family: **Satoshi**. Always reference via `AppTypography.*`:

```dart
AppTypography.headingLarge   // 32sp, w700
AppTypography.headingMedium  // 24sp, w600
AppTypography.headingSmall   // 18sp, w600
AppTypography.bodyLarge      // 16sp, w400
AppTypography.bodyMedium     // 14sp, w400
AppTypography.bodySmall      // 12sp, w400
AppTypography.caption        // 11sp, w400, textSecondary
AppTypography.button         // 14sp, w600
```

To change color: `AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)`

---

## SIZING — NO FLUTTER_SCREENUTIL

This project does **not** use `flutter_screenutil`. No `.r`, `.sp`, `.w`, `.h` suffixes.

```dart
// ✅ CORRECT
SizedBox(height: AppSpacing.md)
Padding(padding: EdgeInsets.all(AppSpacing.md))
BorderRadius.circular(AppSpacing.borderRadius)
SizedBox(height: AppSpacing.sm)

// ❌ FORBIDDEN
SizedBox(height: 16)
SizedBox(height: 16.r)
BorderRadius.circular(12)
```

Exception: literal `0` is always acceptable (`SizedBox(height: 0)`, `EdgeInsets.zero`).

---

## ICONS — HUGEICONS

Use `HugeIcon` widget (not `Icon`):

```dart
// ✅
HugeIcon(
  icon: HugeIcons.strokeRoundedHome01,
  color: AppColors.textSecondary,
  size: 24,
)

// ❌
Icon(Icons.home, color: AppColors.textSecondary)
```

All icons use the `strokeRounded*` variant unless a filled variant is explicitly required.

---

## ANIMATIONS

```dart
// Entrance
widget.animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0, duration: 220.ms)

// Staggered list items
widget.animate(delay: (i * 60).ms).fadeIn().scale(begin: const Offset(0.94, 0.94))
```

Use `flutter_animate`. Do not use `AnimatedContainer` or manual `AnimationController` unless animating loops (e.g., live-session pulsing indicator).

---

## FORBIDDEN

```dart
// ❌ Raw colors
Container(color: Colors.purple)
Container(color: Color(0xFF0A0A0A))  // use AppColors.background

// ❌ Raw TextStyle without AppTypography
Text('x', style: TextStyle(fontSize: 16, fontFamily: 'Satoshi'))
// use: Text('x', style: AppTypography.bodyLarge)

// ❌ Raw sizes
SizedBox(height: 24)
BorderRadius.circular(16)
Padding(padding: EdgeInsets.all(16))

// ❌ flutter_screenutil suffixes
SizedBox(height: 16.r)
fontSize: 20.sp
```

---

## WIDGET CHECKLIST BEFORE BUILDING A NEW WIDGET

Before building a new widget, check `lib/shared/widgets/` for existing shared widgets. If one exists, use it. If building a new shared widget:
1. Use `AppColors.*` + `AppSpacing.*` + `AppTypography.*`
2. Name it descriptively (not `GZ*` — just describe what it does)
3. Keep it stateless where possible
