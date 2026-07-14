import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/quiz/domain/models/quiz_leaderboard_entry_model.dart';
import 'package:respilink_mobile/features/quiz/domain/models/quiz_leaderboard_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_leaderboard_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_leaderboard_state.dart';

class QuizLeaderboardBloc
    extends Bloc<QuizLeaderboardEvent, QuizLeaderboardState> {
  final QuizRepository _repository;

  QuizLeaderboardBloc(this._repository) : super(QuizLeaderboardLoading()) {
    on<QuizLeaderboardRequested>(_fetchLeaderboard);
  }

  Future<void> _fetchLeaderboard(
    QuizLeaderboardRequested event,
    Emitter<QuizLeaderboardState> emit,
  ) async {
    emit(QuizLeaderboardLoading());

    final res = await _repository.getLeaderboard(event.quizId);

    if (res.success && res.data != null) {
      final model = res.data!;
      emit(
        QuizLeaderboardLoaded(
          topThree: [for (final t in model.topThree ?? []) _mapTopThree(t)],
          rankings: [for (final r in model.rankings ?? []) _mapRanking(r)],
          currentUser: _mapCurrentUser(model.currentUser),
        ),
      );
    } else {
      emit(QuizLeaderboardFailed(message: res.fullErrorMessage));
    }
  }

  QuizLeaderboardEntryModel _mapTopThree(TopThree entry) {
    return QuizLeaderboardEntryModel(
      rank: entry.rank ?? 0,
      name: entry.name ?? '',
      specialty: entry.speciality,
      location: entry.location,
      points: entry.points ?? entry.score ?? 0,
    );
  }

  QuizLeaderboardEntryModel _mapRanking(Rankings entry) {
    return QuizLeaderboardEntryModel(
      rank: entry.rank ?? 0,
      name: entry.name ?? '',
      specialty: entry.speciality,
      location: entry.location,
      avatarUrl: entry.avatar,
      points: entry.points ?? entry.score ?? 0,
    );
  }

  QuizLeaderboardEntryModel? _mapCurrentUser(CurrentUser? entry) {
    if (entry == null) return null;

    return QuizLeaderboardEntryModel(
      rank: entry.rank ?? 0,
      name: entry.name ?? '',
      avatarUrl: entry.avatar,
      points: entry.points ?? 0,
      pointsToNextRank: entry.nextRankPoints,
      isCurrentUser: true,
    );
  }
}
