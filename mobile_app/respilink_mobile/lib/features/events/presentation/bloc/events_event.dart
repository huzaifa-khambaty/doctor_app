import 'package:respilink_mobile/features/events/domain/models/event_filter.dart';

abstract class EventsEvent {}

/// Fetches page 1 for the given filter, replacing whatever is currently loaded.
class FetchEventsRequested extends EventsEvent {
  final EventFilter filter;
  final String search;

  FetchEventsRequested({this.filter = EventFilter.all, this.search = ''});
}

/// Fetches the next page and appends it to the currently loaded list.
class LoadMoreEventsRequested extends EventsEvent {
  LoadMoreEventsRequested();
}

class EventFilterChanged extends EventsEvent {
  final EventFilter filter;

  EventFilterChanged({required this.filter});
}

class EventsSearchChanged extends EventsEvent {
  final String query;

  EventsSearchChanged({required this.query});
}
