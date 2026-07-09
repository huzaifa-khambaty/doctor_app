import '../../../../exports.dart';

class ContentTypeTag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final Color? textColor;

  const ContentTypeTag({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? AppColors.white, size: 11.sp),
            SizedBox(width: 4.w),
          ],
          AppText.small(
            label: label,
            color: textColor ?? AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 9.sp,
          ),
        ],
      ),
    );
  }
}
