abstract class AppSpacing {
  AppSpacing._();

  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;

  // ── Radii (GZ design tokens) ──
  static const double borderRadiusCard  = 26.0; // gz-r-card
  static const double borderRadiusLg   = 16.0;  // gz-r-inner
  static const double borderRadiusChip = 10.0;  // gz-r-chip
  static const double borderRadius      = 12.0;  // legacy default
  static const double borderRadiusSm   = 8.0;   // legacy small
  static const double borderRadiusPill = 999.0;  // gz-r-pill (circular)
}
