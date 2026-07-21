abstract class ContentDetailsEvent {}

class ContentDetailsRequested extends ContentDetailsEvent {
  final int contentId;

  ContentDetailsRequested({required this.contentId});
}

class ContentLikeToggled extends ContentDetailsEvent {}

class ContentBookmarkToggled extends ContentDetailsEvent {}
