import 'package:respilink_mobile/features/dashboard/domain/models/daily_challenge_summary_model.dart';

import '../../../../exports.dart';

class DailyChallengeBanner extends StatelessWidget {
  final DailyChallengeSummaryModel summary;
  final VoidCallback onStart;
  final VoidCallback? onLeaderboardTap;

  const DailyChallengeBanner({
    super.key,
    required this.summary,
    required this.onStart,
    this.onLeaderboardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: AppColors.yellow, size: 14.sp),
                    SizedBox(width: 6.w),
                    AppText.small(
                      label: 'DAILY CHALLENGE',
                      color: AppColors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                AppText.medium(
                  label: summary.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
                SizedBox(height: 4.h),
                AppText.small(
                  label: summary.subtitle,
                  color: AppColors.grey,
                  fontSize: 12.sp,
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: onLeaderboardTap,
                  child: RichText(
                    text: TextSpan(
                      text: 'Your Rank: #${summary.globalRank}  ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstants.fontFamily,
                        color: AppColors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Global Leaderboard',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: AppConstants.fontFamily,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: onStart,
            child: Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: AppColors.purpleAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.white,
                size: 26.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
