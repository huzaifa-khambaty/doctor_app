import 'package:respilink_mobile/features/quiz/domain/models/quiz_question_model.dart';

import '../../../../exports.dart';

class QuizAnswerOptionTile extends StatelessWidget {
  final QuizAnswerOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizAnswerOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.fieldColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28.r,
              height: 28.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AppText.small(
                label: option.label,
                color: isSelected ? AppColors.white : AppColors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText.medium(
                label: option.text,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
