import 'package:respilink_mobile/features/events/domain/models/event_model.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/up_next_event_card.dart';

import '../../../../exports.dart';

/// Horizontal "Up next" event preview, embedded on the dashboard's Home tab.
class UpNextSection extends StatelessWidget {
  final List<EventModel> events;
  final VoidCallback? onViewAll;
  final ValueChanged<EventModel>? onEventTap;

  const UpNextSection({
    super.key,
    required this.events,
    this.onViewAll,
    this.onEventTap,
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
              label: 'Up next',
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
            GestureDetector(
              onTap: onViewAll,
              child: AppText.small(
                label: 'View all',
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (events.isEmpty)
          AppText.small(
            label: 'No upcoming events.',
            color: AppColors.grey,
            fontSize: 12.sp,
          )
        else
          SizedBox(
            height: 130.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) => UpNextEventCard(
                event: events[index],
                onTap: onEventTap != null ? () => onEventTap!(events[index]) : null,
              ),
            ),
          ),
      ],
    );
  }
}
