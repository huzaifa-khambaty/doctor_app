import '../../../../exports.dart';

class QuizSubmitButton extends StatelessWidget {
  final VoidCallback? onTap;

  const QuizSubmitButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.grey.withValues(alpha: 0.3),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.medium(
              label: 'Submit Answer',
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward, color: AppColors.white, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
