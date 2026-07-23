class DailyChallengeSummaryModel {
  final int? quizId;
  final String title;
  final String subtitle;
  final int? globalRank;

  const DailyChallengeSummaryModel({
    this.quizId,
    required this.title,
    required this.subtitle,
    this.globalRank,
  });
}
