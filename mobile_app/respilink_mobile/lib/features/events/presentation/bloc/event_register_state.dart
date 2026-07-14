abstract class EventRegisterState {}

class EventRegisterInitial extends EventRegisterState {}

class EventRegisterLoading extends EventRegisterState {}

class EventRegisterSuccess extends EventRegisterState {
  final String message;

  EventRegisterSuccess({required this.message});
}

class EventRegisterFailed extends EventRegisterState {
  final String message;

  EventRegisterFailed({required this.message});
}
