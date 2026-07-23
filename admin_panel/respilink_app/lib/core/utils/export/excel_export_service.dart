import 'package:excel/excel.dart';

import 'app_export_service.dart';
import 'export_document.dart';
import 'excel_save_stub.dart'
    if (dart.library.html) 'excel_save_web.dart'
    if (dart.library.io) 'excel_save_io.dart';

class ExcelExportService implements AppExportService {
  @override
  Future<bool> export(ExportDocument doc) async {
    final workbook = Excel.createExcel();
    workbook.delete('Sheet1');

    for (final sheet in doc.sheets) {
      final ws = workbook[sheet.name];

      // Header row — bold
      for (int col = 0; col < sheet.headers.length; col++) {
        final cell = ws.cell(
          CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
        );
        cell.value = TextCellValue(sheet.headers[col]);
        cell.cellStyle = CellStyle(bold: true);
      }

      // Data rows
      for (int row = 0; row < sheet.rows.length; row++) {
        final rowData = sheet.rows[row];
        for (int col = 0; col < rowData.length; col++) {
          final cell = ws.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1),
          );
          final value = rowData[col];
          cell.value = switch (value) {
            int v    => IntCellValue(v),
            double v => DoubleCellValue(v),
            _        => TextCellValue(value?.toString() ?? ''),
          };
        }
      }
    }

    final bytes = workbook.encode();
    if (bytes == null) return false;

    return saveExcelFile(bytes, doc.fileName);
  }
}
