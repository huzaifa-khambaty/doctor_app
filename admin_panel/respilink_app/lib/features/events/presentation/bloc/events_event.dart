import 'package:respilink_app/features/events/data/model/request/create_event_request.dart';
import 'package:respilink_app/service/image_picker_service.dart';

abstract class EventsEvent {}

class FetchEventsRequested extends EventsEvent {
  final int page;
  final String? status;
  final String? type;

  FetchEventsRequested({this.page = 1, this.status, this.type});
}

class CreateEventRequested extends EventsEvent {
  final CreateEventRequest request;
  final PickedImage? banner;

  CreateEventRequested(this.request, {this.banner});
}

class UpdateEventRequested extends EventsEvent {
  final int eventId;
  final CreateEventRequest request;
  final PickedImage? banner;

  UpdateEventRequested(this.eventId, this.request, {this.banner});
}

class ToggleEventStatusRequested extends EventsEvent {
  final int eventId;
  final String status;
  ToggleEventStatusRequested(this.eventId, this.status);
}

class DeleteEventRequested extends EventsEvent {
  final int eventId;
  DeleteEventRequested(this.eventId);
}

class FetchSpeakersRequested extends EventsEvent {}

class FetchEventParticipantsRequested extends EventsEvent {
  final int eventId;
  final String? eventTitle;
  FetchEventParticipantsRequested(this.eventId, {this.eventTitle});
}
