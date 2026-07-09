enum EventType { webinar, workshop, conference }

class EventModel {
  final int id;
  final EventType type;
  final String title;
  final String dateLabel;
  final String timeLabel;
  final String? location;
  final String image;
  final bool isLive;
  final bool isFeatured;
  final String? featuredSubtitle;

  const EventModel({
    required this.id,
    required this.type,
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    this.location,
    required this.image,
    this.isLive = false,
    this.isFeatured = false,
    this.featuredSubtitle,
  });

  String get typeLabel => switch (type) {
    EventType.webinar => 'WEBINAR',
    EventType.workshop => 'WORKSHOP',
    EventType.conference => 'CONFERENCE',
  };
}
