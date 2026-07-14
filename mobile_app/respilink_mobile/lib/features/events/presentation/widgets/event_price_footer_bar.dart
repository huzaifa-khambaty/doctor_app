import '../../../../exports.dart';

class EventPriceFooterBar extends StatelessWidget {
  final String priceCaption;
  final String priceLabel;
  final String ctaLabel;
  final VoidCallback onCtaTap;
  final bool isLoading;

  const EventPriceFooterBar({
    super.key,
    required this.priceCaption,
    required this.priceLabel,
    required this.ctaLabel,
    required this.onCtaTap,
    this.isLoading = false,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                children: [
                  AppText.small(
                    label: priceCaption,
                    color: AppColors.grey,
                    fontSize: 11.sp,
                  ),
                  AppText.large(
                    label: priceLabel,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.sp,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: isLoading ? null : onCtaTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 16.sp,
                      height: 16.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.medium(
                          label: ctaLabel,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.arrow_forward,
                          color: AppColors.white,
                          size: 16.sp,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
