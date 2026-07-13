class QuizListModel {
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

  QuizListModel(
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

  QuizListModel.fromJson(Map<String, dynamic> json) {
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
  int? topicId;
  String? status;
  String? opensAt;
  String? closesAt;
  String? createdAt;
  int? questionsCount;
  int? participantsCount;
  List<Participants>? participants;
  Topic? topic;

  Data(
      {this.id,
      this.title,
      this.topicId,
      this.status,
      this.opensAt,
      this.closesAt,
      this.createdAt,
      this.questionsCount,
      this.participantsCount,
      this.participants,
      this.topic});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    topicId = json['topic_id'];
    status = json['status'];
    opensAt = json['opens_at'];
    closesAt = json['closes_at'];
    createdAt = json['created_at'];
    questionsCount = json['questions_count'];
    participantsCount = json['participants_count'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    topic = json['topic'] != null ? Topic.fromJson(json['topic']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['topic_id'] = topicId;
    data['status'] = status;
    data['opens_at'] = opensAt;
    data['closes_at'] = closesAt;
    data['created_at'] = createdAt;
    data['questions_count'] = questionsCount;
    data['participants_count'] = participantsCount;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    if (topic != null) {
      data['topic'] = topic!.toJson();
    }
    return data;
  }
}

class Participants {
  int? id;
  String? fullName;
  String? photoUrl;

  Participants({this.id, this.fullName, this.photoUrl});

  Participants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['photo_url'] = photoUrl;
    return data;
  }
}

class Topic {
  int? id;
  String? name;

  Topic({this.id, this.name});

  Topic.fromJson(Map<String, dynamic> json) {
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
