import 'package:respilink_mobile/exports.dart';

class AppText extends Text {
  AppText.small({
    super.key,
    required String label,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    Color? color,
    int? maxLines,
    double? fontSize,
    TextAlign? textAlign,
    TextDecoration? decoration,
    double? height,
    FontStyle? fontStyle,
  }) : super(
         label,
         textAlign: textAlign ?? .left,
         maxLines: maxLines,
         overflow: overflow ?? .visible,
         style: TextStyle(
           fontSize: fontSize ?? 12.sp,
           fontWeight: fontWeight ?? .normal,
           color: color ?? AppColors.black,
           fontFamily: AppConstants.fontFamily,
           decoration: decoration,
           height: height,
           fontStyle: fontStyle,
         ),
       );

  AppText.medium({
    super.key,
    required String label,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    Color? color,
    double? fontSize,
    int? maxLines,
    double? letterSpacing,
    TextAlign? textAlign,
    TextDecoration? decoration,
    Color? decorationColor,
  }) : super(
         label,
         overflow: overflow ?? .visible,
         maxLines: maxLines,
         textAlign: textAlign,
         style: TextStyle(
           fontSize: fontSize ?? 15.sp,
           letterSpacing: letterSpacing,
           fontWeight: fontWeight ?? .normal,
           color: color ?? AppColors.black,
           fontFamily: AppConstants.fontFamily,
           decoration: decoration,
           decorationColor: decorationColor,
         ),
       );

  AppText.large({
    super.key,
    required String label,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    Color? color,
    double? fontSize,
    TextAlign? textAlign,
    TextStyle? style,
  }) : super(
         label,
         textAlign: textAlign,
         overflow: overflow ?? .visible,
         style: style ?? TextStyle(
           fontSize: fontSize ?? 23.sp,
           fontWeight: fontWeight ?? .normal,
           color: color ?? AppColors.black,
           fontFamily: AppConstants.fontFamily,
         ),
       );
}
