import 'package:respilink_mobile/features/dashboard/data/model/quiz_correct_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';

abstract class QuizReviewState {}

class QuizReviewLoading extends QuizReviewState {}

class QuizReviewLoaded extends QuizReviewState {
  final Quiz? quiz;
  final List<QuizReviewQuestion> questions;

  QuizReviewLoaded({required this.quiz, required this.questions});
}

class QuizReviewFailed extends QuizReviewState {
  final String message;

  QuizReviewFailed({required this.message});
}
