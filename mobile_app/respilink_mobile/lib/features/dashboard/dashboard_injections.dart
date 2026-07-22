import 'package:respilink_mobile/features/dashboard/data/repositories/home_repository_impl.dart';
import 'package:respilink_mobile/features/dashboard/data/repositories/quiz_repository_impl.dart';
import 'package:respilink_mobile/features/dashboard/data/sources/home_remote_data_source.dart';
import 'package:respilink_mobile/features/dashboard/data/sources/quiz_remote_data_source.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/home_repository.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import '../../exports.dart';

class DashboardInjections {
  DashboardInjections._();

  static void setupDashboardInjections() {
    locator.registerFactory<DashboardBloc>(() => DashboardBloc());

    locator.registerLazySingleton<QuizRemoteDataSource>(
      () => QuizRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<QuizRepository>(
      () => QuizRepositoryImpl(locator()),
    );

    locator.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(locator()),
    );
  }
}
