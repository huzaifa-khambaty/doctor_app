import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static Future<String?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
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
    try {
      // 1. Parse ISO strings to DateTime objects
      DateTime start = DateTime.parse(startDateStr!);
      DateTime end = DateTime.parse(endDateStr!);

      // 2. Define the format (MMM for short month name like 'Sep')
      final formatter = DateFormat('MMM d');

      // 3. Join them together
      return "${formatter.format(start)} - ${formatter.format(end)}";
    } catch (e) {
      return "Invalid Date";
    }
  }

  static String convertToTimeAgo(String? isoDate) {
    // 1. Parse the string to a UTC DateTime
    DateTime postDate = DateTime.parse(isoDate!).toUtc();
    DateTime now = DateTime.now().toUtc();

    // 2. Calculate the difference
    Duration difference = now.difference(postDate);

    // 3. Logic for relative time strings
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // For older dates, use intl to format it properly (e.g., May 1, 2026)
      return DateFormat('MMM d, yyyy').format(postDate);
    }
  }

  static String formatToTime(String? isoDate) {
    try {
      // 1. Parse the string to a DateTime object
      DateTime dateTime = DateTime.parse(isoDate!);

      // 2. Convert to local time (so it matches the user's clock)
      DateTime localDateTime = dateTime.toLocal();

      // 3. Format using intl (jm stands for 'Hour:Minute AM/PM')
      return DateFormat.jm().format(localDateTime);

      // Alternative explicit format:
      // return DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      return "Invalid Time";
    }
  }

  static String formatToHumanReadable(String? isoDate) {
    try {
      String? timestamp = isoDate;
      DateTime dt = DateTime.parse(timestamp!).toLocal();

      // "yMMMMEEEEd" gives: Friday, May 8, 2026
      // "jm" gives: 5:08 AM
      String fullDate = DateFormat.yMMMMEEEEd().add_jm().format(dt);
      return fullDate;
    } catch (e) {
      return "Invalid Date";
    }
  }

  static String formatToHumanReadableMonthYear(String? isoDate) {
    try {
      String? timestamp = isoDate;
      DateTime dt = DateTime.parse(timestamp!).toLocal();

      // "yMMMMEEEEd" gives: Friday, May 8, 2026
      // "jm" gives: 5:08 AM
      String fullDate = DateFormat("MMMM, yyyy").format(dt);
      return fullDate;
    } catch (e) {
      return "Invalid Date";
    }
  }

  static String formatTimeShortDays(String? time) {
    try {
      String? timestamp = time;
      DateTime dt = DateTime.parse(timestamp!);

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
    } catch (e) {
      return "Invalid Date";
    }
  }

  static String getEventDuration(String? start, String? end) {
    if (start == null || end == null) return '0 Days';

    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);

      final days = endDate.difference(startDate).inDays;

      return '$days Days';
    } catch (e) {
      return '0 Days';
    }
  }

  static String timeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }

    try {
      final dateTime = DateTime.parse(dateString).toLocal();
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
    } catch (e) {
      return '';
    }
  }

  static String formatDateToDayMonthYear(String isoDate) {
  if (isoDate.trim().isEmpty) return "";
  try {
    final cleanStr = isoDate.trim();
    
    // 2. Drop timestamp metadata if present (e.g., "1993-09-19T00:00:00Z")
    final datePart = cleanStr.contains('T') ? cleanStr.split('T')[0] : cleanStr;

    // 3. Parse using strict rules to prevent malformed strings from causing layout bugs
    final DateTime parsedDate = DateFormat('yyyy-MM-dd').parseStrict(datePart);

    // 4. Return the newly formatted string
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  } catch (_) {
    // 5. Catch-all fallback: returns an empty string instead of breaking the UI execution
    return "";
  }
}
}
