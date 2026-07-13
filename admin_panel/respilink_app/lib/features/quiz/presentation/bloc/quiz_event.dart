import 'package:respilink_app/features/quiz/data/models/requests/add_questions_request.dart';
import 'package:respilink_app/features/quiz/data/models/requests/create_quiz_request.dart';

abstract class QuizEvent {}

class FetchTopicsRequested extends QuizEvent {}

class FetchQuizzesRequested extends QuizEvent {
  final int page;
  FetchQuizzesRequested({this.page = 1});
}

class PublishQuizRequested extends QuizEvent {
  final CreateQuizRequest createRequest;
  final AddQuestionsRequest questionsRequest;

  PublishQuizRequested({
    required this.createRequest,
    required this.questionsRequest,
  });
}

class FetchQuizDetailRequested extends QuizEvent {
  final int quizId;
  FetchQuizDetailRequested(this.quizId);
}

class UpdateQuizRequested extends QuizEvent {
  final int quizId;
  final CreateQuizRequest updateRequest;
  final AddQuestionsRequest questionsRequest;

  UpdateQuizRequested({
    required this.quizId,
    required this.updateRequest,
    required this.questionsRequest,
  });
}

class ToggleQuizStatusRequested extends QuizEvent {
  final int quizId;
  final bool publish; // true = publish, false = unpublish

  ToggleQuizStatusRequested({required this.quizId, required this.publish});
}

class DeleteQuizRequested extends QuizEvent {
  final int quizId;
  DeleteQuizRequested(this.quizId);
}

class ResetQuizFormRequested extends QuizEvent {}
