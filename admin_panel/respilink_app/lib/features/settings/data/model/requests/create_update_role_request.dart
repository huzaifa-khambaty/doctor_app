class CreateUpdateRoleRequest {
  final String name;
  final List<String>? permissions;

  const CreateUpdateRoleRequest(this.name, {this.permissions});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'name': name};
    if (permissions != null) data['permissions'] = permissions;
    return data;
  }
}
