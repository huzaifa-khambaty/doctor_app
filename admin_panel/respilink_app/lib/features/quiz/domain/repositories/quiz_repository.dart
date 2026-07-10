import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';

abstract class QuizRepository {
  Future<ApiResponse<List<QuizTopicModel>>> getTopics();
}
