import 'package:respilink_mobile/features/content_library/domain/models/library_content_model.dart';
import 'package:respilink_mobile/features/content_library/presentation/widgets/content_type_tag.dart';
import 'package:respilink_mobile/shared/widgets/app_html_text.dart';

import '../../../../exports.dart';

/// Promo card for an interactive quiz/assessment (no thumbnail image).
class AssessmentLibraryCard extends StatelessWidget {
  final LibraryContentModel content;
  final VoidCallback? onStart;
  final bool isLoading;

  const AssessmentLibraryCard({
    super.key,
    required this.content,
    this.onStart,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigoAccent, AppColors.purpleAccent],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTypeTag(
            label: content.category,
            color: AppColors.white.withValues(alpha: 0.2),
            icon: Icons.bolt,
          ),
          SizedBox(height: 12.h),
          AppText.large(
            label: content.title,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
          ),
          if (content.description != null) ...[
            SizedBox(height: 8.h),
            AppHtmlText(
              html: content.description!,
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: 12.sp,
              maxLines: 2,
            ),
          ],
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 18.sp,
                      height: 18.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.purpleAccent,
                      ),
                    )
                  : AppText.medium(
                      label: content.ctaLabel ?? 'Start Quiz Now',
                      color: AppColors.purpleAccent,
                      fontWeight: FontWeight.bold,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
