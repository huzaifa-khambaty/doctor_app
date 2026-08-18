import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/recent_query_card.dart';

import '../../../../exports.dart';

class RecentQueriesSection extends StatelessWidget {
  final List<QueryItemModel> queries;
  final VoidCallback? onViewAll;
  final ValueChanged<QueryItemModel>? onQueryTap;
  final bool isLoading;
  final bool hasError;

  const RecentQueriesSection({
    super.key,
    required this.queries,
    this.onViewAll,
    this.onQueryTap,
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.medium(
              label: 'Recent Queries',
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
            // GestureDetector(
            //   onTap: onViewAll,
            //   child: AppText.small(
            //     label: 'View All',
            //     color: AppColors.primary,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 12.h),
        if (isLoading) ...[
          for (var i = 0; i < 3; i++) ...[
            _RecentQueryCardSkeleton(),
            SizedBox(height: 12.h),
          ],
        ] else if (hasError)
          AppText.small(label: 'Unable to load queries.', color: AppColors.grey)
        else if (queries.isEmpty)
          AppText.small(label: 'No queries yet.', color: AppColors.grey)
        else
          for (final query in queries) ...[
            RecentQueryCard(query: query, onTap: () => onQueryTap?.call(query)),
            SizedBox(height: 12.h),
          ],
      ],
    );
  }
}

/// Matches [RecentQueryCard]'s icon + two-line layout so the loading state
/// doesn't jump when the query list arrives.
class _RecentQueryCardSkeleton extends StatelessWidget {
  const _RecentQueryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.fieldColor, width: 1),
      ),
      child: Row(
        children: [
          AppSkeleton.circle(size: 38.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: double.infinity, height: 13.h),
                SizedBox(height: 8.h),
                AppSkeleton.textBar(width: 120.w, height: 11.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
