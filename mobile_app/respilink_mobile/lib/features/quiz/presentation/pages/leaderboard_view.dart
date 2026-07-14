import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_leaderboard_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_leaderboard_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_leaderboard_state.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/leaderboard_app_bar.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/medical_leaderboard_widget.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/ranking_row.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/rankings_section_header.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class LeaderboardView extends StatefulWidget {
  final int quizId;

  const LeaderboardView({super.key, required this.quizId});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  @override
  void initState() {
    super.initState();
    context.read<QuizLeaderboardBloc>().add(
      QuizLeaderboardRequested(quizId: widget.quizId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const LeaderboardAppBar(),
      body: SafeArea(
        top: false,
        child: BlocBuilder<QuizLeaderboardBloc, QuizLeaderboardState>(
          builder: (context, state) {
            if (state is QuizLeaderboardFailed) {
              return RequestFailed(message: state.message);
            }

            if (state is! QuizLeaderboardLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MedicalLeaderboardWidget(topThree: state.topThree),

                  SizedBox(height: 12.h),

                  RankingsSectionHeader(
                    onAllSpecialtiesTap: () {
                      // TODO: wire specialty filtering once it exists.
                    },
                  ),

                  SizedBox(height: 8.h),

                  for (final entry in state.rankings)
                    RankingRow(entry: entry),

                  if (state.currentUser != null) ...[
                    SizedBox(height: 8.h),
                    RankingRow(
                      entry: state.currentUser!,
                      onViewBadgeTap: () => locator<NavigationService>()
                          .navigate(RouterStrings.badges),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
