import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the user's dark-mode preference — mirrors the same
/// FlutterSecureStorage-backed local-manager pattern already used for
/// onboarding/auth ([OnboardingLocalManager], [AuthLocalManager]).
abstract class ThemeLocalManager {
  Future<bool> isDarkModeEnabled();

  Future<void> setDarkModeEnabled(bool enabled);
}

class ThemeLocalManagerImpl implements ThemeLocalManager {
  final FlutterSecureStorage _storage;

  ThemeLocalManagerImpl(this._storage);

  static const _darkModeKey = 'dark_mode_enabled';

  @override
  Future<bool> isDarkModeEnabled() async {
    // No stored value yet -> light theme by default.
    return await _storage.read(key: _darkModeKey) == 'true';
  }

  @override
  Future<void> setDarkModeEnabled(bool enabled) async {
    await _storage.write(key: _darkModeKey, value: enabled.toString());
  }
}
