import 'package:respilink_mobile/features/dashboard/domain/models/daily_challenge_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/doctor_status_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/leaderboard_entry_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/specialized_topic_model.dart';

abstract class QuizHomeState {}

class QuizHomeLoading extends QuizHomeState {}

class QuizHomeLoaded extends QuizHomeState {
  final DoctorStatusModel status;
  final DailyChallengeModel? dailyChallenge;
  final List<SpecializedTopicModel> topics;
  final List<LeaderboardEntryModel> leaderboard;

  QuizHomeLoaded({
    required this.status,
    required this.dailyChallenge,
    required this.topics,
    required this.leaderboard,
  });
}

class QuizHomeFailed extends QuizHomeState {
  final String message;

  QuizHomeFailed({required this.message});
}
