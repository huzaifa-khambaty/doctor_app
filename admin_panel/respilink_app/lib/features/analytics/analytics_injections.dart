import 'package:respilink_app/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:respilink_app/features/analytics/data/sources/analytics_remote_data_source.dart';
import 'package:respilink_app/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:respilink_app/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:respilink_app/injections.dart';

class AnalyticsInjections {
  AnalyticsInjections._();

  static void setupAnalyticsInjections() {
    locator.registerLazySingleton<AnalyticsRemoteDataSource>(
      () => AnalyticsRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(locator()),
    );
    locator.registerFactory<AnalyticsBloc>(() => AnalyticsBloc(locator()));
  }
}
