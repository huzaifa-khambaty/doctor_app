import 'package:respilink_mobile/features/dashboard/domain/models/daily_challenge_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/doctor_status_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/leaderboard_entry_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/specialized_topic_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/countdown_timer.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/current_status_card.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/daily_challenge_card.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/peer_leaderboard_card.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/specialized_topics_grid.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the quiz API is wired up.
const _status = DoctorStatusModel(rank: 12, streak: 5);

final _dailyChallenge = DailyChallengeModel(
  title: 'Managing Acute Asthma',
  description:
      'Test your clinical decision-making skills in emergency respiratory care settings.',
  xp: 500,
  timeRemaining: const Duration(hours: 14, minutes: 22, seconds: 4),
  image: 'take_quiz.png',
);

const _specializedTopics = [
  SpecializedTopicModel(
    title: 'COPD Path',
    subtitle: '12 Clinical Cases',
    icon: Icons.circle_outlined,
    accentColor: AppColors.primary,
    progress: 0.6,
  ),
  SpecializedTopicModel(
    title: 'Pharmacology',
    subtitle: '8 Modules',
    icon: Icons.medication_outlined,
    accentColor: AppColors.purpleAccent,
    progress: 0.35,
  ),
  SpecializedTopicModel(
    title: 'Pediatrics',
    subtitle: '15 Quizzes',
    icon: Icons.child_care_outlined,
    accentColor: AppColors.yellow,
    progress: 0.8,
  ),
  SpecializedTopicModel(
    title: 'Diagnostics',
    subtitle: '20 Questions',
    icon: Icons.medical_services_outlined,
    accentColor: AppColors.primary,
    progress: 0.5,
  ),
];

const _leaderboard = [
  LeaderboardEntryModel(rank: 1, name: 'Dr. Sarah K.', points: 2450),
  LeaderboardEntryModel(rank: 2, name: 'Dr. James L.', points: 2310),
];

class QuizTabView extends StatelessWidget {
  const QuizTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CurrentStatusCard(status: _status),

            SizedBox(height: 24.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.medium(
                  label: 'Daily Challenge',
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
                CountdownTimer(duration: _dailyChallenge.timeRemaining),
              ],
            ),
            SizedBox(height: 10.h),
            DailyChallengeCard(
              challenge: _dailyChallenge,
              onStart: () =>
                  locator<NavigationService>().navigate(RouterStrings.quizPlay),
            ),

            SizedBox(height: 24.h),

            AppText.medium(
              label: 'Specialized Topics',
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
            SizedBox(height: 12.h),
            const SpecializedTopicsGrid(topics: _specializedTopics),

            SizedBox(height: 24.h),

            const PeerLeaderboardCard(entries: _leaderboard),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
