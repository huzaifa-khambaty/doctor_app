
import 'package:respilink_app/features/settings/presentation/pages/data/model/roles_model.dart';

class AdminUserModel {
  int? id;
  String? uuid;
  String? name;
  String? email;
  String? status;
  String? lastLoginAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<RolesModel>? roles;

  AdminUserModel(
      {this.id,
      this.uuid,
      this.name,
      this.email,
      this.status,
      this.lastLoginAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.roles});

  AdminUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    email = json['email'];
    status = json['status'];
    lastLoginAt = json['last_login_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['roles'] != null) {
      roles = <RolesModel>[];
      json['roles'].forEach((v) {
        roles!.add(RolesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['name'] = name;
    data['email'] = email;
    data['status'] = status;
    data['last_login_at'] = lastLoginAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}