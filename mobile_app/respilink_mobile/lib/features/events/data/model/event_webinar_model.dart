class EventWebinarModel {
  int? id;
  String? title;
  String? banner;
  Speaker? speaker;
  String? date;
  String? startTime;
  String? endTime;
  double? cmeCredits;
  String? format;
  String? description;
  String? syllabus;
  List<String>? learningObjectives;
  int? registrationFee;
  bool? isRegistered;

  EventWebinarModel(
      {this.id,
      this.title,
      this.banner,
      this.speaker,
      this.date,
      this.startTime,
      this.endTime,
      this.cmeCredits,
      this.format,
      this.description,
      this.syllabus,
      this.learningObjectives,
      this.registrationFee,
      this.isRegistered});

  EventWebinarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    banner = json['banner'];
    speaker =
        json['speaker'] != null ? Speaker.fromJson(json['speaker']) : null;
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    cmeCredits = json['cme_credits'];
    format = json['format'];
    description = json['description'];
    syllabus = json['syllabus'];
    learningObjectives = json['learning_objectives'] != null
        ? List<String>.from(json['learning_objectives'])
        : null;
    registrationFee = json['registration_fee'];
    isRegistered = json['is_registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner'] = banner;
    if (speaker != null) {
      data['speaker'] = speaker!.toJson();
    }
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['cme_credits'] = cmeCredits;
    data['format'] = format;
    data['description'] = description;
    data['syllabus'] = syllabus;
    data['learning_objectives'] = learningObjectives;
    data['registration_fee'] = registrationFee;
    data['is_registered'] = isRegistered;
    return data;
  }
}

class Speaker {
  String? name;
  String? designation;
  String? image;

  Speaker({this.name, this.designation, this.image});

  Speaker.fromJson(Map<String, dynamic> json) {
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
