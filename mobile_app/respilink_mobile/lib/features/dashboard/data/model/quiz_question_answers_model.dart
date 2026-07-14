class QuizQuestionAnswersModel {
  Quiz? quiz;
  List<Questions>? questions;

  QuizQuestionAnswersModel({this.quiz, this.questions});

  QuizQuestionAnswersModel.fromJson(Map<String, dynamic> json) {
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
  int? totalQuestions;
  int? timeLimit;

  Quiz({this.id, this.title, this.totalQuestions, this.timeLimit});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    totalQuestions = json['total_questions'];
    timeLimit = json['time_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['total_questions'] = totalQuestions;
    data['time_limit'] = timeLimit;
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
  String? image;
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
  int? order;

  Options({this.id, this.quizQuestionId, this.optionText, this.order});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizQuestionId = json['quiz_question_id'];
    optionText = json['option_text'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_question_id'] = quizQuestionId;
    data['option_text'] = optionText;
    data['order'] = order;
    return data;
  }
}
