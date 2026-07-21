import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/content_library/domain/repositories/content_library_repository.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/content_details_event.dart';
import 'package:respilink_mobile/features/content_library/presentation/bloc/content_details_state.dart';

class ContentDetailsBloc extends Bloc<ContentDetailsEvent, ContentDetailsState> {
  final ContentLibraryRepository _repository;
  int? _contentId;

  ContentDetailsBloc(this._repository) : super(ContentDetailsLoading()) {
    on<ContentDetailsRequested>(_fetch);
    on<ContentLikeToggled>(_toggleLike);
    on<ContentBookmarkToggled>(_toggleBookmark);
  }

  Future<void> _fetch(
    ContentDetailsRequested event,
    Emitter<ContentDetailsState> emit,
  ) async {
    _contentId = event.contentId;
    emit(ContentDetailsLoading());

    final res = await _repository.getLibraryDetails(event.contentId);

    if (res.success && res.data != null) {
      emit(ContentDetailsLoaded(details: res.data!));
    } else {
      emit(ContentDetailsFailed(message: res.fullErrorMessage));
    }
  }

  Future<void> _toggleLike(
    ContentLikeToggled event,
    Emitter<ContentDetailsState> emit,
  ) async {
    final current = state;
    final id = _contentId;
    if (current is! ContentDetailsLoaded || id == null) return;

    final wasLiked = current.details.isLiked ?? false;
    final likes = current.details.likes ?? 0;

    // Optimistic update — revert if the request fails.
    current.details.isLiked = !wasLiked;
    current.details.likes = wasLiked ? likes - 1 : likes + 1;
    emit(current.copyWith());

    final res = wasLiked
        ? await _repository.unLikeContent(id)
        : await _repository.likeContent(id);

    if (!res.success) {
      current.details.isLiked = wasLiked;
      current.details.likes = likes;
      emit(current.copyWith());
    }
  }

  Future<void> _toggleBookmark(
    ContentBookmarkToggled event,
    Emitter<ContentDetailsState> emit,
  ) async {
    final current = state;
    final id = _contentId;
    if (current is! ContentDetailsLoaded || id == null) return;

    final wasSaved = current.details.isSaved ?? false;

    current.details.isSaved = !wasSaved;
    emit(current.copyWith());

    final res = wasSaved
        ? await _repository.removeBookmark(id)
        : await _repository.bookmark(id);

    if (!res.success) {
      current.details.isSaved = wasSaved;
      emit(current.copyWith());
    }
  }
}
