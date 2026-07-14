import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';

import '../../../../exports.dart';

class QuizAnswerOptionTile extends StatelessWidget {
  final Options option;
  final bool isSelected;
  final bool isMultiSelect;
  final VoidCallback onTap;

  const QuizAnswerOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isMultiSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorIcon = isMultiSelect
        ? (isSelected ? Icons.check_box : Icons.check_box_outline_blank)
        : (isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked);

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
            Icon(
              indicatorIcon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: 22.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText.medium(
                label: option.optionText ?? '',
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
