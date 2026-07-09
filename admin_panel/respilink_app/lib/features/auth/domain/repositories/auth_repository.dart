import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/reset_password_request.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';

abstract class AuthRepository {
  Future<ApiResponse<bool>> isUserLoggedIn();

  Future<ApiResponse<AdminModel>> login(LoginRequest request);

  Future<ApiResponse<void>> logout();

  Future<ApiResponse<AdminModel>> updateProfile(EditProfileRequest request);

  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequest request);

  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request);

  Future<ApiResponse<Admin>> me();
}
