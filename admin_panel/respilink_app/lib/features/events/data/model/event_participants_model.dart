class EventParticipantsModel {
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

  EventParticipantsModel(
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

  EventParticipantsModel.fromJson(Map<String, dynamic> json) {
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
  int? eventId;
  int? userId;
  String? status;
  Null remindedAt;
  String? createdAt;
  String? updatedAt;
  User? user;

  Data(
      {this.id,
      this.eventId,
      this.userId,
      this.status,
      this.remindedAt,
      this.createdAt,
      this.updatedAt,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventId = json['event_id'];
    userId = json['user_id'];
    status = json['status'];
    remindedAt = json['reminded_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event_id'] = eventId;
    data['user_id'] = userId;
    data['status'] = status;
    data['reminded_at'] = remindedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? uuid;
  String? fullName;
  String? email;
  String? phone;
  Null specialtyId;
  String? licenseNumber;
  Null hospitalClinicAffiliation;
  int? yearOfRegistration;
  String? hospitalAffiliation;
  String? photoPath;
  Null qualifications;
  Null location;
  String? status;
  int? points;
  Null rejectionReason;
  String? verifiedAt;
  int? verifiedBy;
  String? emailVerifiedAt;
  Null phoneVerifiedAt;
  bool? biometricEnabled;
  String? lastActiveAt;
  String? createdAt;
  String? updatedAt;
  Null deletedAt;
  String? photoUrl;

  User(
      {this.id,
      this.uuid,
      this.fullName,
      this.email,
      this.phone,
      this.specialtyId,
      this.licenseNumber,
      this.hospitalClinicAffiliation,
      this.yearOfRegistration,
      this.hospitalAffiliation,
      this.photoPath,
      this.qualifications,
      this.location,
      this.status,
      this.points,
      this.rejectionReason,
      this.verifiedAt,
      this.verifiedBy,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.biometricEnabled,
      this.lastActiveAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.photoUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    specialtyId = json['specialty_id'];
    licenseNumber = json['license_number'];
    hospitalClinicAffiliation = json['hospital_clinic_affiliation'];
    yearOfRegistration = json['year_of_registration'];
    hospitalAffiliation = json['hospital_affiliation'];
    photoPath = json['photo_path'];
    qualifications = json['qualifications'];
    location = json['location'];
    status = json['status'];
    points = json['points'];
    rejectionReason = json['rejection_reason'];
    verifiedAt = json['verified_at'];
    verifiedBy = json['verified_by'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    biometricEnabled = json['biometric_enabled'];
    lastActiveAt = json['last_active_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['specialty_id'] = specialtyId;
    data['license_number'] = licenseNumber;
    data['hospital_clinic_affiliation'] = hospitalClinicAffiliation;
    data['year_of_registration'] = yearOfRegistration;
    data['hospital_affiliation'] = hospitalAffiliation;
    data['photo_path'] = photoPath;
    data['qualifications'] = qualifications;
    data['location'] = location;
    data['status'] = status;
    data['points'] = points;
    data['rejection_reason'] = rejectionReason;
    data['verified_at'] = verifiedAt;
    data['verified_by'] = verifiedBy;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['biometric_enabled'] = biometricEnabled;
    data['last_active_at'] = lastActiveAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['photo_url'] = photoUrl;
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
