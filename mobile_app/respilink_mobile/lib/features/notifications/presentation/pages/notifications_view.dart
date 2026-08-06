import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/utils/date_time_utils.dart';
import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/features/notifications/data/models/notification_model.dart';
import 'package:respilink_mobile/features/notifications/domain/models/notification_item_model.dart';
import 'package:respilink_mobile/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:respilink_mobile/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:respilink_mobile/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:respilink_mobile/features/notifications/presentation/widgets/notification_section_header.dart';
import 'package:respilink_mobile/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:respilink_mobile/features/notifications/presentation/widgets/notifications_empty_state.dart';
import 'package:respilink_mobile/features/notifications/presentation/widgets/notifications_list_skeleton.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  /// Local read-state overlay — the API doesn't offer a "mark as read"
  /// endpoint yet, so a tapped notification's read state is tracked here by
  /// id and merged on top of whatever the bloc last loaded.
  final Set<int> _locallyRead = {};

  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(NotificationsRequested());
    // Opening the notification center means the user has seen the badge
    // count — clear it immediately rather than waiting for individual taps.
    GlobalNotifiers.notificationCountNotifier.value = 0;
  }

  NotificationItemModel _mapNotification(NotificationModel model) {
    final id = model.id ?? 0;
    return NotificationItemModel(
      id: id,
      title: model.title ?? '',
      body: model.message ?? '',
      timestamp: DateTimeUtils.parseBackendDate(model.sentAt) ?? DateTime.now(),
      isRead: (model.isOpened ?? false) || _locallyRead.contains(id),
    );
  }

  void _markAsRead(NotificationItemModel notification) {
    if (notification.isRead) return;
    setState(() => _locallyRead.add(notification.id));
  }

  List<(String, List<NotificationItemModel>)> _groupByDay(
    List<NotificationItemModel> notifications,
  ) {
    final today = <NotificationItemModel>[];
    final earlier = <NotificationItemModel>[];

    for (final notification in notifications) {
      (notification.isToday ? today : earlier).add(notification);
    }

    return [
      if (today.isNotEmpty) ('Today', today),
      if (earlier.isNotEmpty) ('Earlier', earlier),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp, color: AppColors.black),
          onPressed: () => locator<NavigationService>().pop(),
        ),
        title: AppText.medium(
          label: 'Notifications',
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsFailed) {
              SnackbarUtil.showSnackbar(message: state.message, isError: true);
            }
          },
          builder: (context, state) {
            return AppRefreshIndicator(
              onRefresh: () async {
                context.read<NotificationsBloc>().add(NotificationsRequested());
              },
              child: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(NotificationsState state) {
    if (state is NotificationsFailed) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 80.h),
          RequestFailed(message: state.message),
        ],
      );
    }

    if (state is! NotificationsLoaded) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: const [NotificationsListSkeleton()],
      );
    }

    final notifications = [
      for (final model in state.notifications) _mapNotification(model),
    ];

    if (notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [NotificationsEmptyState()],
      );
    }

    final sections = _groupByDay(notifications);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final (label, items) = sections[index];

        return Padding(
          padding: EdgeInsets.only(bottom: index == sections.length - 1 ? 0 : 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationSectionHeader(label: label),
              for (var i = 0; i < items.length; i++) ...[
                NotificationTile(
                  notification: items[i],
                  onTap: () => _markAsRead(items[i]),
                ),
                if (i != items.length - 1) SizedBox(height: 10.h),
              ],
            ],
          ),
        );
      },
    );
  }
}
