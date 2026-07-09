class QuizAnswerOption {
  final String label;
  final String text;

  const QuizAnswerOption({required this.label, required this.text});
}

class QuizQuestionModel {
  final int questionNumber;
  final int totalQuestions;
  final String image;
  final String questionText;
  final String caseContext;
  final List<QuizAnswerOption> options;
  final int timeLimitSeconds;

  const QuizQuestionModel({
    required this.questionNumber,
    required this.totalQuestions,
    required this.image,
    required this.questionText,
    required this.caseContext,
    required this.options,
    this.timeLimitSeconds = 60,
  });

  double get progress => questionNumber / totalQuestions;
}
