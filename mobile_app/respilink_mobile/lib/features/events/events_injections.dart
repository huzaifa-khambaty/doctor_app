import 'package:respilink_mobile/features/events/data/repositories/events_repository_impl.dart';
import 'package:respilink_mobile/features/events/data/sources/events_remote_data_source.dart';
import 'package:respilink_mobile/features/events/domain/repositories/events_repository.dart';

import '../../exports.dart';

class EventsInjections {
  EventsInjections._();

  static void setupEventsInjections() {
    locator.registerLazySingleton<EventsRemoteDataSource>(
      () => EventsRemoteDataSourceImpl(),
    );
    locator.registerLazySingleton<EventsRepository>(
      () => EventsRepositoryImpl(locator()),
    );
  }
}
