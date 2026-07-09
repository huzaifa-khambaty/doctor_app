import 'package:respilink_mobile/core/utils/global_notifiers.dart';

import '../../exports.dart';

/// A colorable notification bell with an unread-count badge, reused across
/// feature app bars/headers (Dashboard, Events, ...).
class AppNotificationBell extends StatelessWidget {
  final Color color;

  const AppNotificationBell({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to the notification center once it exists.
      },
      child: ValueListenableBuilder(
        valueListenable: GlobalNotifiers.notificationCountNotifier,
        builder: (context, count, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none_outlined, color: color, size: 24.sp),
              if (count > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.redBA1A1A,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: AppText.small(
                      label: count > 99 ? '99+' : '$count',
                      textAlign: TextAlign.center,
                      color: AppColors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
