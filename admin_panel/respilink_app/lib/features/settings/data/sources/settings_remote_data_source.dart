import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/settings/data/model/admin_user_model.dart';
import 'package:respilink_app/features/settings/data/model/requests/assign_permissions_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_admin_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_update_role_request.dart';
import 'package:respilink_app/features/settings/presentation/pages/data/model/roles_model.dart';

abstract class SettingsRemoteDataSource {
  Future<ApiResponse<List<RolesModel>>> getRoles();
  Future<ApiResponse<List<RolesModel>>> getPermissions();
  Future<ApiResponse<RolesModel>> listPermissionsAgainstRole(int roleId);
  Future<ApiResponse<dynamic>> assignPermissions({
    required int roleId,
    required AssignPermissionsRequest request,
  });
  Future<ApiResponse<dynamic>> createRole(CreateUpdateRoleRequest request);
  Future<ApiResponse<dynamic>> updateRole(int roleId, CreateUpdateRoleRequest request);
  Future<ApiResponse<dynamic>> deleteRole(int roleId);

  Future<ApiResponse<List<AdminUserModel>>> getAdmins();
  Future<ApiResponse<dynamic>> createAdmin(CreateAdminRequest request);
  Future<ApiResponse<dynamic>> updateAdmin(int adminId, UpdateAdminRequest request);
  Future<ApiResponse<dynamic>> deleteAdmin(int adminId);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<List<RolesModel>>> getRoles() async {
    return _client.get(
      ApiEndpoints.roles,
      fromJson: (json) =>
          (json as List).map((e) => RolesModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<List<RolesModel>>> getPermissions() async {
    return _client.get(
      ApiEndpoints.permissions,
      fromJson: (json) =>
          (json as List).map((e) => RolesModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> assignPermissions({
    required int roleId,
    required AssignPermissionsRequest request,
  }) async {
    return _client.put(
      '${ApiEndpoints.roles}/$roleId/permissions',
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> createRole(CreateUpdateRoleRequest request) async {
    return _client.post(ApiEndpoints.roles, data: request.toJson());
  }

  @override
  Future<ApiResponse<dynamic>> updateRole(int roleId, CreateUpdateRoleRequest request) async {
    return _client.put('${ApiEndpoints.roles}/$roleId', data: request.toJson());
  }

  @override
  Future<ApiResponse<dynamic>> deleteRole(int roleId) async {
    return _client.delete('${ApiEndpoints.roles}/$roleId');
  }

  @override
  Future<ApiResponse<List<AdminUserModel>>> getAdmins() async {
    return _client.get(
      ApiEndpoints.admins,
      fromJson: (json) {
        // Handle bare list or paginated/wrapped object ({ "data": [...] })
        final list = json is List
            ? json
            : (json as Map<String, dynamic>)['data'] as List;
        return list.map((e) => AdminUserModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> createAdmin(CreateAdminRequest request) async {
    return _client.post(ApiEndpoints.admins, data: request.toJson());
  }

  @override
  Future<ApiResponse<dynamic>> updateAdmin(int adminId, UpdateAdminRequest request) async {
    return _client.put('${ApiEndpoints.admins}/$adminId', data: request.toJson());
  }

  @override
  Future<ApiResponse<dynamic>> deleteAdmin(int adminId) async {
    return _client.delete('${ApiEndpoints.admins}/$adminId');
  }

    @override
  Future<ApiResponse<RolesModel>> listPermissionsAgainstRole(int roleId) async {
    return _client.get(
      '${ApiEndpoints.roles}/$roleId',
      fromJson: (json) => RolesModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
