class SystemLogsModel {
  List<SystemLogData>? data;
  SystemLogsPagination? pagination;

  SystemLogsModel({this.data, this.pagination});

  SystemLogsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SystemLogData>[];
      json['data'].forEach((v) {
        data!.add(SystemLogData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? SystemLogsPagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination!.toJson();
    }
    return map;
  }
}

class SystemLogData {
  int? id;
  String? category;
  String? color;
  String? title;
  String? description;
  String? causerName;
  SystemLogMetadata? metadata;
  String? createdAt;
  String? timeAgo;

  SystemLogData({
    this.id,
    this.category,
    this.color,
    this.title,
    this.description,
    this.causerName,
    this.metadata,
    this.createdAt,
    this.timeAgo,
  });

  SystemLogData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    color = json['color'];
    title = json['title'];
    description = json['description'];
    causerName = json['causer_name'];
    metadata = json['metadata'] != null
        ? SystemLogMetadata.fromJson(json['metadata'])
        : null;
    createdAt = json['created_at'];
    timeAgo = json['time_ago'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['category'] = category;
    map['color'] = color;
    map['title'] = title;
    map['description'] = description;
    map['causer_name'] = causerName;
    if (metadata != null) {
      map['metadata'] = metadata!.toJson();
    }
    map['created_at'] = createdAt;
    map['time_ago'] = timeAgo;
    return map;
  }
}

class SystemLogMetadata {
  int? contentId;
  String? typeId;

  SystemLogMetadata({this.contentId, this.typeId});

  SystemLogMetadata.fromJson(Map<String, dynamic> json) {
    contentId = json['content_id'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['content_id'] = contentId;
    map['type_id'] = typeId;
    return map;
  }
}

class SystemLogsPagination {
  int? page;
  int? perPage;
  int? total;
  int? lastPage;
  bool? hasNext;
  bool? hasPrevious;

  SystemLogsPagination({
    this.page,
    this.perPage,
    this.total,
    this.lastPage,
    this.hasNext,
    this.hasPrevious,
  });

  SystemLogsPagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    hasNext = json['has_next'];
    hasPrevious = json['has_previous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['page'] = page;
    map['per_page'] = perPage;
    map['total'] = total;
    map['last_page'] = lastPage;
    map['has_next'] = hasNext;
    map['has_previous'] = hasPrevious;
    return map;
  }
}
