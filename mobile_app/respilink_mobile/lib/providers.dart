import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/exports.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/events_bloc.dart';
import 'package:respilink_mobile/shared/bloc/connectivity_cubit.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

class Providers {
  Providers._();

  static List<BlocProvider> getProviders(BuildContext context) => [
    /// Internet
    BlocProvider<ConnectivityCubit>(
      create: (context) => ConnectivityCubit(locator()),
    ),

    BlocProvider<AuthBloc>(
      create: (context) =>
          AuthBloc(locator())..add(UserAuthenticationRequested()),
    ),
    BlocProvider<DashboardBloc>(create: (context) => DashboardBloc()),
    BlocProvider<EventsBloc>(create: (context) => EventsBloc(locator())),
  ];
}
