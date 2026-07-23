import 'package:respilink_mobile/features/dashboard/domain/models/article_update_model.dart';

import '../../../../exports.dart';

class UpdateArticleCard extends StatelessWidget {
  final ArticleUpdateModel article;
  final VoidCallback? onTap;

  const UpdateArticleCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: article.thumbnailUrl != null && article.thumbnailUrl!.isNotEmpty
                  ? AppNetworkImage(
                      imageUrl: article.thumbnailUrl!,
                      width: 56.r,
                      height: 56.r,
                      fit: BoxFit.cover,
                      errorWidget: _FallbackThumbnail(color: article.typeColor),
                    )
                  : _FallbackThumbnail(color: article.typeColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    label: article.typeLabel.toUpperCase(),
                    color: article.typeColor,
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

class _FallbackThumbnail extends StatelessWidget {
  final Color color;

  const _FallbackThumbnail({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.r,
      height: 56.r,
      color: color.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(Icons.article_outlined, color: color, size: 22.sp),
    );
  }
}
