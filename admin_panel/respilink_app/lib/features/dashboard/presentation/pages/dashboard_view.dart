import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/features/analytics/presentation/pages/engagement_analytics_view.dart';
import 'package:respilink_app/features/auth/presentation/pages/user_account_content.dart';
import 'package:respilink_app/features/content/presentation/pages/content_repository_view.dart';
import 'package:respilink_app/features/dashboard/presentation/widgets/desktop_dashboard_main_content.dart';
import 'package:respilink_app/features/dashboard/presentation/widgets/mobile_dashboard_view.dart';
import 'package:respilink_app/features/dashboard/presentation/widgets/tablet_dashboard_view.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/presentation/pages/events_listing_view.dart';
import 'package:respilink_app/features/events/presentation/pages/schedule_event.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_bloc.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_event.dart';
import 'package:respilink_app/features/practioner/presentation/pages/manual_enrollment_form.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_bloc.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_event.dart';
import 'package:respilink_app/features/practioner/presentation/pages/practioner_detail_view.dart';
import 'package:respilink_app/features/practioner/presentation/pages/practioner_management_view.dart';
import 'package:respilink_app/injections.dart';
import 'package:respilink_app/features/query/presentation/pages/notification_history_view.dart';
import 'package:respilink_app/features/query/presentation/pages/query_inbox_view.dart';
import 'package:respilink_app/features/quiz/presentation/pages/create_quiz_content.dart';
import 'package:respilink_app/features/quiz/presentation/pages/edit_quiz_content.dart';
import 'package:respilink_app/features/quiz/presentation/pages/quiz_directory_view.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:respilink_app/features/settings/presentation/pages/setttings_view.dart';
import 'package:respilink_app/features/settings/presentation/pages/user_permission_content_view.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';
import 'package:respilink_app/shared/widgets/responsive_layout.dart';
import 'package:respilink_app/shared/widgets/sidebar_content.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _currentNavigationIndex = 0;
  bool _showManualEnrollmentForm = false;
  bool _showCreateEventForm = false;
  Events? _selectedEvent;
  bool _showCreateQuizForm = false;
  int? _editingQuizId;
  bool _showNotificationHistory = false;

  // Practitioner section
  Practioners? _selectedPractioner;
  bool get _showPractionerDetails => _selectedPractioner != null;

  // Single BLoC instance shared across the management list and detail view.
  late final PractionerBloc _practionerBloc = locator<PractionerBloc>()
    ..add(FetchSpecialtiesRequested())
    ..add(FetchPractionersRequested());

  late final EventsBloc _eventsBloc = locator<EventsBloc>()
    ..add(FetchEventsRequested());

  late final SettingsBloc _settingsBloc = locator<SettingsBloc>()
    ..add(FetchRolesRequested())
    ..add(FetchPermissionsRequested());

  late final QuizBloc _quizBloc = locator<QuizBloc>()
    ..add(FetchTopicsRequested())
    ..add(FetchQuizzesRequested());

  @override
  void dispose() {
    _practionerBloc.close();
    _eventsBloc.close();
    _settingsBloc.close();
    _quizBloc.close();
    super.dispose();
  }

  Widget _getContentBody(int index) {
    switch (index) {
      case 0:
        if (_showNotificationHistory) {
          return NotificationHistoryView(
            onBackToUsers: () =>
                setState(() => _showNotificationHistory = false),
          );
        }
        return DesktopDashboardMainContent(
          onNotificationTapped: () =>
              setState(() => _showNotificationHistory = true),
        );
      case 1:
        return BlocProvider<PractionerBloc>.value(
          value: _practionerBloc,
          child: _showManualEnrollmentForm
              ? ManualEnrollmentContent(
                  onBackToUserManagement: () =>
                      setState(() => _showManualEnrollmentForm = false),
                )
              : _showPractionerDetails
                  ? PractionerDetailView(
                      practioner: _selectedPractioner!,
                      onBackToUsers: () =>
                          setState(() => _selectedPractioner = null),
                    )
                  : PractitionerManagementContent(
                      onManualEnrollmentClicked: () =>
                          setState(() => _showManualEnrollmentForm = true),
                      onUserTapped: (p) =>
                          setState(() => _selectedPractioner = p),
                    ),
        );
      case 2:
        return const ContentRepositoryContent();
      case 3:
        return BlocProvider<QuizBloc>.value(
          value: _quizBloc,
          child: _showCreateQuizForm
              ? CreateQuizContent(
                  onBackToQuizDirectory: () =>
                      setState(() => _showCreateQuizForm = false),
                )
              : _editingQuizId != null
                  ? EditQuizContent(
                      quizId: _editingQuizId!,
                      onBackToQuizDirectory: () =>
                          setState(() => _editingQuizId = null),
                    )
                  : QuizDirectoryContent(
                      onCreateQuizClicked: () =>
                          setState(() => _showCreateQuizForm = true),
                      onEditQuizClicked: (id) =>
                          setState(() => _editingQuizId = id),
                    ),
        );
      case 4:
        return BlocProvider<EventsBloc>.value(
          value: _eventsBloc,
          child: _showCreateEventForm
              ? ScheduleEventContent(
                  onBackToEvents: () => setState(() => _showCreateEventForm = false),
                )
              : _selectedEvent != null
                  ? ScheduleEventContent(
                      existingEvent: _selectedEvent,
                      onBackToEvents: () => setState(() => _selectedEvent = null),
                    )
                  : EventManagementContent(
                      onCreateEventClicked: () => setState(() => _showCreateEventForm = true),
                      onEventTapped: (e) => setState(() => _selectedEvent = e),
                    ),
        );
      case 5:
        return QueryInboxContent();
      case 6:
        return EngagementAnalyticsContent();
      case 7:
        return BlocProvider<SettingsBloc>.value(
          value: _settingsBloc,
          child: const UserPermissionsContent(),
        );
      case 8:
        return SettingsContent();
      case 9:
        return UserAccountContent();
      default:
        return DesktopDashboardMainContent(
          onNotificationTapped: () =>
              setState(() => _showNotificationHistory = true),
        );
    }
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _currentNavigationIndex = index;
    });
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget dynamicMainContent = _getContentBody(_currentNavigationIndex);
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textDark),
              centerTitle: false,
              title: const Text(
                'RespiLink Admin',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, size: 22),
                  onPressed: () {},
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16.0, left: 8.0),
                  child: AppNetworkImage(
                    imageUrl:
                        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150',",
                    width: 14,
                    height: 14,
                    isCircle: true,
                  ),
                ),
              ],
            )
          : null,
      drawer: isMobile
          ? Drawer(
              child: MySidebarContent(
                isCollapsed: false,
                selectedIndex: _currentNavigationIndex,
                onDestinationSelected: _onNavigationChanged,
              ),
            )
          : null,
      body: ResponsiveLayout(
        mobileBody: MobileDashboardView(contentBody: dynamicMainContent),
        tabletBody: TabletDashboardView(
          sidebar: MySidebarContent(
            isCollapsed: true,
            selectedIndex: _currentNavigationIndex,
            onDestinationSelected: _onNavigationChanged,
          ),
          contentBody: dynamicMainContent,
        ),
        desktopBody: Row(
          children: [
            SizedBox(
              width: 260,
              child: MySidebarContent(
                isCollapsed: false,
                selectedIndex: _currentNavigationIndex,
                onDestinationSelected: _onNavigationChanged,
              ),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: AppColors.borderLight,
            ),
            Expanded(child: dynamicMainContent),
          ],
        ),
      ),
      floatingActionButton:
          _currentNavigationIndex == 0 &&
              !_showManualEnrollmentForm &&
              !_showPractionerDetails &&
              !_showNotificationHistory &&
              !_showCreateQuizForm &&
              !_showCreateEventForm
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showCreateEventForm = true;
                  _currentNavigationIndex = 4;
                });
              },
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            )
          : SizedBox.shrink(),
    );
  }
}
