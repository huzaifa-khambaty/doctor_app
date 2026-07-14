import 'package:respilink_mobile/features/dashboard/data/model/quiz_correct_answers_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_question_image.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_review_option_tile.dart';

import '../../../../exports.dart';

class QuizReviewQuestionCard extends StatelessWidget {
  final int questionNumber;
  final QuizReviewQuestion question;

  const QuizReviewQuestionCard({
    super.key,
    required this.questionNumber,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = question.image != null && question.image!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.fieldColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.small(
            label: 'QUESTION $questionNumber',
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
          ),
          SizedBox(height: 8.h),
          AppText.medium(
            label: question.questionText ?? '',
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
          if (hasImage) ...[
            SizedBox(height: 12.h),
            QuizQuestionImage(image: question.image!),
          ],
          SizedBox(height: 14.h),
          for (final option in question.options ?? const [])
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: QuizReviewOptionTile(option: option),
            ),
        ],
      ),
    );
  }
}
