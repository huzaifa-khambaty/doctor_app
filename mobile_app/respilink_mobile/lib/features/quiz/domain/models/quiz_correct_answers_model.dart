class QuizCorrectAnswersModel {
  Quiz? quiz;
  List<Questions>? questions;

  QuizCorrectAnswersModel({this.quiz, this.questions});

  QuizCorrectAnswersModel.fromJson(Map<String, dynamic> json) {
    quiz = json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null;
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
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

class Quiz {
  int? id;
  String? title;

  Quiz({this.id, this.title});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class Questions {
  int? id;
  int? quizId;
  String? questionText;
  bool? isMultiple;
  int? order;
  String? createdAt;
  String? updatedAt;
  Null? image;
  List<Options>? options;

  Questions(
      {this.id,
      this.quizId,
      this.questionText,
      this.isMultiple,
      this.order,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.options});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizId = json['quiz_id'];
    questionText = json['question_text'];
    isMultiple = json['is_multiple'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_id'] = quizId;
    data['question_text'] = questionText;
    data['is_multiple'] = isMultiple;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image'] = image;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? id;
  int? quizQuestionId;
  String? optionText;
  bool? isCorrect;
  String? explanation;
  int? order;

  Options(
      {this.id,
      this.quizQuestionId,
      this.optionText,
      this.isCorrect,
      this.explanation,
      this.order});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizQuestionId = json['quiz_question_id'];
    optionText = json['option_text'];
    isCorrect = json['is_correct'];
    explanation = json['explanation'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_question_id'] = quizQuestionId;
    data['option_text'] = optionText;
    data['is_correct'] = isCorrect;
    data['explanation'] = explanation;
    data['order'] = order;
    return data;
  }
}
