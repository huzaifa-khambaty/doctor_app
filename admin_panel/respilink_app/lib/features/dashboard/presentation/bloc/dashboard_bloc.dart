import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/auth/domain/repositories/auth_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AuthRepository _repository;

  DashboardBloc(this._repository) : super(const DashboardState()) {
    on<FetchDashboardRequested>(_fetchDashboard);
  }

  Future<void> _fetchDashboard(
    FetchDashboardRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repository.dashboard();
    if (res.success) {
      emit(state.copyWith(isLoading: false, data: res.data));
    } else {
      emit(state.copyWith(isLoading: false, error: res.fullErrorMessage));
    }
  }
}
