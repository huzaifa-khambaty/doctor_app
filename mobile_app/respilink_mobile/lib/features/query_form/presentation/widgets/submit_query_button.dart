import '../../../../exports.dart';

class SubmitQueryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const SubmitQueryButton({super.key, this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
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
