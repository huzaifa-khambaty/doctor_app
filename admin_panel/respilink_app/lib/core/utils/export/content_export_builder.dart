import 'package:intl/intl.dart';
import 'package:respilink_app/features/content/data/models/content_model.dart';

import 'export_document.dart';

ExportDocument buildContentExportDocument({required ContentModel? contentData}) {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final stats = contentData?.stats;
  final items = contentData?.contents?.data ?? [];

  // ── Sheet 1: Summary cards ────────────────────────────────────────────────
  final summarySheet = ExportSheet(
    name: 'Summary',
    headers: ['Metric', 'Value'],
    rows: [
      ['Total Content', stats?.total ?? 0],
      ['Webinars', stats?.webinars ?? 0],
      ['Live Quizzes', stats?.liveQuizzes ?? 0],
      ['Upcoming Events', stats?.upcomingEvents ?? 0],
    ],
  );

  // ── Sheet 2: Content list ─────────────────────────────────────────────────
  const typeMap = {1: 'PDF', 2: 'Article', 3: 'Webinar', 4: 'Quiz'};
  final listSheet = ExportSheet(
    name: 'Content List',
    headers: [
      'Title',
      'Type',
      'Specialty / Topic',
      'Date Created',
      'Status',
      'Views',
      'Likes',
    ],
    rows: items.map((item) {
      final typeId = item.type?.id ?? item.typeId;
      final typeLabel = item.type?.name ?? typeMap[typeId] ?? 'Unknown';
      final specialty = item.specialties?.isNotEmpty == true
          ? (item.specialties!.first.name ?? '—')
          : '—';
      final date = _fmtDate(item.createdAt);
      final status = _statusLabel(item.status);
      return [
        item.title ?? '—',
        typeLabel,
        specialty,
        date,
        status,
        item.viewsCount ?? 0,
        item.likesCount ?? 0,
      ];
    }).toList(),
  );

  // ── Sheet 3: Content mix percentages ─────────────────────────────────────
  final total = stats?.total ?? 0;
  final webinars = stats?.webinars ?? 0;
  final quizzes = stats?.liveQuizzes ?? 0;
  final others = (total - webinars - quizzes).clamp(0, total);

  String pct(int v) =>
      total > 0 ? '${((v / total) * 100).toStringAsFixed(1)}%' : '0%';

  final mixSheet = ExportSheet(
    name: 'Content Mix',
    headers: ['Category', 'Count', 'Percentage'],
    rows: [
      ['Clinical Webinars', webinars, pct(webinars)],
      ['Live Quizzes', quizzes, pct(quizzes)],
      ['Articles & PDFs', others, pct(others)],
    ],
  );

  return ExportDocument(
    fileName: 'RespiLink_Content_$today',
    sheets: [summarySheet, listSheet, mixSheet],
  );
}

String _fmtDate(String? raw) {
  if (raw == null) return '—';
  try {
    return DateFormat('MMM d, yyyy').format(DateTime.parse(raw).toLocal());
  } catch (_) {
    return raw;
  }
}

String _statusLabel(String? status) {
  switch (status) {
    case 'published': return 'Published';
    case 'review': return 'In Review';
    default: return 'Draft';
  }
}
