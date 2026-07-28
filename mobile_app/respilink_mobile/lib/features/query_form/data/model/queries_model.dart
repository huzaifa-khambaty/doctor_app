import 'package:respilink_mobile/shared/models/pagination_model.dart';

class QueriesModel {
  List<Data>? data;
  Pagination? pagination;

  QueriesModel({this.data, this.pagination});

  QueriesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  Category? category;
  String? subject;
  String? message;
  String? status;
  String? adminResponse;
  String? respondedAt;
  String? createdAt;

  Data(
      {this.id,
      this.category,
      this.subject,
      this.message,
      this.status,
      this.adminResponse,
      this.respondedAt,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    adminResponse = json['admin_response'];
    respondedAt = json['responded_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['subject'] = subject;
    data['message'] = message;
    data['status'] = status;
    data['admin_response'] = adminResponse;
    data['responded_at'] = respondedAt;
    data['created_at'] = createdAt;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}
