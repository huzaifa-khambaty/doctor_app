import 'package:respilink_app/features/analytics/data/model/analytics_model.dart';

class AnalyticsState {
  final AnalyticsModel? data;
  final bool isLoading;
  final String? error;
  final String selectedPeriod;

  const AnalyticsState({
    this.data,
    this.isLoading = false,
    this.error,
    this.selectedPeriod = 'weekly',
  });

  AnalyticsState copyWith({
    AnalyticsModel? data,
    bool? isLoading,
    String? error,
    String? selectedPeriod,
  }) {
    return AnalyticsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }
}
