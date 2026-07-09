import 'package:respilink_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:respilink_app/features/auth/data/sources/auth_local_manager.dart';
import 'package:respilink_app/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:respilink_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_app/injections.dart';

class AuthInjections {
  AuthInjections._();

  static void setupAuthInjections() {
    locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<AuthLocalManager>(
      () => AuthLocalManagerImpl(locator()),
    );
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator(), locator()),
    );

    locator.registerFactory<AuthBloc>(() => AuthBloc(locator()));
  }
}
