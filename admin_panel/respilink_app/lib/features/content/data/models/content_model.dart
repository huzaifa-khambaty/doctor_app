class ContentModel {
  Stats? stats;
  Contents? contents;

  ContentModel({this.stats, this.contents});

  ContentModel.fromJson(Map<String, dynamic> json) {
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
    contents = json['contents'] != null
        ? Contents.fromJson(json['contents'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    if (contents != null) {
      data['contents'] = contents!.toJson();
    }
    return data;
  }
}

class Stats {
  int? total;
  int? webinars;
  int? liveQuizzes;
  int? upcomingEvents;

  Stats({this.total, this.webinars, this.liveQuizzes, this.upcomingEvents});

  Stats.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    webinars = json['webinars'];
    liveQuizzes = json['live_quizzes'];
    upcomingEvents = json['upcoming_events'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['webinars'] = webinars;
    data['live_quizzes'] = liveQuizzes;
    data['upcoming_events'] = upcomingEvents;
    return data;
  }
}

class Contents {
  int? currentPage;
  List<Data>? data;
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

  Contents(
      {this.currentPage,
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
      this.total});

  Contents.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  String? title;
  int? typeId;
  String? description;
  String? thumbnailPath;
  String? pdfPath;
  String? contentLink;
  int? quizId;
  int? webinarId;
  String? status;
  String? publishedAt;
  String? scheduledAt;
  int? viewsCount;
  int? likesCount;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? thumbnailUrl;
  String? pdfUrl;
  Type? type;
  List<Specialties>? specialties;

  Data(
      {this.id,
      this.title,
      this.typeId,
      this.description,
      this.thumbnailPath,
      this.pdfPath,
      this.contentLink,
      this.quizId,
      this.webinarId,
      this.status,
      this.publishedAt,
      this.scheduledAt,
      this.viewsCount,
      this.likesCount,
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.thumbnailUrl,
      this.pdfUrl,
      this.type,
      this.specialties});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeId = json['type_id'];
    description = json['description'];
    thumbnailPath = json['thumbnail_path'];
    pdfPath = json['pdf_path'];
    contentLink = json['content_link'];
    quizId = json['quiz_id'];
    webinarId = json['webinar_id'];
    status = json['status'];
    publishedAt = json['published_at'];
    scheduledAt = json['scheduled_at'];
    viewsCount = json['views_count'];
    likesCount = json['likes_count'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    thumbnailUrl = json['thumbnail_url'];
    pdfUrl = json['pdf_url'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    if (json['specialties'] != null) {
      specialties = <Specialties>[];
      json['specialties'].forEach((v) {
        specialties!.add(Specialties.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type_id'] = typeId;
    data['description'] = description;
    data['thumbnail_path'] = thumbnailPath;
    data['pdf_path'] = pdfPath;
    data['content_link'] = contentLink;
    data['quiz_id'] = quizId;
    data['webinar_id'] = webinarId;
    data['status'] = status;
    data['published_at'] = publishedAt;
    data['scheduled_at'] = scheduledAt;
    data['views_count'] = viewsCount;
    data['likes_count'] = likesCount;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['thumbnail_url'] = thumbnailUrl;
    data['pdf_url'] = pdfUrl;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (specialties != null) {
      data['specialties'] = specialties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Type {
  int? id;
  String? name;
  String? slug;

  Type({this.id, this.name, this.slug});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Specialties {
  int? id;
  String? name;
  Pivot? pivot;

  Specialties({this.id, this.name, this.pivot});

  Specialties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? contentId;
  int? specialtyId;

  Pivot({this.contentId, this.specialtyId});

  Pivot.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    specialtyId = json['specialty_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content_id'] = contentId;
    data['specialty_id'] = specialtyId;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  int? page;
  bool? active;

  Links({this.url, this.label, this.page, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    page = json['page'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['page'] = page;
    data['active'] = active;
    return data;
  }
}
