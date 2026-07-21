import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/practioner/domain/repositories/practioner_repository.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_event.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_state.dart';

class PractionerBloc extends Bloc<PractionerEvent, PractionerState> {
  final PractionerRepository _repository;

  PractionerBloc(this._repository) : super(const PractionerState()) {
    on<FetchSpecialtiesRequested>(_fetchSpecialties);
    on<FetchPractitionerStatsRequested>(_fetchPractitionerStats);
    on<FetchPractionersRequested>(_fetchPractioners);
    on<CreatePractionerRequested>(_createPractioner);
    on<VerifyPractionerRequested>(_verifyPractioner);
    on<RejectPractionerRequested>(_rejectPractioner);
    on<SuspendPractionerRequested>(_suspendPractioner);
    on<ReinstatePractionerRequested>(_reinstatePractioner);
  }

  Future<void> _createPractioner(
    CreatePractionerRequested event,
    Emitter<PractionerState> emit,
  ) async {
    emit(state.copyWith(isCreating: true));
    final res = await _repository.createPractioner(event.request, photo: event.photo);
    if (res.success) {
      emit(state.copyWith(isCreating: false, createSuccess: true));
      add(FetchPractionersRequested(
        page: state.practioners?.currentPage ?? 1,
        status: state.activeStatus,
        specialtyId: state.activeSpecialtyId,
      ));
    } else {
      emit(state.copyWith(isCreating: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _fetchPractitionerStats(
    FetchPractitionerStatsRequested event,
    Emitter<PractionerState> emit,
  ) async {
    final results = await Future.wait([
      _repository.getPractioners(status: 'pending', page: 1),
      _repository.getPractioners(status: 'verified', page: 1),
    ]);
    emit(state.copyWith(
      pendingTotal: results[0].data?.total,
      verifiedTotal: results[1].data?.total,
    ));
  }

  Future<void> _fetchSpecialties(
    FetchSpecialtiesRequested event,
    Emitter<PractionerState> emit,
  ) async {
    emit(state.copyWith(isLoadingSpecialties: true));
    final res = await _repository.getSpecialties();
    if (res.success && res.data != null) {
      emit(state.copyWith(specialties: res.data!, isLoadingSpecialties: false));
    } else {
      emit(state.copyWith(isLoadingSpecialties: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _fetchPractioners(
    FetchPractionersRequested event,
    Emitter<PractionerState> emit,
  ) async {
    emit(state.copyWith(isLoadingPractioners: true));
    final res = await _repository.getPractioners(
      page: event.page,
      status: event.status,
      specialtyId: event.specialtyId,
    );
    if (res.success && res.data != null) {
      emit(state.copyWith(
        practioners: res.data!,
        isLoadingPractioners: false,
        activeStatus: event.status,
        activeSpecialtyId: event.specialtyId,
        clearStatus: event.status == null,
        clearSpecialtyId: event.specialtyId == null,
      ));
    } else {
      emit(state.copyWith(isLoadingPractioners: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _verifyPractioner(
    VerifyPractionerRequested event,
    Emitter<PractionerState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true, actioningUserId: event.userId));
    final res = await _repository.verifyPractioner(userId: event.userId);
    if (res.success) {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, actionSuccess: true));
      add(FetchPractionersRequested(
        page: state.practioners?.currentPage ?? 1,
        status: state.activeStatus,
        specialtyId: state.activeSpecialtyId,
      ));
    } else {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, error: res.fullErrorMessage));
    }
  }

  Future<void> _rejectPractioner(
    RejectPractionerRequested event,
    Emitter<PractionerState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true, actioningUserId: event.userId));
    final res = await _repository.rejectPractioner(userId: event.userId, reason: event.reason);
    if (res.success) {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, actionSuccess: true));
      add(FetchPractionersRequested(
        page: state.practioners?.currentPage ?? 1,
        status: state.activeStatus,
        specialtyId: state.activeSpecialtyId,
      ));
    } else {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, error: res.fullErrorMessage));
    }
  }

  Future<void> _suspendPractioner(
    SuspendPractionerRequested event,
    Emitter<PractionerState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true, actioningUserId: event.userId));
    final res = await _repository.suspendPractioner(userId: event.userId, request: event.request);
    if (res.success) {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, actionSuccess: true));
      add(FetchPractionersRequested(
        page: state.practioners?.currentPage ?? 1,
        status: state.activeStatus,
        specialtyId: state.activeSpecialtyId,
      ));
    } else {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, error: res.fullErrorMessage));
    }
  }

  Future<void> _reinstatePractioner(
    ReinstatePractionerRequested event,
    Emitter<PractionerState> emit,
  ) async {
    emit(state.copyWith(isActionLoading: true, actioningUserId: event.userId));
    final res = await _repository.reinstatePractioner(userId: event.userId);
    if (res.success) {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, actionSuccess: true));
      add(FetchPractionersRequested(
        page: state.practioners?.currentPage ?? 1,
        status: state.activeStatus,
        specialtyId: state.activeSpecialtyId,
      ));
    } else {
      emit(state.copyWith(isActionLoading: false, clearActioningUserId: true, error: res.fullErrorMessage));
    }
  }
}
