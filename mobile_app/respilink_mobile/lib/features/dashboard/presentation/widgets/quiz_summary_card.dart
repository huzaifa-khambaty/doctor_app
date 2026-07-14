import 'package:respilink_mobile/features/dashboard/data/model/quiz_list_model.dart';

import '../../../../exports.dart';

class QuizSummaryCard extends StatelessWidget {
  final QuizSummary quiz;
  final VoidCallback? onTap;
  final bool isLoading;

  const QuizSummaryCard({
    super.key,
    required this.quiz,
    this.onTap,
    this.isLoading = false,
  });

  bool get _isCompleted => quiz.completed ?? false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: (_isCompleted ? AppColors.success : AppColors.primary)
                    .withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isCompleted ? Icons.check_circle_outline : Icons.quiz_outlined,
                color: _isCompleted ? AppColors.success : AppColors.primary,
                size: 22.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    label: quiz.title ?? '',
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _MetaItem(
                        icon: Icons.help_outline,
                        label: '${quiz.questions ?? 0} Questions',
                      ),
                      if (quiz.duration != null)
                        _MetaItem(
                          icon: Icons.access_time,
                          label: '${quiz.duration} min',
                        ),
                      _MetaItem(
                        icon: Icons.bolt,
                        label: '${quiz.xp ?? 0} XP',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            isLoading
                ? SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.grey, size: 13.sp),
        SizedBox(width: 4.w),
        AppText.small(label: label, color: AppColors.grey, fontSize: 11.sp),
      ],
    );
  }
}
