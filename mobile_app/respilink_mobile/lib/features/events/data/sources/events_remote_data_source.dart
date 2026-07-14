import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';
import 'package:respilink_mobile/features/events/data/model/event_conference_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_webinar_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_workshop_model.dart';

import '../../../../core/network/models/api_response.dart';

abstract class EventsRemoteDataSource {
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

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<EventListingModel>> getEvents({
    required int page,
    String? type,
  }) async {
    return _client.get(
      ApiEndpoints.events,
      queryParameters: {
        'page': page,
        if (type != null && type.isNotEmpty) 'type': type,
      },
      fromJson: (json) =>
          EventListingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<EventWebinarModel>> getEventWebinar({
    required int eventId,
  }) async {
    return _client.get(
      "${ApiEndpoints.events}/webinars/$eventId",
      fromJson: (json) =>
          EventWebinarModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<EventConferenceModel>> getEventConference({
    required int eventId,
  }) async {
    return _client.get(
      "${ApiEndpoints.events}/conferences/$eventId",
      fromJson: (json) =>
          EventConferenceModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<EventWorkshopModel>> getEventWorkshop({
    required int eventId,
  }) async {
    return _client.get(
      "${ApiEndpoints.events}/workshops/$eventId",
      fromJson: (json) =>
          EventWorkshopModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> eventRegister({required int eventId}) async {
    return _client.post("${ApiEndpoints.events}/$eventId/register");
  }
}
