import 'dart:io';
import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/change_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/register_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/resent_otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/reset_password_request.dart';
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
  Future<ApiResponse<Doctor>> login(LoginRequest request) async {
    final response = await _remoteDataSource.login(request);

    if (response.success && response.token != null) {
      await _localManager.saveToken(response.token!);
      await _localManager.saveUser(response.data);
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
  Future<ApiResponse<Doctor>> register(RegisterRequest request) async {
    final response = await _remoteDataSource.register(request);

    if (response.success && response.token != null) {
      await _localManager.saveToken(response.token!);
      await _localManager.saveUser(response.data);
    }

    return response;
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
  Future<ApiResponse<Doctor>> updateProfilePicture(File file) async {
    final response = await _remoteDataSource.updateProfilePicture(file);

    if (response.success && response.data != null) {
      Doctor? model = await _localManager.getCachedUser();

      if (model != null) {
        // 1. Create a new model instance with the updated photo
        final updatedUser = model.copyWith(
          profilePhotoPath: response.data!.profilePhoto,
        );

        // 2. Save the updated version locally
        await _localManager.saveUser(updatedUser);

        // 3. Return the response with the full UserModel instead of just the photo object
        return ApiResponse.success(
          statusCode: response.statusCode,
          message: response.message,
          data: updatedUser,
        );
      }
    }

    // Handle the case where the update failed or user wasn't cached
    return ApiResponse.failure(
      statusCode: response.statusCode,
      message: response.message,
      errors: response.errors,
    );
  }

  @override
  Future<ApiResponse<Doctor>> updateProfile(
    EditProfileRequest request,
  ) async {
    final response = await _remoteDataSource.updateProfile(request);

    if (response.success && response.data != null) {
      await _localManager.saveUser(response.data);
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
}
