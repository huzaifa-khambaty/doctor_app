import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/article_update_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/daily_challenge_summary_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/daily_challenge_banner.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/engage_banner.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/latest_updates_section.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/welcome_header.dart';
import 'package:respilink_mobile/features/events/domain/models/event_model.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/up_next_section.dart';

import '../../../../exports.dart';

const int _eventsTabIndex = 1;

// TODO: replace with real data from the backend once the home feed API is wired up.
const _dailyChallengeSummary = DailyChallengeSummaryModel(
  title: 'Quiz of the day',
  subtitle: 'Test your knowledge on Interstitial Lung Disease.',
  globalRank: 14,
);

const _upcomingEvents = [
  EventModel(
    id: 1,
    type: EventType.webinar,
    title: 'Advanced COPD Management & New Therapeutics',
    dateLabel: 'Today',
    timeLabel: '4:00 PM',
    image: 'copd.png',
  ),
  EventModel(
    id: 2,
    type: EventType.conference,
    title: 'Future of Asthma Care',
    dateLabel: 'Mar 28',
    timeLabel: '9:00 AM',
    image: 'respiratory.png',
  ),
];

const _articles = [
  ArticleUpdateModel(
    category: ArticleCategory.research,
    title: 'New Guidelines for Pediatric Asthma',
    meta: '2 hours ago • 5 min read',
    image: 'respiratory.png',
  ),
  ArticleUpdateModel(
    category: ArticleCategory.pharma,
    title: 'Breakthrough in Biologic Therapies',
    meta: '5 hours ago • 8 min read',
    image: 'copd.png',
  ),
  ArticleUpdateModel(
    category: ArticleCategory.tech,
    title: 'AI-Powered Diagnostics in Radiology',
    meta: 'Yesterday • 12 min read',
    image: 'take_quiz.png',
  ),
];

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeHeader(),

            SizedBox(height: 20.h),

            EngageBanner(onExplore: () {
              // TODO: navigate to the community forum once it exists.
            }),

            SizedBox(height: 24.h),

            UpNextSection(
              events: _upcomingEvents,
              onViewAll: () => context.read<DashboardBloc>().add(
                ChangeTabRequested(_eventsTabIndex),
              ),
            ),

            SizedBox(height: 24.h),

            DailyChallengeBanner(
              summary: _dailyChallengeSummary,
              onStart: () {
                // TODO: navigate to the quiz-taking flow once it exists.
              },
            ),

            SizedBox(height: 24.h),

            LatestUpdatesSection(articles: _articles),
          ],
        ),
      ),
    );
  }
}
