import '../../../../exports.dart';

class QuizProgressHeader extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final double progress;

  const QuizProgressHeader({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.small(
              label: 'QUESTION $questionNumber OF $totalQuestions',
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
            AppText.small(
              label: '${(progress * 100).round()}%',
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: AppColors.fieldColor,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
