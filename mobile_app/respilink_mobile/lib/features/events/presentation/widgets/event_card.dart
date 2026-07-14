import 'package:intl/intl.dart';
import 'package:respilink_mobile/core/utils/date_time_utils.dart';
import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';

import '../../../../exports.dart';

class EventCard extends StatelessWidget {
  final Events event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  String get _type => (event.type ?? '').toLowerCase();

  String get _typeLabel => _type.isEmpty ? '' : _type.toUpperCase();

  Color get _tagColor => switch (_type) {
    'workshop' => AppColors.yellow,
    'conference' => AppColors.purpleAccent,
    _ => AppColors.primary,
  };

  String get _imageUrl {
    final url = event.bannerUrl ?? event.bannerPath ?? '';
    return url.startsWith('http') ? url : "${AppConstants.imagePath}$url";
  }

  String get _dateLabel {
    final startDate = DateTimeUtils.parseBackendDate(event.startsAt)?.toLocal();
    if (startDate == null) return '';

    final endDate = DateTimeUtils.parseBackendDate(event.endsAt)?.toLocal();
    if (endDate != null) {
      if (startDate.year == endDate.year &&
          startDate.month == endDate.month &&
          startDate.day == endDate.day) {
        return DateFormat('MMM d, yyyy').format(startDate);
      }
      return DateTimeUtils.formatToRange(event.startsAt, event.endsAt);
    }
    return DateFormat('MMM d, yyyy').format(startDate);
  }

  String get _timeLabel {
    final start = event.startsAt;
    if (start == null) return '';
    final startTime = DateTimeUtils.formatToTime(start);
    final end = event.endsAt;
    if (end == null) return startTime;
    return '$startTime - ${DateTimeUtils.formatToTime(end)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  imageUrl: _imageUrl,
                  width: double.infinity,
                  height: 130.h,
                  fit: BoxFit.cover,
                ),
                if (event.isLive == true)
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.redBA1A1A,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          AppText.small(
                            label: 'LIVE',
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 9.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    label: _typeLabel,
                    color: _tagColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                  SizedBox(height: 6.h),
                  AppText.medium(
                    label: event.title ?? '',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _MetaItem(icon: Icons.calendar_today_outlined, label: _dateLabel),
                      if (_timeLabel.isNotEmpty)
                        _MetaItem(icon: Icons.access_time, label: _timeLabel),
                      if (event.location != null)
                        _MetaItem(icon: Icons.location_on_outlined, label: event.location!),
                    ],
                  ),
                ],
              ),
            ),
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
