class HomeModel {
  Hero? hero;
  User? user;
  List<Events>? events;
  Quiz? quiz;
  List<Contents>? contents;

  HomeModel({this.hero, this.user, this.events, this.quiz, this.contents});

  HomeModel.fromJson(Map<String, dynamic> json) {
    hero = json['hero'] != null ? Hero.fromJson(json['hero']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(Events.fromJson(v));
      });
    }
    quiz = json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null;
    if (json['contents'] != null) {
      contents = <Contents>[];
      json['contents'].forEach((v) {
        contents!.add(Contents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hero != null) {
      data['hero'] = hero!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    if (quiz != null) {
      data['quiz'] = quiz!.toJson();
    }
    if (contents != null) {
      data['contents'] = contents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hero {
  String? title;
  String? subtitle;
  String? buttonText;

  Hero({this.title, this.subtitle, this.buttonText});

  Hero.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    buttonText = json['button_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['button_text'] = buttonText;
    return data;
  }
}

class User {
  String? fullName;
  String? photoUrl;

  User({this.fullName, this.photoUrl});

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['photo_url'] = photoUrl;
    return data;
  }
}

class Events {
  int? id;
  String? title;
  String? type;
  String? startsAt;
  String? bannerUrl;
  bool? isRegistered;

  Events(
      {this.id,
      this.title,
      this.type,
      this.startsAt,
      this.bannerUrl,
      this.isRegistered});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    startsAt = json['starts_at'];
    bannerUrl = json['banner_url'];
    isRegistered = json['is_registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['starts_at'] = startsAt;
    data['banner_url'] = bannerUrl;
    data['is_registered'] = isRegistered;
    return data;
  }
}

class Quiz {
  int? id;
  String? title;
  String? description;
  String? opensAt;
  int? xp;
  int? remainingSeconds;
  String? banner;
  int? yourRank;
  bool? hasAttempted;

  Quiz(
      {this.id,
      this.title,
      this.description,
      this.opensAt,
      this.xp,
      this.remainingSeconds,
      this.banner,
      this.yourRank,
      this.hasAttempted});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    opensAt = json['opens_at'];
    xp = json['xp'];
    remainingSeconds = json['remaining_seconds'];
    banner = json['banner'];
    yourRank = json['your_rank'];
    hasAttempted = json['has_attempted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['opens_at'] = opensAt;
    data['xp'] = xp;
    data['remaining_seconds'] = remainingSeconds;
    data['banner'] = banner;
    data['your_rank'] = yourRank;
    data['has_attempted'] = hasAttempted;
    return data;
  }
}

class Contents {
  int? id;
  String? title;
  String? typeSlug;
  String? typeName;
  String? thumbnailUrl;
  String? readTime;

  Contents(
      {this.id,
      this.title,
      this.typeSlug,
      this.typeName,
      this.thumbnailUrl,
      this.readTime});

  Contents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeSlug = json['type_slug'];
    typeName = json['type_name'];
    thumbnailUrl = json['thumbnail_url'];
    readTime = json['read_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type_slug'] = typeSlug;
    data['type_name'] = typeName;
    data['thumbnail_url'] = thumbnailUrl;
    data['read_time'] = readTime;
    return data;
  }
}
