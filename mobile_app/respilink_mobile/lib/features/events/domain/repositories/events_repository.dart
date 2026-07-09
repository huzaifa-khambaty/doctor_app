import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';

abstract class EventsRepository {
  Future<ApiResponse<EventListingModel>> getEvents({
    required int page,
    String? type,
  });
}
