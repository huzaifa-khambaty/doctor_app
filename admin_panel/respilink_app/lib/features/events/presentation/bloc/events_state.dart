import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/data/model/event_participants_model.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';

class EventsState {
  final EventListingModel? events;
  final bool isLoading;
  final bool isCreating;
  final bool createSuccess;
  final bool isUpdating;
  final bool updateSuccess;
  final bool isTogglingStatus;
  final int? togglingEventId;
  final bool isDeleting;
  final int? deletingEventId;
  final String? activeType;
  final String? error;
  final List<Practioners> speakers;
  final bool isLoadingSpeakers;
  final EventParticipantsModel? participantsData;
  final String? participantsEventTitle;
  final bool isLoadingParticipants;
  final int? loadingParticipantsForEventId;
  final bool participantsJustFetched;

  const EventsState({
    this.events,
    this.isLoading = false,
    this.isCreating = false,
    this.createSuccess = false,
    this.isUpdating = false,
    this.updateSuccess = false,
    this.isTogglingStatus = false,
    this.togglingEventId,
    this.isDeleting = false,
    this.deletingEventId,
    this.activeType,
    this.error,
    this.speakers = const [],
    this.isLoadingSpeakers = false,
    this.participantsData,
    this.participantsEventTitle,
    this.isLoadingParticipants = false,
    this.loadingParticipantsForEventId,
    this.participantsJustFetched = false,
  });

  EventsState copyWith({
    EventListingModel? events,
    bool? isLoading,
    bool? isCreating,
    bool? createSuccess,
    bool? isUpdating,
    bool? updateSuccess,
    bool? isTogglingStatus,
    int? togglingEventId,
    bool clearTogglingEventId = false,
    bool? isDeleting,
    int? deletingEventId,
    bool clearDeletingEventId = false,
    String? activeType,
    String? error,
    List<Practioners>? speakers,
    bool? isLoadingSpeakers,
    bool clearActiveType = false,
    Object? participantsData = _sentinel,
    String? participantsEventTitle,
    bool? isLoadingParticipants,
    Object? loadingParticipantsForEventId = _sentinel,
    bool? participantsJustFetched,
  }) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      createSuccess: createSuccess ?? false,
      isUpdating: isUpdating ?? this.isUpdating,
      updateSuccess: updateSuccess ?? false,
      isTogglingStatus: isTogglingStatus ?? this.isTogglingStatus,
      togglingEventId: clearTogglingEventId ? null : (togglingEventId ?? this.togglingEventId),
      isDeleting: isDeleting ?? this.isDeleting,
      deletingEventId: clearDeletingEventId ? null : (deletingEventId ?? this.deletingEventId),
      activeType: clearActiveType ? null : (activeType ?? this.activeType),
      error: error,
      speakers: speakers ?? this.speakers,
      isLoadingSpeakers: isLoadingSpeakers ?? this.isLoadingSpeakers,
      participantsData: identical(participantsData, _sentinel)
          ? this.participantsData
          : participantsData as EventParticipantsModel?,
      participantsEventTitle: participantsEventTitle ?? this.participantsEventTitle,
      isLoadingParticipants: isLoadingParticipants ?? this.isLoadingParticipants,
      loadingParticipantsForEventId: identical(loadingParticipantsForEventId, _sentinel)
          ? this.loadingParticipantsForEventId
          : loadingParticipantsForEventId as int?,
      participantsJustFetched: participantsJustFetched ?? false,
    );
  }
}

const Object _sentinel = Object();
