import '../../../../exports.dart';

class QueryFieldLabel extends StatelessWidget {
  final String label;

  const QueryFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText.small(
      label: label.toUpperCase(),
      color: AppColors.secondary,
      fontWeight: FontWeight.w600,
      fontSize: 10.sp,
    );
  }
}
