import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';

abstract class AuthLocalManager {
  Future<void> saveToken(String token);

  Future<void> saveUser(Admin? user);

  Future<String?> getCachedToken();

  Future<Admin?> getCachedUser();

  Future<void> clearAuthData();

  Future<void> saveBadgeCount(int count);

  Future<String?> getCachedCount();
}

class AuthLocalManagerImpl implements AuthLocalManager {
  final FlutterSecureStorage _storage;

  AuthLocalManagerImpl(this._storage);

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user-key';
  static const _badgeKey = 'badge-key';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> saveUser(Admin? user) async {
    if (user == null) return;
    await _storage.write(key: _userKey, value: user.toJson());
  }

  @override
  Future<String?> getCachedToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<Admin?> getCachedUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson == null) return null;
    try {
      return Admin.fromCachedJson(userJson);
    } catch (_) {
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
}
