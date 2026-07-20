class EventWorkshopModel {
  int? id;
  String? title;
  String? banner;
  List<Trainer>? trainers;
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
      this.trainers,
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
    if (json['trainers'] != null) {
      trainers = <Trainer>[];
      json['trainers'].forEach((v) {
        trainers!.add(Trainer.fromJson(v));
      });
    }
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
    if (trainers != null) {
      data['trainers'] = trainers!.map((v) => v.toJson()).toList();
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
  List<WorkshopSpecialty>? specialties;

  Trainer({this.name, this.designation, this.image, this.specialties});

  Trainer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    designation = json['designation'];
    image = json['image'];
    if (json['specialties'] != null) {
      specialties = <WorkshopSpecialty>[];
      json['specialties'].forEach((v) {
        specialties!.add(WorkshopSpecialty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['designation'] = designation;
    data['image'] = image;
    if (specialties != null) {
      data['specialties'] = specialties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkshopSpecialty {
  int? id;
  String? name;
  String? slug;

  WorkshopSpecialty({this.id, this.name, this.slug});

  WorkshopSpecialty.fromJson(Map<String, dynamic> json) {
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
