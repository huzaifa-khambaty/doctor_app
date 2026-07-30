class QuizAiResponseModel {
  final String? message;
  final int? generationId;
  final List<AiQuestion> questions;
  final int? totalQuestions;

  const QuizAiResponseModel({
    this.message,
    this.generationId,
    this.questions = const [],
    this.totalQuestions,
  });

  factory QuizAiResponseModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'];
    return QuizAiResponseModel(
      message: json['message'] as String?,
      generationId: json['generation_id'] as int?,
      totalQuestions: json['total_questions'] as int?,
      questions: rawQuestions is List
          ? rawQuestions
              .map((e) => AiQuestion.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}

class AiQuestion {
  final String? questionText;
  final bool isMultiple;
  final String? explanation;
  final List<AiOption> options;

  const AiQuestion({
    this.questionText,
    this.isMultiple = false,
    this.explanation,
    this.options = const [],
  });

  factory AiQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    return AiQuestion(
      questionText: json['question_text'] as String?,
      isMultiple: (json['is_multiple'] as bool?) ?? false,
      explanation: json['explanation'] as String?,
      options: rawOptions is List
          ? rawOptions
              .map((e) => AiOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}

class AiOption {
  final String? optionText;
  final bool isCorrect;
  final String? explanation;

  const AiOption({
    this.optionText,
    this.isCorrect = false,
    this.explanation,
  });

  factory AiOption.fromJson(Map<String, dynamic> json) => AiOption(
        optionText: json['option_text'] as String?,
        isCorrect: (json['is_correct'] as bool?) ?? false,
        explanation: json['explanation'] as String?,
      );
}
