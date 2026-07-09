import '../../../../exports.dart';

class SubmitQueryButton extends StatelessWidget {
  final VoidCallback? onTap;

  const SubmitQueryButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
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
              label: 'Submit Query',
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(width: 8.w),
            Icon(Icons.send, color: AppColors.white, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
