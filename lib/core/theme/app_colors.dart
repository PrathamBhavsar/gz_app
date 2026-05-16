import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  // ── Surfaces ──
  static const Color background       = Color(0xFFF1F1EF); // gz-bg: warm paper
  static const Color surface          = Color(0xFFFFFFFF); // gz-card: white card
  static const Color surfaceTint      = Color(0xFFDDE9D2); // gz-card-tint: mint active
  static const Color surfaceTintStrong = Color(0xFFC7DDB8); // gz-card-tint-strong
  static const Color divider          = Color(0xFFECECE9); // gz-divider
  static const Color rule             = Color(0xFFE4E4E0); // gz-rule: borders

  // ── Text ──
  static const Color textPrimary   = Color(0xFF0A0A0A); // gz-fg
  static const Color textSecondary = Color(0xFF4C4C49); // gz-fg-2
  static const Color textTertiary  = Color(0xFF8A8A85); // gz-fg-3
  static const Color textMuted     = Color(0xFFB5B5AF); // gz-fg-4

  // ── Action ──
  static const Color buttonBg = Color(0xFF0A0A0A); // gz-btn
  static const Color buttonFg = Color(0xFFFFFFFF); // gz-btn-fg
  static const Color pillBg   = Color(0xFFF4F4F1); // gz-pill-bg
  static const Color pillFg   = Color(0xFF1A1A1A); // gz-pill-fg

  // ── Status: ok ──
  static const Color ok   = Color(0xFF2E7A3C);
  static const Color okBg = Color(0xFFDDEFD9);

  // ── Status: warn ──
  static const Color warn   = Color(0xFF8A5A12);
  static const Color warnBg = Color(0xFFF6E6C8);

  // ── Status: err ──
  static const Color err   = Color(0xFF9A2A1F);
  static const Color errBg = Color(0xFFF2DAD5);

  // ── Status: info ──
  static const Color info   = Color(0xFF2A4A8A);
  static const Color infoBg = Color(0xFFDCE3F2);

  // ── Status: purple ──
  static const Color purple   = Color(0xFF5A3A82);
  static const Color purpleBg = Color(0xFFE5DCEE);

  // ── Overlays / shadows ──
  static const Color overlayLight  = Color(0x80FFFFFF); // semi-transparent white over tinted bg
  static const Color shadowSubtle  = Color(0x0A000000); // 4% black ambient shadow

  // ── Legacy aliases (keep existing call-sites compiling) ──
  static const Color primary       = buttonBg;
  static const Color secondary     = pillBg;
  static const Color surface2      = surfaceTint;
  static const Color accent        = surfaceTint;
  static const Color border        = rule;
  static const Color error         = err;
  static const Color success       = ok;
  static const Color rose          = err;
  static const Color gold          = warn;
}
