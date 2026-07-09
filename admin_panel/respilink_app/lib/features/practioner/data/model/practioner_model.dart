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

  PractionersModel(
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
  int? specialtyId;
  String? hospitalAffiliation;
  String? photoPath;
  String? qualifications;
  String? location;
  String? status;
  String? rejectionReason;
  String? verifiedAt;
  int? verifiedBy;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  bool? biometricEnabled;
  String? lastActiveAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? photoUrl;

  Practioners(
      {this.id,
      this.uuid,
      this.fullName,
      this.email,
      this.phone,
      this.specialtyId,
      this.hospitalAffiliation,
      this.photoPath,
      this.qualifications,
      this.location,
      this.status,
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

  Practioners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    specialtyId = json['specialty_id'];
    hospitalAffiliation = json['hospital_affiliation'];
    photoPath = json['photo_path'];
    qualifications = json['qualifications'];
    location = json['location'];
    status = json['status'];
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
    data['hospital_affiliation'] = hospitalAffiliation;
    data['photo_path'] = photoPath;
    data['qualifications'] = qualifications;
    data['location'] = location;
    data['status'] = status;
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