import 'package:respilink_mobile/features/query_form/data/repositories/query_form_repository_impl.dart';
import 'package:respilink_mobile/features/query_form/data/sources/query_form_remote_data_source.dart';
import 'package:respilink_mobile/features/query_form/domain/repositories/query_form_repository.dart';

import '../../exports.dart';

class QueryFormInjections {
  QueryFormInjections._();

  static void setupQueryFormInjections() {
    locator.registerLazySingleton<QueryFormRemoteDataSource>(
      () => QueryFormRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<QueryFormRepository>(
      () => QueryFormRepositoryImpl(locator()),
    );
  }
}
