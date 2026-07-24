import 'package:respilink_mobile/features/auth/presentation/pages/badges_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/change_password_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/edit_profile_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/forgot_password_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/login_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/otp_verification_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/profile_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/register_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/reset_password_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/settings_view.dart';
import 'package:respilink_mobile/features/auth/presentation/pages/splash_view.dart';
import 'package:respilink_mobile/features/content_library/presentation/pages/article_reader_view.dart';
import 'package:respilink_mobile/features/dashboard/domain/models/specialized_topic_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/pages/dashboard_view.dart';
import 'package:respilink_mobile/features/dashboard/presentation/pages/topic_quiz_list_view.dart';
import 'package:respilink_mobile/features/events/presentation/pages/conference_detail_view.dart';
import 'package:respilink_mobile/features/events/presentation/pages/webinar_detail_view.dart';
import 'package:respilink_mobile/features/events/presentation/pages/workshop_detail_view.dart';
import 'package:respilink_mobile/features/onboarding/presentation/pages/onboarding_view.dart';
import 'package:respilink_mobile/features/quiz/presentation/pages/leaderboard_view.dart';
import 'package:respilink_mobile/features/quiz/presentation/pages/quiz_play_view.dart';
import 'package:respilink_mobile/features/quiz/presentation/pages/quiz_results_view.dart';
import 'package:respilink_mobile/features/quiz/presentation/pages/quiz_review_view.dart';
import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/pages/query_chat_view.dart';
import 'package:respilink_mobile/features/query_form/presentation/pages/query_form_view.dart';

import '../exports.dart';

class RouterConfiguration {
  RouterConfiguration._();

  static final GoRouter router = GoRouter(
    navigatorKey: locator<NavigationService>().navigationKey,
    initialLocation: RouterStrings.initial,
    routes: [
      GoRoute(
        path: RouterStrings.initial,
        builder: (context, state) => SplashView(),
      ),
      GoRoute(
        path: RouterStrings.onboarding,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: RouterStrings.dashboard,
        builder: (context, state) => const DashboardView(),
      ),
      GoRoute(
        path: RouterStrings.login,
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: RouterStrings.register,
        builder: (context, state) => RegisterView(),
      ),
      GoRoute(
        path: RouterStrings.forgetPassword,
        builder: (context, state) => ForgotPasswordView(),
      ),
      GoRoute(
        path: RouterStrings.changePassword,
        builder: (context, state) => ChangePasswordView(),
      ),
      GoRoute(
        path: RouterStrings.resetPassword,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;

          final email = args['email'] as String;
          final code = args['code'] as String;
          return ResetPasswordView(email: email, code: code);
        },
      ),
      GoRoute(
        path: RouterStrings.otpVerificationView,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;

          final email = args['email'] as String;
          final purpose = args['purpose'] as String;
          return OtpVerificationView(email: email, purpose: purpose);
        },
      ),
      GoRoute(
        path: RouterStrings.webinarDetail,
        builder: (context, state) =>
            WebinarDetailView(eventId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.workshopDetail,
        builder: (context, state) =>
            WorkshopDetailView(eventId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.conferenceDetail,
        builder: (context, state) =>
            ConferenceDetailView(eventId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.settings,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: RouterStrings.editProfile,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: RouterStrings.badges,
        builder: (context, state) => BadgesView(),
      ),
      GoRoute(
        path: RouterStrings.quizPlay,
        builder: (context, state) =>
            QuizPlayView(quizId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.topicQuizList,
        builder: (context, state) =>
            TopicQuizListView(topic: state.extra as SpecializedTopicModel),
      ),
      GoRoute(
        path: RouterStrings.quizReview,
        builder: (context, state) =>
            QuizReviewView(quizId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.quizResults,
        builder: (context, state) =>
            QuizResultsView(quizId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.leaderboard,
        builder: (context, state) =>
            LeaderboardView(quizId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.queryForm,
        builder: (context, state) => const QueryFormView(),
      ),
      GoRoute(
        path: RouterStrings.queryChat,
        builder: (context, state) =>
            QueryChatView(query: state.extra as QueryItemModel),
      ),
      GoRoute(
        path: RouterStrings.articleReaderView,
        builder: (context, state) =>
            ArticleReaderView(contentId: state.extra as int),
      ),
      GoRoute(
        path: RouterStrings.profileView,
        builder: (context, state) => const ProfileView(),
      ),
    ],
  );
}
