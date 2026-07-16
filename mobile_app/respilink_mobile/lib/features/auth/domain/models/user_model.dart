import 'dart:convert';

import 'package:respilink_mobile/core/network/api_endpoints.dart';

class UserModel {
  String? token;
  Doctor? doctor;

  UserModel({this.token, this.doctor});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    return data;
  }
}

class Doctor {
  int? id;
  String? uuid;
  String? fullName;
  String? email;
  String? phone;
  List<Specialties>? specialties;
  String? hospitalAffiliation;
  String? profilePhotoPath;
  String? qualifications;
  String? location;
  String? status;
  bool? biometricEnabled;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? lastActiveAt;
  int? quizCount;
  int? rank;
  int? badgeCount;

  Doctor({
    this.id,
    this.uuid,
    this.fullName,
    this.email,
    this.phone,
    this.specialties,
    this.hospitalAffiliation,
    this.profilePhotoPath,
    this.qualifications,
    this.location,
    this.status,
    this.biometricEnabled,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.lastActiveAt,
    this.quizCount,
    this.rank,
    this.badgeCount,
  });

  factory Doctor.fromCachedJson(String source) =>
      Doctor.fromJson(jsonDecode(source) as Map<String, dynamic>);

  Doctor copyWith({
    int? id,
    String? uuid,
    String? fullName,
    String? email,
    String? phone,
    List<Specialties>? specialties,
    String? hospitalAffiliation,
    String? profilePhotoPath,
    String? qualifications,
    String? location,
    String? status,
    bool? biometricEnabled,
    String? emailVerifiedAt,
    String? phoneVerifiedAt,
    String? lastActiveAt,
    int? quizCount,
    int? rank,
    int? badgeCount,
  }) {
    return Doctor(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialties: specialties ?? this.specialties,
      hospitalAffiliation: hospitalAffiliation ?? this.hospitalAffiliation,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      qualifications: qualifications ?? this.qualifications,
      location: location ?? this.location,
      status: status ?? this.status,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      quizCount: quizCount ?? this.quizCount,
      badgeCount: badgeCount ?? this.badgeCount,
      rank: rank ?? this.rank,
    );
  }

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    fullName = json['full_name'];
    email = json['email'];
    // Different endpoints name this field differently (login/register vs
    // profile update), so accept either.
    phone = json['phone'] ?? json['phone_number'];
    final specialtiesJson = json['specialties'] ?? json['specialty_ids'];
    if (specialtiesJson != null) {
      specialties = <Specialties>[];
      specialtiesJson.forEach((v) {
        specialties!.add(Specialties.fromJson(v));
      });
    }
    hospitalAffiliation = json['hospital_affiliation'];
    profilePhotoPath = _normalizePhotoPath(
      json['photo_path'] ?? json['profile_picture'],
    );
    qualifications = json['qualifications'];
    location = json['location'];
    status = json['status'];
    biometricEnabled = json['biometric_enabled'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    lastActiveAt = json['last_active_at'];
    quizCount = json['quiz_count'];
    rank = json['rank'];
    badgeCount = json['badge_count'];
  }

  /// Some endpoints (e.g. profile update) return a full URL for the photo
  /// while others return a path relative to [ApiEndpoints.imageUrl]. Keeping
  /// this always relative means every display site's
  /// `"${ApiEndpoints.imageUrl}/$profilePhotoPath"` concatenation stays valid.
  static String? _normalizePhotoPath(String? value) {
    if (value == null) return null;
    return value.startsWith(ApiEndpoints.imageUrl)
        ? value.substring(ApiEndpoints.imageUrl.length)
        : value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    if (specialties != null) {
      data['specialties'] = specialties!.map((v) => v.toJson()).toList();
    }
    data['hospital_affiliation'] = hospitalAffiliation;
    data['photo_path'] = profilePhotoPath;
    data['qualifications'] = qualifications;
    data['location'] = location;
    data['status'] = status;
    data['biometric_enabled'] = biometricEnabled;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['last_active_at'] = lastActiveAt;
    data['quiz_count'] = quizCount;
    data['rank'] = rank;
    data['badge_count'] = badgeCount;
    return data;
  }
}

class Specialties {
  int? id;
  String? name;

  Specialties({this.id, this.name});

  Specialties.fromJson(Map<String, dynamic> json) {
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
