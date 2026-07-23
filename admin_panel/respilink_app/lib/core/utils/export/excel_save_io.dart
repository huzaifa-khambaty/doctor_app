import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<bool> saveExcelFile(List<int> bytes, String fileName) async {
  final savePath = await FilePicker.platform.saveFile(
    dialogTitle: 'Save Report',
    fileName: '$fileName.xlsx',
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );
  if (savePath == null) return false;
  final path = savePath.endsWith('.xlsx') ? savePath : '$savePath.xlsx';
  await File(path).writeAsBytes(bytes);
  return true;
}
