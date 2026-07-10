import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:respilink_app/features/quiz/presentation/bloc/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;

  QuizBloc(this._repository) : super(const QuizState()) {
    on<FetchTopicsRequested>(_fetchTopics);
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
}
