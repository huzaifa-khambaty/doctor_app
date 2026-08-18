import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/theme/theme_cubit.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:respilink_mobile/features/dashboard/presentation/pages/home_tab_view.dart';
import 'package:respilink_mobile/features/dashboard/presentation/pages/quiz_tab_view.dart';
import 'package:respilink_mobile/features/content_library/presentation/pages/library_view.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/dashboard_bottom_nav_bar.dart';
import 'package:respilink_mobile/features/events/presentation/pages/events_list_view.dart';
import 'package:respilink_mobile/features/query_form/presentation/pages/query_form_view.dart';
import 'package:respilink_mobile/shared/widgets/respilink_app_bar.dart';

import '../../../../exports.dart';

const int _homeTabIndex = 0;
const int _eventsTabIndex = 1;
const int _quizTabIndex = 2;
const int _libraryTabIndex = 3;
//const int _queryTabIndex = 4;

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  Widget _tabContent(int index) {
    // Deliberately NOT `const` — a `const` widget here would be the exact
    // same canonical instance on every call, and Flutter's element diffing
    // skips rebuilding a child entirely when the new widget is `identical`
    // to the old one. That silently broke dark-mode reactivity for every
    // tab except the one the user was actively interacting with (which
    // rebuilds anyway via its own bloc/setState), since this switch's
    // result is exactly what changes when `DashboardView` rebuilds on a
    // theme change.
    return switch (index) {
      _homeTabIndex => HomeTabView(),
      _quizTabIndex => QuizTabView(),
      _eventsTabIndex => EventsListView(),
      _libraryTabIndex => LibraryView(),
      // _queryTabIndex => QueryFormView(showBackButton: false),
      _ => HomeTabView(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: switch (state.currentTabIndex) {
                _quizTabIndex ||
                _eventsTabIndex => RespiLinkAppBar(showBackButton: false),
                _libraryTabIndex => RespiLinkAppBar(
                  showBackButton: false,
                  showSearchAction: false,
                ),
                _ => null,
              },
              body: _tabContent(state.currentTabIndex),
              bottomNavigationBar: DashboardBottomNavBar(
                currentIndex: state.currentTabIndex,
                onTap: (index) => context.read<DashboardBloc>().add(
                  ChangeTabRequested(index),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
