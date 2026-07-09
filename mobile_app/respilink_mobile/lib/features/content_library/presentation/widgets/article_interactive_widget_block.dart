import '../../../../exports.dart';

class ArticleInteractiveWidgetBlock extends StatelessWidget {
  final String title;
  final String ctaLabel;
  final VoidCallback? onLaunch;

  const ArticleInteractiveWidgetBlock({
    super.key,
    required this.title,
    required this.ctaLabel,
    this.onLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.onSurface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          AppNetworkImage(imageUrl: "${AppConstants.imagePath}lung.png", width: 40.w, height: 40.h),
          SizedBox(height: 12.h),
          AppText.medium(
            label: title,
            color: AppColors.primary,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 14.h),
          ElevatedButton(
            onPressed: onLaunch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            child: AppText.small(
              label: ctaLabel,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
