import 'package:respilink_mobile/features/events/domain/models/event_model.dart';

enum EventFilter {
  all('All'),
  webinars('Webinars'),
  conferences('Conferences'),
  workshops('Workshops');

  final String label;

  const EventFilter(this.label);

  bool matches(EventType type) {
    return switch (this) {
      EventFilter.all => true,
      EventFilter.webinars => type == EventType.webinar,
      EventFilter.conferences => type == EventType.conference,
      EventFilter.workshops => type == EventType.workshop,
    };
  }
}
