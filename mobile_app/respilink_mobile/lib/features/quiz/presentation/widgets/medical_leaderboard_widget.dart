import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:respilink_mobile/features/quiz/domain/models/quiz_leaderboard_entry_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/podium_widget.dart';

class MedicalLeaderboardWidget extends StatelessWidget {
  final List<QuizLeaderboardEntryModel> topThree;

  const MedicalLeaderboardWidget({super.key, required this.topThree});

  QuizLeaderboardEntryModel? _byRank(int rank) {
    for (final entry in topThree) {
      if (entry.rank == rank) return entry;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final second = _byRank(2);
    final first = _byRank(1);
    final third = _byRank(3);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (second != null) ...[
            PodiumItemWidget(
              rank: 2,
              name: second.name,
              points: '${second.points}',
              imageUrl: second.avatarUrl ?? "",
              podiumHeight: 100,
              gradientColors: const [Color(0xFFB0BCC6), Color(0xFFE2E8F0)],
            ),
            SizedBox(width: 6.w),
          ],

          if (first != null)
            PodiumItemWidget(
              rank: 1,
              name: first.name,
              points: '${first.points}',
              imageUrl: first.avatarUrl ?? "",
              podiumHeight: 120,
              gradientColors: const [Color(0xFFFFAE34), Color(0xFFFFF4DF)],
              isFirstPlace: true,
            ),

          if (third != null) ...[
            SizedBox(width: 6.w),
            PodiumItemWidget(
              rank: 3,
              name: third.name,
              points: '${third.points}',
              imageUrl: third.avatarUrl ?? "",
              podiumHeight: 80,
              gradientColors: const [Color(0xFFC6926F), Color(0xFFF5EBE6)],
            ),
          ],
        ],
      ),
    );
  }
}
