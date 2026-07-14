import 'package:respilink_mobile/features/quiz/domain/models/quiz_leaderboard_entry_model.dart';

import '../../../../exports.dart';

class RankingRow extends StatelessWidget {
  final QuizLeaderboardEntryModel entry;
  final VoidCallback? onViewBadgeTap;

  const RankingRow({super.key, required this.entry, this.onViewBadgeTap});

  static String _initialsFor(String name) {
    final words = name
        .replaceAll('Dr.', '')
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  Widget _avatar() {
    return entry.avatarUrl != null
        ? AppNetworkImage(
            imageUrl: entry.avatarUrl!,
            width: 40.r,
            height: 40.r,
            isCircle: true,
          )
        : CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: AppText.small(
              label: _initialsFor(entry.name),
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        border: entry.isCurrentUser
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (entry.isCurrentUser)
            Stack(
              clipBehavior: Clip.none,
              children: [
                _avatar(),
                Positioned(
                  top: -6.h,
                  left: -6.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                    child: AppText.small(
                      label: '${entry.rank}',
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ],
            )
          else ...[
            SizedBox(
              width: 20.w,
              child: AppText.medium(
                label: '${entry.rank}',
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: AppColors.grey,
              ),
            ),
            SizedBox(width: 8.w),
            _avatar(),
          ],
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium(
                  label: entry.isCurrentUser
                      ? 'You (${entry.name})'
                      : entry.name,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: entry.isCurrentUser
                      ? AppColors.primary
                      : AppColors.black,
                ),
                if (entry.isCurrentUser) ...[
                  SizedBox(height: 2.h),
                  AppText.small(
                    label: 'Next rank ${entry.pointsToNextRank} pts away',
                    color: AppColors.grey,
                    fontSize: 11.sp,
                  ),
                  GestureDetector(
                    onTap: onViewBadgeTap,
                    child: AppText.small(
                      label: 'View Badge',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ] else ...[
                  SizedBox(height: 2.h),
                  AppText.small(
                    label: '${entry.specialty} • ${entry.location}',
                    color: AppColors.grey,
                    fontSize: 11.sp,
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              entry.isCurrentUser
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: AppColors.yellow, size: 14.sp),
                        SizedBox(width: 4.w),
                        AppText.medium(
                          label: '${entry.points}',
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ],
                    )
                  : AppText.medium(
                      label: '${entry.points}',
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
