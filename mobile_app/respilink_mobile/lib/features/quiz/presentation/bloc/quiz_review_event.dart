abstract class QuizReviewEvent {}

class QuizReviewRequested extends QuizReviewEvent {
  final int quizId;

  QuizReviewRequested({required this.quizId});
}
