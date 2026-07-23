import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/quiz/domain/models/quiz_result_model.dart';
import 'package:respilink_mobile/features/quiz/domain/models/reinforce_content_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_results_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_results_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_results_state.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_results_app_bar.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_skeletons.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_stat_card.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/reinforce_knowledge_section.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/score_gauge.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/streak_badge_banner.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/view_leaderboard_button.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

// Not returned by the quiz-results API; kept as curated static suggestions.
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

class QuizResultsView extends StatefulWidget {
  final int quizId;

  const QuizResultsView({super.key, required this.quizId});

  @override
  State<QuizResultsView> createState() => _QuizResultsViewState();
}

class _QuizResultsViewState extends State<QuizResultsView> {
  @override
  void initState() {
    super.initState();
    context.read<QuizResultsBloc>().add(
      QuizResultsRequested(quizId: widget.quizId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const QuizResultsAppBar(),
      body: SafeArea(
        top: false,
        child: BlocBuilder<QuizResultsBloc, QuizResultsState>(
          builder: (context, state) {
            if (state is QuizResultsFailed) {
              return RequestFailed(message: state.message);
            }

            if (state is! QuizResultsLoaded) {
              return const QuizResultsSkeleton();
            }

            return _QuizResultsBody(quizId: widget.quizId, result: state.result);
          },
        ),
      ),
    );
  }
}

class _QuizResultsBody extends StatelessWidget {
  final int quizId;
  final QuizResultModel result;

  const _QuizResultsBody({required this.quizId, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                AppText.large(
                  label: result.performanceTitle,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                AppText.small(
                  label: result.performanceSubtitle,
                  color: AppColors.grey,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          Center(
            child: ScoreGauge(
              scorePercent: result.scorePercent,
              globalRank: result.globalRank,
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
                  value: '${result.correctCount}/${result.totalCount}',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: QuizStatCard(
                  icon: Icons.timer_outlined,
                  iconColor: AppColors.purpleAccent,
                  label: 'Time Taken',
                  value: result.timeTaken,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          if (result.badgeEarned.isNotEmpty) ...[
            StreakBadgeBanner(
              streakLabel: result.streakLabel,
              badgeEarned: result.badgeEarned,
            ),
            SizedBox(height: 16.h),
          ],

          ViewLeaderboardButton(
            onTap: () => locator<NavigationService>().navigate(
              RouterStrings.leaderboard,
              arguments: quizId,
            ),
          ),

          //SizedBox(height: 24.h),
          //ReinforceKnowledgeSection(items: _reinforceContent),
        ],
      ),
    );
  }
}
