import 'export_document.dart';

/// Implement this to add a new export format (PDF, CSV, …).
abstract class AppExportService {
  /// Returns true if the file was saved, false if the user cancelled.
  Future<bool> export(ExportDocument document);
}
