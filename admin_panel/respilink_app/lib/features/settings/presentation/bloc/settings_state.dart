import 'package:respilink_app/features/settings/data/model/admin_user_model.dart';
import 'package:respilink_app/features/settings/presentation/pages/data/model/roles_model.dart';

class SettingsState {
  final List<RolesModel> roles;
  final bool isLoadingRoles;

  final List<RolesModel> permissions;
  final bool isLoadingPermissions;

  final bool isSaving;
  final bool saveSuccess;

  final bool isCreatingRole;
  final bool createRoleSuccess;

  final bool isUpdatingRole;
  final bool updateRoleSuccess;

  final bool isDeletingRole;
  final bool deleteRoleSuccess;

  // Admin user management
  final List<AdminUserModel> admins;
  final bool isLoadingAdmins;
  final bool isCreatingAdmin;
  final bool createAdminSuccess;
  final bool isUpdatingAdmin;
  final bool updateAdminSuccess;
  final bool isDeletingAdmin;
  final bool deleteAdminSuccess;

  final String? error;

  const SettingsState({
    this.roles = const [],
    this.isLoadingRoles = false,
    this.permissions = const [],
    this.isLoadingPermissions = false,
    this.isSaving = false,
    this.saveSuccess = false,
    this.isCreatingRole = false,
    this.createRoleSuccess = false,
    this.isUpdatingRole = false,
    this.updateRoleSuccess = false,
    this.isDeletingRole = false,
    this.deleteRoleSuccess = false,
    this.admins = const [],
    this.isLoadingAdmins = false,
    this.isCreatingAdmin = false,
    this.createAdminSuccess = false,
    this.isUpdatingAdmin = false,
    this.updateAdminSuccess = false,
    this.isDeletingAdmin = false,
    this.deleteAdminSuccess = false,
    this.error,
  });

  SettingsState copyWith({
    List<RolesModel>? roles,
    bool? isLoadingRoles,
    List<RolesModel>? permissions,
    bool? isLoadingPermissions,
    bool? isSaving,
    bool? saveSuccess,
    bool? isCreatingRole,
    bool? createRoleSuccess,
    bool? isUpdatingRole,
    bool? updateRoleSuccess,
    bool? isDeletingRole,
    bool? deleteRoleSuccess,
    List<AdminUserModel>? admins,
    bool? isLoadingAdmins,
    bool? isCreatingAdmin,
    bool? createAdminSuccess,
    bool? isUpdatingAdmin,
    bool? updateAdminSuccess,
    bool? isDeletingAdmin,
    bool? deleteAdminSuccess,
    String? error,
  }) {
    return SettingsState(
      roles: roles ?? this.roles,
      isLoadingRoles: isLoadingRoles ?? this.isLoadingRoles,
      permissions: permissions ?? this.permissions,
      isLoadingPermissions: isLoadingPermissions ?? this.isLoadingPermissions,
      isSaving: isSaving ?? this.isSaving,
      saveSuccess: saveSuccess ?? false,
      isCreatingRole: isCreatingRole ?? this.isCreatingRole,
      createRoleSuccess: createRoleSuccess ?? false,
      isUpdatingRole: isUpdatingRole ?? this.isUpdatingRole,
      updateRoleSuccess: updateRoleSuccess ?? false,
      isDeletingRole: isDeletingRole ?? this.isDeletingRole,
      deleteRoleSuccess: deleteRoleSuccess ?? false,
      admins: admins ?? this.admins,
      isLoadingAdmins: isLoadingAdmins ?? this.isLoadingAdmins,
      isCreatingAdmin: isCreatingAdmin ?? this.isCreatingAdmin,
      createAdminSuccess: createAdminSuccess ?? false,
      isUpdatingAdmin: isUpdatingAdmin ?? this.isUpdatingAdmin,
      updateAdminSuccess: updateAdminSuccess ?? false,
      isDeletingAdmin: isDeletingAdmin ?? this.isDeletingAdmin,
      deleteAdminSuccess: deleteAdminSuccess ?? false,
      error: error,
    );
  }
}
