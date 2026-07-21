import 'package:respilink_mobile/features/content_library/domain/models/library_filter.dart';

abstract class LibraryEvent {}

class LibraryRequested extends LibraryEvent {
  final LibraryFilter filter;
  final String search;

  LibraryRequested({this.filter = LibraryFilter.topics, this.search = ''});
}

class LibraryLoadMoreRequested extends LibraryEvent {}

class LibraryFilterChanged extends LibraryEvent {
  final LibraryFilter filter;

  LibraryFilterChanged({required this.filter});
}

class LibrarySearchChanged extends LibraryEvent {
  final String query;

  LibrarySearchChanged({required this.query});
}
