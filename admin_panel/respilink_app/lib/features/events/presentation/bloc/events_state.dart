import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
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
    );
  }
}
