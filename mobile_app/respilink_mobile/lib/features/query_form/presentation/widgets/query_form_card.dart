import 'package:respilink_mobile/features/query_form/domain/models/query_category.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_category_field.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_message_field.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_subject_field.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/submit_query_button.dart';

import '../../../../exports.dart';

class QueryFormCard extends StatelessWidget {
  final QueryCategory category;
  final ValueChanged<QueryCategory?> onCategoryChanged;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final VoidCallback? onSubmit;

  const QueryFormCard({
    super.key,
    required this.category,
    required this.onCategoryChanged,
    required this.subjectController,
    required this.messageController,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QueryCategoryField(value: category, onChanged: onCategoryChanged),
          SizedBox(height: 16.h),
          QuerySubjectField(controller: subjectController),
          SizedBox(height: 16.h),
          QueryMessageField(controller: messageController),
          SizedBox(height: 18.h),
          SubmitQueryButton(onTap: onSubmit),
        ],
      ),
    );
  }
}
