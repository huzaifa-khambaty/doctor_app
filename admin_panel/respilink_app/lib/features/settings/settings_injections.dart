import 'package:respilink_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:respilink_app/features/settings/data/sources/settings_remote_data_source.dart';
import 'package:respilink_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:respilink_app/injections.dart';

class SettingsInjections {
  SettingsInjections._();

  static void setupSettingsInjections() {
    locator.registerLazySingleton<SettingsRemoteDataSource>(
      () => SettingsRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(locator()),
    );
    locator.registerFactory<SettingsBloc>(() => SettingsBloc(locator()));
  }
}
