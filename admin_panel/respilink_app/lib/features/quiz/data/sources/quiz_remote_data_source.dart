import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';

abstract class QuizRemoteDataSource {
  Future<ApiResponse<List<QuizTopicModel>>> getTopics();
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<List<QuizTopicModel>>> getTopics() async {
    return _client.get(
      ApiEndpoints.topics,
      fromJson: (json) =>
          (json["data"] as List).map((e) => QuizTopicModel.fromJson(e)).toList(),
    );
  }
}
