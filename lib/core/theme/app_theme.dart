import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Geist',
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        colorScheme: ColorScheme.light(
          primary: AppColors.buttonBg,
          onPrimary: AppColors.buttonFg,
          secondary: AppColors.pillBg,
          onSecondary: AppColors.pillFg,
          error: AppColors.err,
          onError: AppColors.buttonFg,
          surface: AppColors.background,
          onSurface: AppColors.textPrimary,
          surfaceContainerHighest: AppColors.surface,
          outline: AppColors.rule,
          outlineVariant: AppColors.divider,
        ),
        textTheme: const TextTheme(
          titleLarge: AppTypography.h1,
          titleMedium: AppTypography.h2,
          titleSmall: AppTypography.h3,
          bodyLarge: AppTypography.body,
          bodyMedium: AppTypography.bodyR,
          bodySmall: AppTypography.small,
          labelSmall: AppTypography.meta,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: AppSpacing.md,
        ),
        cardTheme: const CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSpacing.borderRadiusCard)),
          ),
        ),
      );
}
