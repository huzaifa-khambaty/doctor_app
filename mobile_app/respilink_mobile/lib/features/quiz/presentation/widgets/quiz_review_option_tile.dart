import 'package:respilink_mobile/features/dashboard/data/model/quiz_correct_answers_model.dart';

import '../../../../exports.dart';

class QuizReviewOptionTile extends StatelessWidget {
  final QuizReviewOption option;

  const QuizReviewOptionTile({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    final isCorrect = option.isCorrect ?? false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.fieldColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isCorrect ? AppColors.success : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.circle_outlined,
            color: isCorrect ? AppColors.success : AppColors.grey,
            size: 22.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppText.medium(
              label: option.optionText ?? '',
              fontSize: 13.sp,
              fontWeight: isCorrect ? FontWeight.w600 : FontWeight.w500,
              color: isCorrect ? AppColors.success : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
