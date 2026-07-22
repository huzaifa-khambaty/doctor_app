import 'package:respilink_app/features/auth/data/models/dashboard_model.dart';

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

  static const _months = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
    'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
    'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
  };

  static List<EngagementDataPoint> fromTrend(EngagementTrend trend) {
    final labels = trend.labels ?? [];
    final views = trend.views ?? [];
    final quizzes = trend.quizzes ?? [];
    final year = DateTime.now().year;
    return List.generate(labels.length, (i) {
      final parts = labels[i].split(' ');
      final month = _months[parts[0]] ?? 1;
      final day = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
      return EngagementDataPoint(
        date: DateTime(year, month, day),
        views: i < views.length ? views[i] : 0,
        quizzes: i < quizzes.length ? quizzes[i] : 0,
      );
    });
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
