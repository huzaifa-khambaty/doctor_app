import 'package:flutter/material.dart';
import 'package:respilink_mobile/core/theme/app_colors.dart';

/// Light/dark [ThemeData] pair driven by [ThemeCubit].
///
/// [light] is intentionally kept identical to the app's original inline
/// theme (just the brand-colored text-selection handle) — every existing
/// screen was built and verified against exactly that theme, and the vast
/// majority of widgets already set their own colors explicitly via
/// [AppColors] rather than reading `Theme.of(context)`. Changing anything
/// here risks a visual regression across the whole app for zero benefit.
///
/// [dark] is new, additive behaviour only reached once a user explicitly
/// opts into dark mode — it can't affect the (default) light experience.
class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.primary,
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: AppColors.primary,
    ),
  );
}
