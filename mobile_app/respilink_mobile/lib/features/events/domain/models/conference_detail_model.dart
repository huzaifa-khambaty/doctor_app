import 'package:respilink_mobile/features/events/domain/models/event_detail_model.dart';
import 'package:respilink_mobile/features/events/domain/models/event_model.dart';

class SpeakerModel {
  final String name;
  final String? avatarUrl;

  const SpeakerModel({required this.name, this.avatarUrl});
}

class AgendaItemModel {
  final String time;
  final String title;
  final String description;
  final String location;

  const AgendaItemModel({
    required this.time,
    required this.title,
    required this.description,
    required this.location,
  });
}

class ConferenceDetailModel {
  final EventModel event;
  final String badgeLabel;
  final List<EventInfoTile> infoTiles;
  final List<SpeakerModel> speakers;

  /// Agenda entries keyed by day label (e.g. "Day 1"), in display order.
  final Map<String, List<AgendaItemModel>> agendaByDay;
  final String priceCaption;
  final String priceLabel;
  final String ctaLabel;

  const ConferenceDetailModel({
    required this.event,
    required this.badgeLabel,
    required this.infoTiles,
    required this.speakers,
    required this.agendaByDay,
    this.priceCaption = 'Admission Price',
    required this.priceLabel,
    this.ctaLabel = 'Register',
  });
}
