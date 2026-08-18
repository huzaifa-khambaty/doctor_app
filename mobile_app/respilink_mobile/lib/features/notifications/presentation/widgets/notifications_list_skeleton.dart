import '../../../../exports.dart';

/// Matches [NotificationTile]'s icon-avatar + title/body/time layout so the
/// loading state doesn't jump when the `/notifications` response arrives.
class NotificationsListSkeleton extends StatelessWidget {
  const NotificationsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 5; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == 4 ? 0 : 10.h),
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.fieldColor, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton.circle(size: 40.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSkeleton.textBar(
                          width: double.infinity,
                          height: 13.h,
                        ),
                        SizedBox(height: 8.h),
                        AppSkeleton.textBar(width: 160.w, height: 11.h),
                        SizedBox(height: 10.h),
                        AppSkeleton.textBar(width: 60.w, height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
