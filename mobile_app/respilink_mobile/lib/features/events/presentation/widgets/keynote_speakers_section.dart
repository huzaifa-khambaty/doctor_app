import 'package:respilink_mobile/features/events/domain/models/conference_detail_model.dart';

import '../../../../exports.dart';

class KeynoteSpeakersSection extends StatelessWidget {
  final List<SpeakerModel> speakers;
  final VoidCallback? onViewAll;

  const KeynoteSpeakersSection({
    super.key,
    required this.speakers,
    this.onViewAll,
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
              label: 'Keynote Speakers',
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
        SizedBox(height: 14.h),
        Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: speakers
      .map(
        (speaker) => Expanded(
          child: _SpeakerAvatar(speaker: speaker),
        ),
      )
      .toList(),
)
      ],
    );
  }
}

class _SpeakerAvatar extends StatelessWidget {
  final SpeakerModel speaker;

  const _SpeakerAvatar({required this.speaker});

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     speaker.avatarUrl != null
    //         ? AppNetworkImage(
    //             imageUrl: speaker.avatarUrl!,
    //             width: 48.r,
    //             height: 48.r,
    //             isCircle: true,
    //           )
    //         : CircleAvatar(
    //             radius: 24.r,
    //             backgroundColor: AppColors.fieldColor,
    //             child: Icon(Icons.person, color: AppColors.grey, size: 24.sp),
    //           ),
    //     SizedBox(height: 6.h),
    //     AppText.small(
    //       label: speaker.name,
    //       fontWeight: FontWeight.w600,
    //       fontSize: 11.sp,
    //       textAlign: TextAlign.start,
    //       maxLines: 2,
    //       overflow: TextOverflow.ellipsis,
    //     ),
    //   ],
    // );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        speaker.avatarUrl != null
            ? AppNetworkImage(
                imageUrl: speaker.avatarUrl!,
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
                label: speaker.name,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
             
              if (speaker.specialties?.isNotEmpty ?? false) ...[
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: speaker.specialties?.map(
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
                            label: specialty.name ?? "",
                            color: AppColors.primary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList() ?? [],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
