class EventConferenceModel {
  int? id;
  String? title;
  String? banner;
  String? duration;
  String? dateFrom;
  String? dateTo;
  String? time;
  String? format;
  String? venue;
  List<Speakers>? speakers;
  List<Agenda>? agenda;
  int? price;
  String? currency;
  bool? isRegistered;

  EventConferenceModel(
      {this.id,
      this.title,
      this.banner,
      this.duration,
      this.dateFrom,
      this.dateTo,
      this.time,
      this.format,
      this.venue,
      this.speakers,
      this.agenda,
      this.price,
      this.currency,
      this.isRegistered});

  EventConferenceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    duration = json['duration'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    time = json['time'];
    format = json['format'];
    venue = json['venue'];
    if (json['speakers'] != null) {
      speakers = <Speakers>[];
      json['speakers'].forEach((v) {
        speakers!.add(Speakers.fromJson(v));
      });
    }
    if (json['agenda'] != null) {
      agenda = <Agenda>[];
      json['agenda'].forEach((v) {
        agenda!.add(Agenda.fromJson(v));
      });
    }
    price = json['price'];
    currency = json['currency'];
    isRegistered = json['is_registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner'] = banner;
    data['duration'] = duration;
    data['date_from'] = dateFrom;
    data['date_to'] = dateTo;
    data['time'] = time;
    data['format'] = format;
    data['venue'] = venue;
    if (speakers != null) {
      data['speakers'] = speakers!.map((v) => v.toJson()).toList();
    }
    if (agenda != null) {
      data['agenda'] = agenda!.map((v) => v.toJson()).toList();
    }
    data['price'] = price;
    data['currency'] = currency;
    data['is_registered'] = isRegistered;
    return data;
  }
}

class Speakers {
  String? name;
  String? image;

  Speakers({this.name, this.image});

  Speakers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Agenda {
  int? day;
  String? time;
  String? title;
  String? description;
  String? location;

  Agenda({this.day, this.time, this.title, this.description, this.location});

  Agenda.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
    title = json['title'];
    description = json['description'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['time'] = time;
    data['title'] = title;
    data['description'] = description;
    data['location'] = location;
    return data;
  }
}
