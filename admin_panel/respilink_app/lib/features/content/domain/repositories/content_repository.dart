import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/content/data/models/content_model.dart';
import 'package:respilink_app/features/content/data/models/content_specialty_model.dart';
import 'package:respilink_app/features/content/data/models/quiz_summary_model.dart';
import 'package:respilink_app/features/content/data/models/requests/create_content_request.dart';

abstract class ContentRepository {
  Future<ApiResponse<List<ContentSpecialtyModel>>> getSpecialties();
  Future<ApiResponse<List<QuizSummaryModel>>> getQuizzes();
  Future<ApiResponse<ContentModel>> getContents({int page = 1, String? status, String? search});
  Future<ApiResponse<dynamic>> createContent(CreateContentRequest request);
  Future<ApiResponse<dynamic>> updateContent(int id, UpdateContentRequest request);
  Future<ApiResponse<dynamic>> deleteContent(int id);
  Future<ApiResponse<dynamic>> updateStatus(int id, String status);
}
