import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/data/model/event_participants_model.dart';
import 'package:respilink_app/features/events/data/model/request/create_event_request.dart';
import 'package:respilink_app/features/events/data/sources/events_remote_data_source.dart';
import 'package:respilink_app/features/events/domain/repositories/events_repository.dart';
import 'package:respilink_app/service/image_picker_service.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource _remoteDataSource;

  EventsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<EventListingModel>> getEvents({int page = 1, String? status, String? type}) =>
      _remoteDataSource.getEvents(page: page, status: status, type: type);

  @override
  Future<ApiResponse<dynamic>> createEvent(CreateEventRequest request, {PickedImage? banner}) =>
      _remoteDataSource.createEvent(request, banner: banner);

  @override
  Future<ApiResponse<dynamic>> updateEvent(int id, CreateEventRequest request, {PickedImage? banner}) =>
      _remoteDataSource.updateEvent(id, request, banner: banner);

  @override
  Future<ApiResponse<dynamic>> toggleEventStatus(int id, String status) =>
      _remoteDataSource.toggleEventStatus(id, status);

  @override
  Future<ApiResponse<dynamic>> deleteEvent(int id) =>
      _remoteDataSource.deleteEvent(id);

  @override
  Future<ApiResponse<EventParticipantsModel>> eventParticipants(int eventId) =>
      _remoteDataSource.eventParticipants(eventId);
}
