import '../../../../exports.dart';

class ViewLeaderboardButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ViewLeaderboardButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard, color: AppColors.white, size: 18.sp),
            SizedBox(width: 8.w),
            AppText.medium(
              label: 'View leaderboard',
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
