import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  AppTypography._();

  static const String _sans = 'Geist';
  static const String _mono = 'GeistMono';

  // gz-hero — 56 px, w700, mono, tight
  static const TextStyle hero = TextStyle(
    fontFamily: _mono,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -2.24,
    color: AppColors.textPrimary,
  );

  // gz-hero-md — 44 px, w700, mono
  static const TextStyle heroMd = TextStyle(
    fontFamily: _mono,
    fontSize: 44,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -1.32,
    color: AppColors.textPrimary,
  );

  // gz-title — 28 px, w700
  static const TextStyle title = TextStyle(
    fontFamily: _sans,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.84,
    color: AppColors.textPrimary,
  );

  // gz-h1 — 22 px, w700
  static const TextStyle h1 = TextStyle(
    fontFamily: _sans,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.55,
    color: AppColors.textPrimary,
  );

  // gz-h2 — 18 px, w600
  static const TextStyle h2 = TextStyle(
    fontFamily: _sans,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.27,
    color: AppColors.textPrimary,
  );

  // gz-h3 — 16 px, w600
  static const TextStyle h3 = TextStyle(
    fontFamily: _sans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // gz-body — 14 px, w500
  static const TextStyle body = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // gz-body-r — 14 px, w400, secondary colour
  static const TextStyle bodyR = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  // gz-small — 12 px, w500, tertiary colour
  static const TextStyle small = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.textTertiary,
  );

  // gz-meta — 10.5 px, w600, UPPERCASE, tracked
  static const TextStyle meta = TextStyle(
    fontFamily: _sans,
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 1.26,
    color: AppColors.textTertiary,
  );

  // gz-num — monospace numerals inline
  static const TextStyle num = TextStyle(
    fontFamily: _mono,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // Button label
  static const TextStyle button = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.15,
    color: AppColors.buttonFg,
  );

  // ── Legacy aliases — keep existing call-sites compiling ──
  static const TextStyle headingLarge  = title;
  static const TextStyle headingMedium = h1;
  static const TextStyle headingSmall  = h2;
  static const TextStyle bodyLarge     = body;
  static const TextStyle bodyMedium    = bodyR;
  static const TextStyle bodySmall     = small;
  static const TextStyle caption       = meta;
}
