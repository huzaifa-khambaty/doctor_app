import 'package:respilink_app/shared/model/pagination_model.dart';

class PractionersModel {
  int? currentPage;
  List<Practioners>? data;
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

  PractionersModel({
    this.currentPage,
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
    this.total,
  });

  PractionersModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Practioners>[];
      json['data'].forEach((v) {
        data!.add(Practioners.fromJson(v));
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

class Practioners {
  int? id;
  String? uuid;
  String? fullName;
  String? email;
  String? phone;
  String? licenseNumber;
  String? hospitalClinicAffiliation;
  int? yearOfRegistration;
  String? hospitalAffiliation;
  String? photoPath;
  String? qualifications;
  String? location;
  String? status;
  String? rejectionReason;
  String? verifiedAt;
  int? verifiedBy;
  String? createdAt;
  String? updatedAt;
  String? photoUrl;
  List<Specialties>? specialties;

  Practioners({
    this.id,
    this.uuid,
    this.fullName,
    this.email,
    this.phone,
    this.licenseNumber,
    this.hospitalClinicAffiliation,
    this.yearOfRegistration,
    this.hospitalAffiliation,
    this.photoPath,
    this.qualifications,
    this.location,
    this.status,
    this.rejectionReason,
    this.verifiedAt,
    this.verifiedBy,
    this.createdAt,
    this.updatedAt,
    this.photoUrl,
    this.specialties,
  });

  Practioners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    licenseNumber = json['license_number'];
    hospitalClinicAffiliation = json['hospital_clinic_affiliation'];
    yearOfRegistration = json['year_of_registration'];
    hospitalAffiliation = json['hospital_affiliation'];
    photoPath = json['photo_path'];
    qualifications = json['qualifications'];
    location = json['location'];
    status = json['status'];
    rejectionReason = json['rejection_reason'];
    verifiedAt = json['verified_at'];
    verifiedBy = json['verified_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    photoUrl = json['photo_url'];
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
    data['uuid'] = uuid;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['license_number'] = licenseNumber;
    data['hospital_clinic_affiliation'] = hospitalClinicAffiliation;
    data['year_of_registration'] = yearOfRegistration;
    data['hospital_affiliation'] = hospitalAffiliation;
    data['photo_path'] = photoPath;
    data['qualifications'] = qualifications;
    data['location'] = location;
    data['status'] = status;
    data['rejection_reason'] = rejectionReason;
    data['verified_at'] = verifiedAt;
    data['verified_by'] = verifiedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['photo_url'] = photoUrl;
    if (specialties != null) {
      data['specialties'] = specialties!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specialties {
  int? id;
  String? name;
  String? slug;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Specialties({
    this.id,
    this.name,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  Specialties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? specialtyId;

  Pivot({this.userId, this.specialtyId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    specialtyId = json['specialty_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['specialty_id'] = specialtyId;
    return data;
  }
}
