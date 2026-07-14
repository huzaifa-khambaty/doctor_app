import 'package:respilink_mobile/features/dashboard/data/model/quiz_question_answers_model.dart';

class QuizCorrectAnswersModel {
  Quiz? quiz;
  List<QuizReviewQuestion>? questions;

  QuizCorrectAnswersModel({this.quiz, this.questions});

  QuizCorrectAnswersModel.fromJson(Map<String, dynamic> json) {
    quiz = json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null;
    if (json['questions'] != null) {
      questions = <QuizReviewQuestion>[];
      json['questions'].forEach((v) {
        questions!.add(QuizReviewQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (quiz != null) {
      data['quiz'] = quiz!.toJson();
    }
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizReviewQuestion {
  int? id;
  String? questionText;
  bool? isMultiple;
  int? order;
  String? image;
  List<QuizReviewOption>? options;

  QuizReviewQuestion({
    this.id,
    this.questionText,
    this.isMultiple,
    this.order,
    this.image,
    this.options,
  });

  QuizReviewQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionText = json['question_text'];
    isMultiple = json['is_multiple'];
    order = json['order'];
    image = json['image'];
    if (json['options'] != null) {
      options = <QuizReviewOption>[];
      json['options'].forEach((v) {
        options!.add(QuizReviewOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_text'] = questionText;
    data['is_multiple'] = isMultiple;
    data['order'] = order;
    data['image'] = image;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuizReviewOption {
  int? id;
  String? optionText;
  bool? isCorrect;

  QuizReviewOption({this.id, this.optionText, this.isCorrect});

  QuizReviewOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionText = json['option_text'];
    isCorrect = json['is_correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['option_text'] = optionText;
    data['is_correct'] = isCorrect;
    return data;
  }
}
