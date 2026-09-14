import 'package:respilink_mobile/features/events/data/model/event_listing_model.dart';
import 'package:respilink_mobile/features/events/domain/models/event_filter.dart';
import 'package:respilink_mobile/shared/models/pagination_model.dart';

abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<Events> events;
  final EventFilter filter;
  final String search;
  final Pagination? pagination;
  final bool isLoadingMore;

  EventsLoaded({
    required this.events,
    required this.filter,
    this.search = '',
    this.pagination,
    this.isLoadingMore = false,
  });

  bool get hasMore => pagination?.hasNext ?? false;

  /// Search is applied client-side over whatever pages have already been
  /// fetched — it never triggers a network call. [events]/[hasMore] stay
  /// based on the full unfiltered list so pagination keeps working normally
  /// while a search is active.
  List<Events> get visibleEvents {
    final query = search.trim().toLowerCase();
    if (query.isEmpty) return events;
    return events
        .where((event) => (event.title ?? '').toLowerCase().contains(query))
        .toList();
  }

  EventsLoaded copyWith({
    List<Events>? events,
    EventFilter? filter,
    String? search,
    Pagination? pagination,
    bool? isLoadingMore,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class EventsFailed extends EventsState {
  final String message;

  EventsFailed({required this.message});
}
