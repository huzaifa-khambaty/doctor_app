import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:respilink_mobile/core/network/dio_client.dart';

/// Downloads a remote file into the app's own sandboxed documents
/// directory (no storage permission needed) and opens it with the
/// device's default viewer.
class ContentDownloadService {
  final DioClient _client;

  ContentDownloadService(this._client);

  Future<File> downloadAndOpen(String url, String fileName) async {
    final file = await _download(url, fileName);

    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }

    return file;
  }

  Future<File> _download(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/$fileName';
    final file = File(savePath);

    // Already cached from a previous download — skip re-fetching.
    if (await file.exists() && await file.length() > 0) {
      return file;
    }

    await _client.downloadFile(url, savePath);
    return file;
  }
}
