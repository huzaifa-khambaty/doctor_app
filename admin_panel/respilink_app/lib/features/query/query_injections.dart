import 'package:respilink_app/features/practioner/domain/repositories/practioner_repository.dart';
import 'package:respilink_app/features/query/data/repositories/notification_repository_impl.dart';
import 'package:respilink_app/features/query/data/sources/notification_remote_data_source.dart';
import 'package:respilink_app/features/query/domain/repositories/notification_repository.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_bloc.dart';
import 'package:respilink_app/injections.dart';

class QueryInjections {
  QueryInjections._();

  static void setupQueryInjections() {
    locator.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(locator()),
    );
    locator.registerFactory<NotificationBloc>(
      () => NotificationBloc(locator(), locator<PractionerRepository>()),
    );
  }
}
