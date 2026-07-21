import 'package:respilink_mobile/features/content_library/domain/models/library_content_model.dart';
import 'package:respilink_mobile/features/content_library/domain/models/library_filter.dart';
import 'package:respilink_mobile/shared/models/pagination_model.dart';

abstract class LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final String heroTitle;
  final String heroSubtitle;
  final List<LibraryContentModel> items;
  final LibraryFilter filter;
  final String search;
  final Pagination? pagination;
  final bool isLoadingMore;

  LibraryLoaded({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.items,
    required this.filter,
    this.search = '',
    this.pagination,
    this.isLoadingMore = false,
  });

  bool get hasMore => pagination?.hasNext ?? false;

  LibraryLoaded copyWith({
    String? heroTitle,
    String? heroSubtitle,
    List<LibraryContentModel>? items,
    LibraryFilter? filter,
    String? search,
    Pagination? pagination,
    bool? isLoadingMore,
  }) {
    return LibraryLoaded(
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class LibraryFailed extends LibraryState {
  final String message;
  final LibraryFilter filter;
  final String search;

  LibraryFailed({
    required this.message,
    this.filter = LibraryFilter.topics,
    this.search = '',
  });
}
