import '../../../../exports.dart';

class StreakBadgeBanner extends StatelessWidget {
  final String streakLabel;
  final String badgeEarned;

  const StreakBadgeBanner({
    super.key,
    required this.streakLabel,
    required this.badgeEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealGradientStart, AppColors.deeperTeal],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: AppColors.yellow, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.small(
                  label: streakLabel,
                  color: AppColors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
                SizedBox(height: 2.h),
                AppText.medium(
                  label: badgeEarned,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
