import 'package:respilink_mobile/features/events/domain/models/conference_detail_model.dart';
import 'package:respilink_mobile/features/events/domain/models/event_detail_model.dart';

abstract class EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class WebinarDetailLoaded extends EventDetailState {
  final EventDetailModel detail;

  WebinarDetailLoaded({required this.detail});
}

class WorkshopDetailLoaded extends EventDetailState {
  final EventDetailModel detail;

  WorkshopDetailLoaded({required this.detail});
}

class ConferenceDetailLoaded extends EventDetailState {
  final ConferenceDetailModel detail;

  ConferenceDetailLoaded({required this.detail});
}

class EventDetailFailed extends EventDetailState {
  final String message;

  EventDetailFailed({required this.message});
}
