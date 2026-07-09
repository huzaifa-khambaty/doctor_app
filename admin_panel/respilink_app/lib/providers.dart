import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_app/injections.dart';
import 'package:respilink_app/shared/bloc/connectivity_cubit.dart';

class Providers {
  Providers._();

  static List<BlocProvider> getProviders(BuildContext context) => [
    /// Internet
    BlocProvider<ConnectivityCubit>(
      create: (context) => ConnectivityCubit(locator()),
    ),

    BlocProvider<AuthBloc>(
      create: (context) =>
          AuthBloc(locator())
          ..add(UserAuthenticationRequested()),
    ),
   ];
}
