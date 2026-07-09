import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/recent_query_card.dart';

import '../../../../exports.dart';

class RecentQueriesSection extends StatelessWidget {
  final List<QueryItemModel> queries;
  final VoidCallback? onViewAll;
  final ValueChanged<QueryItemModel>? onQueryTap;

  const RecentQueriesSection({
    super.key,
    required this.queries,
    this.onViewAll,
    this.onQueryTap,
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
            GestureDetector(
              onTap: onViewAll,
              child: AppText.small(
                label: 'View All',
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        for (final query in queries) ...[
          RecentQueryCard(
            query: query,
            onTap: () => onQueryTap?.call(query),
          ),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}
