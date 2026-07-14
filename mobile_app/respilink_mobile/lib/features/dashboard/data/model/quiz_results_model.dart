class QuizResultsModel {
  Quiz? quiz;
  Result? result;
  Ranking? ranking;
  Achievement? achievement;
  Actions? actions;
  List<RecommendedContent>? recommendedContent;

  QuizResultsModel(
      {this.quiz,
      this.result,
      this.ranking,
      this.achievement,
      this.actions,
      this.recommendedContent});

  QuizResultsModel.fromJson(Map<String, dynamic> json) {
    quiz = json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null;
    result =
        json['result'] != null ? Result.fromJson(json['result']) : null;
    ranking =
        json['ranking'] != null ? Ranking.fromJson(json['ranking']) : null;
    achievement = json['achievement'] != null
        ? Achievement.fromJson(json['achievement'])
        : null;
    actions =
        json['actions'] != null ? Actions.fromJson(json['actions']) : null;
    if (json['recommended_content'] != null) {
      recommendedContent = <RecommendedContent>[];
      json['recommended_content'].forEach((v) {
        recommendedContent!.add(RecommendedContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (quiz != null) {
      data['quiz'] = quiz!.toJson();
    }
    if (result != null) {
      data['result'] = result!.toJson();
    }
    if (ranking != null) {
      data['ranking'] = ranking!.toJson();
    }
    if (achievement != null) {
      data['achievement'] = achievement!.toJson();
    }
    if (actions != null) {
      data['actions'] = actions!.toJson();
    }
    if (recommendedContent != null) {
      data['recommended_content'] =
          recommendedContent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quiz {
  int? id;
  String? title;

  Quiz({this.id, this.title});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class Result {
  int? scorePercentage;
  int? correctAnswers;
  int? totalQuestions;
  String? timeTaken;
  String? message;
  String? subMessage;

  Result(
      {this.scorePercentage,
      this.correctAnswers,
      this.totalQuestions,
      this.timeTaken,
      this.message,
      this.subMessage});

  Result.fromJson(Map<String, dynamic> json) {
    scorePercentage = json['score_percentage'];
    correctAnswers = json['correct_answers'];
    totalQuestions = json['total_questions'];
    timeTaken = json['time_taken'];
    message = json['message'];
    subMessage = json['sub_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score_percentage'] = scorePercentage;
    data['correct_answers'] = correctAnswers;
    data['total_questions'] = totalQuestions;
    data['time_taken'] = timeTaken;
    data['message'] = message;
    data['sub_message'] = subMessage;
    return data;
  }
}

class Ranking {
  int? currentRank;

  Ranking({this.currentRank});

  Ranking.fromJson(Map<String, dynamic> json) {
    currentRank = json['current_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_rank'] = currentRank;
    return data;
  }
}

class Achievement {
  String? title;
  String? subtitle;
  String? badgeImage;

  Achievement({this.title, this.subtitle, this.badgeImage});

  Achievement.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    badgeImage = json['badge_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['badge_image'] = badgeImage;
    return data;
  }
}

class Actions {
  bool? showLeaderboard;

  Actions({this.showLeaderboard});

  Actions.fromJson(Map<String, dynamic> json) {
    showLeaderboard = json['show_leaderboard'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['show_leaderboard'] = showLeaderboard;
    return data;
  }
}

class RecommendedContent {
  int? id;
  String? type;
  String? title;
  String? thumbnail;

  RecommendedContent({this.id, this.type, this.title, this.thumbnail});

  RecommendedContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    return data;
  }
}
