import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/badges_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/badges_state.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';

class BadgesBloc extends Bloc<BadgesEvent, BadgesState> {
  final QuizRepository _repository;

  BadgesBloc(this._repository) : super(BadgesLoading()) {
    on<BadgesRequested>(_fetchBadges);
  }

  Future<void> _fetchBadges(
    BadgesRequested event,
    Emitter<BadgesState> emit,
  ) async {
    emit(BadgesLoading());

    final res = await _repository.getBadgesOverview();

    if (res.success && res.data != null) {
      emit(BadgesLoaded(badges: res.data!));
    } else {
      emit(BadgesFailed(message: res.fullErrorMessage));
    }
  }
}
