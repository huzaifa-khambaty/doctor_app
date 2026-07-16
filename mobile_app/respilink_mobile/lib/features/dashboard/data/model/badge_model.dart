class BadgeModel {
  int? totalBadges;
  int? earnedBadges;
  int? totalAvailable;
  List<Categories>? categories;

  BadgeModel(
      {this.totalBadges,
      this.earnedBadges,
      this.totalAvailable,
      this.categories});

  BadgeModel.fromJson(Map<String, dynamic> json) {
    totalBadges = json['total_badges'];
    earnedBadges = json['earned_badges'];
    totalAvailable = json['total_available'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_badges'] = totalBadges;
    data['earned_badges'] = earnedBadges;
    data['total_available'] = totalAvailable;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  int? earned;
  int? total;
  List<Badges>? badges;

  Categories({this.id, this.name, this.earned, this.total, this.badges});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    earned = json['earned'];
    total = json['total'];
    if (json['badges'] != null) {
      badges = <Badges>[];
      json['badges'].forEach((v) {
        badges!.add(Badges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['earned'] = earned;
    data['total'] = total;
    if (badges != null) {
      data['badges'] = badges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Badges {
  int? id;
  String? code;
  String? name;
  String? description;
  String? icon;
  bool? earned;
  String? earnedAt;

  Badges(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.icon,
      this.earned,
      this.earnedAt});

  Badges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    earned = json['earned'];
    earnedAt = json['earned_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['icon'] = icon;
    data['earned'] = earned;
    data['earned_at'] = earnedAt;
    return data;
  }
}
