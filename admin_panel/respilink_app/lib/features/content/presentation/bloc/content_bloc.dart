import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/content/domain/repositories/content_repository.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_event.dart';
import 'package:respilink_app/features/content/presentation/bloc/content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository _repository;

  ContentBloc(this._repository) : super(const ContentState()) {
    on<FetchContentsRequested>(_fetchContents);
    on<FetchContentSpecialtiesRequested>(_fetchSpecialties);
    on<FetchContentQuizzesRequested>(_fetchQuizzes);
    on<CreateContentRequested>(_createContent);
    on<UpdateContentRequested>(_updateContent);
    on<DeleteContentRequested>(_deleteContent);
    on<UpdateContentStatusRequested>(_updateContentStatus);
  }

  Future<void> _fetchContents(
    FetchContentsRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(isLoadingContents: true));
    final res = await _repository.getContents(
      page: event.page,
      status: event.status,
      search: event.search,
    );
    if (res.success && res.data != null) {
      emit(state.copyWith(contentData: res.data!, isLoadingContents: false));
    } else {
      emit(state.copyWith(isLoadingContents: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _fetchSpecialties(
    FetchContentSpecialtiesRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(isLoadingSpecialties: true));
    final res = await _repository.getSpecialties();
    if (res.success && res.data != null) {
      emit(state.copyWith(specialties: res.data!, isLoadingSpecialties: false));
    } else {
      emit(state.copyWith(isLoadingSpecialties: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _fetchQuizzes(
    FetchContentQuizzesRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(isLoadingQuizzes: true));
    final res = await _repository.getQuizzes();
    if (res.success && res.data != null) {
      emit(state.copyWith(quizzes: res.data!, isLoadingQuizzes: false));
    } else {
      emit(state.copyWith(isLoadingQuizzes: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _createContent(
    CreateContentRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final res = await _repository.createContent(event.request);
    if (res.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));
    } else {
      emit(state.copyWith(isSubmitting: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _updateContent(
    UpdateContentRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));
    final res = await _repository.updateContent(event.contentId, event.request);
    if (res.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));
    } else {
      emit(state.copyWith(isSubmitting: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _deleteContent(
    DeleteContentRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, actioningContentId: event.contentId));
    final res = await _repository.deleteContent(event.contentId);
    if (res.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true, clearActioningId: true));
    } else {
      emit(state.copyWith(isSubmitting: false, error: res.fullErrorMessage, clearActioningId: true));
    }
  }

  Future<void> _updateContentStatus(
    UpdateContentStatusRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, actioningContentId: event.contentId));
    final res = await _repository.updateStatus(event.contentId, event.status);
    if (res.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true, clearActioningId: true));
    } else {
      emit(state.copyWith(isSubmitting: false, error: res.fullErrorMessage, clearActioningId: true));
    }
  }
}
