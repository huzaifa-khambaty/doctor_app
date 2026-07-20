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

class EventHostModel {
  final String name;
  final String title;
  final String? avatarUrl;
  final List<String> specialties;

  const EventHostModel({
    required this.name,
    this.title = '',
    this.avatarUrl,
    this.specialties = const [],
  });
}

class EventDetailModel {
  final EventModel event;
  final List<EventHostModel> hosts;
  final List<EventInfoTile> infoTiles;
  final String aboutTitle;
  final String description;

  /// Extra text revealed by the "Read Full Syllabus" expand link. Null hides
  /// the link entirely — only webinars currently have separate syllabus copy.
  final String? expandedContent;
  final String listTitle;
  final List<String> listItems;
  final String registrationNote;
  final String ctaLabel;

  const EventDetailModel({
    required this.event,
    this.hosts = const [],
    required this.infoTiles,
    this.aboutTitle = 'About this Event',
    required this.description,
    this.expandedContent,
    this.listTitle = 'Learning Objectives',
    required this.listItems,
    required this.registrationNote,
    this.ctaLabel = 'Register Now',
  });
}
