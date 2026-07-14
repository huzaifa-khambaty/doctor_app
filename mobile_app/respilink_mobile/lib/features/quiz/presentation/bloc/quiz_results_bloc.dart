import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_results_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/quiz/domain/models/quiz_result_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_results_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_results_state.dart';

class QuizResultsBloc extends Bloc<QuizResultsEvent, QuizResultsState> {
  final QuizRepository _repository;

  QuizResultsBloc(this._repository) : super(QuizResultsLoading()) {
    on<QuizResultsRequested>(_fetchResults);
  }

  Future<void> _fetchResults(
    QuizResultsRequested event,
    Emitter<QuizResultsState> emit,
  ) async {
    emit(QuizResultsLoading());

    final res = await _repository.getQuizResults(event.quizId);

    if (res.success && res.data != null) {
      emit(QuizResultsLoaded(result: _mapResult(res.data!)));
    } else {
      emit(QuizResultsFailed(message: res.fullErrorMessage));
    }
  }

  QuizResultModel _mapResult(QuizResultsModel model) {
    final result = model.result;
    final achievement = model.achievement;

    return QuizResultModel(
      scorePercent: result?.scorePercentage ?? 0,
      performanceTitle:
          result?.message ?? model.quiz?.title ?? 'Quiz Completed',
      performanceSubtitle: result?.subMessage ?? '',
      globalRank: model.ranking?.currentRank ?? 0,
      correctCount: result?.correctAnswers ?? 0,
      totalCount: result?.totalQuestions ?? 0,
      timeTaken: result?.timeTaken ?? '',
      streakLabel: achievement?.subtitle ?? '',
      badgeEarned: achievement?.title ?? '',
    );
  }
}
