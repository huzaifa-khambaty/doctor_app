import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';
import 'package:respilink_app/features/quiz/data/sources/quiz_remote_data_source.dart';
import 'package:respilink_app/features/quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource _remoteDataSource;

  QuizRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<QuizTopicModel>>> getTopics() =>
      _remoteDataSource.getTopics();
}
