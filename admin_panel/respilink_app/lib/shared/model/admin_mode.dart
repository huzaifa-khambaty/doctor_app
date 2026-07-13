import 'dart:convert';

class AdminModel {
  String? token;
  Admin? admin;

  AdminModel({this.token, this.admin});

  AdminModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    admin = json['admin'] != null ? Admin.fromJson(json['admin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (admin != null) {
      data['admin'] = admin!.toJson();
    }
    return data;
  }
}

class Admin {
  int? id;
  String? uuid;
  String? name;
  String? email;
  String? phone;
  String? photoUrl;
  String? status;
  String? lastLoginAt;
  List<String>? roles;
  List<String>? permissions;

  Admin(
      {this.id,
      this.uuid,
      this.name,
      this.email,
      this.phone,
      this.photoUrl,
      this.status,
      this.lastLoginAt,
      this.roles,
      this.permissions});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    photoUrl = json['photo_url'] ?? json['photo'] ?? json['avatar'];
    status = json['status'];
    lastLoginAt = json['last_login_at'];
    roles = (json['roles'] as List?)?.cast<String>() ?? [];
    permissions = (json['permissions'] as List?)?.cast<String>() ?? [];
  }

  // Convert Model to JSON String (For Secure Storage)
  String toJson() => json.encode(toMap());

  // Create Model from JSON String
  factory Admin.fromCachedJson(String source) =>
      Admin.fromJson(json.decode(source));

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['photo_url'] = photoUrl;
    data['status'] = status;
    data['last_login_at'] = lastLoginAt;
    data['roles'] = roles;
    data['permissions'] = permissions;
    return data;
  }
}
