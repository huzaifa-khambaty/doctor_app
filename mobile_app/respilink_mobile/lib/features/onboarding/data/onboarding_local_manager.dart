import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class OnboardingLocalManager {
  Future<bool> hasSeenOnboarding();

  Future<void> markOnboardingSeen();
}

class OnboardingLocalManagerImpl implements OnboardingLocalManager {
  final FlutterSecureStorage _storage;

  OnboardingLocalManagerImpl(this._storage);

  static const _seenOnboardingKey = 'has_seen_onboarding';

  @override
  Future<bool> hasSeenOnboarding() async {
    return await _storage.read(key: _seenOnboardingKey) == 'true';
  }

  @override
  Future<void> markOnboardingSeen() async {
    await _storage.write(key: _seenOnboardingKey, value: 'true');
  }
}
