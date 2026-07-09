import 'package:respilink_mobile/features/events/domain/models/event_model.dart';

import '../../../../exports.dart';

class FeaturedEventBanner extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const FeaturedEventBanner({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AppText.small(
                label: 'FEATURED',
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 9.sp,
              ),
            ),
            SizedBox(height: 10.h),
            AppText.large(
              label: event.title,
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19.sp,
            ),
            if (event.featuredSubtitle != null) ...[
              SizedBox(height: 6.h),
              AppText.small(
                label: event.featuredSubtitle!,
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: 12.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
