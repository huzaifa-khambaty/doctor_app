import 'app_export_service.dart';
import 'excel_export_service.dart';
import 'export_document.dart';

export 'export_document.dart';

enum ExportFormat { excel }

/// Single call-site for all exports.
/// To add a new format, add an enum value and a case in [_serviceFor].
class AppExporter {
  AppExporter._();

  static Future<bool> export({
    required ExportDocument document,
    ExportFormat format = ExportFormat.excel,
  }) =>
      _serviceFor(format).export(document);

  static AppExportService _serviceFor(ExportFormat format) => switch (format) {
        ExportFormat.excel => ExcelExportService(),
      };
}
