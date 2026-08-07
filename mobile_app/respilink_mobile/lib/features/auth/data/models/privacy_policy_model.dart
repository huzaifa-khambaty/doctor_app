class PrivacyPolicyModel {
  String? title;
  String? content;
  String? updatedAt;

  PrivacyPolicyModel({this.title, this.content, this.updatedAt});

  PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['updated_at'] = updatedAt;
    return data;
  }
}
