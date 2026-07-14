class DailyChallengeModel {
  int? id;
  String? title;
  String? description;
  int? xp;
  int? remainingSeconds;
  String? expiresAt;
  String? banner;
  int? quizId;

  DailyChallengeModel(
      {this.id,
      this.title,
      this.description,
      this.xp,
      this.remainingSeconds,
      this.expiresAt,
      this.banner,
      this.quizId});

  /// Hour-based countdown (formatted as 00:00:00 by [CountdownTimer]).
  Duration get timeRemaining => Duration(seconds: remainingSeconds ?? 0);
}