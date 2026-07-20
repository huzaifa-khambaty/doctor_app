import 'package:respilink_app/features/quiz/data/models/quiz_analytics_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_detail_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_list_model.dart';
import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';

class QuizState {
  final List<QuizTopicModel> topics;
  final bool isLoadingTopics;

  final List<Data> quizzes;
  final bool isLoadingQuizzes;
  final int currentPage;
  final int lastPage;
  final int totalQuizzes;

  final bool isSubmitting;
  final bool submitSuccess;

  final int? actioningQuizId;
  final bool actionSuccess;

  final QuizDetailModel? quizDetail;
  final bool isLoadingDetail;

  final QuizAnalyticsModel? analyticsData;
  final bool isLoadingAnalytics;
  final int? loadingAnalyticsForQuizId;
  final bool analyticsJustFetched;

  final String? error;

  const QuizState({
    this.topics = const [],
    this.isLoadingTopics = false,
    this.quizzes = const [],
    this.isLoadingQuizzes = false,
    this.currentPage = 1,
    this.lastPage = 1,
    this.totalQuizzes = 0,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.actioningQuizId,
    this.actionSuccess = false,
    this.quizDetail,
    this.isLoadingDetail = false,
    this.analyticsData,
    this.isLoadingAnalytics = false,
    this.loadingAnalyticsForQuizId,
    this.analyticsJustFetched = false,
    this.error,
  });

  QuizState copyWith({
    List<QuizTopicModel>? topics,
    bool? isLoadingTopics,
    List<Data>? quizzes,
    bool? isLoadingQuizzes,
    int? currentPage,
    int? lastPage,
    int? totalQuizzes,
    bool? isSubmitting,
    bool? submitSuccess,
    Object? actioningQuizId = _sentinel,
    bool? actionSuccess,
    Object? quizDetail = _sentinel,
    bool? isLoadingDetail,
    Object? analyticsData = _sentinel,
    bool? isLoadingAnalytics,
    Object? loadingAnalyticsForQuizId = _sentinel,
    bool? analyticsJustFetched,
    String? error,
  }) {
    return QuizState(
      topics: topics ?? this.topics,
      isLoadingTopics: isLoadingTopics ?? this.isLoadingTopics,
      quizzes: quizzes ?? this.quizzes,
      isLoadingQuizzes: isLoadingQuizzes ?? this.isLoadingQuizzes,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? false,
      actioningQuizId: identical(actioningQuizId, _sentinel)
          ? this.actioningQuizId
          : actioningQuizId as int?,
      actionSuccess: actionSuccess ?? false,
      quizDetail: identical(quizDetail, _sentinel)
          ? this.quizDetail
          : quizDetail as QuizDetailModel?,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      analyticsData: identical(analyticsData, _sentinel)
          ? this.analyticsData
          : analyticsData as QuizAnalyticsModel?,
      isLoadingAnalytics: isLoadingAnalytics ?? this.isLoadingAnalytics,
      loadingAnalyticsForQuizId: identical(loadingAnalyticsForQuizId, _sentinel)
          ? this.loadingAnalyticsForQuizId
          : loadingAnalyticsForQuizId as int?,
      analyticsJustFetched: analyticsJustFetched ?? false,
      error: error,
    );
  }
}

const Object _sentinel = Object();
