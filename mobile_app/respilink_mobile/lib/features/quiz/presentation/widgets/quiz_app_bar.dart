import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_timer_badge.dart';
import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';

import '../../../../exports.dart';

class QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? timeLimitSeconds;
  final VoidCallback? onTimeExpired;

  const QuizAppBar({super.key, this.timeLimitSeconds, this.onTimeExpired});

  @override
  Widget build(BuildContext context) {
    final timeLimit = timeLimitSeconds;

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
        label: 'Quiz Play',
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      actions: [
        if (timeLimit != null && timeLimit > 0) ...[
          QuizTimerBadge(seconds: timeLimit, onExpire: onTimeExpired),
          SizedBox(width: 12.w),
        ],
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
