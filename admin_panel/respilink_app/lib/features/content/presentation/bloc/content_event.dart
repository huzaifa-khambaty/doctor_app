import 'package:respilink_app/features/content/data/models/requests/create_content_request.dart';

abstract class ContentEvent {}

class FetchContentsRequested extends ContentEvent {
  final int page;
  final String? status;
  final String? search;
  FetchContentsRequested({this.page = 1, this.status, this.search});
}

class FetchContentSpecialtiesRequested extends ContentEvent {}

class FetchContentQuizzesRequested extends ContentEvent {}

class CreateContentRequested extends ContentEvent {
  final CreateContentRequest request;
  CreateContentRequested(this.request);
}

class UpdateContentRequested extends ContentEvent {
  final int contentId;
  final UpdateContentRequest request;
  UpdateContentRequested({required this.contentId, required this.request});
}

class DeleteContentRequested extends ContentEvent {
  final int contentId;
  DeleteContentRequested(this.contentId);
}

class UpdateContentStatusRequested extends ContentEvent {
  final int contentId;
  final String status;
  UpdateContentStatusRequested(this.contentId, this.status);
}
