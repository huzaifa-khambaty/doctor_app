import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<bool> saveExcelFile(List<int> bytes, String fileName) async {
  final uint8list = Uint8List.fromList(bytes);
  final blob = web.Blob(
    [uint8list.toJS].toJS,
    web.BlobPropertyBag(
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    ),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = '$fileName.xlsx';
  anchor.click();
  web.URL.revokeObjectURL(url);
  return true;
}
