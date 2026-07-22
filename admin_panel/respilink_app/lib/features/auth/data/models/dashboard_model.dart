class DashboardModel {
  StatCounts? statCounts;
  EngagementTrend? engagementTrend;

  DashboardModel({this.statCounts, this.engagementTrend});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    statCounts = json['stat_counts'] != null
        ? StatCounts.fromJson(json['stat_counts'])
        : null;
    engagementTrend = json['engagement_trend'] != null
        ? EngagementTrend.fromJson(json['engagement_trend'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statCounts != null) {
      data['stat_counts'] = statCounts!.toJson();
    }
    if (engagementTrend != null) {
      data['engagement_trend'] = engagementTrend!.toJson();
    }
    return data;
  }
}

class StatCounts {
  ActiveDoctors? activeDoctors;
  PendingVerifications? pendingVerifications;
  QuizParticipation? quizParticipation;
  LibraryViews? libraryViews;

  StatCounts({
    this.activeDoctors,
    this.pendingVerifications,
    this.quizParticipation,
    this.libraryViews,
  });

  StatCounts.fromJson(Map<String, dynamic> json) {
    activeDoctors = json['active_doctors'] != null
        ? ActiveDoctors.fromJson(json['active_doctors'])
        : null;
    pendingVerifications = json['pending_verifications'] != null
        ? PendingVerifications.fromJson(json['pending_verifications'])
        : null;
    quizParticipation = json['quiz_participation'] != null
        ? QuizParticipation.fromJson(json['quiz_participation'])
        : null;
    libraryViews = json['library_views'] != null
        ? LibraryViews.fromJson(json['library_views'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (activeDoctors != null) {
      data['active_doctors'] = activeDoctors!.toJson();
    }
    if (pendingVerifications != null) {
      data['pending_verifications'] = pendingVerifications!.toJson();
    }
    if (quizParticipation != null) {
      data['quiz_participation'] = quizParticipation!.toJson();
    }
    if (libraryViews != null) {
      data['library_views'] = libraryViews!.toJson();
    }
    return data;
  }
}

class ActiveDoctors {
  int? count;
  int? changePercent;

  ActiveDoctors({this.count, this.changePercent});

  ActiveDoctors.fromJson(Map<String, dynamic> json) {
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

class PendingVerifications {
  int? count;
  int? critical;

  PendingVerifications({this.count, this.critical});

  PendingVerifications.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    critical = json['critical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['critical'] = critical;
    return data;
  }
}

class QuizParticipation {
  int? percentage;
  int? changePercent;

  QuizParticipation({this.percentage, this.changePercent});

  QuizParticipation.fromJson(Map<String, dynamic> json) {
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

class LibraryViews {
  int? total;
  int? recent;

  LibraryViews({this.total, this.recent});

  LibraryViews.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    recent = json['recent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['recent'] = recent;
    return data;
  }
}

class EngagementTrend {
  List<String>? labels;
  List<int>? views;
  List<int>? quizzes;

  EngagementTrend({this.labels, this.views, this.quizzes});

  EngagementTrend.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    views = json['views'].cast<int>();
    quizzes = json['quizzes'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labels'] = labels;
    data['views'] = views;
    data['quizzes'] = quizzes;
    return data;
  }
}
