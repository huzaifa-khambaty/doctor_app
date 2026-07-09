import 'package:respilink_mobile/features/dashboard/domain/models/doctor_status_model.dart';

import '../../../../exports.dart';

class CurrentStatusCard extends StatelessWidget {
  final DoctorStatusModel status;

  const CurrentStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.indigoAccent, AppColors.purpleAccent],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.small(
                  label: 'CURRENT STATUS',
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
                SizedBox(height: 6.h),
                AppText.large(
                  label: 'Test your knowledge',
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _StatBadge(icon: Icons.emoji_events, label: '${status.rank} RANK'),
          SizedBox(width: 8.w),
          _StatBadge(
            icon: Icons.local_fire_department,
            label: '${status.streak} STREAK',
            iconColor: AppColors.redBA1A1A,
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _StatBadge({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor ?? AppColors.yellow, size: 18.sp),
          SizedBox(height: 2.h),
          AppText.small(
            label: label,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10.sp,
          ),
        ],
      ),
    );
  }
}
