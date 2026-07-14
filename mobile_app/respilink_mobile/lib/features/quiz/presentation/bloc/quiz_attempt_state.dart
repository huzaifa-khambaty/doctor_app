abstract class QuizAttemptState {}

class QuizAttemptInitial extends QuizAttemptState {}

class QuizAttemptStarting extends QuizAttemptState {
  final int quizId;

  QuizAttemptStarting({required this.quizId});
}

class QuizAttemptStarted extends QuizAttemptState {
  final int quizId;

  QuizAttemptStarted({required this.quizId});
}

class QuizAttemptFailed extends QuizAttemptState {
  final String message;

  QuizAttemptFailed({required this.message});
}
