class DailyChallengeModel {
  final String title;
  final String description;
  final int xp;
  final Duration timeRemaining;
  final String image;

  const DailyChallengeModel({
    required this.title,
    required this.description,
    required this.xp,
    required this.timeRemaining,
    required this.image,
  });
}
