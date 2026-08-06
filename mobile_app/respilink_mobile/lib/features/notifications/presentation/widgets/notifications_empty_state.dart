import '../../../../exports.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 20.w),
      child: Column(
        children: [
          Container(
            width: 72.r,
            height: 72.r,
            decoration: BoxDecoration(
              color: AppColors.fieldColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              color: AppColors.grey,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 16.h),
          AppText.medium(
            label: "You're all caught up",
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
          SizedBox(height: 6.h),
          AppText.small(
            label: 'New updates about your events, quizzes and content will show up here.',
            color: AppColors.grey,
            textAlign: TextAlign.center,
            fontSize: 12.sp,
          ),
        ],
      ),
    );
  }
}
