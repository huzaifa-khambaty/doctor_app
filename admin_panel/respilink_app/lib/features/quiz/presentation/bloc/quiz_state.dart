import 'package:respilink_app/features/quiz/data/models/quiz_topic_model.dart';

class QuizState {
  final List<QuizTopicModel> topics;
  final bool isLoadingTopics;
  final String? error;

  const QuizState({
    this.topics = const [],
    this.isLoadingTopics = false,
    this.error,
  });

  QuizState copyWith({
    List<QuizTopicModel>? topics,
    bool? isLoadingTopics,
    String? error,
  }) {
    return QuizState(
      topics: topics ?? this.topics,
      isLoadingTopics: isLoadingTopics ?? this.isLoadingTopics,
      error: error,
    );
  }
}
