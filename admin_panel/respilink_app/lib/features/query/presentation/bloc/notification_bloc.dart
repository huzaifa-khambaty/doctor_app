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
    on<FetchVerifiedDoctorsCountRequested>(_onFetchCount);
    on<CreateNotificationRequested>(_onCreate);
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
}
