import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_review_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_review_state.dart';

class QuizReviewBloc extends Bloc<QuizReviewEvent, QuizReviewState> {
  final QuizRepository _repository;

  QuizReviewBloc(this._repository) : super(QuizReviewLoading()) {
    on<QuizReviewRequested>(_fetchReview);
  }

  Future<void> _fetchReview(
    QuizReviewRequested event,
    Emitter<QuizReviewState> emit,
  ) async {
    emit(QuizReviewLoading());

    final res = await _repository.getQuizCorrectAnswers(event.quizId);
    final questions = res.data?.questions ?? const [];

    if (res.success && questions.isNotEmpty) {
      emit(QuizReviewLoaded(quiz: res.data!.quiz, questions: questions));
    } else if (res.success) {
      emit(QuizReviewFailed(message: 'No questions found for this quiz.'));
    } else {
      emit(QuizReviewFailed(message: res.fullErrorMessage));
    }
  }
}
