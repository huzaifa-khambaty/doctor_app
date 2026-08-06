import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Icons;
import 'package:respilink_mobile/core/utils/date_time_utils.dart';

enum NotificationType { event, quiz, content, badge, system }

extension NotificationTypeStyle on NotificationType {
  IconData get icon => switch (this) {
    NotificationType.event => Icons.calendar_today_outlined,
    NotificationType.quiz => Icons.quiz_outlined,
    NotificationType.content => Icons.article_outlined,
    NotificationType.badge => Icons.workspace_premium_outlined,
    NotificationType.system => Icons.info_outline,
  };
}

class NotificationItemModel {
  final int id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItemModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  /// Computed on demand (not stored) so [timestamp] stays the single source
  /// of truth — no risk of a stale display string drifting from it.
  String get timeLabel => DateTimeUtils.formatTimeShortDays(timestamp.toIso8601String());

  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  NotificationItemModel copyWith({bool? isRead}) {
    return NotificationItemModel(
      id: id,
      type: type,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
