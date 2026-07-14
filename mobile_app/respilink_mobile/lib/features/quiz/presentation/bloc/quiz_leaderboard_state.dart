import 'package:respilink_mobile/features/quiz/domain/models/quiz_leaderboard_entry_model.dart';

abstract class QuizLeaderboardState {}

class QuizLeaderboardLoading extends QuizLeaderboardState {}

class QuizLeaderboardLoaded extends QuizLeaderboardState {
  final List<QuizLeaderboardEntryModel> topThree;
  final List<QuizLeaderboardEntryModel> rankings;
  final QuizLeaderboardEntryModel? currentUser;

  QuizLeaderboardLoaded({
    required this.topThree,
    required this.rankings,
    this.currentUser,
  });
}

class QuizLeaderboardFailed extends QuizLeaderboardState {
  final String message;

  QuizLeaderboardFailed({required this.message});
}
