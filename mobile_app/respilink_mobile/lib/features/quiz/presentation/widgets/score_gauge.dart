import 'package:respilink_mobile/features/quiz/presentation/widgets/global_rank_badge.dart';

import '../../../../exports.dart';

class ScoreGauge extends StatelessWidget {
  final int scorePercent;
  final int globalRank;

  const ScoreGauge({
    super.key,
    required this.scorePercent,
    required this.globalRank,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 26.h),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180.r,
            height: 180.r,
            child: CircularProgressIndicator(
              value: scorePercent / 100,
              strokeWidth: 12.r,
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.fieldColor,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.large(
                label: '$scorePercent%',
                fontWeight: FontWeight.bold,
                fontSize: 36.sp,
              ),
              SizedBox(height: 2.h),
              AppText.small(
                label: 'SCORE',
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ],
          ),
          Positioned(
            bottom: -26.h,
            child: GlobalRankBadge(rank: globalRank),
          ),
        ],
      ),
    );
  }
}
