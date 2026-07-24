class AnalyticsModel {
  StatCards? statCards;
  EngagementTrends? engagementTrends;
  List<GrowthBySpecialty>? growthBySpecialty;
  List<TopPerformingContent>? topPerformingContent;

  AnalyticsModel(
      {this.statCards,
      this.engagementTrends,
      this.growthBySpecialty,
      this.topPerformingContent});

  AnalyticsModel.fromJson(Map<String, dynamic> json) {
    statCards = json['stat_cards'] != null
        ? StatCards.fromJson(json['stat_cards'])
        : null;
    engagementTrends = json['engagement_trends'] != null
        ? EngagementTrends.fromJson(json['engagement_trends'])
        : null;
    if (json['growth_by_specialty'] != null) {
      growthBySpecialty = <GrowthBySpecialty>[];
      json['growth_by_specialty'].forEach((v) {
        growthBySpecialty!.add(GrowthBySpecialty.fromJson(v));
      });
    }
    if (json['top_performing_content'] != null) {
      topPerformingContent = <TopPerformingContent>[];
      json['top_performing_content'].forEach((v) {
        topPerformingContent!.add(TopPerformingContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statCards != null) {
      data['stat_cards'] = statCards!.toJson();
    }
    if (engagementTrends != null) {
      data['engagement_trends'] = engagementTrends!.toJson();
    }
    if (growthBySpecialty != null) {
      data['growth_by_specialty'] =
          growthBySpecialty!.map((v) => v.toJson()).toList();
    }
    if (topPerformingContent != null) {
      data['top_performing_content'] =
          topPerformingContent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatCards {
  TotalActiveDoctors? totalActiveDoctors;
  AvgQuizScore? avgQuizScore;
  AvgQuizScore? eventRsvpRate;
  TotalActiveDoctors? contentReach;

  StatCards(
      {this.totalActiveDoctors,
      this.avgQuizScore,
      this.eventRsvpRate,
      this.contentReach});

  StatCards.fromJson(Map<String, dynamic> json) {
    totalActiveDoctors = json['total_active_doctors'] != null
        ? TotalActiveDoctors.fromJson(json['total_active_doctors'])
        : null;
    avgQuizScore = json['avg_quiz_score'] != null
        ? AvgQuizScore.fromJson(json['avg_quiz_score'])
        : null;
    eventRsvpRate = json['event_rsvp_rate'] != null
        ? AvgQuizScore.fromJson(json['event_rsvp_rate'])
        : null;
    contentReach = json['content_reach'] != null
        ? TotalActiveDoctors.fromJson(json['content_reach'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (totalActiveDoctors != null) {
      data['total_active_doctors'] = totalActiveDoctors!.toJson();
    }
    if (avgQuizScore != null) {
      data['avg_quiz_score'] = avgQuizScore!.toJson();
    }
    if (eventRsvpRate != null) {
      data['event_rsvp_rate'] = eventRsvpRate!.toJson();
    }
    if (contentReach != null) {
      data['content_reach'] = contentReach!.toJson();
    }
    return data;
  }
}

class TotalActiveDoctors {
  int? count;
  int? changePercent;

  TotalActiveDoctors({this.count, this.changePercent});

  TotalActiveDoctors.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    changePercent = json['change_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['change_percent'] = changePercent;
    return data;
  }
}

class AvgQuizScore {
  int? percentage;
  int? changePercent;

  AvgQuizScore({this.percentage, this.changePercent});

  AvgQuizScore.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    changePercent = json['change_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentage'] = percentage;
    data['change_percent'] = changePercent;
    return data;
  }
}

class EngagementTrends {
  List<String>? labels;
  List<int>? contentViews;
  List<int>? quizAttempts;

  EngagementTrends({this.labels, this.contentViews, this.quizAttempts});

  EngagementTrends.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    contentViews = json['content_views'].cast<int>();
    quizAttempts = json['quiz_attempts'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labels'] = labels;
    data['content_views'] = contentViews;
    data['quiz_attempts'] = quizAttempts;
    return data;
  }
}

class GrowthBySpecialty {
  String? name;
  int? contentCount;
  int? percentage;

  GrowthBySpecialty({this.name, this.contentCount, this.percentage});

  GrowthBySpecialty.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contentCount = json['content_count'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['content_count'] = contentCount;
    data['percentage'] = percentage;
    return data;
  }
}

class TopPerformingContent {
  int? id;
  String? title;
  String? type;
  String? specialty;
  int? viewsCount;
  int? likesCount;

  TopPerformingContent(
      {this.id,
      this.title,
      this.type,
      this.specialty,
      this.viewsCount,
      this.likesCount});

  TopPerformingContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    specialty = json['specialty'];
    viewsCount = json['views_count'];
    likesCount = json['likes_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['specialty'] = specialty;
    data['views_count'] = viewsCount;
    data['likes_count'] = likesCount;
    return data;
  }
}
