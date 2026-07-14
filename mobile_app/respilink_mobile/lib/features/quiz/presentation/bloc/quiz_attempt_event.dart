abstract class QuizAttemptEvent {}

class QuizAttemptStartRequested extends QuizAttemptEvent {
  final int quizId;

  QuizAttemptStartRequested({required this.quizId});
}
