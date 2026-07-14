import 'package:intl/intl.dart';

import '../../exports.dart';

class DateTimeUtils {
  DateTimeUtils._();

  /// The backend sends most timestamps as `yyyy-MM-dd hh:mm:ss a`
  /// (12-hour clock, e.g. "2026-07-12 12:58:00 PM"), which `DateTime.parse`
  /// cannot handle at all since it isn't ISO-8601. Falls back to that format,
  /// parsed as UTC, before giving up.
  static final DateFormat _backendDateTimeFormat = DateFormat(
    'yyyy-MM-dd hh:mm:ss a',
  );

  static DateTime? parseBackendDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final iso = DateTime.tryParse(value);
    if (iso != null) return iso;

    try {
      return _backendDateTimeFormat.parse(value, true);
    } catch (_) {
      return null;
    }
  }

  static Future<String?> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: locator<NavigationService>().navigationKey.currentContext!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      return "${picked.year}-${picked.month}-${picked.day}";
    }
    return null;
  }

  static String formatToRange(String? startDateStr, String? endDateStr) {
    final start = parseBackendDate(startDateStr);
    final end = parseBackendDate(endDateStr);
    if (start == null || end == null) return "Invalid Date";

    final formatter = DateFormat('MMM d');
    return "${formatter.format(start.toLocal())} - ${formatter.format(end.toLocal())}";
  }

  static String convertToTimeAgo(String? isoDate) {
    final postDate = parseBackendDate(isoDate)?.toUtc();
    if (postDate == null) return '';

    final now = DateTime.now().toUtc();
    final difference = now.difference(postDate);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(postDate);
    }
  }

  static String formatToTime(String? isoDate) {
    final dateTime = parseBackendDate(isoDate);
    if (dateTime == null) return "Invalid Time";

    return DateFormat.jm().format(dateTime.toLocal());
  }

  static String formatToHumanReadable(String? isoDate) {
    final dateTime = parseBackendDate(isoDate);
    if (dateTime == null) return "Invalid Date";

    return DateFormat.yMMMMEEEEd().add_jm().format(dateTime.toLocal());
  }

  static String formatToHumanReadableMonthYear(String? isoDate) {
    final dateTime = parseBackendDate(isoDate);
    if (dateTime == null) return "Invalid Date";

    return DateFormat("MMMM, yyyy").format(dateTime.toLocal());
  }

  static String formatTimeShortDays(String? time) {
    final dt = parseBackendDate(time)?.toLocal();
    if (dt == null) return "Invalid Date";

    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays == 0) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}/${dt.year.toString().substring(2)}';
  }

  static String getEventDuration(String? start, String? end) {
    final startDate = parseBackendDate(start);
    final endDate = parseBackendDate(end);
    if (startDate == null || endDate == null) return '0 Days';

    final days = endDate.difference(startDate).inDays;
    return '$days Days';
  }

  static String timeAgo(String? dateString) {
    final dateTime = parseBackendDate(dateString)?.toLocal();
    if (dateTime == null) return '';

    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}mo';
    } else {
      return '${(diff.inDays / 365).floor()}y';
    }
  }

  static String formatDateToDayMonthYear(String isoDate) {
    if (isoDate.trim().isEmpty) return "";

    final cleanStr = isoDate.trim();

    // Drop timestamp metadata if present, whether ISO ("...T00:00:00Z")
    // or the backend's space-separated datetime format.
    final datePart = cleanStr.contains('T')
        ? cleanStr.split('T')[0]
        : cleanStr.split(' ')[0];

    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parseStrict(datePart);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (_) {
      return "";
    }
  }
}
