class GenerateQuizAiRequest {
  final String prompt;

  const GenerateQuizAiRequest({required this.prompt});

  Map<String, dynamic> toJson() => {'prompt': prompt};
}
