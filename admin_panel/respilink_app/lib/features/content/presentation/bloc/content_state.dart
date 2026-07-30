import 'package:respilink_app/features/content/data/models/content_model.dart';
import 'package:respilink_app/features/content/data/models/content_specialty_model.dart';
import 'package:respilink_app/features/content/data/models/quiz_summary_model.dart';
import 'package:respilink_app/features/content/data/models/system_logs_model.dart';

class ContentState {
  final List<ContentSpecialtyModel> specialties;
  final bool isLoadingSpecialties;

  final List<QuizSummaryModel> quizzes;
  final bool isLoadingQuizzes;

  final ContentModel? contentData;
  final bool isLoadingContents;

  final List<SystemLogData> systemLogs;
  final bool isLoadingSystemLogs;

  final bool isSubmitting;
  final bool submitSuccess;
  final int? actioningContentId;

  final String? error;

  const ContentState({
    this.specialties = const [],
    this.isLoadingSpecialties = false,
    this.quizzes = const [],
    this.isLoadingQuizzes = false,
    this.contentData,
    this.isLoadingContents = false,
    this.systemLogs = const [],
    this.isLoadingSystemLogs = false,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.actioningContentId,
    this.error,
  });

  ContentState copyWith({
    List<ContentSpecialtyModel>? specialties,
    bool? isLoadingSpecialties,
    List<QuizSummaryModel>? quizzes,
    bool? isLoadingQuizzes,
    ContentModel? contentData,
    bool? isLoadingContents,
    List<SystemLogData>? systemLogs,
    bool? isLoadingSystemLogs,
    bool? isSubmitting,
    bool? submitSuccess,
    int? actioningContentId,
    bool clearActioningId = false,
    String? error,
  }) {
    return ContentState(
      specialties: specialties ?? this.specialties,
      isLoadingSpecialties: isLoadingSpecialties ?? this.isLoadingSpecialties,
      quizzes: quizzes ?? this.quizzes,
      isLoadingQuizzes: isLoadingQuizzes ?? this.isLoadingQuizzes,
      contentData: contentData ?? this.contentData,
      isLoadingContents: isLoadingContents ?? this.isLoadingContents,
      systemLogs: systemLogs ?? this.systemLogs,
      isLoadingSystemLogs: isLoadingSystemLogs ?? this.isLoadingSystemLogs,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? false,
      actioningContentId: clearActioningId ? null : (actioningContentId ?? this.actioningContentId),
      error: error,
    );
  }
}
