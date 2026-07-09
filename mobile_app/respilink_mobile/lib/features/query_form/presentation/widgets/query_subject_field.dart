import 'package:respilink_mobile/features/query_form/presentation/widgets/query_field_label.dart';

import '../../../../exports.dart';

class QuerySubjectField extends StatelessWidget {
  final TextEditingController controller;

  const QuerySubjectField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QueryFieldLabel(label: 'Subject'),
        SizedBox(height: 6.h),
        AppFormField.filled(
          controller: controller,
          hint: 'Brief summary of your inquiry...',
        ),
      ],
    );
  }
}
