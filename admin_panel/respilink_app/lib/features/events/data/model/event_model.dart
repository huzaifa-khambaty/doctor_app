import 'package:intl/intl.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';

// Parses both ISO 8601 ("2026-10-01T10:00:00") and the API's
// "yyyy-MM-dd hh:mm:ss a" format ("2026-10-01 10:00:00 AM").
DateTime? _parseEventDateTime(String? raw) {
  if (raw == null) return null;
  try {
    return DateTime.parse(raw);
  } catch (_) {}
  try {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').parse(raw);
  } catch (_) {}
  return null;
}

extension EventsComputed on Events {
  bool get isLive {
    if (startsAt == null || endsAt == null) return false;
    final start = _parseEventDateTime(startsAt);
    final end = _parseEventDateTime(endsAt);
    if (start == null || end == null) return false;
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }

  bool get isUpcoming {
    final start = _parseEventDateTime(startsAt);
    if (start == null) return false;
    return DateTime.now().isBefore(start);
  }

  String get computedStatus {
    if (isLive) return 'live';
    if (isUpcoming) return 'upcoming';
    if (status != null && status!.isNotEmpty) return status!;
    return 'ended';
  }

  DateTime? get startDateTime => _parseEventDateTime(startsAt);
  DateTime? get endDateTime => _parseEventDateTime(endsAt);
}
