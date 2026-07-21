import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_details_model.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_library_model.dart';

abstract class ContentLibraryRepository {
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
