import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/theme/app_colors.dart';
import 'package:respilink_mobile/features/content_library/data/models/content_library_model.dart';
import 'package:respilink_mobile/features/content_library/domain/models/library_content_model.dart';
import 'package:respilink_mobile/features/content_library/domain/models/library_filter.dart';
import 'package:respilink_mobile/features/content_library/domain/repositories/content_library_repository.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/library_event.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final ContentLibraryRepository _repository;

  LibraryBloc(this._repository) : super(LibraryLoading()) {
    on<LibraryRequested>(_fetch);
    on<LibraryFilterChanged>(_changeFilter);
    on<LibrarySearchChanged>(_search);
    on<LibraryLoadMoreRequested>(_loadMore);
  }

  Future<void> _fetch(LibraryRequested event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());

    final res = await _repository.getLibrary(
      page: 1,
      tab: _tabParam(event.filter),
      search: event.search.isEmpty ? null : event.search,
    );

    if (res.success && res.data != null) {
      final model = res.data!;
      emit(
        LibraryLoaded(
          heroTitle: model.hero?.title ?? 'Medical Library',
          heroSubtitle: model.hero?.subtitle ?? '',
          items: [for (final item in model.data ?? []) _mapItem(item)],
          filter: event.filter,
          search: event.search,
          pagination: model.pagination,
        ),
      );
    } else {
      emit(
        LibraryFailed(
          message: res.fullErrorMessage,
          filter: event.filter,
          search: event.search,
        ),
      );
    }
  }

  Future<void> _changeFilter(
    LibraryFilterChanged event,
    Emitter<LibraryState> emit,
  ) {
    return _fetch(
      LibraryRequested(filter: event.filter, search: _currentSearch),
      emit,
    );
  }

  Future<void> _search(
    LibrarySearchChanged event,
    Emitter<LibraryState> emit,
  ) {
    return _fetch(
      LibraryRequested(filter: _currentFilter, search: event.query),
      emit,
    );
  }

  LibraryFilter get _currentFilter => switch (state) {
    LibraryLoaded(:final filter) => filter,
    LibraryFailed(:final filter) => filter,
    _ => LibraryFilter.topics,
  };

  String get _currentSearch => switch (state) {
    LibraryLoaded(:final search) => search,
    LibraryFailed(:final search) => search,
    _ => '',
  };

  Future<void> _loadMore(
    LibraryLoadMoreRequested event,
    Emitter<LibraryState> emit,
  ) async {
    final current = state;
    if (current is! LibraryLoaded || current.isLoadingMore || !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = (current.pagination?.page ?? 1) + 1;
    final res = await _repository.getLibrary(
      page: nextPage,
      tab: _tabParam(current.filter),
      search: current.search.isEmpty ? null : current.search,
    );

    if (res.success && res.data != null) {
      final model = res.data!;
      emit(
        current.copyWith(
          items: [
            ...current.items,
            for (final item in model.data ?? []) _mapItem(item),
          ],
          pagination: model.pagination,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  String _tabParam(LibraryFilter filter) => switch (filter) {
    LibraryFilter.topics => 'topics',
    LibraryFilter.newContent => 'new',
    LibraryFilter.trending => 'trending',
    LibraryFilter.saved => 'saved',
  };

  LibraryContentType _typeFor(int? typeId) => switch (typeId) {
    1 => LibraryContentType.pdf,
    3 => LibraryContentType.webinar,
    4 => LibraryContentType.quiz,
    _ => LibraryContentType.article,
  };

  Color _categoryColorFor(LibraryContentType type) => switch (type) {
    LibraryContentType.pdf => AppColors.error,
    LibraryContentType.article => AppColors.primary,
    LibraryContentType.webinar => AppColors.purpleAccent,
    LibraryContentType.quiz => AppColors.purpleAccent,
  };

  LibraryContentModel _mapItem(ContentItem item) {
    final type = _typeFor(item.typeId);
    final specialtyNames = [
      for (final specialty in item.specialties ?? const <ContentSpecialty>[])
        if (specialty.name != null) specialty.name!,
    ];

    final category = type == LibraryContentType.quiz
        ? 'INTERACTIVE ASSESSMENT'
        : (specialtyNames.isNotEmpty
              ? specialtyNames.first.toUpperCase()
              : (item.type?.name?.toUpperCase() ?? ''));

    return LibraryContentModel(
      id: item.id ?? 0,
      type: type,
      category: category,
      categoryColor: _categoryColorFor(type),
      title: item.title ?? '',
      description: type == LibraryContentType.quiz ? item.description : null,
      image: item.thumbnailUrl ?? item.thumbnailPath,
      metaLeft: type == LibraryContentType.pdf
          ? (item.pagesCount != null ? '${item.pagesCount} Pages' : null)
          : item.readTime,
      metaLeftIcon: type == LibraryContentType.pdf
          ? Icons.description_outlined
          : Icons.timer_outlined,
      metaRight: type == LibraryContentType.pdf
          ? '${item.downloadsCount ?? 0} Downloads'
          : (type == LibraryContentType.quiz
                ? null
                : '${item.viewsCount ?? 0} views'),
      metaRightIcon: type == LibraryContentType.pdf
          ? Icons.download_outlined
          : Icons.visibility_outlined,
      ctaLabel: type == LibraryContentType.quiz ? 'Start Quiz Now' : null,
      isBookmarked: item.isSaved ?? false,
      quizId: item.quizId,
      pdfUrl: item.pdfUrl,
    );
  }
}
