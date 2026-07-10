class RolesModel {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  List<RolesModel>? permissions;

  RolesModel({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.permissions,
  });

  RolesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['permissions'] != null) {
      permissions = <RolesModel>[];
      json['permissions'].forEach((v) {
        permissions!.add(RolesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
