import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickResult {
  const ImagePickResult._({
    this.image,
    this.images,
    this.error,
  });

  const ImagePickResult.success(PickedImage image)
      : this._(image: image);

  const ImagePickResult.successMultiple(List<PickedImage> images)
      : this._(images: images);

  const ImagePickResult.failure(String error)
      : this._(error: error);

  final PickedImage? image;
  final List<PickedImage>? images;
  final String? error;

  bool get isSuccess =>
      image != null || (images != null && images!.isNotEmpty);
}

class PickedImage {
  const PickedImage({
    required this.name,
    required this.bytes,
    required this.mimeType,
  });

  final String name;
  final Uint8List bytes;
  final String mimeType;

  int get size => bytes.lengthInBytes;
}

class ImagePickerService {
  ImagePickerService._();

  static final ImagePickerService instance = ImagePickerService._();

  final ImagePicker _picker = ImagePicker();

  static const int _quality = 82;

  Future<ImagePickResult> pickFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (file == null) {
        return const ImagePickResult.failure(
          'No image selected.',
        );
      }

      return ImagePickResult.success(
        await _prepare(file),
      );
    } catch (e) {
      return ImagePickResult.failure(e.toString());
    }
  }

  Future<ImagePickResult> pickFromCamera() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (file == null) {
        return const ImagePickResult.failure(
          'No image selected.',
        );
      }

      return ImagePickResult.success(
        await _prepare(file),
      );
    } catch (e) {
      return ImagePickResult.failure(e.toString());
    }
  }

  Future<ImagePickResult> pickMultipleFromGallery() async {
    try {
      final List<XFile> files = await _picker.pickMultiImage();

      if (files.isEmpty) {
        return const ImagePickResult.failure(
          'No images selected.',
        );
      }

      final images = await Future.wait(
        files.map(_prepare),
      );

      return ImagePickResult.successMultiple(images);
    } catch (e) {
      return ImagePickResult.failure(e.toString());
    }
  }

  Future<PickedImage> _prepare(XFile file) async {
    Uint8List bytes = await file.readAsBytes();

    bytes = await _compress(bytes);

    return PickedImage(
      name: file.name,
      bytes: bytes,
      mimeType: _mimeType(file.name),
    );
  }

  Future<Uint8List> _compress(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      quality: _quality,
    );

    return Uint8List.fromList(result);
  }

  String _mimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();

    switch (ext) {
      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'gif':
        return 'image/gif';

      case 'bmp':
        return 'image/bmp';

      default:
        return 'image/jpeg';
    }
  }
}