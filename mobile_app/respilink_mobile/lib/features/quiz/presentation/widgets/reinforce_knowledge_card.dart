import 'package:respilink_mobile/features/quiz/domain/models/reinforce_content_model.dart';

import '../../../../exports.dart';

class ReinforceKnowledgeCard extends StatelessWidget {
  final ReinforceContentModel content;
  final VoidCallback? onTap;

  const ReinforceKnowledgeCard({super.key, required this.content, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppNetworkImage(
              imageUrl: "${AppConstants.imagePath}${content.image}",
              width: double.infinity,
              height: 80.h,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    label: content.typeLabel,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                  SizedBox(height: 4.h),
                  AppText.medium(
                    label: content.title,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
