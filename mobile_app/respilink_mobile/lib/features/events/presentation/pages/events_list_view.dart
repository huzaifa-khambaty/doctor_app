import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';
import 'package:respilink_mobile/features/events/domain/models/event_filter.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/events_bloc.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/events_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/events_state.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_card.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/event_filter_chips.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class EventsListView extends StatefulWidget {
  const EventsListView({super.key});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(FetchEventsRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels >= maxScroll - 200.h) {
      context.read<EventsBloc>().add(LoadMoreEventsRequested());
    }
  }

  void _openEventDetail(Events event) {
    final eventId = event.id;
    if (eventId == null) return;

    final route = switch (event.type?.toLowerCase()) {
      'conference' => RouterStrings.conferenceDetail,
      'workshop' => RouterStrings.workshopDetail,
      _ => RouterStrings.webinarDetail,
    };

    locator<NavigationService>().navigate(route, arguments: eventId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state is EventsFailed) {
          SnackbarUtil.showSnackbar(message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        final selectedFilter = state is EventsLoaded
            ? state.filter
            : EventFilter.all;

        return SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: EventFilterChips(
                  selected: selectedFilter,
                  onSelected: (filter) => context.read<EventsBloc>().add(
                    EventFilterChanged(filter: filter),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(child: _buildBody(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(EventsState state) {
    if (state is EventsFailed) {
      return RequestFailed(message: state.message);
    }

    if (state is! EventsLoaded) {
      return AppSkeleton.cardList();
    }

    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<EventsBloc>().add(
          FetchEventsRequested(filter: state.filter),
        );
      },
      isEmpty: state.events.isEmpty,
      emptyWidget: const RequestFailed(message: 'No events found.'),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.events.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AppText.medium(
                label: 'Upcoming Events',
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            );
          }

          final eventIndex = index - 1;

          if (eventIndex == state.events.length) {
            return state.isLoadingMore
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : SizedBox(height: 16.h);
          }

          final event = state.events[eventIndex];
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: EventCard(
              event: event,
              onTap: () => _openEventDetail(event),
            ),
          );
        },
      ),
    );
  }
}
