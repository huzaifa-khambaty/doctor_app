import '../../../../exports.dart';

class GlobalRankBadge extends StatelessWidget {
  final int rank;

  const GlobalRankBadge({super.key, required this.rank});

  String get _ordinal {
    if (rank % 100 >= 11 && rank % 100 <= 13) return '${rank}th';
    switch (rank % 10) {
      case 1:
        return '${rank}st';
      case 2:
        return '${rank}nd';
      case 3:
        return '${rank}rd';
      default:
        return '${rank}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, color: AppColors.yellow, size: 16.sp),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.small(
                label: 'Global Rank',
                color: AppColors.grey,
                fontSize: 9.sp,
              ),
              AppText.medium(
                label: _ordinal,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
