import 'package:respilink_mobile/features/query_form/data/model/query_category_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_field_label.dart';

import '../../../../exports.dart';

class QueryCategoryField extends StatelessWidget {
  final List<QueryCategoryModel> categories;
  final QueryCategoryModel? value;
  final ValueChanged<QueryCategoryModel?> onChanged;
  final bool isLoading;

  const QueryCategoryField({
    super.key,
    required this.categories,
    required this.value,
    required this.onChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QueryFieldLabel(label: 'Category'),
        SizedBox(height: 6.h),
        if (isLoading)
          AppSkeleton(width: double.infinity, height: 48.h, borderRadius: 12.r)
        else if (categories.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.fieldColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: AppText.small(
              label: 'No categories available',
              color: AppColors.grey,
              fontSize: 14.sp,
            ),
          )
        else
          AppDropdownFilled<QueryCategoryModel>(
            items: categories,
            value: categories.contains(value) ? value : null,
            itemLabelMapper: (category) => category.name ?? 'Untitled',
            onChanged: onChanged,
            isExpanded: true,
          ),
      ],
    );
  }
}
