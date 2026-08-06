import 'package:dio/dio.dart';
import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/features/auth/data/models/dashboard_model.dart';
import 'package:respilink_app/features/auth/data/models/requests/change_password_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/reset_password_request.dart';
import 'package:respilink_app/core/utils/global_notifiers.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';

import '../../../../core/network/models/api_response.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResponse<AdminModel>> login(LoginRequest request);

  Future<ApiResponse<void>> logout();

  Future<ApiResponse<AdminModel>> updateProfile(EditProfileRequest request);

  Future<ApiResponse<Admin>> updateAdmin(int adminId, EditProfileRequest request);

  Future<ApiResponse<void>> changeAdminPassword(int adminId, ChangePasswordRequest request);

  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request);

  Future<ApiResponse<void>> forgetPassword(ForgetPasswordRequest request);

  Future<ApiResponse<Admin>> me();

  Future<ApiResponse<DashboardModel>> dashboard();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<AdminModel>> login(LoginRequest request) async {
    return _client.post(
      ApiEndpoints.login,
      data: request.toJson(),
      fromJson: (json) =>
          AdminModel.fromJson(json as Map<String, dynamic>),
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
  Future<ApiResponse<AdminModel>> updateProfile(
    EditProfileRequest request,
  ) async {
    return _client.put(
      ApiEndpoints.editProfile,
      data: {'name': request.name, 'email': request.email},
      fromJson: (json) => AdminModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> changeAdminPassword(int adminId, ChangePasswordRequest request) async {
    return _client.post(
      '${ApiEndpoints.admins}/$adminId/change-password',
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
    return _client.post(
      ApiEndpoints.resetPassword,
      data: request.toJson(),
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<Admin>> updateAdmin(int adminId, EditProfileRequest request) async {
    final fields = <String, dynamic>{
      '_method': 'PUT',
      'name': request.name,
      'email': request.email,
    };
    if (request.photoBytes != null) {
      fields['photo'] = MultipartFile.fromBytes(
        request.photoBytes!,
        filename: request.photoName ?? 'photo.jpg',
      );
    }
    final response = await _client.post(
      '${ApiEndpoints.admins}/$adminId',
      data: FormData.fromMap(fields),
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        final adminJson = map.containsKey('admin') ? map['admin'] : map;
        return Admin.fromJson(adminJson as Map<String, dynamic>);
      },
    );
    if (response.success && response.data != null) {
      GlobalNotifiers.adminNotifier.value = response.data;
    }
    return response;
  }

  @override
  Future<ApiResponse<Admin>> me() async {
    return _client.get(
      ApiEndpoints.me,
      fromJson: (json) => Admin.fromJson(json as Map<String, dynamic>),
    );
  }

    @override
  Future<ApiResponse<DashboardModel>> dashboard() async {
    return _client.get(
      ApiEndpoints.dashboard,
      fromJson: (json) => DashboardModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
