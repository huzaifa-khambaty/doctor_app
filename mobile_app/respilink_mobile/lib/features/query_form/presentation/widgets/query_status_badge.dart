import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';

import '../../../../exports.dart';

class QueryStatusBadge extends StatelessWidget {
  final QueryStatus status;

  const QueryStatusBadge({super.key, required this.status});

  bool get _isPending => status == QueryStatus.pending;

  @override
  Widget build(BuildContext context) {
    final color = _isPending ? AppColors.yellow : AppColors.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: AppText.small(
        label: _isPending ? 'PENDING' : 'ANSWERED',
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 9.sp,
      ),
    );
  }
}
