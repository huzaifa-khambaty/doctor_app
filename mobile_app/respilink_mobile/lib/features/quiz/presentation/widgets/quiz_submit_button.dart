import '../../../../exports.dart';

class QuizSubmitButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isLastQuestion;

  const QuizSubmitButton({
    super.key,
    this.onTap,
    this.isLoading = false,
    this.isLastQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.3),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 18.sp,
                height: 18.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.medium(
                    label: isLastQuestion ? 'Finish Quiz' : 'Submit Answer',
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.white,
                    size: 16.sp,
                  ),
                ],
              ),
      ),
    );
  }
}
