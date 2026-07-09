import 'package:respilink_app/core/constants/app_constants.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/core/utils/global_notifiers.dart';
import 'package:respilink_app/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/reset_password_request.dart';
import 'package:respilink_app/features/auth/data/sources/auth_local_manager.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalManager _localManager;

  AuthRepositoryImpl(this._remoteDataSource, this._localManager);

  @override
  Future<ApiResponse<AdminModel>> login(LoginRequest request) async {
    final response = await _remoteDataSource.login(request);

    if (response.success) {
      // Prefer token parsed directly from the response body; fall back to
      // whatever the interceptor may have set as a side-effect.
      final token = (response.data?.token ?? AppConstants.apiToken).trim();
      if (token.isNotEmpty) {
        AppConstants.apiToken = token;
        await _localManager.saveToken(token);
        await _localManager.saveUser(response.data?.admin);
        if (response.data?.admin != null) {
          GlobalNotifiers.adminNotifier.value = response.data!.admin;
        }
      }
    }

    return response;
  }

  @override
  Future<ApiResponse<bool>> isUserLoggedIn() async {
    final cachedToken = await _localManager.getCachedToken();

    if (cachedToken != null && cachedToken.isNotEmpty) {
      AppConstants.apiToken = cachedToken;

      final cachedUser = await _localManager.getCachedUser();
      if (cachedUser != null) {
        GlobalNotifiers.adminNotifier.value = cachedUser;
      }

      return ApiResponse.success(data: true);
    }

    return ApiResponse.success(data: false);
  }

  @override
  Future<ApiResponse<void>> logout() async {
    // Call API first while the token is still set in the header.
    final res = await _remoteDataSource.logout();
    // Clear local state regardless of API outcome.
    await _localManager.clearAuthData();
    AppConstants.apiToken = '';
    GlobalNotifiers.adminNotifier.value = null;
    return res;
  }

  @override
  Future<ApiResponse<AdminModel>> updateProfile(
    EditProfileRequest request,
  ) async {
    final response = await _remoteDataSource.updateProfile(request);

    if (response.success && response.data != null) {
      await _localManager.saveUser(response.data?.admin);
    }
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
  Future<ApiResponse<Admin>> me() async {
    final response = await _remoteDataSource.me();
    return response;
  }
}
