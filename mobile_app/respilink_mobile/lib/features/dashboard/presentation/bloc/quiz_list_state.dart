import 'package:respilink_mobile/features/dashboard/data/model/quiz_list_model.dart';

abstract class QuizListState {}

class QuizListLoading extends QuizListState {}

class QuizListLoaded extends QuizListState {
  final Topic? topic;
  final List<QuizSummary> quizzes;

  QuizListLoaded({required this.topic, required this.quizzes});
}

class QuizListFailed extends QuizListState {
  final String message;

  QuizListFailed({required this.message});
}
