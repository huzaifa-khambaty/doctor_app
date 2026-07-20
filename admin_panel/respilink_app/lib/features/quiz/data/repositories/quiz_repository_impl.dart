import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_analytics_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_detail_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_list_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';
import 'package:respilink_app/features/quiz/data/models/requests/add_questions_request.dart';
import 'package:respilink_app/features/quiz/data/models/requests/create_quiz_request.dart';
import 'package:respilink_app/features/quiz/data/sources/quiz_remote_data_source.dart';
import 'package:respilink_app/features/quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource _remoteDataSource;

  QuizRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<QuizTopicModel>>> getTopics() =>
      _remoteDataSource.getTopics();

  @override
  Future<ApiResponse<QuizListModel>> getQuizzes({int page = 1}) =>
      _remoteDataSource.getQuizzes(page: page);

  @override
  Future<ApiResponse<int>> createQuiz(CreateQuizRequest request) =>
      _remoteDataSource.createQuiz(request);

  @override
  Future<ApiResponse<dynamic>> addQuizQuestions(
          int quizId, AddQuestionsRequest request) =>
      _remoteDataSource.addQuizQuestions(quizId, request);

  @override
  Future<ApiResponse<QuizDetailModel>> getQuizDetail(int quizId) =>
      _remoteDataSource.getQuizDetail(quizId);

  @override
  Future<ApiResponse<dynamic>> updateQuiz(
          int quizId, CreateQuizRequest request) =>
      _remoteDataSource.updateQuiz(quizId, request);

  @override
  Future<ApiResponse<dynamic>> updateQuizQuestions(
          int quizId, AddQuestionsRequest request) =>
      _remoteDataSource.updateQuizQuestions(quizId, request);

  @override
  Future<ApiResponse<dynamic>> publishQuiz(int quizId) =>
      _remoteDataSource.publishQuiz(quizId);

  @override
  Future<ApiResponse<dynamic>> unpublishQuiz(int quizId) =>
      _remoteDataSource.unpublishQuiz(quizId);

  @override
  Future<ApiResponse<dynamic>> deleteQuiz(int quizId) =>
      _remoteDataSource.deleteQuiz(quizId);

  @override
  Future<ApiResponse<QuizAnalyticsModel>> quizAnalytics(int quizId) =>
      _remoteDataSource.quizAnalytics(quizId);
}
