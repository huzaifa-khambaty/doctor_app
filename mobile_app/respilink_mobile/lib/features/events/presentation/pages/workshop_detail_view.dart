import 'package:respilink_mobile/features/events/domain/models/event_detail_model.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_app_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_banner.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_checklist.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_info_grid.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_section.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_host_row.dart';

import '../../../../exports.dart';

class WorkshopDetailView extends StatelessWidget {
  final EventDetailModel detail;

  const WorkshopDetailView({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const EventDetailAppBar(title: 'Workshop Detail'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventDetailBanner(image: detail.event.image),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.large(
                      label: detail.event.title,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.sp,
                    ),
                    SizedBox(height: 14.h),
                    EventHostRow(
                      name: detail.hostName,
                      title: detail.hostTitle,
                      avatarUrl: detail.hostAvatar,
                    ),
                    SizedBox(height: 18.h),
                    EventDetailInfoGrid(tiles: detail.infoTiles),
                    SizedBox(height: 22.h),
                    EventDetailSection(
                      title: detail.aboutTitle,
                      description: detail.description,
                      expandedContent:
                          'Full syllabus: session recordings, speaker slides, and a CME assessment quiz will be made available to all registered attendees after the live session.',
                    ),
                    SizedBox(height: 22.h),
                    EventDetailChecklist(
                      title: detail.listTitle,
                      items: detail.listItems,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: AppText.medium(
              label: "Register",
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
