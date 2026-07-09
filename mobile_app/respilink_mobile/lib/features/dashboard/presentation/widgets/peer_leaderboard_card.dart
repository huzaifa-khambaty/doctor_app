import 'package:respilink_mobile/features/dashboard/domain/models/leaderboard_entry_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/leaderboard_row.dart';

import '../../../../exports.dart';

class PeerLeaderboardCard extends StatelessWidget {
  final List<LeaderboardEntryModel> entries;

  const PeerLeaderboardCard({super.key, required this.entries});

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
          AppText.medium(
            label: 'Peer Leaderboard',
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
          SizedBox(height: 4.h),
          ...entries.map((entry) => LeaderboardRow(entry: entry)),
        ],
      ),
    );
  }
}
