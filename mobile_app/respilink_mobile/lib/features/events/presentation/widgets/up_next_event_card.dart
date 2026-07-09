import 'package:respilink_mobile/features/events/domain/models/event_model.dart';

import '../../../../exports.dart';

/// Compact horizontal event card used in the dashboard's "Up next" preview.
class UpNextEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const UpNextEventCard({super.key, required this.event, this.onTap});

  Color get _tagColor => switch (event.type) {
    EventType.webinar => AppColors.primary,
    EventType.workshop => AppColors.yellow,
    EventType.conference => AppColors.purpleAccent,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220.w,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _tagColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AppText.small(
                    label: event.typeLabel,
                    color: _tagColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 9.sp,
                  ),
                ),
                Icon(Icons.calendar_today_outlined, color: AppColors.grey, size: 14.sp),
              ],
            ),
            SizedBox(height: 10.h),
            AppText.medium(
              label: event.title,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: AppColors.grey, size: 13.sp),
                    SizedBox(width: 4.w),
                    AppText.small(
                      label: event.timeLabel,
                      color: AppColors.grey,
                      fontSize: 11.sp,
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 12.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
