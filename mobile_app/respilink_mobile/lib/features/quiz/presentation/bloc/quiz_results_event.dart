abstract class QuizResultsEvent {}

class QuizResultsRequested extends QuizResultsEvent {
  final int quizId;

  QuizResultsRequested({required this.quizId});
}
