import '../../../../exports.dart';

class EventDetailFooterBar extends StatelessWidget {
  final String note;
  final String ctaLabel;
  final VoidCallback onCtaTap;

  const EventDetailFooterBar({
    super.key,
    required this.note,
    required this.ctaLabel,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppText.small(
                label: note,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: onCtaTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.medium(
                    label: ctaLabel,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: 6.w),
                  Icon(Icons.arrow_forward, color: AppColors.white, size: 16.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
