import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/change_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/register_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/resent_otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/reset_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/privacy_policy_model.dart';
import 'package:respilink_mobile/features/auth/data/models/specialities_model.dart';
import 'package:respilink_mobile/features/auth/data/sources/auth_local_manager.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/global_notifiers.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalManager _localManager;

  AuthRepositoryImpl(this._remoteDataSource, this._localManager);

  @override
  Future<ApiResponse<Doctor>> login(
    LoginRequest request, {
    bool rememberMe = true,
  }) async {
    final response = await _remoteDataSource.login(request);

    if (response.success && response.token != null) {
      if (rememberMe) {
        await _localManager.saveToken(response.token!);
        await _localManager.saveUser(response.data);
        await _localManager.saveBiometricSession(
          response.token!,
          response.data,
        );
      } else {
        // Respect the explicit choice not to be remembered on this device —
        // drop any session/biometric credentials a previous login may have
        // left behind, rather than leaving them to silently auto-login the
        // user (or unlock biometrically) next time regardless.
        await _localManager.clearAuthData();
        await _localManager.clearBiometricSession();
      }
    }

    return response;
  }

  @override
  Future<ApiResponse<bool>> isUserLoggedIn() async {
    final cachedToken = await _localManager.getCachedToken();
    final cachedUser = await _localManager.getCachedUser();
    final cachedBadgeCount = await _localManager.getCachedCount();

    if (cachedToken != null && cachedUser != null) {
      AppConstants.apiToken = cachedToken;
      GlobalNotifiers.userNotifier.value = cachedUser;

      if (cachedBadgeCount != null) {
        GlobalNotifiers.notificationCountNotifier.value =
            int.tryParse(cachedBadgeCount) ?? 0;
      }

      return ApiResponse.success(data: true);
    } else {
      return ApiResponse.success(data: false);
    }
  }

  @override
  Future<ApiResponse<Doctor?>> register(RegisterRequest request) async {
    // Deliberately never persists a session here, even if the backend's
    // response happens to include a token — the account is still
    // `status: "pending"` until OTP verification succeeds, and saving
    // credentials at this point would auto-log-in a device that skipped
    // OTP entirely (e.g. closing the app right after signing up).
    // `verifyOtp()` below is the only step that should ever mark the
    // device as signed in.
    return _remoteDataSource.register(request);
  }

  @override
  Future<ApiResponse<Doctor>> verifyOtp(OtpRequest request) async {
    final response = await _remoteDataSource.verifyOtp(request);

    if (response.success && response.token != null) {
      await _localManager.saveToken(response.token!);
      if (response.data != null) {
        await _localManager.saveUser(response.data);
      }
    }

    return response;
  }

  @override
  Future<ApiResponse<void>> resendOtp(ResendOtpRequest request) async {
    final response = await _remoteDataSource.resendOtp(request);

    return response;
  }

  @override
  Future<ApiResponse<void>> logout() async {
    await _localManager.clearAuthData();
    return _remoteDataSource.logout();
  }

  @override
  Future<ApiResponse<Doctor>> updateProfile(
    EditProfileRequest request,
  ) async {
    final response = await _remoteDataSource.updateProfile(request);

    if (response.success && response.data != null) {
      await _localManager.saveUser(response.data);
      GlobalNotifiers.userNotifier.value = response.data;
    }
    return response;
  }

  @override
  Future<ApiResponse<void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    final response = await _remoteDataSource.changePassword(request);
    return response;
  }

  @override
  Future<ApiResponse<void>> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    final response = await _remoteDataSource.forgetPassword(request);
    return response;
  }

  @override
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    final response = await _remoteDataSource.resetPassword(request);
    return response;
  }

  @override
  Future<ApiResponse<List<SpecialitiesModel>>> specialities() async {
    return _remoteDataSource.specialities();
  }

  @override
  Future<ApiResponse<PrivacyPolicyModel>> getPrivacyPolicy() async {
    return _remoteDataSource.getPrivacyPolicy();
  }
}
