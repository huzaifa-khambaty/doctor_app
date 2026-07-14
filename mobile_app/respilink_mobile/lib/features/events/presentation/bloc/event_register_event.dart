abstract class EventRegisterEvent {}

class EventRegisterRequested extends EventRegisterEvent {
  final int eventId;

  EventRegisterRequested({required this.eventId});
}
