abstract class SettingsEvent {}

class FetchRolesRequested extends SettingsEvent {}

class FetchPermissionsRequested extends SettingsEvent {}

class FetchRolePermissionsRequested extends SettingsEvent {
  final int roleId;
  FetchRolePermissionsRequested(this.roleId);
}

class AssignPermissionsRequested extends SettingsEvent {
  final int roleId;
  final List<int> permissionIds;

  AssignPermissionsRequested({
    required this.roleId,
    required this.permissionIds,
  });
}

class CreateRoleRequested extends SettingsEvent {
  final String name;
  CreateRoleRequested(this.name);
}

class UpdateRoleRequested extends SettingsEvent {
  final int roleId;
  final String name;
  final List<String>? permissions;
  UpdateRoleRequested({required this.roleId, required this.name, this.permissions});
}

class DeleteRoleRequested extends SettingsEvent {
  final int roleId;
  DeleteRoleRequested(this.roleId);
}

// Admin user management events
class FetchAdminsRequested extends SettingsEvent {}

class CreateAdminRequested extends SettingsEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final List<String> roles;
  CreateAdminRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.roles,
  });
}

class UpdateAdminRequested extends SettingsEvent {
  final int adminId;
  final String? name;
  final String? email;
  final String? password;
  final String? passwordConfirmation;
  final List<String>? roles;
  UpdateAdminRequested({
    required this.adminId,
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.roles,
  });
}

class DeleteAdminRequested extends SettingsEvent {
  final int adminId;
  DeleteAdminRequested(this.adminId);
}
