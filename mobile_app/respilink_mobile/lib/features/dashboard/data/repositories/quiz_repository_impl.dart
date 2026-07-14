import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_correct_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_home_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_list_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/requests/submit_quiz_answers_request.dart';
import 'package:respilink_mobile/features/dashboard/data/sources/quiz_remote_data_source.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource _remoteDataSource;

  QuizRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<QuizHomeModel>> getQuizHome() {
    return _remoteDataSource.getQuizHome();
  }

  @override
  Future<ApiResponse<QuizListModel>> getTopicQuizzes(int topicId) {
    return _remoteDataSource.getTopicQuizzes(topicId);
  }

  @override
  Future<ApiResponse<void>> startQuizAttempt(int quizId) {
    return _remoteDataSource.startQuizAttempt(quizId);
  }

  @override
  Future<ApiResponse<QuizQuestionAnswersModel>> getQuizQuestionAnswers(
    int quizId,
  ) {
    return _remoteDataSource.getQuizQuestionAnswers(quizId);
  }

  @override
  Future<ApiResponse<void>> submitQuizAnswers(
    int quizId,
    SubmitQuizAnswersRequest request,
  ) {
    return _remoteDataSource.submitQuizAnswers(quizId, request);
  }

  @override
  Future<ApiResponse<void>> submitQuiz(int quizId) {
    return _remoteDataSource.submitQuiz(quizId);
  }

  @override
  Future<ApiResponse<QuizCorrectAnswersModel>> getQuizCorrectAnswers(
    int quizId,
  ) {
    return _remoteDataSource.getQuizCorrectAnswers(quizId);
  }
}
