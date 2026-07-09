import 'package:respilink_mobile/features/dashboard/domain/models/specialized_topic_model.dart';

import '../../../../exports.dart';

class SpecializedTopicCard extends StatelessWidget {
  final SpecializedTopicModel topic;
  final VoidCallback? onTap;

  const SpecializedTopicCard({super.key, required this.topic, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: topic.accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(topic.icon, color: topic.accentColor, size: 18.r),
            ),
            SizedBox(height: 10.h),
            AppText.medium(
              label: topic.title,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            SizedBox(height: 2.h),
            AppText.small(
              label: topic.subtitle,
              color: AppColors.grey,
              fontSize: 11.sp,
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: topic.progress,
                minHeight: 4.h,
                backgroundColor: AppColors.fieldColor,
                valueColor: AlwaysStoppedAnimation(topic.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
