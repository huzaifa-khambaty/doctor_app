class QuizResultModel {
  final int scorePercent;
  final String performanceTitle;
  final String performanceSubtitle;
  final int globalRank;
  final int correctCount;
  final int totalCount;
  final String timeTaken;
  final String streakLabel;
  final String badgeEarned;

  const QuizResultModel({
    required this.scorePercent,
    required this.performanceTitle,
    required this.performanceSubtitle,
    required this.globalRank,
    required this.correctCount,
    required this.totalCount,
    required this.timeTaken,
    required this.streakLabel,
    required this.badgeEarned,
  });
}
