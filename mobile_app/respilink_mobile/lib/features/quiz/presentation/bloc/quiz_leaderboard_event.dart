abstract class QuizLeaderboardEvent {}

class QuizLeaderboardRequested extends QuizLeaderboardEvent {
  final int quizId;

  QuizLeaderboardRequested({required this.quizId});
}
