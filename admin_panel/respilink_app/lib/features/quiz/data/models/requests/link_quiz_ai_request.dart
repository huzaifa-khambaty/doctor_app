class LinkQuizAiRequest {
  final int quizId;
  final int generationId;

  const LinkQuizAiRequest({required this.quizId, required this.generationId});

  Map<String, dynamic> toJson() => {
        'quiz_id': quizId,
        'generation_id': generationId,
      };
}
