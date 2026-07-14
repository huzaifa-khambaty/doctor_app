abstract class EventDetailEvent {}

class WebinarDetailRequested extends EventDetailEvent {
  final int eventId;

  WebinarDetailRequested({required this.eventId});
}

class WorkshopDetailRequested extends EventDetailEvent {
  final int eventId;

  WorkshopDetailRequested({required this.eventId});
}

class ConferenceDetailRequested extends EventDetailEvent {
  final int eventId;

  ConferenceDetailRequested({required this.eventId});
}
