abstract class QuizListEvent {}

class QuizListRequested extends QuizListEvent {
  final int topicId;

  QuizListRequested({required this.topicId});
}
