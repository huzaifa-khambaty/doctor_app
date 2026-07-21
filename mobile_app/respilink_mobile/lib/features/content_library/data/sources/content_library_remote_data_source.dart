import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_details_model.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_library_model.dart';

import '../../../../core/network/models/api_response.dart';

abstract class ContentLibraryRemoteDataSource {
  Future<ApiResponse<ContentLibraryModel>> getLibrary({
    required int page,
    String? tab,
    String? search,
  });

  Future<ApiResponse<ContentDetailsModel>> getLibraryDetails(int libraryId);

  Future<ApiResponse<void>> increaseCount(int libraryId);

  Future<ApiResponse<void>> increaseDownloadCount(int libraryId);

  Future<ApiResponse<void>> likeContent(int libraryId);

  Future<ApiResponse<void>> unLikeContent(int libraryId);

  Future<ApiResponse<void>> bookmark(int libraryId);

  Future<ApiResponse<void>> removeBookmark(int libraryId);
}

class ContentLibraryRemoteDataSourceImpl
    implements ContentLibraryRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<ContentLibraryModel>> getLibrary({
    required int page,
    String? tab,
    String? search,
  }) async {
    return _client.get(
      "${ApiEndpoints.library}?tab=$tab",
      queryParameters: {
        'page': page,
        if (search != null && search.isNotEmpty) 'search': search,
      },
      fromJson: (json) =>
          ContentLibraryModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<ContentDetailsModel>> getLibraryDetails(
    int libraryId,
  ) async {
    return _client.get(
      "${ApiEndpoints.library}/$libraryId",
      fromJson: (json) =>
          ContentDetailsModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> increaseCount(int libraryId) async {
    return _client.post(
      "${ApiEndpoints.library}/$libraryId/view_count",
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> likeContent(int libraryId) async {
    return _client.post(
      "${ApiEndpoints.library}/$libraryId/like",
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> unLikeContent(int libraryId) async {
    return _client.delete(
      "${ApiEndpoints.library}/$libraryId/like",
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> bookmark(int libraryId) async {
    return _client.post(
      "${ApiEndpoints.library}/$libraryId/save",
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> removeBookmark(int libraryId) async {
    return _client.delete(
      "${ApiEndpoints.library}/$libraryId/unsave",
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }

  @override
  Future<ApiResponse<void>> increaseDownloadCount(int libraryId) async {
    return _client.post(
      "${ApiEndpoints.library}/$libraryId/download",
      fromJson: (json) => ApiResponse.fromJson(json, (val) {}),
    );
  }
}
