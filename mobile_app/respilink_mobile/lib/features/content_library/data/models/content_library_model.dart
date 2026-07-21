import 'package:respilink_mobile/shared/models/pagination_model.dart';

class ContentLibraryModel {
  LibraryHero? hero;
  List<String>? tabs;
  List<LibraryTopic>? topics;
  List<ContentItem>? data;
  Pagination? pagination;

  ContentLibraryModel(
      {this.hero, this.tabs, this.topics, this.data, this.pagination});

  ContentLibraryModel.fromJson(Map<String, dynamic> json) {
    hero = json['hero'] != null ? LibraryHero.fromJson(json['hero']) : null;
    tabs = json['tabs'] != null ? List<String>.from(json['tabs']) : null;
    if (json['topics'] != null) {
      topics = <LibraryTopic>[];
      json['topics'].forEach((v) {
        topics!.add(LibraryTopic.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <ContentItem>[];
      json['data'].forEach((v) {
        data!.add(ContentItem.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hero != null) {
      data['hero'] = hero!.toJson();
    }
    data['tabs'] = tabs;
    if (topics != null) {
      data['topics'] = topics!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class LibraryHero {
  String? title;
  String? subtitle;

  LibraryHero({this.title, this.subtitle});

  LibraryHero.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subtitle'] = subtitle;
    return data;
  }
}

class LibraryTopic {
  int? id;
  String? name;

  LibraryTopic({this.id, this.name});

  LibraryTopic.fromJson(Map<String, dynamic> json) {
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

class ContentItem {
  int? id;
  String? title;
  int? typeId;
  String? description;
  String? thumbnailPath;
  String? pdfPath;
  int? pagesCount;
  String? contentLink;
  int? quizId;
  String? webinarPath;
  String? status;
  String? publishedAt;
  String? scheduledAt;
  int? viewsCount;
  int? downloadsCount;
  int? likesCount;
  int? createdBy;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool? isSaved;
  bool? isLiked;
  String? thumbnailUrl;
  String? pdfUrl;
  String? webinarUrl;
  String? readTime;
  ContentType? type;
  List<ContentSpecialty>? specialties;
  int? pdfSize;

  ContentItem({
    this.id,
    this.title,
    this.typeId,
    this.description,
    this.thumbnailPath,
    this.pdfPath,
    this.pagesCount,
    this.contentLink,
    this.quizId,
    this.webinarPath,
    this.status,
    this.publishedAt,
    this.scheduledAt,
    this.viewsCount,
    this.downloadsCount,
    this.likesCount,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isSaved,
    this.isLiked,
    this.thumbnailUrl,
    this.pdfUrl,
    this.webinarUrl,
    this.readTime,
    this.type,
    this.specialties,
    this.pdfSize,
  });

  ContentItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeId = json['type_id'];
    description = json['description'];
    thumbnailPath = json['thumbnail_path'];
    pdfPath = json['pdf_path'];
    pagesCount = json['pages_count'];
    contentLink = json['content_link'];
    quizId = json['quiz_id'];
    webinarPath = json['webinar_path'];
    status = json['status'];
    publishedAt = json['published_at'];
    scheduledAt = json['scheduled_at'];
    viewsCount = json['views_count'];
    downloadsCount = json['downloads_count'];
    likesCount = json['likes_count'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isSaved = json['is_saved'];
    isLiked = json['is_liked'];
    thumbnailUrl = json['thumbnail_url'];
    pdfUrl = json['pdf_url'];
    webinarUrl = json['webinar_url'];
    readTime = json['read_time'];
    pdfSize = json['pdf_size'];
    type = json['type'] != null ? ContentType.fromJson(json['type']) : null;
    if (json['specialties'] != null) {
      specialties = <ContentSpecialty>[];
      json['specialties'].forEach((v) {
        specialties!.add(ContentSpecialty.fromJson(v));
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
    data['pages_count'] = pagesCount;
    data['content_link'] = contentLink;
    data['quiz_id'] = quizId;
    data['webinar_path'] = webinarPath;
    data['status'] = status;
    data['published_at'] = publishedAt;
    data['scheduled_at'] = scheduledAt;
    data['views_count'] = viewsCount;
    data['downloads_count'] = downloadsCount;
    data['likes_count'] = likesCount;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['is_saved'] = isSaved;
    data['is_liked'] = isLiked;
    data['thumbnail_url'] = thumbnailUrl;
    data['pdf_url'] = pdfUrl;
    data['webinar_url'] = webinarUrl;
    data['read_time'] = readTime;
    data['pdf_size'] = pdfSize;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    if (specialties != null) {
      data['specialties'] = specialties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContentType {
  int? id;
  String? name;
  String? slug;

  ContentType({this.id, this.name, this.slug});

  ContentType.fromJson(Map<String, dynamic> json) {
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

class ContentSpecialty {
  int? id;
  String? name;

  ContentSpecialty({this.id, this.name});

  ContentSpecialty.fromJson(Map<String, dynamic> json) {
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
