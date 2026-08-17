import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';

abstract class AuthLocalManager {
  Future<void> saveToken(String token);

  Future<void> saveUser(Doctor? user);

  Future<String?> getCachedToken();

  Future<Doctor?> getCachedUser();

  /// Clears the active-session cache only (used for cold-start auto-login).
  /// Deliberately leaves the biometric cache untouched — logging out should
  /// still let the user unlock again with biometrics without retyping their
  /// password, matching how [saveBiometricSession]/[clearBiometricSession]
  /// are managed separately.
  Future<void> clearAuthData();

  Future<void> saveBadgeCount(int count);

  Future<String?> getCachedCount();

  /// Credentials kept specifically for the "Unlock with biometrics" button —
  /// intentionally decoupled from the session cache above so that logging
  /// out (which clears the session cache) doesn't also make biometric login
  /// permanently unreachable.
  Future<void> saveBiometricSession(String token, Doctor? user);

  Future<String?> getBiometricToken();

  Future<Doctor?> getBiometricUser();

  Future<void> clearBiometricSession();
}

class AuthLocalManagerImpl implements AuthLocalManager {
  final FlutterSecureStorage _storage;

  AuthLocalManagerImpl(this._storage);

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user-key';
  static const _badgeKey = 'badge-key';

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      debugPrint('AuthLocalManager: saveToken failed: $e');
    }
  }

  @override
  Future<void> saveUser(Doctor? user) async {
    try {
      await _storage.write(
        key: _userKey,
        value: user != null ? jsonEncode(user.toJson()) : null,
      );
    } catch (e) {
      debugPrint('AuthLocalManager: saveUser failed: $e');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      debugPrint('AuthLocalManager: failed to read cached token: $e');
      return null;
    }
  }

  @override
  Future<Doctor?> getCachedUser() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      if (userJson == null) return null;

      return Doctor.fromCachedJson(userJson);
    } catch (e) {
      // A corrupt/unreadable cache entry should fall back to "logged out"
      // rather than throwing and leaving the auth bloc stuck in AuthLoading.
      debugPrint('AuthLocalManager: failed to read/parse cached user: $e');
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _badgeKey);
  }

  @override
  Future<void> saveBadgeCount(int count) async {
    await _storage.write(key: _badgeKey, value: count.toString());
  }

  @override
  Future<String?> getCachedCount() async {
    return await _storage.read(key: _badgeKey);
  }

  static const _biometricTokenKey = 'biometric_token';
  static const _biometricUserKey = 'biometric_user';

  @override
  Future<void> saveBiometricSession(String token, Doctor? user) async {
    try {
      await _storage.write(key: _biometricTokenKey, value: token);
      await _storage.write(
        key: _biometricUserKey,
        value: user != null ? jsonEncode(user.toJson()) : null,
      );
    } catch (e) {
      debugPrint('AuthLocalManager: saveBiometricSession failed: $e');
    }
  }

  @override
  Future<String?> getBiometricToken() async {
    try {
      return await _storage.read(key: _biometricTokenKey);
    } catch (e) {
      debugPrint('AuthLocalManager: failed to read biometric token: $e');
      return null;
    }
  }

  @override
  Future<Doctor?> getBiometricUser() async {
    try {
      final userJson = await _storage.read(key: _biometricUserKey);
      if (userJson == null) return null;

      return Doctor.fromCachedJson(userJson);
    } catch (e) {
      debugPrint('AuthLocalManager: failed to read/parse biometric user: $e');
      return null;
    }
  }

  @override
  Future<void> clearBiometricSession() async {
    await _storage.delete(key: _biometricTokenKey);
    await _storage.delete(key: _biometricUserKey);
  }
}
