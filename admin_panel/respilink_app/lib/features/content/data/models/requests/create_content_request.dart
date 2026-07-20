import 'package:dio/dio.dart';

class CreateContentRequest {
  final String title;
  final String? description;
  final String contentType;
  final String? link;
  final List<String>? externalLinks;
  final List<int>? specialtyIds;
  final int? quizId;
  final String? scheduledAt;
  final String status;
  final List<int>? fileBytes;
  final String? fileName;

  const CreateContentRequest({
    required this.title,
    this.description,
    required this.contentType,
    this.link,
    this.externalLinks,
    this.specialtyIds,
    this.quizId,
    this.scheduledAt,
    this.status = 'draft',
    this.fileBytes,
    this.fileName,
  });

  // Maps content type string to the backend type_id integer.
  // pdf=1, article=2, webinar=3, quiz=4
  int get typeId {
    switch (contentType.toLowerCase()) {
      case 'pdf':     return 1;
      case 'article': return 2;
      case 'webinar': return 3;
      case 'quiz':    return 4;
      default:        return 1;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type_id': typeId,
      if (description != null) 'description': description,
      if (link != null) 'content_link': link,
      if (externalLinks != null) 'external_links': externalLinks,
      if (specialtyIds != null) 'specialty_ids': specialtyIds,
      if (quizId != null) 'quiz_id': quizId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      'status': status,
    };
  }

  FormData toFormData() {
    final formData = FormData();
    formData.fields.add(MapEntry('title', title));
    formData.fields.add(MapEntry('type_id', typeId.toString()));
    if (description != null) formData.fields.add(MapEntry('description', description!));
    if (link != null) formData.fields.add(MapEntry('content_link', link!));
    if (scheduledAt != null) formData.fields.add(MapEntry('scheduled_at', scheduledAt!));
    formData.fields.add(MapEntry('status', status));
    if (externalLinks != null) {
      for (final l in externalLinks!) {
        formData.fields.add(MapEntry('external_links[]', l));
      }
    }
    if (specialtyIds != null) {
      for (final id in specialtyIds!) {
        formData.fields.add(MapEntry('specialty_ids[]', id.toString()));
      }
    }
    if (quizId != null) {
      formData.fields.add(MapEntry('quiz_id', quizId.toString()));
    }
    if (fileBytes != null && fileName != null) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(fileBytes!, filename: fileName),
      ));
    }
    formData.fields.add(MapEntry('_method', "PUT"));
    return formData;
  }

    FormData toFormDataPost() {
    final formData = FormData();
    formData.fields.add(MapEntry('title', title));
    formData.fields.add(MapEntry('type_id', typeId.toString()));
    if (description != null) formData.fields.add(MapEntry('description', description!));
    if (link != null) formData.fields.add(MapEntry('content_link', link!));
    if (scheduledAt != null) formData.fields.add(MapEntry('scheduled_at', scheduledAt!));
    formData.fields.add(MapEntry('status', status));
    if (externalLinks != null) {
      for (final l in externalLinks!) {
        formData.fields.add(MapEntry('external_links[]', l));
      }
    }
    if (specialtyIds != null) {
      for (final id in specialtyIds!) {
        formData.fields.add(MapEntry('specialty_ids[]', id.toString()));
      }
    }
    if (quizId != null) {
      formData.fields.add(MapEntry('quiz_id', quizId.toString()));
    }
    if (fileBytes != null && fileName != null) {
      formData.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(fileBytes!, filename: fileName),
      ));
    }
    return formData;
  }
}

class UpdateContentRequest extends CreateContentRequest {
  const UpdateContentRequest({
    required super.title,
    super.description,
    required super.contentType,
    super.link,
    super.externalLinks,
    super.specialtyIds,
    super.quizId,
    super.scheduledAt,
    required super.status,
    super.fileBytes,
    super.fileName,
  });
}
