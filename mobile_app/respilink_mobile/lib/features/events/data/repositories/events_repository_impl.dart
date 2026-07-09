import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';
import 'package:respilink_mobile/features/events/data/sources/events_remote_data_source.dart';
import 'package:respilink_mobile/features/events/domain/repositories/events_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource _remoteDataSource;

  EventsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<EventListingModel>> getEvents({
    required int page,
    String? type,
  }) {
    return _remoteDataSource.getEvents(page: page, type: type);
  }
}
