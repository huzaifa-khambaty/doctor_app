import 'package:respilink_mobile/exports.dart';

class AppFormField extends TextFormField {
  AppFormField({
    super.key,
    required TextEditingController super.controller,
    String? label,
    String? hint,
    super.validator,
    TextInputType? keyboardType,
    super.obscureText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    int? maxLines,
    super.maxLength,
    super.readOnly,
    super.onTap,
    super.onFieldSubmitted,
  }) : super(
         maxLines: maxLines ?? 1,
         keyboardType: keyboardType ?? TextInputType.text,
         decoration: InputDecoration(
           labelText: label,
           counterText: "",
           hintText: hint,
           contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 0),
           hintStyle: TextStyle(
             fontSize: 14.sp,
             color: AppColors.black.withValues(alpha: 0.4),
             fontFamily: AppConstants.fontFamily,
           ),
           labelStyle: TextStyle(
             fontSize: 14.sp,
             color: AppColors.primary,
             fontFamily: AppConstants.fontFamily,
           ),
           suffixIcon: suffixIcon,
           prefixIcon: prefixIcon,
           prefixIconConstraints: const BoxConstraints(
             minWidth: 30,
             minHeight: 0,
           ),
           border: UnderlineInputBorder(
             borderSide: BorderSide(color: AppColors.primary),
           ),
           focusedBorder: UnderlineInputBorder(
             borderSide: BorderSide(color: AppColors.primary),
           ),
           
         ),
         cursorColor: AppColors.primary,
         style: TextStyle(
           fontSize: 14.sp,
           color: AppColors.black,
           fontFamily: AppConstants.fontFamily,
         ),
       );

  AppFormField.filled({
    super.key,
    required TextEditingController super.controller,
    String? label,
    String? hint,
    super.validator,
    TextInputType? keyboardType,
    super.obscureText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    int? maxLines,
    super.maxLength,
    super.readOnly,
    super.onTap,
    super.onFieldSubmitted,
    Color? backgroundColor,
    ValueChanged<String?>? super.onChanged,
    bool? enabled,
    TextInputAction? inputAction,
    super.focusNode,
    super.contextMenuBuilder = null,
  }) : super(
         textInputAction: inputAction,
         maxLines: maxLines ?? 1,
         keyboardType: keyboardType ?? TextInputType.text,
         enabled: enabled ?? true,
         decoration: InputDecoration(
           labelText: label,
           hintText: hint,
           filled: true,
           counterText: "",
           fillColor: backgroundColor ?? AppColors.fieldColor,
           contentPadding: EdgeInsets.only(
             top: 12.h,
             bottom: 12.h,
             right: 2.w,
             left: 2.w,
           ),
           hintStyle: TextStyle(
             fontSize: 14.sp,
             color: AppColors.black.withValues(alpha: 0.4),
             fontFamily: AppConstants.fontFamily,
           ),
           labelStyle: TextStyle(
             fontSize: 14.sp,
             color: AppColors.primary,
             fontFamily: AppConstants.fontFamily,
           ),
           suffixIcon: suffixIcon,
           prefixIcon: prefixIcon,
           prefixIconConstraints: const BoxConstraints(
             minWidth: 40,
             minHeight: 0,
           ),
           border: OutlineInputBorder(
             borderRadius: .circular(14.r),
             borderSide: .none,
           ),
           focusedBorder: OutlineInputBorder(
             borderRadius: .circular(14.r),
             borderSide: .none,
           ),
         ),
         cursorColor: AppColors.primary,
         style: TextStyle(
           fontSize: 14.sp,
           color: AppColors.black,
           fontFamily: AppConstants.fontFamily,
         ),
       );
}
