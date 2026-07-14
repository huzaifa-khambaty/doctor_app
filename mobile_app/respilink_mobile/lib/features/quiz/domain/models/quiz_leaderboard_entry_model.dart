enum RankChangeDirection { up, down, none }

class QuizLeaderboardEntryModel {
  final int rank;
  final String name;
  final String? specialty;
  final String? location;
  final String? avatarUrl;
  final int points;
  final RankChangeDirection changeDirection;
  final bool isCurrentUser;
  final int? pointsToNextRank;

  const QuizLeaderboardEntryModel({
    required this.rank,
    required this.name,
    this.specialty,
    this.location,
    this.avatarUrl,
    required this.points,
    this.changeDirection = RankChangeDirection.none,
    this.isCurrentUser = false,
    this.pointsToNextRank,
  });
}
