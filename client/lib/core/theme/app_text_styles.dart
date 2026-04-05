import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography scale — use via [Theme.of(context).textTheme] when possible;
/// this file centralizes custom styles shared across modules.
abstract final class AppTextStyles {
  static const String fontFamily = 'Roboto';

  static TextTheme textTheme(ColorScheme colors) {
    final base = TextTheme(
      displayLarge: const TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 32,
        height: 1.2,
        color: AppColors.onSurface,
      ),
      headlineMedium: const TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 22,
        height: 1.25,
        color: AppColors.onSurface,
      ),
      titleLarge: const TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 1.3,
        color: AppColors.onSurface,
      ),
      bodyLarge: const TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.45,
        color: AppColors.onSurface,
      ),
      bodyMedium: const TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.45,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: const TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.2,
        letterSpacing: 0.2,
        color: AppColors.onSurface,
      ),
    );

    return base.apply(
      bodyColor: colors.onSurface,
      displayColor: colors.onSurface,
    );
  }
}
