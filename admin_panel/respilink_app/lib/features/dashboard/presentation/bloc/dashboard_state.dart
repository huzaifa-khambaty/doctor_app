import 'package:respilink_app/features/auth/data/models/dashboard_model.dart';

class DashboardState {
  final bool isLoading;
  final DashboardModel? data;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    DashboardModel? data,
    String? error,
  }) => DashboardState(
    isLoading: isLoading ?? this.isLoading,
    data: data ?? this.data,
    error: error ?? this.error,
  );
}
