import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_list_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_list_state.dart';

class QuizListBloc extends Bloc<QuizListEvent, QuizListState> {
  final QuizRepository _repository;

  QuizListBloc(this._repository) : super(QuizListLoading()) {
    on<QuizListRequested>(_fetchQuizList);
  }

  Future<void> _fetchQuizList(
    QuizListRequested event,
    Emitter<QuizListState> emit,
  ) async {
    emit(QuizListLoading());

    final res = await _repository.getTopicQuizzes(event.topicId);

    if (res.success && res.data != null) {
      final listing = res.data!;
      emit(
        QuizListLoaded(topic: listing.topic, quizzes: listing.data ?? []),
      );
    } else {
      emit(QuizListFailed(message: res.fullErrorMessage));
    }
  }
}
