class QuizDetailModel {
  int? id;
  String? title;
  String? banner;
  String? description;
  String? opensAt;
  String? closesAt;
  int? timeLimitMinutes;
  String? status;
  String? tieBreaker;
  CreatedBy? createdBy;
  String? createdAt;
  String? updatedAt;
  int? topicId;
  List<Questions>? questions;

  QuizDetailModel(
      {this.id,
      this.title,
      this.banner,
      this.description,
      this.opensAt,
      this.closesAt,
      this.timeLimitMinutes,
      this.status,
      this.tieBreaker,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.topicId,
      this.questions});

  QuizDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    description = json['description'];
    opensAt = json['opens_at'];
    closesAt = json['closes_at'];
    timeLimitMinutes = json['time_limit_minutes'];
    status = json['status'];
    tieBreaker = json['tie_breaker'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    topicId = json['topic_id'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner'] = banner;
    data['description'] = description;
    data['opens_at'] = opensAt;
    data['closes_at'] = closesAt;
    data['time_limit_minutes'] = timeLimitMinutes;
    data['status'] = status;
    data['tie_breaker'] = tieBreaker;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['topic_id'] = topicId;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatedBy {
  int? id;
  String? name;

  CreatedBy({this.id, this.name});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Questions {
  int? id;
  int? quizId;
  String? questionText;
  String? imagePath;
  bool? isMultiple;
  int? order;
  String? createdAt;
  String? updatedAt;
  List<Options>? options;

  Questions(
      {this.id,
      this.quizId,
      this.questionText,
      this.imagePath,
      this.isMultiple,
      this.order,
      this.createdAt,
      this.updatedAt,
      this.options});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizId = json['quiz_id'];
    questionText = json['question_text'];
    imagePath = json['image_path'];
    isMultiple = json['is_multiple'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['image_path'] = imagePath;
    data['is_multiple'] = isMultiple;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
  String? createdAt;
  String? updatedAt;

  Options({
    this.id,
    this.quizQuestionId,
    this.optionText,
    this.isCorrect,
    this.explanation,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizQuestionId = json['quiz_question_id'];
    optionText = json['option_text'];
    isCorrect = json['is_correct'];
    explanation = json['explanation'];
    order = json['order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_question_id'] = quizQuestionId;
    data['option_text'] = optionText;
    data['is_correct'] = isCorrect;
    data['explanation'] = explanation;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
