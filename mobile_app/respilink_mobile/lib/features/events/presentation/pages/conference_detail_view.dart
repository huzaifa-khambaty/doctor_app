import 'package:respilink_mobile/features/events/domain/models/conference_detail_model.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/conference_agenda_section.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_app_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_banner.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_info_grid.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_price_footer_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/keynote_speakers_section.dart';

import '../../../../exports.dart';

class ConferenceDetailView extends StatelessWidget {
  final ConferenceDetailModel detail;

  const ConferenceDetailView({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const EventDetailAppBar(title: 'Conference Detail'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  EventDetailBanner(image: detail.event.image),
                  Positioned(
                    left: 14.w,
                    bottom: 14.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AppText.small(
                        label: detail.badgeLabel,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
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
                    SizedBox(height: 16.h),
                    EventDetailInfoGrid(tiles: detail.infoTiles),
                    SizedBox(height: 24.h),
                    KeynoteSpeakersSection(
                      speakers: detail.speakers,
                      onViewAll: () {
                        // TODO: navigate to the full speaker list once it exists.
                      },
                    ),
                    SizedBox(height: 24.h),
                    ConferenceAgendaSection(agendaByDay: detail.agendaByDay),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: EventPriceFooterBar(
        priceCaption: detail.priceCaption,
        priceLabel: detail.priceLabel,
        ctaLabel: detail.ctaLabel,
        onCtaTap: () {
          // TODO: wire to the registration/RSVP API once it exists.
        },
      ),
    );
  }
}
