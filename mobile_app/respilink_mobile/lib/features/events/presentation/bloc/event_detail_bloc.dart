import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:respilink_mobile/core/utils/date_time_utils.dart';
import 'package:respilink_mobile/features/events/data/model/event_conference_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_webinar_model.dart';
import 'package:respilink_mobile/features/events/data/model/event_workshop_model.dart';
import 'package:respilink_mobile/features/events/domain/models/conference_detail_model.dart';
import 'package:respilink_mobile/features/events/domain/models/event_detail_model.dart';
import 'package:respilink_mobile/features/events/domain/models/event_model.dart';
import 'package:respilink_mobile/features/events/domain/repositories/events_repository.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_event.dart';
import 'package:respilink_mobile/features/events/presentation/bloc/event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventsRepository _repository;

  EventDetailBloc(this._repository) : super(EventDetailLoading()) {
    on<WebinarDetailRequested>(_fetchWebinar);
    on<WorkshopDetailRequested>(_fetchWorkshop);
    on<ConferenceDetailRequested>(_fetchConference);
  }

  Future<void> _fetchWebinar(
    WebinarDetailRequested event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());

    final res = await _repository.getEventWebinar(eventId: event.eventId);

    if (res.success && res.data != null) {
      emit(WebinarDetailLoaded(detail: _mapWebinar(res.data!)));
    } else {
      emit(EventDetailFailed(message: res.fullErrorMessage));
    }
  }

  Future<void> _fetchWorkshop(
    WorkshopDetailRequested event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());

    final res = await _repository.getEventWorkshop(eventId: event.eventId);

    if (res.success && res.data != null) {
      emit(WorkshopDetailLoaded(detail: _mapWorkshop(res.data!)));
    } else {
      emit(EventDetailFailed(message: res.fullErrorMessage));
    }
  }

  Future<void> _fetchConference(
    ConferenceDetailRequested event,
    Emitter<EventDetailState> emit,
  ) async {
    emit(EventDetailLoading());

    final res = await _repository.getEventConference(eventId: event.eventId);

    if (res.success && res.data != null) {
      emit(ConferenceDetailLoaded(detail: _mapConference(res.data!)));
    } else {
      emit(EventDetailFailed(message: res.fullErrorMessage));
    }
  }

  // ─────────────────────────────────────────────
  // Mapping: API models -> UI domain models
  // ─────────────────────────────────────────────

  EventDetailModel _mapWebinar(EventWebinarModel model) {
    final fee = model.registrationFee ?? 0;

    return EventDetailModel(
      event: EventModel(
        id: model.id ?? 0,
        type: EventType.webinar,
        title: model.title ?? '',
        dateLabel: _formatDateOnly(model.date),
        timeLabel: _formatTimeRange(model.startTime, model.endTime),
        image: model.banner ?? '',
        isLive: false,
      ),
      hosts: [
        if (model.speaker != null)
          EventHostModel(
            name: model.speaker!.name ?? '',
            title: model.speaker!.designation ?? '',
            avatarUrl: model.speaker!.image,
          ),
      ],
      infoTiles: [
        EventInfoTile(
          icon: Icons.calendar_today_outlined,
          label: 'DATE',
          value: _formatDateOnly(model.date),
        ),
        EventInfoTile(
          icon: Icons.access_time,
          label: 'TIME',
          value: _formatTimeRange(model.startTime, model.endTime),
        ),
        if (model.cmeCredits != null)
          EventInfoTile(
            icon: Icons.workspace_premium_outlined,
            label: 'CME CREDITS',
            value: '${model.cmeCredits} Points',
          ),
        EventInfoTile(
          icon: Icons.live_tv_outlined,
          label: 'FORMAT',
          value: model.format ?? 'Live Stream',
        ),
      ],
      description: model.description ?? model.syllabus ?? '',
      // Only show the expand link when the syllabus adds something beyond
      // what's already shown as the main description.
      expandedContent:
          (model.syllabus != null && model.syllabus != model.description)
              ? model.syllabus
              : null,
      listTitle: 'Learning Objectives',
      listItems: model.learningObjectives ?? const [],
      registrationNote: fee > 0 ? 'Fee: $fee' : 'Free for Members',
      ctaLabel: 'Register Now',
    );
  }

  EventDetailModel _mapWorkshop(EventWorkshopModel model) {
    final fee = model.fee ?? 0;
    final currency = model.currency ?? '\$';

    return EventDetailModel(
      event: EventModel(
        id: model.id ?? 0,
        type: EventType.workshop,
        title: model.title ?? '',
        dateLabel: _formatDateOnly(model.date),
        timeLabel: _formatTimeRange(model.startTime, model.endTime),
        location: model.location,
        image: model.banner ?? '',
        isLive: model.isLive ?? false,
        externalJoinLink: model.externalJoinLink,
      ),
      hosts: [
        for (final trainer in model.trainers ?? const <Trainer>[])
          EventHostModel(
            name: trainer.name ?? '',
            title: trainer.designation ?? '',
            avatarUrl: trainer.image,
            specialties: [
              for (final specialty in trainer.specialties ?? const <WorkshopSpecialty>[])
                if (specialty.name != null) specialty.name!,
            ],
          ),
      ],
      infoTiles: [
        EventInfoTile(
          icon: Icons.calendar_today_outlined,
          label: 'DATE',
          value: _formatDateOnly(model.date),
        ),
        EventInfoTile(
          icon: Icons.access_time,
          label: 'TIME',
          value: _formatTimeRange(model.startTime, model.endTime),
        ),
        if (model.location != null)
          EventInfoTile(
            icon: Icons.location_on_outlined,
            label: 'LOCATION',
            value: model.location!,
          ),
        EventInfoTile(
          icon: Icons.bar_chart_outlined,
          label: 'FEE',
          value: fee > 0 ? '$currency$fee' : 'Free',
        ),
      ],
      aboutTitle: 'About this Workshop',
      description: model.description ?? '',
      listTitle: 'Pre-requisites',
      listItems: model.prerequisites ?? const [],
      registrationNote: fee > 0 ? '$currency$fee (Registration Fee)' : 'Free',
      ctaLabel: 'Register',
    );
  }

  ConferenceDetailModel _mapConference(EventConferenceModel model) {
    final price = model.price ?? 0;
    final currency = model.currency ?? '\$';

    return ConferenceDetailModel(
      event: EventModel(
        id: model.id ?? 0,
        type: EventType.conference,
        title: model.title ?? '',
        dateLabel: _formatDateRange(model.dateFrom, model.dateTo),
        timeLabel: model.time ?? '',
        location: model.venue,
        image: model.banner ?? '',
        isLive: false,
      ),
      badgeLabel: model.duration ?? _dayCount(model.dateFrom, model.dateTo),
      infoTiles: [
        EventInfoTile(
          icon: Icons.calendar_today_outlined,
          label: 'DATE',
          value: _formatDateRange(model.dateFrom, model.dateTo),
        ),
        EventInfoTile(
          icon: Icons.access_time,
          label: 'TIME',
          value: model.time ?? '',
        ),
        EventInfoTile(
          icon: Icons.groups_outlined,
          label: 'FORMAT',
          value: model.format ?? 'In-Person',
        ),
        if (model.venue != null)
          EventInfoTile(
            icon: Icons.location_on_outlined,
            label: 'VENUE',
            value: model.venue!,
          ),
      ],
      speakers: [
        for (final speaker in model.speakers ?? const <Speakers>[])
          SpeakerModel(name: speaker.name ?? '', avatarUrl: speaker.image, specialties: speaker.specialties),
      ],
      agendaByDay: _groupAgenda(model.agenda),
      priceLabel: price > 0 ? '$currency$price / person' : 'Free',
      ctaLabel: 'Register',
    );
  }

  Map<String, List<AgendaItemModel>> _groupAgenda(List<Agenda>? agenda) {
    final grouped = <String, List<AgendaItemModel>>{};

    for (final item in agenda ?? const <Agenda>[]) {
      final dayLabel = item.day != null ? 'Day ${item.day}' : 'Day 1';
      grouped
          .putIfAbsent(dayLabel, () => [])
          .add(
            AgendaItemModel(
              time: item.time ?? '',
              title: item.title ?? '',
              description: item.description ?? '',
              location: item.location ?? '',
            ),
          );
    }

    return grouped;
  }

  // ─────────────────────────────────────────────
  // Defensive date/time formatting — these endpoints send plain date/time
  // strings (not the combined ISO-ish datetimes the listing API uses), and
  // the exact format isn't guaranteed, so every parse attempt falls back to
  // the raw value instead of throwing or showing "Invalid Date".
  // ─────────────────────────────────────────────

  String _formatDateOnly(String? date) {
    if (date == null || date.trim().isEmpty) return '';

    final parsed = DateTimeUtils.parseBackendDate(date);
    if (parsed != null) return DateFormat('MMM d, yyyy').format(parsed.toLocal());

    for (final pattern in ['yyyy-MM-dd', 'dd-MM-yyyy', 'MM/dd/yyyy']) {
      try {
        return DateFormat(
          'MMM d, yyyy',
        ).format(DateFormat(pattern).parseStrict(date.trim()));
      } catch (_) {}
    }

    return date;
  }

  String _formatDateRange(String? from, String? to) {
    final fromLabel = _formatDateOnly(from);
    final toLabel = _formatDateOnly(to);

    if (fromLabel.isEmpty) return toLabel;
    if (toLabel.isEmpty) return fromLabel;
    return '$fromLabel - $toLabel';
  }

  String _dayCount(String? from, String? to) {
    if (from == null || to == null) return '';
    return DateTimeUtils.getEventDuration(from, to);
  }

  String _formatTimeOnly(String? time) {
    if (time == null || time.trim().isEmpty) return '';

    for (final pattern in ['HH:mm:ss', 'HH:mm', 'hh:mm:ss a', 'hh:mm a']) {
      try {
        return DateFormat(
          'h:mm a',
        ).format(DateFormat(pattern).parseStrict(time.trim()));
      } catch (_) {}
    }

    return time;
  }

  String _formatTimeRange(String? start, String? end) {
    final startLabel = _formatTimeOnly(start);
    final endLabel = _formatTimeOnly(end);

    if (startLabel.isEmpty) return endLabel;
    if (endLabel.isEmpty) return startLabel;
    return '$startLabel - $endLabel';
  }
}
