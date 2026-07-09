import 'package:respilink_app/features/events/data/repositories/events_repository_impl.dart';
import 'package:respilink_app/features/events/data/sources/events_remote_data_source.dart';
import 'package:respilink_app/features/events/domain/repositories/events_repository.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_bloc.dart';
import 'package:respilink_app/features/practioner/domain/repositories/practioner_repository.dart';
import 'package:respilink_app/injections.dart';

class EventsInjections {
  static void setupEventsInjections() {
    locator.registerLazySingleton<EventsRemoteDataSource>(() => EventsRemoteDataSourceImpl());
    locator.registerLazySingleton<EventsRepository>(() => EventsRepositoryImpl(locator()));
    locator.registerFactory<EventsBloc>(() => EventsBloc(locator(), locator<PractionerRepository>()));
  }
}
