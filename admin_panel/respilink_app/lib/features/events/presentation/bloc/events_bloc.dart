import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/events/domain/repositories/events_repository.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_event.dart';
import 'package:respilink_app/features/events/presentation/bloc/events_state.dart';
import 'package:respilink_app/features/practioner/domain/repositories/practioner_repository.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository _repository;
  final PractionerRepository _practionerRepository;

  EventsBloc(this._repository, this._practionerRepository) : super(const EventsState()) {
    on<FetchEventsRequested>(_fetchEvents);
    on<CreateEventRequested>(_createEvent);
    on<UpdateEventRequested>(_updateEvent);
    on<ToggleEventStatusRequested>(_toggleEventStatus);
    on<DeleteEventRequested>(_deleteEvent);
    on<FetchSpeakersRequested>(_fetchSpeakers);
  }

  Future<void> _fetchEvents(FetchEventsRequested event, Emitter<EventsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final res = await _repository.getEvents(
      page: event.page,
      status: event.status,
      type: event.type,
    );
    if (res.success && res.data != null) {
      emit(state.copyWith(
        events: res.data,
        isLoading: false,
        activeType: event.type,
        clearActiveType: event.type == null,
      ));
    } else {
      emit(state.copyWith(isLoading: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _createEvent(CreateEventRequested event, Emitter<EventsState> emit) async {
    emit(state.copyWith(isCreating: true));
    final res = await _repository.createEvent(event.request, banner: event.banner);
    if (res.success) {
      emit(state.copyWith(isCreating: false, createSuccess: true));
      add(FetchEventsRequested(
        page: state.events?.currentPage ?? 1,
        type: state.activeType,
      ));
    } else {
      emit(state.copyWith(isCreating: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _updateEvent(UpdateEventRequested event, Emitter<EventsState> emit) async {
    emit(state.copyWith(isUpdating: true));
    final res = await _repository.updateEvent(event.eventId, event.request, banner: event.banner);
    if (res.success) {
      emit(state.copyWith(isUpdating: false, updateSuccess: true));
      add(FetchEventsRequested(
        page: state.events?.currentPage ?? 1,
        type: state.activeType,
      ));
    } else {
      emit(state.copyWith(isUpdating: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _toggleEventStatus(ToggleEventStatusRequested event, Emitter<EventsState> emit) async {
    emit(state.copyWith(isTogglingStatus: true, togglingEventId: event.eventId));
    final res = await _repository.toggleEventStatus(event.eventId, event.status);
    if (res.success) {
      emit(state.copyWith(isTogglingStatus: false, clearTogglingEventId: true));
      add(FetchEventsRequested(
        page: state.events?.currentPage ?? 1,
        type: state.activeType,
      ));
    } else {
      emit(state.copyWith(isTogglingStatus: false, clearTogglingEventId: true, error: res.fullErrorMessage));
    }
  }

  Future<void> _deleteEvent(DeleteEventRequested event, Emitter<EventsState> emit) async {
    emit(state.copyWith(isDeleting: true, deletingEventId: event.eventId));
    final res = await _repository.deleteEvent(event.eventId);
    if (res.success) {
      emit(state.copyWith(isDeleting: false, clearDeletingEventId: true));
      add(FetchEventsRequested(
        page: state.events?.currentPage ?? 1,
        type: state.activeType,
      ));
    } else {
      emit(state.copyWith(isDeleting: false, clearDeletingEventId: true, error: res.fullErrorMessage));
    }
  }

  Future<void> _fetchSpeakers(FetchSpeakersRequested event, Emitter<EventsState> emit) async {
    emit(state.copyWith(isLoadingSpeakers: true));
    final res = await _practionerRepository.getPractioners(status: 'verified');
    if (res.success && res.data != null) {
      emit(state.copyWith(
        speakers: res.data!.data ?? [],
        isLoadingSpeakers: false,
      ));
    } else {
      emit(state.copyWith(isLoadingSpeakers: false, error: res.fullErrorMessage));
    }
  }
}
