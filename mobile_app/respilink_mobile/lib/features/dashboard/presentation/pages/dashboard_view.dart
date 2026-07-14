import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/profile_view.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:respilink_mobile/features/dashboard/presentation/pages/home_tab_view.dart';
import 'package:respilink_mobile/features/dashboard/presentation/pages/quiz_tab_view.dart';
import 'package:respilink_mobile/features/content_library/presentation/pages/library_view.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/dashboard_bottom_nav_bar.dart';
import 'package:respilink_mobile/features/events/presentation/pages/events_list_view.dart';
import 'package:respilink_mobile/shared/widgets/respilink_app_bar.dart';

import '../../../../exports.dart';

const int _homeTabIndex = 0;
const int _eventsTabIndex = 1;
const int _quizTabIndex = 2;
const int _libraryTabIndex = 3;
const int _profileTabIndex = 4;

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  Widget _tabContent(int index) {
    return switch (index) {
      _homeTabIndex => const HomeTabView(),
      _quizTabIndex => const QuizTabView(),
      _eventsTabIndex => const EventsListView(),
      _libraryTabIndex => const LibraryView(),
      _profileTabIndex => const ProfileView(showBackButton: false),
      _ => const HomeTabView(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: switch (state.currentTabIndex) {
            _quizTabIndex ||
            _eventsTabIndex => const RespiLinkAppBar(showBackButton: false),
            _libraryTabIndex => const RespiLinkAppBar(
              showBackButton: false,
              showSearchAction: true,
            ),
            _ => null,
          },
          body: _tabContent(state.currentTabIndex),
          bottomNavigationBar: DashboardBottomNavBar(
            currentIndex: state.currentTabIndex,
            onTap: (index) =>
                context.read<DashboardBloc>().add(ChangeTabRequested(index)),
          ),
        );
      },
    );
  }
}
