class QuizTopicModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  QuizTopicModel(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  QuizTopicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  bool operator ==(Object other) => other is QuizTopicModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}