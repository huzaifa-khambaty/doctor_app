import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_state.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_state.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_app_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_banner.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_checklist.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_footer_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_info_grid.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_section.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_host_row.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class WebinarDetailView extends StatefulWidget {
  final int eventId;

  const WebinarDetailView({super.key, required this.eventId});

  @override
  State<WebinarDetailView> createState() => _WebinarDetailViewState();
}

class _WebinarDetailViewState extends State<WebinarDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<EventDetailBloc>().add(
      WebinarDetailRequested(eventId: widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const EventDetailAppBar(),
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

            if (state is! WebinarDetailLoaded) {
              return AppSkeleton.cardList();
            }

            final detail = state.detail;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventDetailBanner(image: detail.event.image),
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
                        if (detail.listItems.isNotEmpty) ...[
                          SizedBox(height: 22.h),
                          EventDetailChecklist(
                            title: detail.listTitle,
                            items: detail.listItems,
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
              if (state is! WebinarDetailLoaded) return const SizedBox.shrink();

              return EventDetailFooterBar(
                note: state.detail.registrationNote,
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
