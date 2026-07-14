import 'package:respilink_mobile/features/dashboard/domain/models/daily_challenge_model.dart';

import '../../../../exports.dart';

class DailyChallengeCard extends StatelessWidget {
  final DailyChallengeModel challenge;
  final VoidCallback onStart;
  final bool isLoading;

  const DailyChallengeCard({
    super.key,
    required this.challenge,
    required this.onStart,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Stack(
        children: [
          AppNetworkImage(
            imageUrl: (challenge.banner ?? '').startsWith('http')
                ? challenge.banner!
                : "${AppConstants.imagePath}${challenge.banner ?? ''}",
            width: double.infinity,
            height: 170.h,
            fit: BoxFit.cover,
          ),

          Container(
            width: double.infinity,
            height: 170.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AppText.small(
                    label: '+${challenge.xp ?? 0} XP',
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),

                7.h.addHeight,
                AppText.large(
                  label: challenge.title ?? '',
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
                SizedBox(height: 4.h),
                AppText.small(
                  label: challenge.description ?? '',
                  color: AppColors.white.withValues(alpha: 0.85),
                  fontSize: 12.sp,
                ),

                SizedBox(height: 12.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 18.sp,
                            height: 18.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bolt,
                                color: AppColors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              AppText.medium(
                                label: 'START DAILY QUIZ',
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
