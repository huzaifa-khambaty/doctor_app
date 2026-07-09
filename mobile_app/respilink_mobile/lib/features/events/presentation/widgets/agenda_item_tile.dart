import 'package:respilink_mobile/features/events/domain/models/conference_detail_model.dart';

import '../../../../exports.dart';

class AgendaItemTile extends StatelessWidget {
  final AgendaItemModel item;

  const AgendaItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56.w,
          child: AppText.small(
            label: item.time,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium(
                label: item.title,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
              SizedBox(height: 4.h),
              AppText.small(
                label: item.description,
                color: AppColors.grey,
                fontSize: 12.sp,
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.grey, size: 13.sp),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: AppText.small(
                      label: item.location,
                      color: AppColors.grey,
                      fontSize: 11.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
