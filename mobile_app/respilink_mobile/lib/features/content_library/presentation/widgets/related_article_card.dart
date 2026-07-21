import 'package:respilink_mobile/features/content_library/domain/models/related_article_model.dart';

import '../../../../exports.dart';

class RelatedArticleCard extends StatelessWidget {
  final RelatedArticleModel article;
  final VoidCallback? onTap;

  const RelatedArticleCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            AppNetworkImage(
              imageUrl: article.image.startsWith('http')
                  ? article.image
                  : "${AppConstants.imagePath}${article.image}",
              width: 90.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.small(
                      label: article.category,
                      color: article.categoryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                    SizedBox(height: 4.h),
                    AppText.medium(
                      label: article.title,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}
