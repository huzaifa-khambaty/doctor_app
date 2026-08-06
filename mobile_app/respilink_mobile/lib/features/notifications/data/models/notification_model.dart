class NotificationModel {
  int? id;
  String? title;
  String? message;
  String? sentAt;
  bool? isOpened;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.sentAt,
    this.isOpened,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    sentAt = json['sent_at'];
    isOpened = json['is_opened'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['message'] = message;
    data['sent_at'] = sentAt;
    data['is_opened'] = isOpened;
    return data;
  }
}
