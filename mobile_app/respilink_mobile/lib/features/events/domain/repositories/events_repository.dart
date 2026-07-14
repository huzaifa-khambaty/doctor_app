import 'package:respilink_mobile/core/network/models/api_response.dart';
import 'package:respilink_mobile/features/events/data/model/event_conference_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_webinar_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_workshop_model.dart';

abstract class EventsRepository {
  Future<ApiResponse<EventListingModel>> getEvents({
    required int page,
    String? type,
  });

  Future<ApiResponse<EventWebinarModel>> getEventWebinar({
    required int eventId,
  });

  Future<ApiResponse<EventConferenceModel>> getEventConference({
    required int eventId,
  });

  Future<ApiResponse<EventWorkshopModel>> getEventWorkshop({
    required int eventId,
  });

  Future<ApiResponse<void>> eventRegister({required int eventId});
}
