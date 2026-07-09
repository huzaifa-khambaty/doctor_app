import 'package:respilink_mobile/features/quiz/domain/models/quiz_result_model.dart';
import 'package:respilink_mobile/features/quiz/domain/models/reinforce_content_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_results_app_bar.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_stat_card.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/reinforce_knowledge_section.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/score_gauge.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/streak_badge_banner.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/view_leaderboard_button.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the quiz-results API is wired up.
const _result = QuizResultModel(
  scorePercent: 80,
  performanceTitle: 'Exceptional Performance!',
  performanceSubtitle: "You've mastered the Advanced Pulmonology module.",
  globalRank: 14,
  correctCount: 16,
  totalCount: 20,
  timeTaken: '04:12',
  streakLabel: '5-DAY HOT STREAK',
  badgeEarned: 'Clinical Expert Badge Earned',
);

const _reinforceContent = [
  ReinforceContentModel(
    type: ReinforceContentType.article,
    title: 'Advanced COPD Management in 2024',
    image: 'copd.png',
  ),
  ReinforceContentModel(
    type: ReinforceContentType.video,
    title: 'Pathophysiology of Respiratory Failure',
    image: 'respiratory.png',
  ),
];

class QuizResultsView extends StatelessWidget {
  const QuizResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const QuizResultsAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    AppText.large(
                      label: _result.performanceTitle,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    AppText.small(
                      label: _result.performanceSubtitle,
                      color: AppColors.grey,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              Center(
                child: ScoreGauge(
                  scorePercent: _result.scorePercent,
                  globalRank: _result.globalRank,
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: QuizStatCard(
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.primary,
                      label: 'Accuracy',
                      value: '${_result.correctCount}/${_result.totalCount}',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: QuizStatCard(
                      icon: Icons.timer_outlined,
                      iconColor: AppColors.purpleAccent,
                      label: 'Time Taken',
                      value: _result.timeTaken,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              StreakBadgeBanner(
                streakLabel: _result.streakLabel,
                badgeEarned: _result.badgeEarned,
              ),

              SizedBox(height: 16.h),

              ViewLeaderboardButton(
                onTap: () =>
                    locator<NavigationService>().navigate(RouterStrings.leaderboard),
              ),

              SizedBox(height: 24.h),
              ReinforceKnowledgeSection(items: _reinforceContent),
            ],
          ),
        ),
      ),
    );
  }
}
