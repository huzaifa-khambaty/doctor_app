import '../../../../exports.dart';

class ArticleTagRow extends StatelessWidget {
  final String tag;
  final String readTime;

  const ArticleTagRow({super.key, required this.tag, required this.readTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: AppText.small(
            label: tag,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 9.sp,
          ),
        ),
        SizedBox(width: 8.w),
        AppText.small(
          label: readTime,
          color: AppColors.grey,
          fontSize: 11.sp,
        ),
      ],
    );
  }
}
