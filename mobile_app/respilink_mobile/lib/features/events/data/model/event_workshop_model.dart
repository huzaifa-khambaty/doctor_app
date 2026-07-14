class EventWorkshopModel {
  int? id;
  String? title;
  String? banner;
  Trainer? trainer;
  String? date;
  String? startTime;
  String? endTime;
  String? location;
  int? fee;
  String? currency;
  String? description;
  List<String>? prerequisites;
  bool? isRegistered;

  EventWorkshopModel(
      {this.id,
      this.title,
      this.banner,
      this.trainer,
      this.date,
      this.startTime,
      this.endTime,
      this.location,
      this.fee,
      this.currency,
      this.description,
      this.prerequisites,
      this.isRegistered});

  EventWorkshopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    trainer =
        json['trainer'] != null ? Trainer.fromJson(json['trainer']) : null;
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    location = json['location'];
    fee = json['fee'];
    currency = json['currency'];
    description = json['description'];
    prerequisites = json['prerequisites'] != null
        ? List<String>.from(json['prerequisites'])
        : null;
    isRegistered = json['is_registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner'] = banner;
    if (trainer != null) {
      data['trainer'] = trainer!.toJson();
    }
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['location'] = location;
    data['fee'] = fee;
    data['currency'] = currency;
    data['description'] = description;
    data['prerequisites'] = prerequisites;
    data['is_registered'] = isRegistered;
    return data;
  }
}

class Trainer {
  String? name;
  String? designation;
  String? image;

  Trainer({this.name, this.designation, this.image});

  Trainer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    designation = json['designation'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['designation'] = designation;
    data['image'] = image;
    return data;
  }
}
