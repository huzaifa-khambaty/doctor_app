import 'package:flutter/widgets.dart';
import 'package:respilink_mobile/features/events/domain/models/event_model.dart';

class EventInfoTile {
  final IconData icon;
  final String label;
  final String value;

  const EventInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class EventDetailModel {
  final EventModel event;
  final String hostName;
  final String hostTitle;
  final String? hostAvatar;
  final List<EventInfoTile> infoTiles;
  final String aboutTitle;
  final String description;
  final String listTitle;
  final List<String> listItems;
  final String registrationNote;
  final String ctaLabel;

  const EventDetailModel({
    required this.event,
    required this.hostName,
    required this.hostTitle,
    this.hostAvatar,
    required this.infoTiles,
    this.aboutTitle = 'About this Event',
    required this.description,
    this.listTitle = 'Learning Objectives',
    required this.listItems,
    required this.registrationNote,
    this.ctaLabel = 'Register Now',
  });
}
