import '../../../../exports.dart';

class MonthlyEliteHeader extends StatelessWidget {
  final String timeRemainingLabel;

  const MonthlyEliteHeader({super.key, required this.timeRemainingLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.large(
          label: 'Monthly Elite',
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 19.sp,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.fieldColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, color: AppColors.grey, size: 13.sp),
              SizedBox(width: 4.w),
              AppText.small(
                label: timeRemainingLabel,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
