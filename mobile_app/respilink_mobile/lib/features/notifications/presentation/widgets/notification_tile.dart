import 'package:respilink_mobile/features/notifications/domain/models/notification_item_model.dart';

import '../../../../exports.dart';

/// Single notification row — colored icon avatar + title/body/time, with an
/// unread accent (tinted background + dot) that clears once read.
class NotificationTile extends StatelessWidget {
  final NotificationItemModel notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  Color get _accentColor => switch (notification.type) {
    NotificationType.event => AppColors.primary,
    NotificationType.quiz => AppColors.purpleAccent,
    NotificationType.content => AppColors.tertiary,
    NotificationType.badge => AppColors.yellow,
    NotificationType.system => AppColors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isUnread ? _accentColor.withValues(alpha: 0.06) : AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(notification.type.icon, color: _accentColor, size: 19.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    label: notification.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  AppText.small(
                    label: notification.body,
                    color: AppColors.grey,
                    fontSize: 11.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  AppText.small(
                    label: notification.timeLabel,
                    color: AppColors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              SizedBox(width: 8.w),
              Container(
                width: 8.r,
                height: 8.r,
                margin: EdgeInsets.only(top: 4.h),
                decoration: BoxDecoration(color: _accentColor, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
