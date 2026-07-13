import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;

  QuizBloc(this._repository) : super(const QuizState()) {
    on<FetchTopicsRequested>(_fetchTopics);
    on<FetchQuizzesRequested>(_fetchQuizzes);
    on<PublishQuizRequested>(_publishQuiz);
    on<FetchQuizDetailRequested>(_fetchQuizDetail);
    on<UpdateQuizRequested>(_updateQuiz);
    on<ToggleQuizStatusRequested>(_toggleStatus);
    on<DeleteQuizRequested>(_deleteQuiz);
    on<ResetQuizFormRequested>((_, emit) => emit(state.copyWith(
          isSubmitting: false,
          submitSuccess: false,
        )));
  }

  Future<void> _fetchTopics(
    FetchTopicsRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isLoadingTopics: true));
    final res = await _repository.getTopics();
    if (res.success && res.data != null) {
      emit(state.copyWith(topics: res.data!, isLoadingTopics: false));
    } else {
      emit(state.copyWith(isLoadingTopics: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _fetchQuizzes(
    FetchQuizzesRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isLoadingQuizzes: true));
    final res = await _repository.getQuizzes(page: event.page);
    if (res.success && res.data != null) {
      final paged = res.data!;
      emit(state.copyWith(
        quizzes: paged.data ?? [],
        isLoadingQuizzes: false,
        currentPage: paged.currentPage ?? 1,
        lastPage: paged.lastPage ?? 1,
        totalQuizzes: paged.total ?? 0,
      ));
    } else {
      emit(state.copyWith(
        isLoadingQuizzes: false,
        error: res.fullErrorMessage,
      ));
    }
  }

  Future<void> _fetchQuizDetail(
    FetchQuizDetailRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetail: true, quizDetail: null));
    final res = await _repository.getQuizDetail(event.quizId);
    if (res.success && res.data != null) {
      emit(state.copyWith(isLoadingDetail: false, quizDetail: res.data));
    } else {
      emit(state.copyWith(isLoadingDetail: false, error: res.fullErrorMessage));
    }
  }

  Future<void> _updateQuiz(
    UpdateQuizRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final updateRes = await _repository.updateQuiz(event.quizId, event.updateRequest);
    if (!updateRes.success) {
      emit(state.copyWith(isSubmitting: false, error: updateRes.fullErrorMessage));
      return;
    }

    final questionsRes = await _repository.updateQuizQuestions(
      event.quizId,
      event.questionsRequest,
    );

    if (questionsRes.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));
    } else {
      emit(state.copyWith(isSubmitting: false, error: questionsRes.fullErrorMessage));
    }
  }

  Future<void> _publishQuiz(
    PublishQuizRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final createRes = await _repository.createQuiz(event.createRequest);
    if (!createRes.success || createRes.data == null) {
      emit(state.copyWith(
        isSubmitting: false,
        error: createRes.fullErrorMessage,
      ));
      return;
    }

    final quizId = createRes.data!;
    final questionsRes = await _repository.addQuizQuestions(
      quizId,
      event.questionsRequest,
    );

    if (questionsRes.success) {
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));
    } else {
      emit(state.copyWith(
        isSubmitting: false,
        error: questionsRes.fullErrorMessage,
      ));
    }
  }

  Future<void> _toggleStatus(
    ToggleQuizStatusRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(actioningQuizId: event.quizId));
    final res = event.publish
        ? await _repository.publishQuiz(event.quizId)
        : await _repository.unpublishQuiz(event.quizId);

    if (res.success) {
      emit(state.copyWith(
        actioningQuizId: null,
        actionSuccess: true,
      ));
      add(FetchQuizzesRequested(page: state.currentPage));
    } else {
      emit(state.copyWith(
        actioningQuizId: null,
        error: res.fullErrorMessage,
      ));
    }
  }

  Future<void> _deleteQuiz(
    DeleteQuizRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(actioningQuizId: event.quizId));
    final res = await _repository.deleteQuiz(event.quizId);

    if (res.success) {
      emit(state.copyWith(
        actioningQuizId: null,
        actionSuccess: true,
      ));
      add(FetchQuizzesRequested(page: state.currentPage));
    } else {
      emit(state.copyWith(
        actioningQuizId: null,
        error: res.fullErrorMessage,
      ));
    }
  }
}
