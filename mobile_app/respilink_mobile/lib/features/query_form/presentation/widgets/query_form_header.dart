import '../../../../exports.dart';

class QueryFormHeader extends StatelessWidget {
  const QueryFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.large(
          label: 'Submit a Query',
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
        ),
        SizedBox(height: 8.h),
        AppText.small(
          label:
              'Need clinical clarification or technical support? Our medical liaison team typically responds within 4 hours.',
          color: AppColors.grey,
          fontSize: 13.sp,
          height: 1.4,
        ),
      ],
    );
  }
}
