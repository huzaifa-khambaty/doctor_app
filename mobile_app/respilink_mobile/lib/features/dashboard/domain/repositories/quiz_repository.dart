import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_correct_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_home_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_list_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/requests/submit_quiz_answers_request.dart';

abstract class QuizRepository {
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
