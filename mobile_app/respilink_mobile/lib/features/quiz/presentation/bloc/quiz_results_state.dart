import 'package:respilink_mobile/features/quiz/domain/models/quiz_result_model.dart';

abstract class QuizResultsState {}

class QuizResultsLoading extends QuizResultsState {}

class QuizResultsLoaded extends QuizResultsState {
  final QuizResultModel result;

  QuizResultsLoaded({required this.result});
}

class QuizResultsFailed extends QuizResultsState {
  final String message;

  QuizResultsFailed({required this.message});
}
