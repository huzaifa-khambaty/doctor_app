import 'package:dio/dio.dart';
import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_detail_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_list_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';
import 'package:respilink_app/features/quiz/data/models/requests/add_questions_request.dart';
import 'package:respilink_app/features/quiz/data/models/requests/create_quiz_request.dart';

abstract class QuizRemoteDataSource {
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
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<List<QuizTopicModel>>> getTopics() async {
    return _client.get(
      ApiEndpoints.topics,
      fromJson: (json) =>
          (json['data'] as List).map((e) => QuizTopicModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<ApiResponse<QuizListModel>> getQuizzes({int page = 1}) async {
    return _client.get(
      ApiEndpoints.quizzes,
      queryParameters: {'page': page},
      fromJson: (json) => QuizListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<int>> createQuiz(CreateQuizRequest request) async {
    return _client.post(
      ApiEndpoints.quizzes,
      data: request.toJson(),
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        if (map['id'] != null) return map['id'] as int;
        final quiz = map['quiz'];
        if (quiz is Map<String, dynamic> && quiz['id'] != null) {
          return quiz['id'] as int;
        }
        final data = map['data'];
        if (data is Map<String, dynamic> && data['id'] != null) {
          return data['id'] as int;
        }
        throw Exception('Quiz ID not found in response: $map');
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> addQuizQuestions(
    int quizId,
    AddQuestionsRequest request,
  ) async {
    final hasImages = request.questions.any((q) => q.imageBytes != null);

    if (!hasImages) {
      return _client.post(
        '${ApiEndpoints.quizzes}/$quizId/questions',
        data: request.toJson(),
      );
    }

    return _client.post(
      '${ApiEndpoints.quizzes}/$quizId/questions',
      data: _buildQuestionsFormData(request),
    );
  }

  @override
  Future<ApiResponse<QuizDetailModel>> getQuizDetail(int quizId) async {
    return _client.get(
      '${ApiEndpoints.quizzes}/$quizId',
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        if (map.containsKey('id')) return QuizDetailModel.fromJson(map);
        final nested = map['quiz'] ?? map['data'];
        if (nested is Map<String, dynamic>) return QuizDetailModel.fromJson(nested);
        return QuizDetailModel.fromJson(map);
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> updateQuiz(
    int quizId,
    CreateQuizRequest request,
  ) async {
    return _client.put(
      '${ApiEndpoints.quizzes}/$quizId',
      data: request.toJson(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> updateQuizQuestions(
    int quizId,
    AddQuestionsRequest request,
  ) async {
    final hasImages = request.questions.any(
      (q) => q.imageBytes != null || q.existingImagePath != null,
    );

    // Use the same POST endpoint as create — backend syncs by question id.
    if (!hasImages) {
      return _client.post(
        '${ApiEndpoints.quizzes}/$quizId/questions',
        data: request.toJson(),
      );
    }

    return _client.post(
      '${ApiEndpoints.quizzes}/$quizId/questions',
      data: _buildQuestionsFormData(request, includeExistingPaths: true),
    );
  }

  @override
  Future<ApiResponse<dynamic>> publishQuiz(int quizId) async {
    return _client.post('${ApiEndpoints.quizzes}/$quizId/publish', data: {});
  }

  @override
  Future<ApiResponse<dynamic>> unpublishQuiz(int quizId) async {
    return _client.post('${ApiEndpoints.quizzes}/$quizId/unpublish', data: {});
  }

  @override
  Future<ApiResponse<dynamic>> deleteQuiz(int quizId) async {
    return _client.delete('${ApiEndpoints.quizzes}/$quizId');
  }

  // Shared multipart builder for add and update question flows.
  FormData _buildQuestionsFormData(
    AddQuestionsRequest request, {
    bool includeExistingPaths = false,
  }) {
    final formData = FormData();
    for (int i = 0; i < request.questions.length; i++) {
      final q = request.questions[i];
      formData.fields.addAll([
        if (q.id != null) MapEntry('questions[$i][id]', q.id.toString()),
        MapEntry('questions[$i][question_text]', q.questionText),
        MapEntry('questions[$i][is_multiple]', q.isMultiple ? '1' : '0'),
        MapEntry('questions[$i][order]', q.order.toString()),
      ]);
      for (int j = 0; j < q.options.length; j++) {
        final o = q.options[j];
        formData.fields.addAll([
          MapEntry('questions[$i][options][$j][option_text]', o.optionText),
          MapEntry('questions[$i][options][$j][is_correct]', o.isCorrect ? '1' : '0'),
          MapEntry('questions[$i][options][$j][order]', o.order.toString()),
          if (o.explanation != null && o.explanation!.isNotEmpty)
            MapEntry('questions[$i][options][$j][explanation]', o.explanation!),
        ]);
      }
      if (q.imageBytes != null) {
        formData.files.add(MapEntry(
          'questions[$i][image_path]',
          MultipartFile.fromBytes(
            q.imageBytes!,
            filename: q.imageName ?? 'image.jpg',
          ),
        ));
      } else if (includeExistingPaths && q.existingImagePath != null) {
        formData.fields
            .add(MapEntry('questions[$i][image_path]', q.existingImagePath!));
      }
    }
    return formData;
  }
}
