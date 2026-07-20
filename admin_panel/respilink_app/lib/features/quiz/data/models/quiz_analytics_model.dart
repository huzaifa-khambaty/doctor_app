class QuizAnalyticsModel {
  int? quizId;
  String? quizTitle;
  int? totalStarted;
  int? totalSubmitted;
  int? completionRate;
  double? averageScore;
  ScoreDistribution? scoreDistribution;

  QuizAnalyticsModel({
    this.quizId,
    this.quizTitle,
    this.totalStarted,
    this.totalSubmitted,
    this.completionRate,
    this.averageScore,
    this.scoreDistribution,
  });

  QuizAnalyticsModel.fromJson(Map<String, dynamic> json) {
    quizId = json['quiz_id'] as int?;
    quizTitle = json['quiz_title'] as String?;
    totalStarted = (json['total_started'] as num?)?.toInt();
    totalSubmitted = (json['total_submitted'] as num?)?.toInt();
    completionRate = (json['completion_rate'] as num?)?.toInt();
    averageScore = (json['average_score'] as num?)?.toDouble();
    final raw = json['score_distribution'];
    scoreDistribution = raw != null ? ScoreDistribution.fromDynamic(raw) : null;
  }

  Map<String, dynamic> toJson() => {
        'quiz_id': quizId,
        'quiz_title': quizTitle,
        'total_started': totalStarted,
        'total_submitted': totalSubmitted,
        'completion_rate': completionRate,
        'average_score': averageScore,
        if (scoreDistribution != null) 'score_distribution': scoreDistribution!.toJson(),
      };
}

class ScoreDistribution {
  final Map<String, int> scores;

  ScoreDistribution(this.scores);

  factory ScoreDistribution.fromDynamic(dynamic raw) {
    if (raw is Map) {
      return ScoreDistribution(
        raw.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      );
    }
    if (raw is List) {
      // Each element is a score value that appeared once, keyed by its index position.
      final map = <String, int>{};
      for (int i = 0; i < raw.length; i++) {
        if (raw[i] != null) map['$i'] = (raw[i] as num).toInt();
      }
      return ScoreDistribution(map);
    }
    return ScoreDistribution({});
  }

  Map<String, dynamic> toJson() => scores;
}
