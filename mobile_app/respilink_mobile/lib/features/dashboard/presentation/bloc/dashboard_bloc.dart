import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<ChangeTabRequested>(_changeTab);
  }

  void _changeTab(ChangeTabRequested event, Emitter<DashboardState> emit) {
    emit(state.copyWith(currentTabIndex: event.index));
  }
}
