import 'package:respilink_app/core/network/models/api_response.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/data/model/request/create_event_request.dart';
import 'package:respilink_app/service/image_picker_service.dart';

abstract class EventsRepository {
  Future<ApiResponse<EventListingModel>> getEvents({int page = 1, String? status, String? type});
  Future<ApiResponse<dynamic>> createEvent(CreateEventRequest request, {PickedImage? banner});
  Future<ApiResponse<dynamic>> updateEvent(int id, CreateEventRequest request, {PickedImage? banner});
  Future<ApiResponse<dynamic>> toggleEventStatus(int id, String status);
  Future<ApiResponse<dynamic>> deleteEvent(int id);
}
