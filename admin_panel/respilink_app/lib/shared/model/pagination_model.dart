class Links {
  String? url;
  String? label;
  int? page;
  bool? active;

  Links({this.url, this.label, this.page, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    page = json['page'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['page'] = page;
    data['active'] = active;
    return data;
  }
}