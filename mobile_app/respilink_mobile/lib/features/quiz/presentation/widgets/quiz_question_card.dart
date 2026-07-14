import '../../../../exports.dart';

class QuizQuestionCard extends StatelessWidget {
  final String questionText;
  final String? caseContext;

  const QuizQuestionCard({
    super.key,
    required this.questionText,
    this.caseContext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.large(
          label: questionText,
          fontWeight: FontWeight.bold,
          fontSize: 17.sp,
        ),
        if (caseContext != null && caseContext!.isNotEmpty) ...[
          SizedBox(height: 8.h),
          AppText.small(
            label: caseContext!,
            color: AppColors.grey,
            fontSize: 12.sp,
            height: 1.4,
          ),
        ],
      ],
    );
  }
}
