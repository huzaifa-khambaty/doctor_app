import 'package:respilink_mobile/features/events/domain/models/event_detail_model.dart';

import '../../../../exports.dart';

class EventDetailInfoGrid extends StatelessWidget {
  final List<EventInfoTile> tiles;

  const EventDetailInfoGrid({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        final tile = tiles[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.fieldColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(tile.icon, color: AppColors.primary, size: 14.sp),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: AppText.small(
                      label: tile.label,
                      color: AppColors.grey,
                      fontSize: 9.sp,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              AppText.medium(
                label: tile.value,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                maxLines: 2,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        );
      },
    );
  }
}
