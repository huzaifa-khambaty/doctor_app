import 'package:respilink_mobile/features/content_library/domain/models/library_content_model.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/bookmark_toggle_button.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/content_type_tag.dart';

import '../../../../exports.dart';

/// Card for image-backed content (video lectures, diagnostic articles).
class MediaLibraryCard extends StatelessWidget {
  final LibraryContentModel content;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final bool isLoading;

  const MediaLibraryCard({
    super.key,
    required this.content,
    this.onTap,
    this.onBookmarkTap,
    this.isLoading = false,
  });

  String get _imageUrl {
    final image = content.image ?? '';
    return image.startsWith('http')
        ? image
        : "${AppConstants.imagePath}$image";
  }

  ({String label, Color color, IconData icon}) get _typeTag => switch (content.type) {
        LibraryContentType.webinar => (
            label: 'WEBINAR',
            color: AppColors.purpleAccent,
            icon: Icons.live_tv_outlined,
          ),
        LibraryContentType.article => (
            label: 'ARTICLE',
            color: AppColors.primary,
            icon: Icons.article_outlined,
          ),
        _ => (
            label: 'CONTENT',
            color: AppColors.primary,
            icon: Icons.image_outlined,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final tag = _typeTag;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  imageUrl: _imageUrl,
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: ContentTypeTag(
                    label: tag.label,
                    color: tag.color,
                    icon: tag.icon,
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: BookmarkToggleButton(
                    isBookmarked: content.isBookmarked,
                    onTap: onBookmarkTap,
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.black.withValues(alpha: 0.35),
                      child: Center(
                        child: SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (content.duration != null)
                  Positioned(
                    bottom: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: AppText.small(
                        label: content.duration!,
                        color: AppColors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    label: content.category,
                    color: content.categoryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                  SizedBox(height: 6.h),
                  AppText.medium(
                    label: content.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (content.metaLeft != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(content.metaLeftIcon, color: AppColors.grey, size: 13.sp),
                            SizedBox(width: 4.w),
                            AppText.small(
                              label: content.metaLeft!,
                              color: AppColors.grey,
                              fontSize: 11.sp,
                            ),
                          ],
                        ),
                      if (content.ctaLabel != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt, color: AppColors.white, size: 12.sp),
                              SizedBox(width: 4.w),
                              AppText.small(
                                label: content.ctaLabel!,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp,
                              ),
                            ],
                          ),
                        )
                      else if (content.metaRight != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(content.metaRightIcon, color: AppColors.grey, size: 13.sp),
                            SizedBox(width: 4.w),
                            AppText.small(
                              label: content.metaRight!,
                              color: AppColors.grey,
                              fontSize: 11.sp,
                            ),
                          ],
                        ),
                    ],
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
