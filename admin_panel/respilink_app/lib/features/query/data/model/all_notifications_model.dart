class AllNotificationsModel {
  bool? success;
  String? message;
  Notifications? data;

  AllNotificationsModel({this.success, this.message, this.data});

  AllNotificationsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Notifications.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Notifications {
  Summary? summary;
  List<ScheduledNotifications>? scheduledNotifications;
  List<History>? history;
  Pagination? pagination;

  Notifications(
      {this.summary,
      this.scheduledNotifications,
      this.history,
      this.pagination});

  Notifications.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    if (json['scheduled_notifications'] != null) {
      scheduledNotifications = <ScheduledNotifications>[];
      json['scheduled_notifications'].forEach((v) {
        scheduledNotifications!.add(ScheduledNotifications.fromJson(v));
      });
    }
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (scheduledNotifications != null) {
      data['scheduled_notifications'] =
          scheduledNotifications!.map((v) => v.toJson()).toList();
    }
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Summary {
  int? pendingCount;

  Summary({this.pendingCount});

  Summary.fromJson(Map<String, dynamic> json) {
    pendingCount = json['pending_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pending_count'] = pendingCount;
    return data;
  }
}

class ScheduledNotifications {
  int? id;
  String? title;
  String? targetAudience;
  String? status;
  String? scheduledAt;
  bool? canEdit;
  bool? canCancel;

  ScheduledNotifications(
      {this.id,
      this.title,
      this.targetAudience,
      this.status,
      this.scheduledAt,
      this.canEdit,
      this.canCancel});

  ScheduledNotifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    targetAudience = json['target_audience'];
    status = json['status'];
    scheduledAt = json['scheduled_at'];
    canEdit = json['can_edit'];
    canCancel = json['can_cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['target_audience'] = targetAudience;
    data['status'] = status;
    data['scheduled_at'] = scheduledAt;
    data['can_edit'] = canEdit;
    data['can_cancel'] = canCancel;
    return data;
  }
}

class History {
  int? id;
  String? title;
  String? type;
  String? targetAudience;
  String? sentAt;
  String? status;
  int? recipientCount;
  int? openedCount;
  int? openRate;
  String? createdBy;

  History(
      {this.id,
      this.title,
      this.type,
      this.targetAudience,
      this.sentAt,
      this.status,
      this.recipientCount,
      this.openedCount,
      this.openRate,
      this.createdBy});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    targetAudience = json['target_audience'];
    sentAt = json['sent_at'];
    status = json['status'];
    recipientCount = json['recipient_count'];
    openedCount = json['opened_count'];
    openRate = json['open_rate'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['target_audience'] = targetAudience;
    data['sent_at'] = sentAt;
    data['status'] = status;
    data['recipient_count'] = recipientCount;
    data['opened_count'] = openedCount;
    data['open_rate'] = openRate;
    data['created_by'] = createdBy;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Pagination({this.currentPage, this.perPage, this.total, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['last_page'] = lastPage;
    return data;
  }
}
