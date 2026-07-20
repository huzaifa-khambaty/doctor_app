import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/content/data/models/content_model.dart';
import 'package:respilink_app/features/content/data/models/content_specialty_model.dart';
import 'package:respilink_app/features/content/data/models/quiz_summary_model.dart';
import 'package:respilink_app/features/content/data/models/requests/create_content_request.dart';

abstract class ContentRemoteDataSource {
  Future<ApiResponse<List<ContentSpecialtyModel>>> getSpecialties();
  Future<ApiResponse<List<QuizSummaryModel>>> getQuizzes();
  Future<ApiResponse<ContentModel>> getContents({int page = 1, String? status, String? search});
  Future<ApiResponse<dynamic>> createContent(CreateContentRequest request);
  Future<ApiResponse<dynamic>> updateContent(int id, UpdateContentRequest request);
  Future<ApiResponse<dynamic>> deleteContent(int id);
  Future<ApiResponse<dynamic>> updateStatus(int id, String status);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<List<ContentSpecialtyModel>>> getSpecialties() async {
    return _client.get(
      ApiEndpoints.specialties,
      fromJson: (json) {
        final list = json is List ? json : (json as Map<String, dynamic>)['data'] as List;
        return list.map((e) => ContentSpecialtyModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<ApiResponse<List<QuizSummaryModel>>> getQuizzes() async {
    return _client.get(
      ApiEndpoints.quizzes,
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        final list = map['data'] as List;
        return list.map((e) => QuizSummaryModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<ApiResponse<ContentModel>> getContents({int page = 1, String? status, String? search}) async {
    return _client.get(
      ApiEndpoints.content,
      queryParameters: {
        'page': page,
        'status': ?status,
        if (search != null && search.isNotEmpty) 'search': search,
      },
      fromJson: (json) => ContentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<dynamic>> createContent(CreateContentRequest request) async {
    return _client.post(
      ApiEndpoints.content,
      data: request.toFormDataPost(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> updateContent(int id, UpdateContentRequest request) async {
    return _client.post(
      '${ApiEndpoints.content}/$id',
      data: request.toFormData(),
    );
  }

  @override
  Future<ApiResponse<dynamic>> deleteContent(int id) async {
    return _client.delete('${ApiEndpoints.content}/$id');
  }

  @override
  Future<ApiResponse<dynamic>> updateStatus(int id, String status) async {
    return _client.patch('${ApiEndpoints.content}/$id/status', data: {'status': status});
  }
}
