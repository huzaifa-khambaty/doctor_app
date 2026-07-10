class AssignPermissionsRequest {
  final List<int> permissionIds;

  const AssignPermissionsRequest(this.permissionIds);

  Map<String, dynamic> toJson() => {'permissions': permissionIds};
}
