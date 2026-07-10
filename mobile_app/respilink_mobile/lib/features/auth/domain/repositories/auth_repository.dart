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
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<ApiResponse<bool>> isUserLoggedIn();

  Future<ApiResponse<Doctor>> login(LoginRequest request);

  Future<ApiResponse<Doctor>> register(RegisterRequest request);

  Future<ApiResponse<Doctor>> verifyOtp(OtpRequest request);

  Future<ApiResponse<void>> resendOtp(ResendOtpRequest request);

  Future<ApiResponse<void>> logout();

  Future<ApiResponse<Doctor>> updateProfilePicture(File file);

  Future<ApiResponse<Doctor>> updateProfile(EditProfileRequest request);

  Future<ApiResponse<void>> changePassword(ChangePasswordRequest request);

  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequest request);

  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request);

  Future<ApiResponse<List<SpecialitiesModel>>> specialities();

  Future<ApiResponse<Doctor>> toggleBiometric(bool enabled);
}
