import '../../../../shared/model/pagination_model.dart';

class EventListingModel {
  int? currentPage;
  List<Events>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  EventListingModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  EventListingModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Events>[];
      json['data'].forEach((v) {
        data!.add(Events.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
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
  String? bannerUrl;
  Creator? creator;
  List<Speakers>? speakers;

  Events({
    this.id,
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
    this.bannerUrl,
    this.creator,
    this.speakers,
  });

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
    bannerUrl = json['banner_url'];
    creator = json['creator'] != null
        ? Creator.fromJson(json['creator'])
        : null;
    if (json['speakers'] != null) {
      speakers = <Speakers>[];
      json['speakers'].forEach((v) {
        speakers!.add(Speakers.fromJson(v));
      });
    }
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
    data['banner_url'] = bannerUrl;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    if (speakers != null) {
      data['speakers'] = speakers!.map((v) => v.toJson()).toList();
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

class Speakers {
  int? id;
  String? fullName;
  String? photoUrl;
  Pivot? pivot;

  Speakers({this.id, this.fullName, this.photoUrl, this.pivot});

  Speakers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    photoUrl = json['photo_url'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['photo_url'] = photoUrl;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? eventId;
  int? userId;

  Pivot({this.eventId, this.userId});

  Pivot.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event_id'] = eventId;
    data['user_id'] = userId;
    return data;
  }
}
