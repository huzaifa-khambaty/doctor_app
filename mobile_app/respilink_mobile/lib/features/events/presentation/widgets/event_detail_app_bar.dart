import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';

import '../../../../exports.dart';

class EventDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onShare;

  const EventDetailAppBar({super.key, this.title = 'Event Details', this.onShare});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        label: title,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.ios_share_outlined, size: 20.sp, color: AppColors.black),
          onPressed: onShare,
        ),
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: AppNotificationBell(color: AppColors.black),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
