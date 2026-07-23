import 'package:intl/intl.dart';
import 'package:respilink_app/features/auth/data/models/dashboard_model.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';

import 'export_document.dart';

/// Builds the [ExportDocument] for the Clinical Dashboard report.
/// Contains two sheets: stat-card summary and the pending verification queue.
ExportDocument buildDashboardExportDocument({
  required DashboardModel? dashboard,
  required List<Practioners> practitioners,
}) {
  final stats = dashboard?.statCounts;
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final summarySheet = ExportSheet(
    name: 'Summary',
    headers: ['Metric', 'Value', 'Change / Note'],
    rows: [
      [
        'Active Doctors',
        stats?.activeDoctors?.count ?? 0,
        _pct(stats?.activeDoctors?.changePercent),
      ],
      [
        'Pending Verifications',
        stats?.pendingVerifications?.count ?? 0,
        '${stats?.pendingVerifications?.critical ?? 0} critical',
      ],
      [
        'Quiz Participation',
        '${stats?.quizParticipation?.percentage ?? 0}%',
        _pct(stats?.quizParticipation?.changePercent),
      ],
      [
        'Library Views (Total)',
        stats?.libraryViews?.total ?? 0,
        '${stats?.libraryViews?.recent ?? 0} recent',
      ],
    ],
  );

  final queueSheet = ExportSheet(
    name: 'Verification Queue',
    headers: [
      'Full Name',
      'ID',
      'Specialties',
      'Hospital / Facility',
      'Registration Date',
      'Status',
    ],
    rows: practitioners.map((p) {
      final specialties = p.specialties
              ?.where((s) => s.name != null)
              .map((s) => s.name!)
              .join(', ') ??
          '—';
      final regDate = p.createdAt != null
          ? p.createdAt!.substring(0, 10)
          : '—';
      return [
        p.fullName ?? '—',
        p.uuid?.substring(0, 8) ?? p.id?.toString() ?? '—',
        specialties,
        p.hospitalAffiliation ?? '—',
        regDate,
        (p.status ?? 'pending').toUpperCase(),
      ];
    }).toList(),
  );

  return ExportDocument(
    fileName: 'RespiLink_Dashboard_$today',
    sheets: [summarySheet, queueSheet],
  );
}

String _pct(int? v) {
  if (v == null || v == 0) return 'No change';
  return v > 0 ? '+$v%' : '$v%';
}
