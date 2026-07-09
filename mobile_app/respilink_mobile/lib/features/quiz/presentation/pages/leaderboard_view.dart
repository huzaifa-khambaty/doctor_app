import 'package:respilink_mobile/features/quiz/domain/models/quiz_leaderboard_entry_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/leaderboard_app_bar.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/leaderboard_tab_selector.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/medical_leaderboard_widget.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/monthly_elite_header.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/ranking_row.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/rankings_section_header.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the leaderboard API is wired up.
const _rankings = [
  QuizLeaderboardEntryModel(
    rank: 4,
    name: 'Dr. Sarah Chen',
    specialty: 'Pulmonology',
    location: 'Beijing',
    avatarUrl: 'assets/images/doctor.jpg',
    points: 8240,
    changeLabel: '+120 Today',
    changeDirection: RankChangeDirection.up,
  ),
  QuizLeaderboardEntryModel(
    rank: 5,
    name: 'Dr. Julian Ross',
    specialty: 'ICU Specialist',
    location: 'London',
    avatarUrl: 'assets/images/doctor.jpg',
    points: 7815,
    changeLabel: '-4 Ranks',
    changeDirection: RankChangeDirection.down,
  ),
  QuizLeaderboardEntryModel(
    rank: 6,
    name: 'Dr. Maria Garcia',
    specialty: 'General Practice',
    location: 'Madrid',
    avatarUrl: 'assets/images/doctor.jpg',
    points: 7102,
    changeLabel: '+24 Today',
    changeDirection: RankChangeDirection.up,
  ),
  QuizLeaderboardEntryModel(
    rank: 7,
    name: 'Dr. Amir Jafari',
    specialty: 'Chest Physician',
    location: 'Dubai',
    points: 6950,
  ),
];

const _currentUser = QuizLeaderboardEntryModel(
  rank: 42,
  name: 'Dr. Alex Doe',
  avatarUrl: 'assets/images/doctor.jpg',
  points: 4210,
  pointsToNextRank: 240,
  isCurrentUser: true,
);

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const LeaderboardAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MonthlyEliteHeader(timeRemainingLabel: '12d 4h left'),

              SizedBox(height: 16.h),

              LeaderboardTabSelector(controller: _tabController),

              SizedBox(height: 12.h),

              const MedicalLeaderboardWidget(),

              SizedBox(height: 12.h),

              RankingsSectionHeader(
                onAllSpecialtiesTap: () {
                  // TODO: wire specialty filtering once it exists.
                },
              ),

              SizedBox(height: 8.h),

              for (final entry in _rankings) RankingRow(entry: entry),

              SizedBox(height: 8.h),

              RankingRow(
                entry: _currentUser,
                onViewBadgeTap: () =>
                    locator<NavigationService>().navigate(RouterStrings.badges),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
