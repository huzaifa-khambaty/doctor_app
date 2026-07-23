import '../../../../exports.dart';

class EngageBanner extends StatelessWidget {
  final VoidCallback onExplore;
  final String title;
  final String subtitle;
  final String buttonText;

  const EngageBanner({
    super.key,
    required this.onExplore,
    this.title = 'Engage. Learn. Collaborate.',
    this.subtitle =
        'Join 5,000+ clinicians in the Respiratory Excellence Forum.',
    this.buttonText = 'Explore Now',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealGradientStart, AppColors.deeperTeal],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.large(
            label: title,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
          SizedBox(height: 8.h),
          AppText.small(
            label: subtitle,
            color: AppColors.white.withValues(alpha: 0.9),
            fontSize: 13.sp,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: onExplore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: AppText.medium(
              label: buttonText,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
