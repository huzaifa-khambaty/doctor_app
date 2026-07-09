import '../../../../exports.dart';

class ArticleInsightCallout extends StatelessWidget {
  final String title;
  final String quote;

  const ArticleInsightCallout({
    super.key,
    required this.title,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border(
          left: BorderSide(color: AppColors.primary, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.small(
            label: title,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          SizedBox(height: 6.h),
          AppText.small(
            label: quote,
            color: AppColors.black,
            fontStyle: FontStyle.italic,
            fontSize: 12.sp,
            height: 1.5,
          ),
        ],
      ),
    );
  }
}
