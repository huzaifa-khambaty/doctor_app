class ContentDetailsModel {
  int? id;
  String? title;
  String? type;
  String? topic;
  String? thumbnail;
  Author? author;
  String? publishedAt;
  String? readTime;
  String? body;
  List<String>? tags;
  int? views;
  int? likes;
  int? commentsCount;
  bool? isLiked;
  bool? isSaved;
  String? externalUrl;
  List<String>? externalLinks;
  List<Attachments>? attachments;
  int? pagesCount;
  int? downloadsCount;
  String? webinarUrl;
  List<RelatedContent>? relatedContent;

  ContentDetailsModel(
      {this.id,
      this.title,
      this.type,
      this.topic,
      this.thumbnail,
      this.author,
      this.publishedAt,
      this.readTime,
      this.body,
      this.tags,
      this.views,
      this.likes,
      this.commentsCount,
      this.isLiked,
      this.isSaved,
      this.externalUrl,
      this.externalLinks,
      this.attachments,
      this.pagesCount,
      this.downloadsCount,
      this.webinarUrl,
      this.relatedContent});

  ContentDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    topic = json['topic'];
    thumbnail = json['thumbnail'];
    author =
        json['author'] != null ? Author.fromJson(json['author']) : null;
    publishedAt = json['published_at'];
    readTime = json['read_time'];
    body = json['body'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : null;
    views = json['views'];
    likes = json['likes'];
    commentsCount = json['comments_count'];
    isLiked = json['is_liked'];
    isSaved = json['is_saved'];
    externalUrl = json['external_url'];
    externalLinks = json['external_links'] != null
        ? List<String>.from(json['external_links'])
        : null;
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
    pagesCount = json['pages_count'];
    downloadsCount = json['downloads_count'];
    webinarUrl = json['webinar_url'];
    if (json['related_content'] != null) {
      relatedContent = <RelatedContent>[];
      json['related_content'].forEach((v) {
        relatedContent!.add(RelatedContent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['topic'] = topic;
    data['thumbnail'] = thumbnail;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['published_at'] = publishedAt;
    data['read_time'] = readTime;
    data['body'] = body;
    data['tags'] = tags;
    data['views'] = views;
    data['likes'] = likes;
    data['comments_count'] = commentsCount;
    data['is_liked'] = isLiked;
    data['is_saved'] = isSaved;
    data['external_url'] = externalUrl;
    data['external_links'] = externalLinks;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['pages_count'] = pagesCount;
    data['downloads_count'] = downloadsCount;
    data['webinar_url'] = webinarUrl;
    if (relatedContent != null) {
      data['related_content'] =
          relatedContent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Author {
  String? name;
  String? designation;

  Author({this.name, this.designation});

  Author.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['designation'] = designation;
    return data;
  }
}

class Attachments {
  String? name;
  String? url;
  int? sizeMb;

  Attachments({this.name, this.url, this.sizeMb});

  Attachments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    sizeMb = json['size_mb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['size_mb'] = sizeMb;
    return data;
  }
}

class RelatedContent {
  int? id;
  String? title;
  String? thumbnailPath;
  int? typeId;
  String? thumbnailUrl;
  String? pdfUrl;
  String? webinarUrl;
  String? readTime;
  RelatedContentType? type;

  RelatedContent(
      {this.id,
      this.title,
      this.thumbnailPath,
      this.typeId,
      this.thumbnailUrl,
      this.pdfUrl,
      this.webinarUrl,
      this.readTime,
      this.type});

  RelatedContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnailPath = json['thumbnail_path'];
    typeId = json['type_id'];
    thumbnailUrl = json['thumbnail_url'];
    pdfUrl = json['pdf_url'];
    webinarUrl = json['webinar_url'];
    readTime = json['read_time'];
    type = json['type'] != null
        ? RelatedContentType.fromJson(json['type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['thumbnail_path'] = thumbnailPath;
    data['type_id'] = typeId;
    data['thumbnail_url'] = thumbnailUrl;
    data['pdf_url'] = pdfUrl;
    data['webinar_url'] = webinarUrl;
    data['read_time'] = readTime;
    if (type != null) {
      data['type'] = type!.toJson();
    }
    return data;
  }
}

class RelatedContentType {
  int? id;
  String? name;
  String? slug;

  RelatedContentType({this.id, this.name, this.slug});

  RelatedContentType.fromJson(Map<String, dynamic> json) {
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
