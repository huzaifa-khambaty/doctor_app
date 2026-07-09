import '../../../../exports.dart';

/// Placeholder for tabs whose feature hasn't been built yet.
class ComingSoonTab extends StatelessWidget {
  final String label;
  final IconData icon;

  const ComingSoonTab({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.grey, size: 40.r),
          SizedBox(height: 12.h),
          AppText.medium(
            label: '$label coming soon',
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
