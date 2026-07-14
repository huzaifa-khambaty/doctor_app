class SubmitQuizAnswersRequest {
  final List<QuestionAnswer> answers;

  SubmitQuizAnswersRequest({required this.answers});

  Map<String, dynamic> toJson() {
    return {'answers': answers.map((a) => a.toJson()).toList()};
  }
}

class QuestionAnswer {
  final int questionId;
  final List<int> optionIds;
  final bool isMultiple;

  QuestionAnswer({
    required this.questionId,
    required this.optionIds,
    required this.isMultiple,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      if (isMultiple) 'option_ids': optionIds else 'option_id': optionIds.first,
    };
  }
}
