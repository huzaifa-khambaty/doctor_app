import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:respilink_mobile/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:respilink_mobile/features/notifications/presentation/bloc/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsBloc(this._repository) : super(NotificationsLoading()) {
    on<NotificationsRequested>(_fetchNotifications);
  }

  Future<void> _fetchNotifications(
    NotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    final res = await _repository.getNotifications();

    if (res.success && res.data != null) {
      emit(NotificationsLoaded(notifications: res.data!));
    } else {
      emit(NotificationsFailed(message: res.fullErrorMessage));
    }
  }
}
