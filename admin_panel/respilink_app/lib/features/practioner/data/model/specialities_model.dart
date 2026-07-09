class SpecialitiesModel {
  int? id;
  String? name;
  String? slug;

  SpecialitiesModel({this.id, this.name, this.slug});

  SpecialitiesModel.fromJson(Map<String, dynamic> json) {
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
