import '../../../../exports.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String label;

  const NotificationSectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: AppText.small(
        label: label.toUpperCase(),
        color: AppColors.grey,
        fontWeight: FontWeight.w600,
        fontSize: 11.sp,
      ),
    );
  }
}
