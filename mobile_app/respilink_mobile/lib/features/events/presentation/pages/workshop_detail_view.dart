import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_state.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_register_state.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_app_bar.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_banner.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_checklist.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_info_grid.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_detail_section.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_host_row.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_skeletons.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class WorkshopDetailView extends StatefulWidget {
  final int eventId;

  const WorkshopDetailView({super.key, required this.eventId});

  @override
  State<WorkshopDetailView> createState() => _WorkshopDetailViewState();
}

class _WorkshopDetailViewState extends State<WorkshopDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<EventDetailBloc>().add(
      WorkshopDetailRequested(eventId: widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const EventDetailAppBar(title: 'Workshop Detail'),
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

            if (state is! WorkshopDetailLoaded) {
              return const EventDetailSkeleton();
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
                        EventHostRow(hosts: detail.hosts),
                        SizedBox(height: 18.h),
                        EventDetailInfoGrid(tiles: detail.infoTiles),
                        SizedBox(height: 22.h),
                        EventDetailSection(
                          title: detail.aboutTitle,
                          description: detail.description,
                          expandedContent: detail.expandedContent,
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
              if (state is! WorkshopDetailLoaded) return const SizedBox.shrink();

              final isLoading = registerState is EventRegisterLoading;
              final joinLink = state.detail.event.externalJoinLink?.trim();
              final isJoinLive = state.detail.event.isLive &&
                  joinLink != null &&
                  joinLink.isNotEmpty;

              return Container(
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
                    onPressed: isLoading
                        ? null
                        : isJoinLive
                            ? () => _joinLive(context, joinLink)
                            : () => context.read<EventRegisterBloc>().add(
                                EventRegisterRequested(eventId: widget.eventId),
                              ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 16.sp,
                            height: 16.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : AppText.medium(
                            label: isJoinLive ? 'Join Live' : state.detail.ctaLabel,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _joinLive(BuildContext context, String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        SnackbarUtil.showSnackbar(message: 'Invalid live session link.', isError: true);
        return;
      }

      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        SnackbarUtil.showSnackbar(message: 'Unable to open the live session.', isError: true);
      }
    } catch (_) {
      if (context.mounted) {
        SnackbarUtil.showSnackbar(message: 'Unable to open the live session.', isError: true);
      }
    }
  }
}
