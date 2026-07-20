import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_home_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_home_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/quiz_home_state.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/countdown_timer.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/current_status_card.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/daily_challenge_card.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/peer_leaderboard_card.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/specialized_topics_grid.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_state.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/quiz_skeletons.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class QuizTabView extends StatefulWidget {
  const QuizTabView({super.key});

  @override
  State<QuizTabView> createState() => _QuizTabViewState();
}

class _QuizTabViewState extends State<QuizTabView> {
  bool _startingDailyChallenge = false;

  @override
  void initState() {
    super.initState();
    context.read<QuizHomeBloc>().add(QuizHomeRequested());
  }

  void _startDailyChallenge(int? quizId) {
    if (quizId == null || _startingDailyChallenge) return;

    setState(() => _startingDailyChallenge = true);
    context.read<QuizAttemptBloc>().add(
      QuizAttemptStartRequested(quizId: quizId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizAttemptBloc, QuizAttemptState>(
      listener: (context, attemptState) {
        if (attemptState is QuizAttemptStarted) {
          setState(() => _startingDailyChallenge = false);
          locator<NavigationService>().navigate(
            RouterStrings.quizPlay,
            arguments: attemptState.quizId,
          );
        } else if (attemptState is QuizAttemptFailed) {
          setState(() => _startingDailyChallenge = false);
          SnackbarUtil.showSnackbar(
            message: attemptState.message,
            isError: true,
          );
        }
      },
      child: BlocConsumer<QuizHomeBloc, QuizHomeState>(
        listener: (context, state) {
          if (state is QuizHomeFailed) {
            SnackbarUtil.showSnackbar(message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          return SafeArea(top: false, child: _buildBody(state));
        },
      ),
    );
  }

  Widget _buildBody(QuizHomeState state) {
    if (state is QuizHomeFailed) {
      return RequestFailed(message: state.message);
    }

    if (state is! QuizHomeLoaded) {
      return const QuizHomeSkeleton();
    }

    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<QuizHomeBloc>().add(QuizHomeRequested());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentStatusCard(status: state.status),

            if (state.dailyChallenge != null) ...[
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.medium(
                    label: 'Daily Challenge',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                  CountdownTimer(duration: state.dailyChallenge!.timeRemaining),
                ],
              ),
              SizedBox(height: 10.h),
              DailyChallengeCard(
                challenge: state.dailyChallenge!,
                isLoading: _startingDailyChallenge,
                onStart: () =>
                    _startDailyChallenge(state.dailyChallenge!.quizId),
              ),
            ],

            if (state.topics.isNotEmpty) ...[
              SizedBox(height: 24.h),
              AppText.medium(
                label: 'Specialized Topics',
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
              SizedBox(height: 12.h),
              SpecializedTopicsGrid(
                topics: state.topics,
                onTopicTap: (topic) => locator<NavigationService>().navigate(
                  RouterStrings.topicQuizList,
                  arguments: topic,
                ),
              ),
            ],

            if (state.leaderboard.isNotEmpty) ...[
              SizedBox(height: 24.h),
              PeerLeaderboardCard(entries: state.leaderboard),
            ],

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
