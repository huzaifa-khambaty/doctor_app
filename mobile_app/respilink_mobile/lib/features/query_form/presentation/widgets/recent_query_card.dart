import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_status_badge.dart';

import '../../../../exports.dart';

class RecentQueryCard extends StatelessWidget {
  final QueryItemModel query;
  final VoidCallback? onTap;

  const RecentQueryCard({super.key, required this.query, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: query.iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(query.icon, color: query.iconColor, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    label: query.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      AppText.small(
                        label: 'Submitted ${query.submittedLabel}',
                        color: AppColors.grey,
                        fontSize: 10.sp,
                      ),
                      SizedBox(width: 8.w),
                      QueryStatusBadge(status: query.status),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey, size: 18.sp),
          ],
        ),
      ),
    );
  }
}
