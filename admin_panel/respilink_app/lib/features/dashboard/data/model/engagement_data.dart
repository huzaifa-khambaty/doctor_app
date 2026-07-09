class EngagementDataPoint {
  final DateTime date;
  final int views;
  final int quizzes;

  EngagementDataPoint({
    required this.date,
    required this.views,
    required this.quizzes,
  });

  factory EngagementDataPoint.fromJson(Map<String, dynamic> json) {
    return EngagementDataPoint(
      date: DateTime.parse(json['date']),
      views: json['views'] as int,
      quizzes: json['quizzes'] as int,
    );
  }

  // Generate clean mock API response pipeline data matching image_bd8279.png
  static List<EngagementDataPoint> get mockWeeklyData {
    final now = DateTime.now();
    return [
      EngagementDataPoint(
        date: now.subtract(const Duration(days: 6)),
        views: 120,
        quizzes: 35,
      ),
      EngagementDataPoint(
        date: now.subtract(const Duration(days: 5)),
        views: 250,
        quizzes: 80,
      ),
      EngagementDataPoint(
        date: now.subtract(const Duration(days: 4)),
        views: 190,
        quizzes: 45,
      ),
      EngagementDataPoint(
        date: now.subtract(const Duration(days: 3)),
        views: 420,
        quizzes: 110,
      ),
      EngagementDataPoint(
        date: now.subtract(const Duration(days: 2)),
        views: 310,
        quizzes: 95,
      ),
      EngagementDataPoint(
        date: now.subtract(const Duration(days: 1)),
        views: 580,
        quizzes: 160,
      ),
      EngagementDataPoint(date: now, views: 490, quizzes: 140),
    ];
  }
}
