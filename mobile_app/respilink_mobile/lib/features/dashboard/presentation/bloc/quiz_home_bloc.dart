import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/theme/app_colors.dart';
import 'package:respilink_mobile/features/dashboard/data/model/quiz_home_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/daily_challenge_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/doctor_status_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/leaderboard_entry_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/specialized_topic_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/repositories/quiz_repository.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_home_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_home_state.dart';

class QuizHomeBloc extends Bloc<QuizHomeEvent, QuizHomeState> {
  final QuizRepository _repository;

  QuizHomeBloc(this._repository) : super(QuizHomeLoading()) {
    on<QuizHomeRequested>(_fetchQuizHome);
  }

  static const _topicPalette = [
    AppColors.primary,
    AppColors.purpleAccent,
    AppColors.yellow,
    AppColors.indigoAccent,
  ];

  static const _topicIcons = <String, IconData>{
    'copd': Icons.air_outlined,
    'pharmacology': Icons.medication_outlined,
    'pediatrics': Icons.child_care_outlined,
    'diagnostics': Icons.medical_services_outlined,
    'cardiology': Icons.favorite_border,
    'asthma': Icons.masks_outlined,
    'respiratory': Icons.air_outlined,
  };

  Future<void> _fetchQuizHome(
    QuizHomeRequested event,
    Emitter<QuizHomeState> emit,
  ) async {
    emit(QuizHomeLoading());

    final res = await _repository.getQuizHome();

    if (res.success && res.data != null) {
      final home = res.data!;

      emit(
        QuizHomeLoaded(
          status: DoctorStatusModel(
            rank: home.currentStatus?.rank ?? 0,
            streak: home.currentStatus?.streak ?? 0,
          ),
          dailyChallenge: _mapDailyChallenge(home.dailyChallenge),
          topics: [
            for (final entry in (home.topics ?? []).asMap().entries)
              _mapTopic(entry.value, entry.key),
          ],
          leaderboard: [
            for (final entry in home.leaderboard ?? [])
              LeaderboardEntryModel(
                rank: entry.rank ?? 0,
                name: entry.doctorName ?? '',
                points: entry.points ?? 0,
              ),
          ],
        ),
      );
    } else {
      emit(QuizHomeFailed(message: res.fullErrorMessage));
    }
  }

  DailyChallengeModel? _mapDailyChallenge(DailyChallenge? challenge) {
    if (challenge == null) return null;

    return DailyChallengeModel(
      id: challenge.id,
      title: challenge.title,
      description: challenge.description,
      xp: challenge.xp,
      remainingSeconds: challenge.remainingSeconds,
      banner: challenge.banner,
      quizId: challenge.quizId,
    );
  }

  SpecializedTopicModel _mapTopic(Topics topic, int index) {
    final iconKey = (topic.icon ?? '').toLowerCase();
    final quizCount = topic.totalQuizzes ?? 0;

    return SpecializedTopicModel(
      id: topic.id ?? 0,
      title: topic.name ?? '',
      subtitle: '$quizCount ${quizCount == 1 ? 'Quiz' : 'Quizzes'}',
      icon: _topicIcons[iconKey] ?? Icons.quiz_outlined,
      accentColor: _topicPalette[index % _topicPalette.length],
      progress: (topic.progress ?? 0).clamp(0, 100) / 100,
    );
  }
}
