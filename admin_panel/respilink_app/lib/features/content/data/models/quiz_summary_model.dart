class QuizSummaryModel {
  int? id;
  String? title;

  QuizSummaryModel({this.id, this.title});

  QuizSummaryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}
