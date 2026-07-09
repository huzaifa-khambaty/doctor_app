import 'package:respilink_mobile/features/dashboard/domain/models/leaderboard_entry_model.dart';

import '../../../../exports.dart';

class LeaderboardRow extends StatelessWidget {
  final LeaderboardEntryModel entry;

  const LeaderboardRow({super.key, required this.entry});

  Color get _rankColor => switch (entry.rank) {
    1 => AppColors.yellow,
    2 => AppColors.grey,
    _ => AppColors.secondary,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _rankColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: AppText.small(
              label: '${entry.rank}',
              color: _rankColor,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(width: 10.w),
          entry.avatarUrl != null
              ? AppNetworkImage(
                  imageUrl: entry.avatarUrl!,
                  width: 32.r,
                  height: 32.r,
                  isCircle: true,
                )
              : CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.fieldColor,
                  child: Icon(
                    Icons.person,
                    color: AppColors.grey,
                    size: 18.sp,
                  ),
                ),
          SizedBox(width: 10.w),
          Expanded(
            child: AppText.medium(
              label: entry.name,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          AppText.medium(
            label: '${entry.points} pts',
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
          ),
        ],
      ),
    );
  }
}
