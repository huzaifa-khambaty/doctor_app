import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import '../../exports.dart';

class DashboardInjections {
  DashboardInjections._();

  static void setupDashboardInjections() {
    locator.registerFactory<DashboardBloc>(() => DashboardBloc());
  }
}
