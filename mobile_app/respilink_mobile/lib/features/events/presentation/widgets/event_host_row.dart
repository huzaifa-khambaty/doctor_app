import 'package:respilink_mobile/features/events/domain/models/event_detail_model.dart';

import '../../../../exports.dart';

class EventHostRow extends StatelessWidget {
  final List<EventHostModel> hosts;

  const EventHostRow({super.key, required this.hosts});

  @override
  Widget build(BuildContext context) {
    if (hosts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < hosts.length; i++) ...[
          if (i > 0) SizedBox(height: 14.h),
          _HostTile(host: hosts[i]),
        ],
      ],
    );
  }
}

class _HostTile extends StatelessWidget {
  final EventHostModel host;

  const _HostTile({required this.host});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        host.avatarUrl != null
            ? AppNetworkImage(
                imageUrl: host.avatarUrl!,
                width: 40.r,
                height: 40.r,
                isCircle: true,
              )
            : CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.fieldColor,
                child: Icon(Icons.person, color: AppColors.grey, size: 22.sp),
              ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium(
                label: host.name,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              if (host.title.isNotEmpty)
                AppText.small(
                  label: host.title,
                  color: AppColors.grey,
                  fontSize: 12.sp,
                ),
              if (host.specialties.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: host.specialties
                      .map(
                        (specialty) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: AppText.small(
                            label: specialty,
                            color: AppColors.primary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
