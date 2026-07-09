import 'package:respilink_mobile/shared/models/pagination_model.dart';

class EventListingModel {
  List<Events>? data;
  Pagination? pagination;

  EventListingModel(
      {this.data,
      this.pagination,});

 EventListingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Events>[];
      json['data'].forEach((v) {
        data!.add(Events.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Events {
  int? id;
  String? title;
  String? type;
  String? startsAt;
  String? endsAt;
  String? timezone;
  String? location;
  String? description;
  String? bannerPath;
  String? externalJoinLink;
  String? recordingLink;
  bool? enableQaSession;
  bool? certificateOfParticipation;
  bool? sendEmailReminders;
  String? status;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? isRegistered;
  bool? isLive;
  String? bannerUrl;
  Creator? creator;

  Events(
      {this.id,
      this.title,
      this.type,
      this.startsAt,
      this.endsAt,
      this.timezone,
      this.location,
      this.description,
      this.bannerPath,
      this.externalJoinLink,
      this.recordingLink,
      this.enableQaSession,
      this.certificateOfParticipation,
      this.sendEmailReminders,
      this.status,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isRegistered,
      this.isLive,
      this.bannerUrl,
      this.creator});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    timezone = json['timezone'];
    location = json['location'];
    description = json['description'];
    bannerPath = json['banner_path'];
    externalJoinLink = json['external_join_link'];
    recordingLink = json['recording_link'];
    enableQaSession = json['enable_qa_session'];
    certificateOfParticipation = json['certificate_of_participation'];
    sendEmailReminders = json['send_email_reminders'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isRegistered = json['is_registered'];
    isLive = json['is_live'];
    bannerUrl = json['banner_url'];
    creator =
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['starts_at'] = startsAt;
    data['ends_at'] = endsAt;
    data['timezone'] = timezone;
    data['location'] = location;
    data['description'] = description;
    data['banner_path'] = bannerPath;
    data['external_join_link'] = externalJoinLink;
    data['recording_link'] = recordingLink;
    data['enable_qa_session'] = enableQaSession;
    data['certificate_of_participation'] = certificateOfParticipation;
    data['send_email_reminders'] = sendEmailReminders;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['is_registered'] = isRegistered;
    data['is_live'] = isLive;
    data['banner_url'] = bannerUrl;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    return data;
  }
}

class Creator {
  int? id;
  String? name;

  Creator({this.id, this.name});

  Creator.fromJson(Map<String, dynamic> json) {
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