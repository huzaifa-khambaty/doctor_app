import 'package:respilink_mobile/features/dashboard/domain/models/article_update_model.dart';

import '../../../../exports.dart';

class UpdateArticleCard extends StatelessWidget {
  final ArticleUpdateModel article;
  final VoidCallback? onTap;

  const UpdateArticleCard({super.key, required this.article, this.onTap});

  (String, Color) get _categoryStyle => switch (article.category) {
    ArticleCategory.research => ('RESEARCH', AppColors.tertiary),
    ArticleCategory.pharma => ('PHARMA', AppColors.purpleAccent),
    ArticleCategory.tech => ('TECH', AppColors.primary),
  };

  @override
  Widget build(BuildContext context) {
    final (label, color) = _categoryStyle;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AppNetworkImage(
                imageUrl: "${AppConstants.imagePath}${article.image}",
                width: 56.r,
                height: 56.r,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    label: label,
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                  SizedBox(height: 4.h),
                  AppText.medium(
                    label: article.title,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  AppText.small(
                    label: article.meta,
                    color: AppColors.grey,
                    fontSize: 11.sp,
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
