import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/settings/data/model/admin_user_model.dart';
import 'package:respilink_app/features/settings/data/model/requests/assign_permissions_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_admin_request.dart';
import 'package:respilink_app/features/settings/data/model/requests/create_update_role_request.dart';
import 'package:respilink_app/features/settings/presentation/pages/data/model/roles_model.dart';

abstract class SettingsRepository {
  Future<ApiResponse<List<RolesModel>>> getRoles();
  Future<ApiResponse<List<RolesModel>>> getPermissions();
  Future<ApiResponse<RolesModel>> listPermissionsAgainstRole(int roleId);
  Future<ApiResponse<dynamic>> assignPermissions({
    required int roleId,
    required AssignPermissionsRequest request,
  });
  Future<ApiResponse<dynamic>> createRole(CreateUpdateRoleRequest request);
  Future<ApiResponse<dynamic>> updateRole(
    int roleId,
    CreateUpdateRoleRequest request,
  );
  Future<ApiResponse<dynamic>> deleteRole(int roleId);

  Future<ApiResponse<List<AdminUserModel>>> getAdmins();
  Future<ApiResponse<dynamic>> createAdmin(CreateAdminRequest request);
  Future<ApiResponse<dynamic>> updateAdmin(int adminId, UpdateAdminRequest request);
  Future<ApiResponse<dynamic>> deleteAdmin(int adminId);
}
