import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/content_library/data/repositories/content_library_repository_impl.dart';
import 'package:respilink_mobile/features/content_library/data/services/content_download_service.dart';
import 'package:respilink_mobile/features/content_library/data/sources/content_library_remote_data_source.dart';
import 'package:respilink_mobile/features/content_library/domain/repositories/content_library_repository.dart';

import '../../exports.dart';

class ContentLibraryInjections {
  ContentLibraryInjections._();

  static void setupContentLibraryInjections() {
    locator.registerLazySingleton<ContentLibraryRemoteDataSource>(
      () => ContentLibraryRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<ContentLibraryRepository>(
      () => ContentLibraryRepositoryImpl(locator()),
    );
    locator.registerLazySingleton<ContentDownloadService>(
      () => ContentDownloadService(DioClient.instance),
    );
  }
}
