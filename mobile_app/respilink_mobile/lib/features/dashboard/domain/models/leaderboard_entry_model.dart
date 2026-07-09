class LeaderboardEntryModel {
  final int rank;
  final String name;
  final int points;
  final String? avatarUrl;

  const LeaderboardEntryModel({
    required this.rank,
    required this.name,
    required this.points,
    this.avatarUrl,
  });
}
