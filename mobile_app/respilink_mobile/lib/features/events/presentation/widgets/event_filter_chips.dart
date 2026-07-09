import 'package:respilink_mobile/features/events/domain/models/event_filter.dart';

import '../../../../exports.dart';

class EventFilterChips extends StatelessWidget {
  final EventFilter selected;
  final ValueChanged<EventFilter> onSelected;

  const EventFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: EventFilter.values.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = EventFilter.values[index];
          final isActive = filter == selected;

          return GestureDetector(
            onTap: () => onSelected(filter),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.fieldColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AppText.small(
                label: filter.label,
                color: isActive ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}
