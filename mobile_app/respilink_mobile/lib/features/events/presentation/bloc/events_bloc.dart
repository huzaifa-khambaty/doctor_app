import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/events/domain/models/event_filter.dart';
import 'package:respilink_mobile/features/events/domain/repositories/events_repository.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/events_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository _repository;

  EventsBloc(this._repository) : super(EventsInitial()) {
    on<FetchEventsRequested>(_fetchEvents);
    on<LoadMoreEventsRequested>(_loadMoreEvents);
    on<EventFilterChanged>(_changeFilter);
  }

  Future<void> _changeFilter(
    EventFilterChanged event,
    Emitter<EventsState> emit,
  ) {
    return _fetchEvents(FetchEventsRequested(filter: event.filter), emit);
  }

  Future<void> _fetchEvents(
    FetchEventsRequested event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventsLoading());

    final res = await _repository.getEvents(
      page: 1,
      type: _apiType(event.filter),
    );

    if (res.success && res.data != null) {
      final listing = res.data!;
      emit(
        EventsLoaded(
          events: listing.data ?? [],
          filter: event.filter,
          pagination: listing.pagination,
        ),
      );
    } else {
      emit(EventsFailed(message: res.fullErrorMessage));
    }
  }

  Future<void> _loadMoreEvents(
    LoadMoreEventsRequested event,
    Emitter<EventsState> emit,
  ) async {
    final current = state;
    if (current is! EventsLoaded || current.isLoadingMore || !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = (current.pagination?.page ?? 1) + 1;
    final res = await _repository.getEvents(
      page: nextPage,
      type: _apiType(current.filter),
    );

    if (res.success && res.data != null) {
      final listing = res.data!;
      emit(
        current.copyWith(
          events: [...current.events, ...(listing.data ?? [])],
          pagination: listing.pagination,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  String? _apiType(EventFilter filter) => switch (filter) {
    EventFilter.all => null,
    EventFilter.webinars => 'webinar',
    EventFilter.workshops => 'workshop',
    EventFilter.conferences => 'conference',
  };
}
