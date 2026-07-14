import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/requests/submit_quiz_answers_request.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_play_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_play_state.dart';

class QuizPlayBloc extends Bloc<QuizPlayEvent, QuizPlayState> {
  final QuizRepository _repository;
  int? _quizId;

  QuizPlayBloc(this._repository) : super(QuizPlayLoading()) {
    on<QuizQuestionsRequested>(_fetchQuestions);
    on<QuizOptionToggled>(_toggleOption);
    on<QuizAnswerSubmitted>(_submitAnswer);
    on<QuizTimeExpired>(_handleTimeExpired);
  }

  Future<void> _fetchQuestions(
    QuizQuestionsRequested event,
    Emitter<QuizPlayState> emit,
  ) async {
    emit(QuizPlayLoading());
    _quizId = event.quizId;

    final res = await _repository.getQuizQuestionAnswers(event.quizId);
    final questions = res.data?.questions ?? const <Questions>[];

    if (res.success && questions.isNotEmpty) {
      emit(
        QuizPlayLoaded(
          quiz: res.data!.quiz ?? Quiz(id: event.quizId),
          questions: questions,
          currentIndex: 0,
          selectedOptionIds: const {},
        ),
      );
    } else if (res.success) {
      emit(QuizPlayFailed(message: 'No questions found for this quiz.'));
    } else {
      emit(QuizPlayFailed(message: res.fullErrorMessage));
    }
  }

  void _toggleOption(QuizOptionToggled event, Emitter<QuizPlayState> emit) {
    final state = this.state;
    if (state is! QuizPlayLoaded || state.isSubmitting) return;

    final isMultiple = state.currentQuestion.isMultiple ?? false;
    final updated = Set<int>.from(state.selectedOptionIds);

    if (isMultiple) {
      if (!updated.remove(event.optionId)) updated.add(event.optionId);
    } else {
      updated
        ..clear()
        ..add(event.optionId);
    }

    emit(state.copyWith(selectedOptionIds: updated));
  }

  Future<void> _submitAnswer(
    QuizAnswerSubmitted event,
    Emitter<QuizPlayState> emit,
  ) async {
    final state = this.state;
    final quizId = _quizId;
    if (state is! QuizPlayLoaded ||
        state.isSubmitting ||
        state.selectedOptionIds.isEmpty ||
        quizId == null) {
      return;
    }

    final updatedAnswers = _foldCurrentAnswer(state);

    if (!state.isLastQuestion) {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex + 1,
          selectedOptionIds: const {},
          collectedAnswers: updatedAnswers,
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, collectedAnswers: updatedAnswers));

    final res = await _repository.submitQuizAnswers(
      quizId,
      SubmitQuizAnswersRequest(answers: updatedAnswers),
    );

    if (!res.success) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submitError: res.fullErrorMessage,
          collectedAnswers: updatedAnswers,
        ),
      );
      return;
    }

    final submitRes = await _repository.submitQuiz(quizId);

    if (submitRes.success) {
      emit(QuizPlayCompleted());
    } else {
      emit(
        state.copyWith(
          isSubmitting: false,
          submitError: submitRes.fullErrorMessage,
          collectedAnswers: updatedAnswers,
        ),
      );
    }
  }

  Future<void> _handleTimeExpired(
    QuizTimeExpired event,
    Emitter<QuizPlayState> emit,
  ) async {
    final state = this.state;
    final quizId = _quizId;

    if (state is! QuizPlayLoaded || quizId == null) {
      emit(QuizPlayTimeExpired());
      return;
    }

    final answers = _foldCurrentAnswer(state);

    emit(state.copyWith(isSubmitting: true, collectedAnswers: answers));

    if (answers.isNotEmpty) {
      await _repository.submitQuizAnswers(
        quizId,
        SubmitQuizAnswersRequest(answers: answers),
      );
    }
    await _repository.submitQuiz(quizId);

    // Time's up regardless of whether the best-effort submit above
    // succeeded — always exit the quiz.
    emit(QuizPlayTimeExpired());
  }

  /// Folds the currently-selected options (if any) into [state.collectedAnswers],
  /// replacing any prior entry for the same question so retries/duplicate
  /// folds never duplicate an answer.
  List<QuestionAnswer> _foldCurrentAnswer(QuizPlayLoaded state) {
    if (state.selectedOptionIds.isEmpty) return state.collectedAnswers;

    final answer = QuestionAnswer(
      questionId: state.currentQuestion.id ?? 0,
      optionIds: state.selectedOptionIds.toList(),
      isMultiple: state.currentQuestion.isMultiple ?? false,
    );

    return [
      ...state.collectedAnswers.where((a) => a.questionId != answer.questionId),
      answer,
    ];
  }
}
