import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/exports.dart';

class NotificationsBellWidget extends StatelessWidget {
  const NotificationsBellWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //locator<NavigationService>().navigate(RouterStrings.notificationsView);
      },
      child: ValueListenableBuilder(
        valueListenable: GlobalNotifiers.notificationCountNotifier,
        builder: (context, value, child) {
          final int count = value;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
                size: 24.sp,
              ),

              if (count > 0)
                Positioned(
                  right: -6,
                  top: -6,
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
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: AppText.small(
                      label: count > 99 ? '99+' : '$count',
                      textAlign: TextAlign.center,
                      color: Colors.white,
                      fontSize: 10.sp,
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
