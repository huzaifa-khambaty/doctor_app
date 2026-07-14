import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_state.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_state.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/conference_agenda_section.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_app_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_banner.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_info_grid.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_price_footer_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/keynote_speakers_section.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class ConferenceDetailView extends StatefulWidget {
  final int eventId;

  const ConferenceDetailView({super.key, required this.eventId});

  @override
  State<ConferenceDetailView> createState() => _ConferenceDetailViewState();
}

class _ConferenceDetailViewState extends State<ConferenceDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<EventDetailBloc>().add(
      ConferenceDetailRequested(eventId: widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const EventDetailAppBar(title: 'Conference Detail'),
      body: SafeArea(
        top: false,
        child: BlocConsumer<EventDetailBloc, EventDetailState>(
          listener: (context, state) {
            if (state is EventDetailFailed) {
              SnackbarUtil.showSnackbar(message: state.message, isError: true);
            }
          },
          builder: (context, state) {
            if (state is EventDetailFailed) {
              return RequestFailed(message: state.message);
            }

            if (state is! ConferenceDetailLoaded) {
              return AppSkeleton.cardList();
            }

            final detail = state.detail;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      EventDetailBanner(image: detail.event.image),
                      if (detail.badgeLabel.isNotEmpty)
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
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
                        if (detail.speakers.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          KeynoteSpeakersSection(
                            speakers: detail.speakers,
                            onViewAll: () {
                              // TODO: navigate to the full speaker list once it exists.
                            },
                          ),
                        ],
                        if (detail.agendaByDay.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          ConferenceAgendaSection(
                            agendaByDay: detail.agendaByDay,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BlocConsumer<EventRegisterBloc, EventRegisterState>(
        listener: (context, registerState) {
          if (registerState is EventRegisterSuccess) {
            SnackbarUtil.showSnackbar(message: registerState.message);
          } else if (registerState is EventRegisterFailed) {
            SnackbarUtil.showSnackbar(
              message: registerState.message,
              isError: true,
            );
          }
        },
        builder: (context, registerState) {
          return BlocBuilder<EventDetailBloc, EventDetailState>(
            builder: (context, state) {
              if (state is! ConferenceDetailLoaded) {
                return const SizedBox.shrink();
              }

              return EventPriceFooterBar(
                priceCaption: state.detail.priceCaption,
                priceLabel: state.detail.priceLabel,
                ctaLabel: state.detail.ctaLabel,
                isLoading: registerState is EventRegisterLoading,
                onCtaTap: () => context.read<EventRegisterBloc>().add(
                  EventRegisterRequested(eventId: widget.eventId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
