class CreateUpdateRoleRequest {
  final String name;

  const CreateUpdateRoleRequest(this.name);

  Map<String, dynamic> toJson() => {'name': name};
}
