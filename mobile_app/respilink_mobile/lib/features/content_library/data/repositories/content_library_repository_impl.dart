import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_details_model.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_library_model.dart';
import 'package:respilink_mobile/features/content_library/data/sources/content_library_remote_data_source.dart';
import 'package:respilink_mobile/features/content_library/domain/repositories/content_library_repository.dart';

class ContentLibraryRepositoryImpl implements ContentLibraryRepository {
  final ContentLibraryRemoteDataSource _remoteDataSource;

  ContentLibraryRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<ContentLibraryModel>> getLibrary({
    required int page,
    String? tab,
    String? search,
  }) {
    return _remoteDataSource.getLibrary(page: page, tab: tab, search: search);
  }

  @override
  Future<ApiResponse<ContentDetailsModel>> getLibraryDetails(int libraryId) {
    return _remoteDataSource.getLibraryDetails(libraryId);
  }

  @override
  Future<ApiResponse<void>> increaseCount(int libraryId) {
    return _remoteDataSource.increaseCount(libraryId);
  }

  @override
  Future<ApiResponse<void>> increaseDownloadCount(int libraryId) {
    return _remoteDataSource.increaseDownloadCount(libraryId);
  }

  @override
  Future<ApiResponse<void>> likeContent(int libraryId) {
    return _remoteDataSource.likeContent(libraryId);
  }

  @override
  Future<ApiResponse<void>> unLikeContent(int libraryId) {
    return _remoteDataSource.unLikeContent(libraryId);
  }

  @override
  Future<ApiResponse<void>> bookmark(int libraryId) {
    return _remoteDataSource.bookmark(libraryId);
  }

  @override
  Future<ApiResponse<void>> removeBookmark(int libraryId) {
    return _remoteDataSource.removeBookmark(libraryId);
  }
}
