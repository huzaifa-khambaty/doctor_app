import 'package:respilink_mobile/features/query_form/domain/models/query_category.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_field_label.dart';

import '../../../../exports.dart';

class QueryCategoryField extends StatelessWidget {
  final QueryCategory value;
  final ValueChanged<QueryCategory?> onChanged;

  const QueryCategoryField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QueryFieldLabel(label: 'Category'),
        SizedBox(height: 6.h),
        AppDropdownFilled<QueryCategory>(
          items: QueryCategory.values,
          value: value,
          itemLabelMapper: (category) => category.label,
          onChanged: onChanged,
          isExpanded: true,
        ),
      ],
    );
  }
}
