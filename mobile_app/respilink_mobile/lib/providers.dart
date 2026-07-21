import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/exports.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/badges_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_home_bloc.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/library_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_list_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/events_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_leaderboard_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_play_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_results_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_review_bloc.dart';
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
    BlocProvider<EventDetailBloc>(
      create: (context) => EventDetailBloc(locator()),
    ),
    BlocProvider<EventRegisterBloc>(
      create: (context) => EventRegisterBloc(locator()),
    ),
    BlocProvider<QuizHomeBloc>(create: (context) => QuizHomeBloc(locator())),
    BlocProvider<QuizListBloc>(create: (context) => QuizListBloc(locator())),
    BlocProvider<QuizAttemptBloc>(
      create: (context) => QuizAttemptBloc(locator()),
    ),
    BlocProvider<QuizPlayBloc>(create: (context) => QuizPlayBloc(locator())),
    BlocProvider<QuizReviewBloc>(
      create: (context) => QuizReviewBloc(locator()),
    ),
    BlocProvider<QuizResultsBloc>(
      create: (context) => QuizResultsBloc(locator()),
    ),
    BlocProvider<QuizLeaderboardBloc>(
      create: (context) => QuizLeaderboardBloc(locator()),
    ),
    BlocProvider<BadgesBloc>(create: (context) => BadgesBloc(locator())),
    BlocProvider<LibraryBloc>(create: (context) => LibraryBloc(locator())),
  ];
}
