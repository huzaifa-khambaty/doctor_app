import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/features/notifications/domain/models/notification_item_model.dart';
import 'package:respilink_mobile/features/notifications/presentation/widgets/notification_section_header.dart';
import 'package:respilink_mobile/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:respilink_mobile/features/notifications/presentation/widgets/notifications_empty_state.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the notifications API is wired up.
final _mockNotifications = [
  NotificationItemModel(
    id: 1,
    type: NotificationType.event,
    title: 'Workshop starts in 1 hour',
    body: 'Advanced COPD Management & New Therapeutics begins soon.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    isRead: false,
  ),
  NotificationItemModel(
    id: 2,
    type: NotificationType.quiz,
    title: 'New Daily Challenge available',
    body: "Today's quiz on Pulmonology Mastery is ready — test your knowledge.",
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    isRead: false,
  ),
  NotificationItemModel(
    id: 3,
    type: NotificationType.badge,
    title: 'New badge earned',
    body: "You've unlocked the \"Quiz Streak\" badge. Keep it up!",
    timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    isRead: true,
  ),
  NotificationItemModel(
    id: 4,
    type: NotificationType.content,
    title: 'New article published',
    body: 'Spirometry Guidelines — a quick read curated for you.',
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    isRead: true,
  ),
  NotificationItemModel(
    id: 5,
    type: NotificationType.system,
    title: 'Your query was answered',
    body: 'Support replied to "API timeout on patient dashboard".',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),
];

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late final List<NotificationItemModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.of(_mockNotifications);
    // Opening the notification center means the user has seen the badge
    // count — clear it immediately rather than waiting for individual taps.
    GlobalNotifiers.notificationCountNotifier.value = 0;
  }

  void _markAsRead(NotificationItemModel notification) {
    if (notification.isRead) return;

    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index == -1) return;

    setState(() => _notifications[index] = notification.copyWith(isRead: true));
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
    final sections = _groupByDay(_notifications);

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
        child: _notifications.isEmpty
            ? const NotificationsEmptyState()
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final (label, items) = sections[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == sections.length - 1 ? 0 : 20.h,
                    ),
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
              ),
      ),
    );
  }
}
