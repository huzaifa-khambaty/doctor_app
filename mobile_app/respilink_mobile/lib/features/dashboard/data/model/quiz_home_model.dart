class QuizHomeModel {
  CurrentStatus? currentStatus;
  DailyChallenge? dailyChallenge;
  List<Topics>? topics;
  List<Leaderboard>? leaderboard;

  QuizHomeModel(
      {this.currentStatus, this.dailyChallenge, this.topics, this.leaderboard});

  QuizHomeModel.fromJson(Map<String, dynamic> json) {
    currentStatus = json['current_status'] != null
        ? CurrentStatus.fromJson(json['current_status'])
        : null;
    dailyChallenge = json['daily_challenge'] != null
        ? DailyChallenge.fromJson(json['daily_challenge'])
        : null;
    if (json['topics'] != null) {
      topics = <Topics>[];
      json['topics'].forEach((v) {
        topics!.add(Topics.fromJson(v));
      });
    }
    if (json['leaderboard'] != null) {
      leaderboard = <Leaderboard>[];
      json['leaderboard'].forEach((v) {
        leaderboard!.add(Leaderboard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentStatus != null) {
      data['current_status'] = currentStatus!.toJson();
    }
    if (dailyChallenge != null) {
      data['daily_challenge'] = dailyChallenge!.toJson();
    }
    if (topics != null) {
      data['topics'] = topics!.map((v) => v.toJson()).toList();
    }
    if (leaderboard != null) {
      data['leaderboard'] = leaderboard!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentStatus {
  int? rank;
  int? streak;
  int? xp;

  CurrentStatus({this.rank, this.streak, this.xp});

  CurrentStatus.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    streak = json['streak'];
    xp = json['xp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['streak'] = streak;
    data['xp'] = xp;
    return data;
  }
}

class DailyChallenge {
  int? id;
  String? title;
  String? description;
  int? xp;
  int? remainingSeconds;
  String? expiresAt;
  String? banner;
  int? quizId;

  DailyChallenge(
      {this.id,
      this.title,
      this.description,
      this.xp,
      this.remainingSeconds,
      this.expiresAt,
      this.banner,
      this.quizId});

  DailyChallenge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    xp = json['xp'];
    remainingSeconds = json['remaining_seconds'];
    expiresAt = json['expires_at'];
    banner = json['banner'];
    quizId = json['quiz_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['xp'] = xp;
    data['remaining_seconds'] = remainingSeconds;
    data['expires_at'] = expiresAt;
    data['banner'] = banner;
    data['quiz_id'] = quizId;
    return data;
  }
}

class Topics {
  int? id;
  String? name;
  String? icon;
  int? totalQuizzes;
  int? progress;

  Topics({this.id, this.name, this.icon, this.totalQuizzes, this.progress});

  Topics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    totalQuizzes = json['total_quizzes'];
    progress = json['progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    data['total_quizzes'] = totalQuizzes;
    data['progress'] = progress;
    return data;
  }
}

class Leaderboard {
  int? rank;
  String? doctorName;
  int? points;

  Leaderboard({this.rank, this.doctorName, this.points});

  Leaderboard.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    doctorName = json['doctor_name'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rank'] = rank;
    data['doctor_name'] = doctorName;
    data['points'] = points;
    return data;
  }
}
