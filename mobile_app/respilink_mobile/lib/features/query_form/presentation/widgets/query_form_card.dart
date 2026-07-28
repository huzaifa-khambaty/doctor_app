import 'package:respilink_mobile/features/query_form/data/model/query_category_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_category_field.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_message_field.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_subject_field.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/submit_query_button.dart';

import '../../../../exports.dart';

class QueryFormCard extends StatelessWidget {
  final List<QueryCategoryModel> categories;
  final QueryCategoryModel? category;
  final bool categoriesLoading;
  final ValueChanged<QueryCategoryModel?> onCategoryChanged;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final VoidCallback? onSubmit;
  final bool isSubmitting;

  const QueryFormCard({
    super.key,
    required this.categories,
    required this.category,
    required this.onCategoryChanged,
    required this.subjectController,
    required this.messageController,
    this.categoriesLoading = false,
    this.onSubmit,
    this.isSubmitting = false,
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
          QueryCategoryField(
            categories: categories,
            value: category,
            isLoading: categoriesLoading,
            onChanged: onCategoryChanged,
          ),
          SizedBox(height: 16.h),
          QuerySubjectField(controller: subjectController),
          SizedBox(height: 16.h),
          QueryMessageField(controller: messageController),
          SizedBox(height: 18.h),
          SubmitQueryButton(onTap: onSubmit, isLoading: isSubmitting),
        ],
      ),
    );
  }
}
