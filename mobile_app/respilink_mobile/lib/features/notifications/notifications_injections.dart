import 'package:respilink_mobile/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:respilink_mobile/features/notifications/data/sources/notifications_remote_data_source.dart';
import 'package:respilink_mobile/features/notifications/domain/repositories/notifications_repository.dart';

import '../../exports.dart';

class NotificationsInjections {
  NotificationsInjections._();

  static void setupNotificationsInjections() {
    locator.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(locator()),
    );
  }
}
