import 'package:intl/intl.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';

import 'export_document.dart';

ExportDocument buildPractitionerExportDocument({
  required int? pendingTotal,
  required int? verifiedTotal,
  required List<Practioners> practitioners,
}) {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final summarySheet = ExportSheet(
    name: 'Summary',
    headers: ['Metric', 'Value'],
    rows: [
      ['Awaiting Approval', pendingTotal ?? 0],
      ['Total Verified', verifiedTotal ?? 0],
    ],
  );

  final listSheet = ExportSheet(
    name: 'Practitioners',
    headers: [
      'Full Name',
      'License No.',
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
      final regDate =
          p.createdAt != null ? p.createdAt!.substring(0, 10) : '—';
      return [
        p.fullName ?? '—',
        p.licenseNumber ?? '—',
        specialties,
        p.hospitalAffiliation ?? '—',
        regDate,
        (p.status ?? 'pending').toUpperCase(),
      ];
    }).toList(),
  );

  return ExportDocument(
    fileName: 'RespiLink_Practitioners_$today',
    sheets: [summarySheet, listSheet],
  );
}
