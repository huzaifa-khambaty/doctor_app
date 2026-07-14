import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_correct_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_home_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_list_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/requests/submit_quiz_answers_request.dart';

import '../../../../core/network/models/api_response.dart';

abstract class QuizRemoteDataSource {
  Future<ApiResponse<QuizHomeModel>> getQuizHome();

  Future<ApiResponse<QuizListModel>> getTopicQuizzes(int topicId);

  Future<ApiResponse<void>> startQuizAttempt(int quizId);

  Future<ApiResponse<QuizQuestionAnswersModel>> getQuizQuestionAnswers(
    int quizId,
  );

  Future<ApiResponse<void>> submitQuizAnswers(
    int quizId,
    SubmitQuizAnswersRequest request,
  );

  Future<ApiResponse<void>> submitQuiz(int quizId);

  Future<ApiResponse<QuizCorrectAnswersModel>> getQuizCorrectAnswers(
    int quizId,
  );
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<QuizHomeModel>> getQuizHome() async {
    return _client.get(
      ApiEndpoints.quizHome,
      fromJson: (json) => QuizHomeModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<QuizListModel>> getTopicQuizzes(int topicId) async {
    return _client.get(
      '${ApiEndpoints.categoryQuiz}/$topicId/quizzes',
      fromJson: (json) => QuizListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> startQuizAttempt(int quizId) async {
    return _client.post('${ApiEndpoints.quizzes}/$quizId/start');
  }

  @override
  Future<ApiResponse<QuizQuestionAnswersModel>> getQuizQuestionAnswers(
    int quizId,
  ) async {
    return _client.get(
      '${ApiEndpoints.quizzes}/$quizId/questions',
      fromJson: (json) =>
          QuizQuestionAnswersModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> submitQuizAnswers(
    int quizId,
    SubmitQuizAnswersRequest request,
  ) async {
    return _client.post(
      '${ApiEndpoints.quizzes}/$quizId/answer',
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<void>> submitQuiz(int quizId) async {
    return _client.post('${ApiEndpoints.quizzes}/$quizId/submit');
  }

  @override
  Future<ApiResponse<QuizCorrectAnswersModel>> getQuizCorrectAnswers(
    int quizId,
  ) async {
    return _client.get(
      '${ApiEndpoints.quizzes}/$quizId/correct-answers',
      fromJson: (json) =>
          QuizCorrectAnswersModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
