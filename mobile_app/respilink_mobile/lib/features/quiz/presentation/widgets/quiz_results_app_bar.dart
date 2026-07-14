import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';

import '../../../../exports.dart';

class QuizResultsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuizResultsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 18.sp, color: AppColors.black),
          onPressed: () => locator<NavigationService>().navigateAndRemove(RouterStrings.dashboard),
      ),
      title: AppText.medium(
        label: 'Quiz Results',
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: AppNotificationBell(color: AppColors.black),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
