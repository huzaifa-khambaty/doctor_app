import '../../exports.dart';

class AppColors {
  AppColors._();

  /// Flipped by [ThemeCubit] whenever the app-wide theme changes. The
  /// neutral/surface getters below read this instead of being fixed
  /// `const`s so that every screen — nearly all of which read colors
  /// straight off [AppColors] rather than `Theme.of(context)` — picks up
  /// dark mode automatically once the app rebuilds after a theme change,
  /// without needing every individual screen edited.
  static bool _isDark = false;

  static void setDark(bool isDark) => _isDark = isDark;

  /// Default text/icon color — used throughout as the "readable foreground"
  /// color, so it inverts to a light tone in dark mode. [white] stays fixed
  /// since it's frequently used for text/icons drawn on top of colored
  /// (e.g. primary-filled button) surfaces that don't change with theme.
  static Color get black =>
      _isDark ? const Color(0xffE8F2FF) : const Color(0xff000000);
  static final Color white = Color(0xffffffff);

  // static final Color primary = Color(0xff065F46);
  static Color get grey =>
      _isDark ? const Color(0xffA0ACC0) : const Color(0xff94A3B8);
  static final Color redFFDAD6 = Color(0xffFFDAD6);
  static final Color redBA1A1A = Color(0xffBA1A1A);
  static final Color greenA3F4C6 = Color(0xffA3F4C6);
  static final Color greyCCE5FF = Color(0xffCCE5FF);
  static final Color grey6F7A72 = Color(0xff6F7A72);
  static final Color orangeFFDCBC = Color(0xffFFDCBC);
  static final Color brown2C1700 = Color(0xff2C1700);
  static final Color green9EEFC2 = Color(0xff9EEFC2);
  static final Color blueEFF6FF = Color(0xFFEFF6FF);

  // Primary — Islamic Green
  //static const Color primary             = Color(0xFF005536);
  static const Color primary = Color(0xff0E7C86);
  static const Color primaryContainer = Color(0xFF1B6F4B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryFixed = Color(0xFFA3F4C6);
  static const Color primaryFixedDim = Color(0xFF88D7AB);
  static const Color inversePrimary = Color(0xFF88D7AB);
  static const Color yellow = Color(0xffFFA534);

  // Secondary — Gold/Brown
  static const Color secondary = Colors.black54;
  static const Color secondaryContainer = Color(0xFFFECB97);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryFixed = Color(0xFFFFDCBC);
  static const Color secondaryFixedDim = Color(0xFFEFBD8A);
  static const Color onSecondaryFixed = Color(0xFF2C1700);

  // Tertiary — Blue
  static const Color tertiary = Color(0xFF004E78);
  static const Color tertiaryContainer = Color(0xFF00679C);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryFixed = Color(0xFFCCE5FF);
  static const Color tertiaryFixedDim = Color(0xFF92CCFF);

  static const Color blue002147 = Color(0xFF002147);
  static const Color blueE8F0FE = Color(0xFFE8F0FE);

  // Surface variants — flip between the original light palette and a
  // matching dark palette so cards/screens keep the same visual hierarchy
  // (background < container < containerHigh < containerHighest) in both
  // modes.
  static Color get surface =>
      _isDark ? const Color(0xFF0F1114) : const Color(0xFFF7F9FF);
  static Color get surfaceBright =>
      _isDark ? const Color(0xFF15181C) : const Color(0xFFF7F9FF);
  static Color get surfaceDim =>
      _isDark ? const Color(0xFF1B1F24) : const Color(0xFFC9DCF3);
  static Color get surfaceContainer =>
      _isDark ? const Color(0xFF1A1E23) : const Color(0xFFE3EFFF);
  static Color get surfaceContainerHigh =>
      _isDark ? const Color(0xFF20252B) : const Color(0xFFD9EAFF);
  static Color get surfaceContainerHighest =>
      _isDark ? const Color(0xFF262B32) : const Color(0xFFD1E4FB);
  static Color get surfaceContainerLow =>
      _isDark ? const Color(0xFF15181C) : const Color(0xFFEDF4FF);
  static Color get surfaceContainerLowest =>
      _isDark ? const Color(0xFF121417) : const Color(0xFFFFFFFF);
  static Color get surfaceVariant =>
      _isDark ? const Color(0xFF262B32) : const Color(0xFFD1E4FB);
  static Color get inverseSurface =>
      _isDark ? const Color(0xFFE8F2FF) : const Color(0xFF203243);
  static Color get inverseOnSurface =>
      _isDark ? const Color(0xFF203243) : const Color(0xFFE8F2FF);

  // On-surface
  static Color get onSurface =>
      _isDark ? const Color(0xFFE8F2FF) : const Color(0xFF091D2E);
  static Color get onSurfaceVariant =>
      _isDark ? const Color(0xFFC4CDD5) : const Color(0xFF3F4942);
  static Color get onBackground =>
      _isDark ? const Color(0xFFE8F2FF) : const Color(0xFF091D2E);

  // Background
  static Color get background =>
      _isDark ? const Color(0xFF0B0D10) : const Color(0xFFF7F9FF);

  // Outline
  static Color get outline =>
      _isDark ? const Color(0xFF8A968D) : const Color(0xFF6F7A72);
  static Color get outlineVariant =>
      _isDark ? const Color(0xFF3A4A42) : const Color(0xFFBEC9C0);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Semantic helpers
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);

  static const Color deeperTeal = Color(0xff0E7C86);
  static const Color tealGradientStart = Color(0xff0E7C86);
  static const Color brighterTeal = Color(0xFF00896B);
  static const Color green1A6B5A = Color(0xFF1A6B5A);
  static Color get fieldColor =>
      _isDark ? const Color(0xFF1E2227) : const Color(0xFFF1F5F9);

  // Dashboard accents
  static const Color indigoAccent = Color(0xFF4C6FFF);
  static const Color purpleAccent = Color(0xFF8B5CF6);
}
