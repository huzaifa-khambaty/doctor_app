class QuizLeaderboardModel {
  String? title;
  String? specialityFilter;
  List<TopThree>? topThree;
  List<Rankings>? rankings;
  CurrentUser? currentUser;

  QuizLeaderboardModel(
      {this.title,
      this.specialityFilter,
      this.topThree,
      this.rankings,
      this.currentUser});

  QuizLeaderboardModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    specialityFilter = json['speciality_filter'];
    if (json['top_three'] != null) {
      topThree = <TopThree>[];
      json['top_three'].forEach((v) {
        topThree!.add(TopThree.fromJson(v));
      });
    }
    if (json['rankings'] != null) {
      rankings = <Rankings>[];
      json['rankings'].forEach((v) {
        rankings!.add(Rankings.fromJson(v));
      });
    }
    currentUser = json['current_user'] != null
        ? CurrentUser.fromJson(json['current_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['speciality_filter'] = specialityFilter;
    if (topThree != null) {
      data['top_three'] = topThree!.map((v) => v.toJson()).toList();
    }
    if (rankings != null) {
      data['rankings'] = rankings!.map((v) => v.toJson()).toList();
    }
    if (currentUser != null) {
      data['current_user'] = currentUser!.toJson();
    }
    return data;
  }
}

class TopThree {
  int? rank;
  int? userId;
  String? name;
  String? speciality;
  String? location;
  Null? avatar;
  String? initials;
  int? points;
  int? score;
  int? durationSeconds;
  String? submittedAt;

  TopThree(
      {this.rank,
      this.userId,
      this.name,
      this.speciality,
      this.location,
      this.avatar,
      this.initials,
      this.points,
      this.score,
      this.durationSeconds,
      this.submittedAt});

  TopThree.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    userId = json['user_id'];
    name = json['name'];
    speciality = json['speciality'];
    location = json['location'];
    avatar = json['avatar'];
    initials = json['initials'];
    points = json['points'];
    score = json['score'];
    durationSeconds = json['duration_seconds'];
    submittedAt = json['submitted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['user_id'] = userId;
    data['name'] = name;
    data['speciality'] = speciality;
    data['location'] = location;
    data['avatar'] = avatar;
    data['initials'] = initials;
    data['points'] = points;
    data['score'] = score;
    data['duration_seconds'] = durationSeconds;
    data['submitted_at'] = submittedAt;
    return data;
  }
}

class Rankings {
  int? rank;
  int? userId;
  String? name;
  String? speciality;
  String? location;
  String? avatar;
  String? initials;
  int? points;
  int? score;
  int? durationSeconds;
  String? submittedAt;

  Rankings(
      {this.rank,
      this.userId,
      this.name,
      this.speciality,
      this.location,
      this.avatar,
      this.initials,
      this.points,
      this.score,
      this.durationSeconds,
      this.submittedAt});

  Rankings.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    userId = json['user_id'];
    name = json['name'];
    speciality = json['speciality'];
    location = json['location'];
    avatar = json['avatar'];
    initials = json['initials'];
    points = json['points'];
    score = json['score'];
    durationSeconds = json['duration_seconds'];
    submittedAt = json['submitted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['user_id'] = userId;
    data['name'] = name;
    data['speciality'] = speciality;
    data['location'] = location;
    data['avatar'] = avatar;
    data['initials'] = initials;
    data['points'] = points;
    data['score'] = score;
    data['duration_seconds'] = durationSeconds;
    data['submitted_at'] = submittedAt;
    return data;
  }
}

class CurrentUser {
  int? rank;
  int? userId;
  String? name;
  String? avatar;
  Null? initials;
  int? points;
  int? nextRankPoints;
  String? badgeUrl;

  CurrentUser(
      {this.rank,
      this.userId,
      this.name,
      this.avatar,
      this.initials,
      this.points,
      this.nextRankPoints,
      this.badgeUrl});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    userId = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
    initials = json['initials'];
    points = json['points'];
    nextRankPoints = json['next_rank_points'];
    badgeUrl = json['badge_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['user_id'] = userId;
    data['name'] = name;
    data['avatar'] = avatar;
    data['initials'] = initials;
    data['points'] = points;
    data['next_rank_points'] = nextRankPoints;
    data['badge_url'] = badgeUrl;
    return data;
  }
}
