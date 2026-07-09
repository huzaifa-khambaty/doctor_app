import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final _localAuth = LocalAuthentication();

  Future<bool> get isAvailable async {
    return await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    if (!await isAvailable) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: 'Verify your identity to log in',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } on Exception {
      return false;
    }
  }
}
