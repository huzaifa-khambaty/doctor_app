abstract class SettingsEvent {}

class FetchRolesRequested extends SettingsEvent {}

class FetchPermissionsRequested extends SettingsEvent {}

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
  UpdateRoleRequested({required this.roleId, required this.name});
}

class DeleteRoleRequested extends SettingsEvent {
  final int roleId;
  DeleteRoleRequested(this.roleId);
}
