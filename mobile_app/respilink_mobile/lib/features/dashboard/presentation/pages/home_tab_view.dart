import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:respilink_mobile/core/utils/date_time_utils.dart';
import 'package:respilink_mobile/features/dashboard/data/model/home_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/article_update_model.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/daily_challenge_summary_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/home_event.dart';
import 'package:respilink_mobile/features/dashboard/presentation/bloc/home_state.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/daily_challenge_banner.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/engage_banner.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/home_skeletons.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/latest_updates_section.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/welcome_header.dart';
import 'package:respilink_mobile/features/events/domain/models/event_model.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/up_next_section.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_bloc.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_event.dart';
import 'package:respilink_mobile/features/quiz/presentation/bloc/quiz_attempt_state.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

const int _eventsTabIndex = 1;
const int _quizTabIndex = 2;

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  bool _startingDailyChallenge = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeRequested());
  }

  void _startDailyChallenge(int? quizId) {
    if (quizId == null || _startingDailyChallenge) return;

    setState(() => _startingDailyChallenge = true);
    context.read<QuizAttemptBloc>().add(
      QuizAttemptStartRequested(quizId: quizId),
    );
  }

  void _openEvent(EventModel event) {
    final route = switch (event.type) {
      EventType.webinar => RouterStrings.webinarDetail,
      EventType.workshop => RouterStrings.workshopDetail,
      EventType.conference => RouterStrings.conferenceDetail,
    };
    locator<NavigationService>().navigate(route, arguments: event.id);
  }

  void _openContent(ArticleUpdateModel article) {
    if (article.typeSlug == 'article' || article.typeSlug == 'webinar') {
      locator<NavigationService>().navigate(
        RouterStrings.articleReaderView,
        arguments: article.id,
      );
    } else {
      // Feed items don't carry a real quiz id — send them to the Quiz tab
      // instead of guessing one and risking a wrong navigation.
      context.read<DashboardBloc>().add(ChangeTabRequested(_quizTabIndex));
    }
  }

  EventType _eventTypeFrom(String? type) => switch (type?.toLowerCase()) {
    'webinar' => EventType.webinar,
    'conference' => EventType.conference,
    _ => EventType.workshop,
  };

  EventModel _mapEvent(Events event) {
    final dt = DateTimeUtils.parseBackendDate(event.startsAt);

    return EventModel(
      id: event.id ?? 0,
      type: _eventTypeFrom(event.type),
      title: event.title ?? '',
      dateLabel: dt != null ? DateFormat('MMM d, yyyy').format(dt.toLocal()) : '',
      timeLabel: dt != null ? DateFormat.jm().format(dt.toLocal()) : '',
      image: event.bannerUrl ?? '',
    );
  }

  ArticleUpdateModel _mapContent(Contents content) {
    final slug = (content.typeSlug ?? '').toLowerCase();
    final color = switch (slug) {
      'article' => AppColors.tertiary,
      'webinar' => AppColors.primary,
      'quiz' => AppColors.purpleAccent,
      _ => AppColors.grey,
    };

    return ArticleUpdateModel(
      id: content.id ?? 0,
      typeSlug: slug,
      typeLabel: content.typeName ?? slug,
      typeColor: color,
      title: content.title ?? '',
      meta: content.readTime ?? '',
      thumbnailUrl: content.thumbnailUrl,
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
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeFailed) {
            SnackbarUtil.showSnackbar(message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: AppRefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(HomeRequested());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WelcomeHeader(),
                    SizedBox(height: 20.h),
                    _buildBody(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state is HomeFailed) {
      return SizedBox(
        height: 240.h,
        child: RequestFailed(message: state.message),
      );
    }

    if (state is! HomeLoaded) {
      return const HomeContentSkeleton();
    }

    final model = state.model;
    final hero = model.hero;
    final quiz = model.quiz;
    final events = [
      for (final event in model.events ?? const <Events>[]) _mapEvent(event),
    ];
    final contents = [
      for (final content in model.contents ?? const <Contents>[])
        _mapContent(content),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EngageBanner(
          title: hero?.title ?? 'Engage. Learn. Collaborate.',
          subtitle:
              hero?.subtitle ??
              'Join 5,000+ clinicians in the Respiratory Excellence Forum.',
          buttonText: hero?.buttonText ?? 'Explore Now',
          onExplore: () {
            context.read<DashboardBloc>().add(ChangeTabRequested(1));
          },
        ),

        SizedBox(height: 24.h),

        UpNextSection(
          events: events,
          onViewAll: () => context.read<DashboardBloc>().add(
            ChangeTabRequested(_eventsTabIndex),
          ),
          onEventTap: _openEvent,
        ),

        if (quiz != null) ...[
          SizedBox(height: 24.h),
          DailyChallengeBanner(
            summary: DailyChallengeSummaryModel(
              quizId: quiz.id,
              title: quiz.title ?? 'Quiz of the Day',
              subtitle: quiz.description ?? '',
              globalRank: quiz.yourRank,
            ),
            isLoading: _startingDailyChallenge,
            onStart: () => _startDailyChallenge(quiz.id),
          ),
        ],

        SizedBox(height: 24.h),

        LatestUpdatesSection(articles: contents, onArticleTap: _openContent),
      ],
    );
  }
}
