import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/network/dio_client.dart';
import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/data/model/event_participants_model.dart';
import 'package:respilink_app/features/events/data/model/request/create_event_request.dart';
import 'package:respilink_app/service/image_picker_service.dart';

abstract class EventsRemoteDataSource {
  Future<ApiResponse<EventListingModel>> getEvents({int page = 1, String? status, String? type});
  Future<ApiResponse<dynamic>> createEvent(CreateEventRequest request, {PickedImage? banner});
  Future<ApiResponse<dynamic>> updateEvent(int id, CreateEventRequest request, {PickedImage? banner});
  Future<ApiResponse<dynamic>> toggleEventStatus(int id, String status);
  Future<ApiResponse<dynamic>> deleteEvent(int id);
  Future<ApiResponse<EventParticipantsModel>> eventParticipants(int eventId);
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final DioClient _client = DioClient.instance;

  @override
  Future<ApiResponse<EventListingModel>> getEvents({int page = 1, String? status, String? type}) {
    return _client.get(
      ApiEndpoints.events,
      queryParameters: {
        'page': page,
        'status': ?status,
        'type': ?type,
      },
      fromJson: (json) => EventListingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<dynamic>> createEvent(CreateEventRequest request, {PickedImage? banner}) {
    if (banner == null) {
      return _client.post(ApiEndpoints.events, data: request.toJson());
    }
    return _client.upload(ApiEndpoints.events, formData: _buildFormData(request, banner));
  }

  @override
  Future<ApiResponse<dynamic>> updateEvent(int id, CreateEventRequest request, {PickedImage? banner}) {
    final url = '${ApiEndpoints.events}/$id';
    if (banner == null) {
      // PATCH with JSON
      return _client.patch(url, data: request.toJson());
    }
    // Laravel doesn't accept multipart PATCH — use method spoofing
    final formData = _buildFormData(request, banner);
    formData.fields.add(const MapEntry('_method', 'PATCH'));
    return _client.upload(url, formData: formData);
  }

  FormData _buildFormData(CreateEventRequest request, PickedImage banner) {
    final formData = FormData();

    formData.fields
      ..add(MapEntry('title', request.title))
      ..add(MapEntry('type', request.type))
      ..add(MapEntry('starts_at', request.startsAt))
      ..add(MapEntry('ends_at', request.endsAt))
      ..add(MapEntry('timezone', request.timezone))
      ..add(MapEntry('location', request.location))
      ..add(MapEntry('description', request.description))
      ..add(MapEntry('enable_qa_session', request.enableQaSession ? '1' : '0'))
      ..add(MapEntry('certificate_of_participation', request.certificateOfParticipation ? '1' : '0'))
      ..add(MapEntry('send_email_reminders', request.sendEmailReminders ? '1' : '0'));

    if (request.externalJoinLink != null) {
      formData.fields.add(MapEntry('external_join_link', request.externalJoinLink!));
    }
    if (request.recordingLink != null) {
      formData.fields.add(MapEntry('recording_link', request.recordingLink!));
    }
    for (final id in request.speakers) {
      formData.fields.add(MapEntry('speakers[]', id.toString()));
    }

    formData.files.add(MapEntry(
      'banner',
      MultipartFile.fromBytes(
        banner.bytes,
        filename: banner.name,
        contentType: MediaType.parse(banner.mimeType),
      ),
    ));

    return formData;
  }

  @override
  Future<ApiResponse<dynamic>> toggleEventStatus(int id, String status) {
    return _client.patch('${ApiEndpoints.events}/$id/status', data: {'status': status});
  }

  @override
  Future<ApiResponse<dynamic>> deleteEvent(int id) {
    return _client.delete('${ApiEndpoints.events}/$id');
  }

  @override
  Future<ApiResponse<EventParticipantsModel>> eventParticipants(int eventId) {
    return _client.get(
      '${ApiEndpoints.events}/$eventId/registrations',
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        if (map.containsKey('current_page')) return EventParticipantsModel.fromJson(map);
        final nested = map['data'];
        if (nested is Map<String, dynamic>) return EventParticipantsModel.fromJson(nested);
        return EventParticipantsModel.fromJson(map);
      },
    );
  }
}
