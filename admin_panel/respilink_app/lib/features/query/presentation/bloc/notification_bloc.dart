import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/practioner/domain/repositories/practioner_repository.dart';
import 'package:respilink_app/features/query/domain/repositories/notification_repository.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_event.dart';
import 'package:respilink_app/features/query/presentation/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  final PractionerRepository _practionerRepository;

  NotificationBloc(this._repository, this._practionerRepository)
      : super(const NotificationState()) {
    on<FetchNotificationsRequested>(_onFetchNotifications);
    on<FetchVerifiedDoctorsCountRequested>(_onFetchCount);
    on<CreateNotificationRequested>(_onCreate);
    on<UpdateNotificationRequested>(_onUpdate);
    on<CancelNotificationRequested>(_onCancel);
    on<DeleteNotificationRequested>(_onDelete);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoadingNotifications: true));
    final res = await _repository.getNotifications(page: event.page);
    if (res.success && res.data != null) {
      emit(state.copyWith(isLoadingNotifications: false, notifications: res.data));
    } else {
      emit(state.copyWith(isLoadingNotifications: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _onFetchCount(
    FetchVerifiedDoctorsCountRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoadingCount: true));
    final res = await _practionerRepository.getPractioners(
      page: 1,
      status: 'verified',
    );
    if (res.success && res.data != null) {
      emit(state.copyWith(
        isLoadingCount: false,
        verifiedDoctorsCount: res.data!.total ?? 0,
      ));
    } else {
      emit(state.copyWith(isLoadingCount: false));
    }
  }

  Future<void> _onCreate(
    CreateNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final res = await _repository.createNotification(event.request);
    if (res.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));
    } else {
      emit(state.copyWith(isSubmitting: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _onUpdate(
    UpdateNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final res = await _repository.updateNotification(event.id, event.request);
    if (res.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));
    } else {
      emit(state.copyWith(isSubmitting: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _onCancel(
    CancelNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    final res = await _repository.cancelNotification(event.id);
    if (res.success) {
      emit(state.copyWith(
        isActionLoading: false,
        actionSuccess: true,
        actionMessage: 'Notification cancelled.',
      ));
    } else {
      emit(state.copyWith(isActionLoading: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _onDelete(
    DeleteNotificationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true));
    final res = await _repository.deleteNotification(event.id);
    if (res.success) {
      emit(state.copyWith(
        isActionLoading: false,
        actionSuccess: true,
        actionMessage: 'Notification deleted.',
      ));
    } else {
      emit(state.copyWith(isActionLoading: false, error: res.fullErrorMessage));
    }
  }
}
