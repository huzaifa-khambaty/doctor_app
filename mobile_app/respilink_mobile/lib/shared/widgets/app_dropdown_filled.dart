import '../../exports.dart';

class AppDropdownFilled<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T)? itemLabelMapper;
  final bool isExpanded;
  final String? hintText;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;

  const AppDropdownFilled({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.itemLabelMapper,
    this.isExpanded = false,
    this.hintText,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: isExpanded,
      initialValue: value,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: const Color(0xFF888888),
        size: 22.sp,
      ),
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.black,
        fontWeight: .w500,
        fontFamily: AppConstants.fontFamily,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.black,
          fontFamily: AppConstants.fontFamily,
        ),
        filled: true,
        fillColor: AppColors.fieldColor,
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
        contentPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.redBA1A1A, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.redBA1A1A, width: 1),
        ),
        errorStyle: TextStyle(
          color: AppColors.redBA1A1A,
          fontSize: 12.sp,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
      menuMaxHeight: 200,
      borderRadius: BorderRadius.circular(12.r),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: AppText.small(
            label: itemLabelMapper != null
                ? itemLabelMapper!(item)
                : item.toString(),
            fontSize: 14.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
