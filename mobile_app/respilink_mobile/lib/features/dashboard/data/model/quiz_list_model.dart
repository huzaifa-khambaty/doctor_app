class QuizListModel {
  Topic? topic;
  List<QuizSummary>? data;

  QuizListModel({this.topic, this.data});

  QuizListModel.fromJson(Map<String, dynamic> json) {
    topic = json['topic'] != null ? Topic.fromJson(json['topic']) : null;
    if (json['data'] != null) {
      data = <QuizSummary>[];
      json['data'].forEach((v) {
        data!.add(QuizSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topic != null) {
      data['topic'] = topic!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topic {
  int? id;
  String? name;
  String? icon;

  Topic({this.id, this.name, this.icon});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}

class QuizSummary {
  int? id;
  String? title;
  int? questions;
  int? duration;
  int? xp;
  bool? completed;

  QuizSummary(
      {this.id,
      this.title,
      this.questions,
      this.duration,
      this.xp,
      this.completed});

  QuizSummary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    questions = json['questions'];
    duration = json['duration'];
    xp = json['xp'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['questions'] = questions;
    data['duration'] = duration;
    data['xp'] = xp;
    data['completed'] = completed;
    return data;
  }
}
