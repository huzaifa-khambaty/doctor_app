import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';
import 'package:respilink_mobile/features/events/domain/models/event_filter.dart';
import 'package:respilink_mobile/shared/models/pagination_model.dart';

abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<Events> events;
  final EventFilter filter;
  final Pagination? pagination;
  final bool isLoadingMore;

  EventsLoaded({
    required this.events,
    required this.filter,
    this.pagination,
    this.isLoadingMore = false,
  });

  bool get hasMore => pagination?.hasNext ?? false;

  EventsLoaded copyWith({
    List<Events>? events,
    EventFilter? filter,
    Pagination? pagination,
    bool? isLoadingMore,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      filter: filter ?? this.filter,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class EventsFailed extends EventsState {
  final String message;

  EventsFailed({required this.message});
}
