import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';


class ImagePickResult {
  const ImagePickResult._({this.file, this.files,this.error});

  const ImagePickResult.success(File file) : this._(file: file);
  const ImagePickResult.successMultiple(List<File> files) : this._(files: files);
  const ImagePickResult.failure(String error) : this._(error: error);

  final File? file;
  final List<File>? files;
  final String? error;

bool get isSuccess => file != null || (files != null && files!.isNotEmpty);
}

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // ─── Configuration ────────────────────────────────────────────────────────

  /// Max long-edge after compression (pixels). Aspect ratio is preserved.
  static const int _maxDimension = 1080;

  /// First-pass JPEG quality from ImagePicker [0–100].
  /// Kept high intentionally — FlutterImageCompress does the real work.
  static const int _pickerQuality = 95;

  /// Final JPEG quality after FlutterImageCompress [0–100].
  /// 82 gives an excellent quality/size ratio for API uploads.
  static const int _compressQuality = 82;

  /// Hard ceiling on the compressed file size (bytes).
  /// If the image is still above this after the first compress pass,
  /// a second pass at reduced quality is attempted automatically.
  static const int _maxFileSizeBytes = 1 * 1024 * 1024; // 1 MB

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Opens the device camera, compresses the capture, and returns the [File].
  Future<ImagePickResult> pickFromCamera() => _pick(ImageSource.camera);

  /// Opens the system gallery, compresses the selection, and returns the [File].
  Future<ImagePickResult> pickFromGallery() => _pick(ImageSource.gallery);

  // ─── Internal pipeline ────────────────────────────────────────────────────

Future<ImagePickResult> pickMultipleFromGallery() async {
    try {
      // 2. Query system using the multi-image native bridge API
      final List<XFile> xFiles = await _picker.pickMultiImage(
        imageQuality: _pickerQuality,
      );

      if (xFiles.isEmpty) {
        return const ImagePickResult.failure('No images selected.');
      }

      // 3. Fire compression passes concurrently across threads via Future.wait
      final List<File> compressedFiles = await Future.wait(
        xFiles.map((xFile) => _compress(File(xFile.path))),
      );

      return ImagePickResult.successMultiple(compressedFiles);
    } on Exception catch (e) {
      return ImagePickResult.failure(e.toString());
    }
  }

  Future<ImagePickResult> _pick(ImageSource source) async {
    try {
      // Step 1 — Pick
      final XFile? xFile = await _picker.pickImage(
        source: source,
        imageQuality: _pickerQuality,
        preferredCameraDevice: .rear,
      );

      if (xFile == null) {
        return const ImagePickResult.failure('No image selected.');
      }

      // Step 2 — Compress
      final File compressed = await _compress(File(xFile.path));
      return ImagePickResult.success(compressed);
    } on Exception catch (e) {
      return ImagePickResult.failure(e.toString());
    }
  }

  Future<File> _compress(File source) async {
    final File output = await _buildOutputFile(source.path);

    // Determine format from extension; default to JPEG for anything unknown.
    final CompressFormat format = _formatFromPath(source.path);

    XFile? result = await FlutterImageCompress.compressAndGetFile(
      source.absolute.path,
      output.absolute.path,
      format: format,
      quality: _compressQuality,
      minWidth: _maxDimension,
      minHeight: _maxDimension,
      keepExif: false, // strip EXIF — reduces size & protects user privacy
    );

    // If the compressor returns null (unsupported format edge case),
    // fall back to the original file so the flow never breaks.
    if (result == null) return source;

    File compressedFile = File(result.path);

    // Step 3 — Safety second pass: if still over the size ceiling, recompress
    // at a lower quality (60) to ensure the upload never crashes the server.
    if (await compressedFile.length() > _maxFileSizeBytes) {
      final File fallbackOutput = await _buildOutputFile(source.path, suffix: '_2');

      final XFile? secondPass = await FlutterImageCompress.compressAndGetFile(
        source.absolute.path,
        fallbackOutput.absolute.path,
        format: format,
        quality: 60,
        minWidth: _maxDimension,
        minHeight: _maxDimension,
        keepExif: false,
      );

      if (secondPass != null) compressedFile = File(secondPass.path);
    }

    return compressedFile;
  }

  Future<File> _buildOutputFile(String sourcePath, {String suffix = ''}) async {
    final Directory tmp = await getTemporaryDirectory();
    final String name =
        'img_${DateTime.now().millisecondsSinceEpoch}$suffix${p.extension(sourcePath)}';
    return File(p.join(tmp.path, name));
  }

  CompressFormat _formatFromPath(String path) {
    switch (p.extension(path).toLowerCase()) {
      case '.png':
        return CompressFormat.png;
      case '.webp':
        return CompressFormat.webp;
      case '.heic':
      case '.heif':
        return CompressFormat.heic;
      default:
        return CompressFormat.jpeg;
    }
  }
}