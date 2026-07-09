import '../../exports.dart';

class AppDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T)? itemLabelMapper;
  final bool isExpanded;
  final String? errorMsg;
  final String? hintText;
  final FormFieldValidator<T>? validator;

  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.itemLabelMapper,
    this.isExpanded = false,
    this.errorMsg,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: isExpanded,
      initialValue: value,
      style: TextStyle(fontSize: 14.sp, color: AppColors.black),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        errorStyle: TextStyle(
          color: AppColors.redBA1A1A,
          fontSize: 12.sp,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
      menuMaxHeight: 200,
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
