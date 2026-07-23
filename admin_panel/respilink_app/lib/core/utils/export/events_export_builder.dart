import 'package:intl/intl.dart';
import 'package:respilink_app/features/events/data/model/event_listing_model.dart';
import 'package:respilink_app/features/events/data/model/event_model.dart';

import 'export_document.dart';

ExportDocument buildEventsExportDocument({
  required EventListingModel? events,
}) {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final all = events?.data ?? [];

  final total = events?.total ?? 0;
  final upcoming = all.where((e) => e.isUpcoming).length;
  final live = all.where((e) => e.isLive).length;

  // ── Sheet 1: Summary metrics ──────────────────────────────────────────────
  final summarySheet = ExportSheet(
    name: 'Summary',
    headers: ['Metric', 'Value'],
    rows: [
      ['Total Events (All Time)', total],
      ['Upcoming (Scheduled)', upcoming],
      ['Live Now', live],
    ],
  );

  // ── Sheet 2: Events list ──────────────────────────────────────────────────
  final listSheet = ExportSheet(
    name: 'Events',
    headers: [
      'Title',
      'Type',
      'Location',
      'Start Date & Time',
      'End Date & Time',
      'Status',
      'Speakers',
    ],
    rows: all.map((e) {
      final type = (e.type ?? '—').toUpperCase();
      final location = e.location?.isNotEmpty == true ? e.location! : '—';
      final startDt = _fmtDt(e.startsAt);
      final endDt = _fmtDt(e.endsAt);
      final status = _computedStatus(e);
      final speakers = e.speakers?.isNotEmpty == true
          ? e.speakers!
              .where((s) => s.fullName != null)
              .map((s) => s.fullName!)
              .join(', ')
          : '—';
      return [
        e.title ?? '—',
        type,
        location,
        startDt,
        endDt,
        status,
        speakers,
      ];
    }).toList(),
  );

  return ExportDocument(
    fileName: 'RespiLink_Events_$today',
    sheets: [summarySheet, listSheet],
  );
}

String _fmtDt(String? raw) {
  if (raw == null) return '—';
  try {
    return DateFormat('MMM d, yyyy • h:mm a').format(DateTime.parse(raw).toLocal());
  } catch (_) {}
  try {
    return DateFormat('MMM d, yyyy • h:mm a')
        .format(DateFormat('yyyy-MM-dd hh:mm:ss a').parse(raw));
  } catch (_) {}
  return raw;
}

String _computedStatus(Events e) {
  final status = e.computedStatus;
  return switch (status) {
    'live' => 'Live',
    'upcoming' => 'Upcoming',
    'ended' => 'Ended',
    _ => status[0].toUpperCase() + status.substring(1),
  };
}
