import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';
import 'package:respilink_mobile/features/dashboard/data/model/requests/submit_quiz_answers_request.dart';

abstract class QuizPlayState {}

class QuizPlayLoading extends QuizPlayState {}

class QuizPlayLoaded extends QuizPlayState {
  final Quiz quiz;
  final List<Questions> questions;
  final int currentIndex;
  final Set<int> selectedOptionIds;

  /// Answers collected locally as the user moves through questions — only
  /// sent to the backend as a single batch once the last question submits.
  final List<QuestionAnswer> collectedAnswers;
  final bool isSubmitting;

  /// Set only on the single emission representing a failed submit attempt —
  /// every other transition (including the next submit attempt) resets it to
  /// null via [copyWith], so the UI can treat "non-null" as a one-shot signal.
  final String? submitError;

  QuizPlayLoaded({
    required this.quiz,
    required this.questions,
    required this.currentIndex,
    required this.selectedOptionIds,
    this.collectedAnswers = const [],
    this.isSubmitting = false,
    this.submitError,
  });

  Questions get currentQuestion => questions[currentIndex];

  bool get isLastQuestion => currentIndex == questions.length - 1;

  QuizPlayLoaded copyWith({
    int? currentIndex,
    Set<int>? selectedOptionIds,
    List<QuestionAnswer>? collectedAnswers,
    bool? isSubmitting,
    String? submitError,
  }) {
    return QuizPlayLoaded(
      quiz: quiz,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      collectedAnswers: collectedAnswers ?? this.collectedAnswers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      // Not falling back to `this.submitError` — a fresh copyWith always
      // clears it unless the caller explicitly passes a new message.
      submitError: submitError,
    );
  }
}

class QuizPlayCompleted extends QuizPlayState {}

/// Time ran out — answers collected so far (if any) were force-submitted;
/// the UI should exit the quiz back to the dashboard, not to results.
class QuizPlayTimeExpired extends QuizPlayState {}

class QuizPlayFailed extends QuizPlayState {
  final String message;

  QuizPlayFailed({required this.message});
}
