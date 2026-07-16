import 'package:dio/dio.dart';
import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/change_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/register_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/resent_otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/reset_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/specialities_model.dart';

import '../../../../core/network/models/api_response.dart';
import '../../domain/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<Doctor>> login(LoginRequest request);

  Future<ApiResponse<Doctor>> register(RegisterRequest request);

  Future<ApiResponse<Doctor>> verifyOtp(OtpRequest request);

  Future<ApiResponse<void>> logout();

  Future<ApiResponse<void>> resendOtp(ResendOtpRequest request);

  Future<ApiResponse<Doctor>> updateProfile(EditProfileRequest request);

  Future<ApiResponse<void>> changePassword(ChangePasswordRequest request);

  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request);

  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequest request);

  Future<ApiResponse<List<SpecialitiesModel>>> specialities();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<Doctor>> login(LoginRequest request) async {
    return _client.post(
      ApiEndpoints.login,
      data: request.toJson(),
      fromJson: (json) =>
          Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<Doctor>> register(RegisterRequest request) async {
    return _client.post(
      ApiEndpoints.register,
      data: request.toJson(),
      fromJson: (json) =>
          Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<Doctor>> verifyOtp(OtpRequest request) async {
    return _client.post(
      ApiEndpoints.otpVerify,
      data: request.toJson(),
      fromJson: request.purpose == "reset"
          ? null
          : (json) => Doctor.fromJson(
              (json as Map<String, dynamic>)['doctor'] as Map<String, dynamic>,
            ),
    );
  }

  @override
  Future<ApiResponse<void>> logout() async {
    return _client.post(
      ApiEndpoints.logout,
      data: {},
      fromJson: (json) =>
          ApiResponse.fromJson(json as Map<String, dynamic>, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> resendOtp(ResendOtpRequest request) async {
    return _client.post(ApiEndpoints.resendOtp, data: request.toJson());
  }

  @override
  Future<ApiResponse<Doctor>> updateProfile(EditProfileRequest request) async {
    final formData = FormData.fromMap({
      ...request.toFields(),
      if (request.profilePicture != null)
        'profile_picture': await MultipartFile.fromFile(
          request.profilePicture!.path,
        ),
    });
    return _client.put(
      ApiEndpoints.editProfile,
      data: formData,
      fromJson: (json) => Doctor.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> changePassword(
    ChangePasswordRequest request,
  ) async {
    return _client.put(
      ApiEndpoints.forgotPassword,
      data: request.toJson(),
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> forgetPassword(
    ForgetPasswordRequest request,
  ) async {
    return _client.post(
      ApiEndpoints.forgotPassword,
      data: request.toJson(),
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    print("data is ${request.toJson()}");
    return _client.post(
      ApiEndpoints.resetPassword,
      data: request.toJson(),
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<List<SpecialitiesModel>>> specialities() async {
    return _client.get(
      ApiEndpoints.specialties,
      fromJson: (json) {
        // Laravel resource collections wrap arrays as {"data": [...]},
        // but some endpoints in this API return a bare array — handle both.
        final list = json is List
            ? json
            : (json as Map<String, dynamic>)['data'] as List;
        return list
            .map((e) => SpecialitiesModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
