import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/events/domain/repositories/events_repository.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_state.dart';

class EventRegisterBloc extends Bloc<EventRegisterEvent, EventRegisterState> {
  final EventsRepository _repository;

  EventRegisterBloc(this._repository) : super(EventRegisterInitial()) {
    on<EventRegisterRequested>(_register);
  }

  Future<void> _register(
    EventRegisterRequested event,
    Emitter<EventRegisterState> emit,
  ) async {
    emit(EventRegisterLoading());

    final res = await _repository.eventRegister(eventId: event.eventId);

    if (res.success) {
      final message = res.message;
      emit(
        EventRegisterSuccess(
          message: (message != null && message.isNotEmpty)
              ? message
              : 'You have successfully registered for this event.',
        ),
      );
    } else {
      emit(EventRegisterFailed(message: res.fullErrorMessage));
    }
  }
}
