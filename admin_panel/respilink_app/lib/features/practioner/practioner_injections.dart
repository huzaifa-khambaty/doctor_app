import 'package:respilink_app/features/practioner/data/repositories/practioner_repository_impl.dart';
import 'package:respilink_app/features/practioner/data/sources/practioner_remote_data_source.dart';
import 'package:respilink_app/features/practioner/domain/repositories/practioner_repository.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_bloc.dart';
import 'package:respilink_app/injections.dart';

class PractionerInjections {
  PractionerInjections._();

  static void setupPractionerInjections() {
    locator.registerLazySingleton<PractionerRemoteDataSource>(
      () => PractionerRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<PractionerRepository>(
      () => PractionerRepositoryImpl(locator()),
    );
    locator.registerFactory<PractionerBloc>(() => PractionerBloc(locator()));
  }
}
