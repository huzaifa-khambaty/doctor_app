import 'package:respilink_mobile/features/query_form/presentation/widgets/query_field_label.dart';

import '../../../../exports.dart';

class QueryMessageField extends StatelessWidget {
  final TextEditingController controller;

  const QueryMessageField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QueryFieldLabel(label: 'Message'),
        SizedBox(height: 6.h),
        AppFormField.filled(
          controller: controller,
          hint: 'Please provide detailed context for our medical team...',
          maxLines: 5,
        ),
      ],
    );
  }
}
