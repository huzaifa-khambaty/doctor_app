import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:respilink_app/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:respilink_app/features/analytics/presentation/bloc/analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsBloc(this._repository) : super(const AnalyticsState()) {
    on<FetchAnalyticsRequested>(_fetchAnalytics);
  }

  Future<void> _fetchAnalytics(
    FetchAnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedPeriod: event.period));
    final res = await _repository.getAnalytics(period: event.period);
    if (res.success && res.data != null) {
      emit(state.copyWith(data: res.data, isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false, error: res.fullErrorMessage));
    }
  }
}
