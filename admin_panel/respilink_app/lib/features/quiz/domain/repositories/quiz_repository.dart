import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_analytics_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_detail_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_list_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';
import 'package:respilink_app/features/quiz/data/models/requests/add_questions_request.dart';
import 'package:respilink_app/features/quiz/data/models/requests/create_quiz_request.dart';

abstract class QuizRepository {
  Future<ApiResponse<List<QuizTopicModel>>> getTopics();
  Future<ApiResponse<QuizListModel>> getQuizzes({int page = 1});
  Future<ApiResponse<int>> createQuiz(CreateQuizRequest request);
  Future<ApiResponse<dynamic>> addQuizQuestions(int quizId, AddQuestionsRequest request);
  Future<ApiResponse<QuizDetailModel>> getQuizDetail(int quizId);
  Future<ApiResponse<dynamic>> updateQuiz(int quizId, CreateQuizRequest request);
  Future<ApiResponse<dynamic>> updateQuizQuestions(int quizId, AddQuestionsRequest request);
  Future<ApiResponse<dynamic>> publishQuiz(int quizId);
  Future<ApiResponse<dynamic>> unpublishQuiz(int quizId);
  Future<ApiResponse<dynamic>> deleteQuiz(int quizId);
  Future<ApiResponse<QuizAnalyticsModel>> quizAnalytics(int quizId);
}
