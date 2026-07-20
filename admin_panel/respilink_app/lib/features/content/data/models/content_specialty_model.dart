class ContentSpecialtyModel {
  int? id;
  String? name;
  String? slug;

  ContentSpecialtyModel({this.id, this.name, this.slug});

  ContentSpecialtyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }
}
