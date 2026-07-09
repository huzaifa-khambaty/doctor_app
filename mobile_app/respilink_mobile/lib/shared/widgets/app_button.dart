import 'package:respilink_mobile/exports.dart';

class AppButton extends ElevatedButton {
  AppButton.filled({
    super.key,
    VoidCallback? onTap,
    required String label,
    Color? bg,
    Color? fontColor,
  }) : super(
         onPressed: onTap,
         child: AppText.medium(
           label: label,
           color: fontColor ?? AppColors.white,
           textAlign: .center,
         ),
         style: ElevatedButton.styleFrom(
           backgroundColor: bg ?? AppColors.primary,
           fixedSize: Size(1.sw, 40.h),
           side: .none,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(14.r),
           ),
           elevation: 0,
         ),
       );

  AppButton.filledWithThickBorder({
    super.key,
    VoidCallback? onTap,
    required String label,
    Color? bg,
    Color? fontColor,
  }) : super(
    onPressed: onTap,
    child: AppText.medium(
      label: label,
      color: fontColor ?? AppColors.white,
      fontWeight: .w600,
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: bg ?? AppColors.primary,
      fixedSize: Size(1.sw, 42.h),
      side: BorderSide(color: AppColors.primary, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      elevation: 0,
    ),
  );

  AppButton.outline({super.key, VoidCallback? onTap, required String label})
    : super(
        onPressed: onTap,
        child: AppText.medium(label: label, color: AppColors.primary),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          fixedSize: Size(1.sw, 40.h),
          side: BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
      );

  AppButton.withIcon({
    super.key,
    VoidCallback? onTap,
    required String label,
    required String icon,
  }) : super(
         onPressed: onTap,
         child: Row(
           mainAxisAlignment: .center,
           children: [
             AppNetworkImage(
               imageUrl: "${AppConstants.svgPath}/$icon",
               color: AppColors.white,
               width: 25.w,
             ),
             10.w.addWidth,
             AppText.medium(label: label, color: AppColors.white),
           ],
         ),
         style: ElevatedButton.styleFrom(
           backgroundColor: AppColors.primary,
           fixedSize: Size(1.sw, 42.h),
           side: .none,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(14.r),
           ),
           elevation: 0,
         ),
       );

  AppButton.withIconOutline({
    super.key,
    VoidCallback? onTap,
    required String label,
    required String icon,
    Color? color,
  }) : super(
    onPressed: onTap,
    child: Column(
      crossAxisAlignment: .center,
      children: [
        AppNetworkImage(
          imageUrl: "${AppConstants.svgPath}/$icon",
          color: color ?? AppColors.black,
        ),
        5.h.addHeight,
        AppText.medium(label: label, color: color ?? AppColors.black, fontSize: 12.sp, fontWeight: .w600,),
      ],
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: .zero,
      elevation: 0
    ),
  );

    AppButton.withIconOutline1({
    super.key,
    VoidCallback? onTap,
    required String label,
    required IconData icon,
    Color? color,
  }) : super(
    onPressed: onTap,
    child: Column(
      crossAxisAlignment: .center,
      children: [
        Icon(
          icon,
          color: color ?? AppColors.black,
          size: 17.sp,
        ),
        5.h.addHeight,
        AppText.medium(label: label, color: color ?? AppColors.black, fontSize: 12.sp, fontWeight: .w600,),
      ],
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: .zero,
      elevation: 0
    ),
  );
}
