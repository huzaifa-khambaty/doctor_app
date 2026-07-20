import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/settings/data/model/admin_user_model.dart';
import 'package:respilink_app/features/settings/data/model/requests/assign_permissions_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_admin_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_update_role_request.dart';
import 'package:respilink_app/features/settings/data/sources/settings_remote_data_source.dart';
import 'package:respilink_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:respilink_app/features/settings/presentation/pages/data/model/roles_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;

  SettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<RolesModel>>> getRoles() =>
      _remoteDataSource.getRoles();

  @override
  Future<ApiResponse<List<RolesModel>>> getPermissions() =>
      _remoteDataSource.getPermissions();

  @override
  Future<ApiResponse<RolesModel>> listPermissionsAgainstRole(int roleId) =>
      _remoteDataSource.listPermissionsAgainstRole(roleId);

  @override
  Future<ApiResponse<dynamic>> assignPermissions({
    required int roleId,
    required AssignPermissionsRequest request,
  }) => _remoteDataSource.assignPermissions(roleId: roleId, request: request);

  @override
  Future<ApiResponse<dynamic>> createRole(CreateUpdateRoleRequest request) =>
      _remoteDataSource.createRole(request);

  @override
  Future<ApiResponse<dynamic>> updateRole(
    int roleId,
    CreateUpdateRoleRequest request,
  ) => _remoteDataSource.updateRole(roleId, request);

  @override
  Future<ApiResponse<dynamic>> deleteRole(int roleId) =>
      _remoteDataSource.deleteRole(roleId);

  @override
  Future<ApiResponse<List<AdminUserModel>>> getAdmins() =>
      _remoteDataSource.getAdmins();

  @override
  Future<ApiResponse<dynamic>> createAdmin(CreateAdminRequest request) =>
      _remoteDataSource.createAdmin(request);

  @override
  Future<ApiResponse<dynamic>> updateAdmin(int adminId, UpdateAdminRequest request) =>
      _remoteDataSource.updateAdmin(adminId, request);

  @override
  Future<ApiResponse<dynamic>> deleteAdmin(int adminId) =>
      _remoteDataSource.deleteAdmin(adminId);
}
