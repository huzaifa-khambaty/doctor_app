import 'dart:typed_data';

import 'package:dio/dio.dart';

class GenerateQuizAiRequest {
  final String prompt;
  final int questionCount;
  final Uint8List? documentBytes;
  final String? documentName;

  const GenerateQuizAiRequest({
    required this.prompt,
    required this.questionCount,
    this.documentBytes,
    this.documentName,
  });

  bool get hasDocument => documentBytes != null && documentName != null;

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'question_count': questionCount,
      };

  FormData toFormData() {
    final fd = FormData.fromMap({
      'prompt': prompt,
      'question_count': questionCount,
    });
    if (hasDocument) {
      fd.files.add(MapEntry(
        'document',
        MultipartFile.fromBytes(
          documentBytes!,
          filename: documentName,
          contentType: _mimeType(documentName!),
        ),
      ));
    }
    return fd;
  }

  static DioMediaType _mimeType(String name) {
    final ext = name.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return DioMediaType('application', 'pdf');
      case 'doc':
        return DioMediaType('application', 'msword');
      case 'docx':
        return DioMediaType(
            'application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'xls':
        return DioMediaType('application', 'vnd.ms-excel');
      case 'xlsx':
        return DioMediaType(
            'application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      default:
        return DioMediaType('application', 'octet-stream');
    }
  }
}
