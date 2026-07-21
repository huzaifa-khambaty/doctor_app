import 'package:respilink_mobile/features/content_library/domain/models/library_content_model.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/bookmark_toggle_button.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/content_type_tag.dart';

import '../../../../exports.dart';

/// Card for downloadable document content (clinical guidelines / PDFs).
class DocumentLibraryCard extends StatelessWidget {
  final LibraryContentModel content;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final bool isLoading;

  const DocumentLibraryCard({
    super.key,
    required this.content,
    this.onTap,
    this.onBookmarkTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.error),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          color: AppColors.error,
                          size: 22.sp,
                        ),
                        if (content.fileSize != null) ...[
                          SizedBox(height: 4.h),
                          AppText.small(
                            label: content.fileSize!,
                            color: AppColors.error,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ],
                    ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ContentTypeTag(
                        label: 'GUIDELINE',
                        color: AppColors.error,
                        icon: Icons.article_outlined,
                      ),
                      BookmarkToggleButton(
                        isBookmarked: content.isBookmarked,
                        onTap: onBookmarkTap,
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  AppText.small(
                    label: content.category,
                    color: content.categoryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                  SizedBox(height: 4.h),
                  AppText.medium(
                    label: content.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      if (content.metaLeft != null) ...[
                        Icon(content.metaLeftIcon, color: AppColors.grey, size: 13.sp),
                        SizedBox(width: 4.w),
                        AppText.small(
                          label: content.metaLeft!,
                          color: AppColors.grey,
                          fontSize: 11.sp,
                        ),
                        SizedBox(width: 12.w),
                      ],
                      if (content.metaRight != null) ...[
                        Icon(content.metaRightIcon, color: AppColors.grey, size: 13.sp),
                        SizedBox(width: 4.w),
                        AppText.small(
                          label: content.metaRight!,
                          color: AppColors.grey,
                          fontSize: 11.sp,
                        ),
                      ],
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
