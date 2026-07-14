import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_state.dart';

class QuizAttemptBloc extends Bloc<QuizAttemptEvent, QuizAttemptState> {
  final QuizRepository _repository;

  QuizAttemptBloc(this._repository) : super(QuizAttemptInitial()) {
    on<QuizAttemptStartRequested>(_start);
  }

  Future<void> _start(
    QuizAttemptStartRequested event,
    Emitter<QuizAttemptState> emit,
  ) async {
    emit(QuizAttemptStarting(quizId: event.quizId));

    final res = await _repository.startQuizAttempt(event.quizId);

    if (res.success) {
      emit(QuizAttemptStarted(quizId: event.quizId));
    } else {
      emit(QuizAttemptFailed(message: res.fullErrorMessage));
    }
  }
}
