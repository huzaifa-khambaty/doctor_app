import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/theme/app_colors.dart';
import 'package:respilink_mobile/core/theme/theme_local_manager.dart';

/// App-wide dark/light mode switch — mirrors the existing [ConnectivityCubit]
/// pattern (a single piece of global, persisted app state exposed as a
/// Cubit). Defaults to [ThemeMode.light] synchronously, then swaps to the
/// persisted preference (if any) once it's been read.
class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeLocalManager _localManager;

  ThemeCubit(this._localManager) : super(ThemeMode.light) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final isDark = await _localManager.isDarkModeEnabled();
    AppColors.setDark(isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> setDarkMode(bool enabled) async {
    AppColors.setDark(enabled);
    emit(enabled ? ThemeMode.dark : ThemeMode.light);
    await _localManager.setDarkModeEnabled(enabled);
  }
}
