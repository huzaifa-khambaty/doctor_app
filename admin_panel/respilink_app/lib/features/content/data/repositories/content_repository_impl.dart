import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/content/data/models/content_model.dart';
import 'package:respilink_app/features/content/data/models/content_specialty_model.dart';
import 'package:respilink_app/features/content/data/models/quiz_summary_model.dart';
import 'package:respilink_app/features/content/data/models/requests/create_content_request.dart';
import 'package:respilink_app/features/content/data/sources/content_remote_data_source.dart';
import 'package:respilink_app/features/content/domain/repositories/content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource _remoteDataSource;

  ContentRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<List<ContentSpecialtyModel>>> getSpecialties() =>
      _remoteDataSource.getSpecialties();

  @override
  Future<ApiResponse<List<QuizSummaryModel>>> getQuizzes() =>
      _remoteDataSource.getQuizzes();

  @override
  Future<ApiResponse<ContentModel>> getContents({int page = 1, String? status, String? search}) =>
      _remoteDataSource.getContents(page: page, status: status, search: search);

  @override
  Future<ApiResponse<dynamic>> createContent(CreateContentRequest request) =>
      _remoteDataSource.createContent(request);

  @override
  Future<ApiResponse<dynamic>> updateContent(int id, UpdateContentRequest request) =>
      _remoteDataSource.updateContent(id, request);

  @override
  Future<ApiResponse<dynamic>> deleteContent(int id) =>
      _remoteDataSource.deleteContent(id);

  @override
  Future<ApiResponse<dynamic>> updateStatus(int id, String status) =>
      _remoteDataSource.updateStatus(id, status);
}
