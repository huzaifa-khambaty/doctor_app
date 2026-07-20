import 'package:respilink_app/features/content/data/repositories/content_repository_impl.dart';
import 'package:respilink_app/features/content/data/sources/content_remote_data_source.dart';
import 'package:respilink_app/features/content/domain/repositories/content_repository.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_bloc.dart';
import 'package:respilink_app/injections.dart';

class ContentInjections {
  ContentInjections._();

  static void setupContentInjections() {
    locator.registerLazySingleton<ContentRemoteDataSource>(
      () => ContentRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<ContentRepository>(
      () => ContentRepositoryImpl(locator()),
    );
    locator.registerFactory<ContentBloc>(() => ContentBloc(locator()));
  }
}
