import 'dart:convert';

class UserModel {
  int? id;
  String? itsNumber;
  String? name;
  String? email;
  String? phone;
  String? dob;
  String? profilePhotoPath;
  String? specialty;
  String? hospitalAffiliation;
  String? city;
  String? mohla;
  String? country;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  MedicalDetail? medicalDetail;
  PassportDetail? passportDetail;
  bool? isTripModeActive;
  TripEvent? tripEvent;
  bool? isSalaar;
  BasicDetail? basicDetail;

  UserModel({
    this.id,
    this.itsNumber,
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.profilePhotoPath,
    this.specialty,
    this.hospitalAffiliation,
    this.city,
    this.country,
    this.mohla,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.medicalDetail,
    this.passportDetail,
    this.isTripModeActive,
    this.tripEvent,
    this.isSalaar,
    this.basicDetail,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itsNumber = json['its_number'];
    name = json['name'];
    email = json['email'];
    specialty = json['specialty'];
    hospitalAffiliation = json['hospital_affiliation'];
    phone = json['phone'];
    dob = json['dob'];
    profilePhotoPath = json['profile_photo'];
    city = json['city'];
    mohla = json['mohla'];
    country = json['country'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    medicalDetail = json['medical_detail'] != null
        ? MedicalDetail.fromJson(json['medical_detail'])
        : null;
    passportDetail = json['passport_detail'] != null
        ? PassportDetail.fromJson(json['passport_detail'])
        : null;
    isTripModeActive = json['is_trip_mode_active'];
    tripEvent = json['trip_event'] != null
        ? TripEvent.fromJson(json['trip_event'])
        : null;
    isSalaar = json['is_salaar'];
    basicDetail = json['basic_detail'] != null
        ? BasicDetail.fromJson(json['basic_detail'])
        : null;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['its_number'] = itsNumber;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['dob'] = dob;
    data['profile_photo'] = profilePhotoPath;
    data['specialty'] = specialty;
    data['hospital_affiliation'] = hospitalAffiliation;
    data['city'] = city;
    data['mohla'] = mohla;
    data['country'] = country;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (medicalDetail != null) {
      data['medical_detail'] = medicalDetail!.toJson();
    }
    if (passportDetail != null) {
      data['passport_detail'] = passportDetail!.toJson();
    }
    data['is_trip_mode_active'] = isTripModeActive;
    if (tripEvent != null) {
      data['trip_event'] = tripEvent!.toJson();
    }
    data['is_salaar'] = isSalaar;
    if (basicDetail != null) {
      data['basic_detail'] = basicDetail!.toJson();
    }
    return data;
  }

  UserModel copyWith({
    int? id,
    String? itsNumber,
    String? name,
    String? email,
    String? phone,
    String? dob,
    String? profilePhotoPath,
    String? specialty,
    String? hospitalAffiliation,
    String? city,
    String? country,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    MedicalDetail? medicalDetail,
    PassportDetail? passportDetail,
    bool? isTripModeActive,
    TripEvent? tripEvent,
    bool? isSalaar,
    BasicDetail? basicDetail,
  }) {
    return UserModel(
      id: id ?? this.id,
      itsNumber: itsNumber ?? this.itsNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      specialty: specialty ?? this.specialty,
      hospitalAffiliation: hospitalAffiliation ?? this.hospitalAffiliation,
      city: city ?? this.city,
      country: country ?? this.country,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      medicalDetail: medicalDetail ?? this.medicalDetail,
      passportDetail: passportDetail ?? this.passportDetail,
      isTripModeActive: isTripModeActive ?? this.isTripModeActive,
      tripEvent: tripEvent ?? this.tripEvent,
      isSalaar: isSalaar ?? this.isSalaar,
      basicDetail: basicDetail ?? this.basicDetail,
    );
  }

  // Convert Model to JSON String (For Secure Storage)
  String toJson() => json.encode(toMap());

  // Create Model from JSON String
  factory UserModel.fromCachedJson(String source) =>
      UserModel.fromJson(json.decode(source));
}

class TripEvent {
  int? id;
  String? name;
  String? startDate;
  String? endDate;
  String? tentativeDate;
  String? tripModeDate;

  TripEvent({
    this.id,
    this.name,
    this.startDate,
    this.endDate,
    this.tentativeDate,
    this.tripModeDate,
  });

  TripEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    tentativeDate = json['tentative_date'];
    tripModeDate = json['trip_mode_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['tentative_date'] = tentativeDate;
    data['trip_mode_date'] = tripModeDate;
    return data;
  }
}

class MedicalDetail {
  String? bloodGroup;
  List<String>? allergies;
  List<String>? chronicConditions;
  List<String>? disabilityNeeds;
  String? emergencyContactName;
  String? emergencyContactPhone;
  String? createdAt;
  String? updatedAt;

  MedicalDetail({
    this.bloodGroup,
    this.allergies,
    this.chronicConditions,
    this.disabilityNeeds,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.createdAt,
    this.updatedAt,
  });

  MedicalDetail.fromJson(Map<String, dynamic> json) {
    bloodGroup = json['blood_group'];
    allergies = json['allergies'].cast<String>();
    chronicConditions = json['chronic_conditions'].cast<String>();
    disabilityNeeds = json['disability_needs'].cast<String>();
    emergencyContactName = json['emergency_contact_name'];
    emergencyContactPhone = json['emergency_contact_phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['blood_group'] = bloodGroup;
    data['allergies'] = allergies;
    data['chronic_conditions'] = chronicConditions;
    data['disability_needs'] = disabilityNeeds;
    data['emergency_contact_name'] = emergencyContactName;
    data['emergency_contact_phone'] = emergencyContactPhone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PassportDetail {
  String? passportHolder;
  String? passportNo;
  String? surname;
  String? dateOfBirth;
  String? givenName;
  String? placeOfBirth;
  String? nationality;
  String? cnicNumber;
  String? countryOfBirth;
  String? passportIssueDate;
  String? fatherHusbandName;
  String? passportExpiryDate;

  PassportDetail({
    this.passportHolder,
    this.passportNo,
    this.surname,
    this.dateOfBirth,
    this.givenName,
    this.placeOfBirth,
    this.nationality,
    this.cnicNumber,
    this.countryOfBirth,
    this.passportIssueDate,
    this.fatherHusbandName,
    this.passportExpiryDate,
  });

  PassportDetail.fromJson(Map<String, dynamic> json) {
    passportHolder = json['passport_holder'];
    passportNo = json['passport_no'];
    surname = json['surname'];
    dateOfBirth = json['date_of_birth'];
    givenName = json['given_name'];
    placeOfBirth = json['place_of_birth'];
    nationality = json['nationality'];
    cnicNumber = json['cnic_number'];
    countryOfBirth = json['country_of_birth'];
    passportIssueDate = json['passport_issue_date'];
    fatherHusbandName = json['father_husband_name'];
    passportExpiryDate = json['passport_expiry_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passport_holder'] = passportHolder;
    data['passport_no'] = passportNo;
    data['surname'] = surname;
    data['date_of_birth'] = dateOfBirth;
    data['given_name'] = givenName;
    data['place_of_birth'] = placeOfBirth;
    data['nationality'] = nationality;
    data['cnic_number'] = cnicNumber;
    data['country_of_birth'] = countryOfBirth;
    data['passport_issue_date'] = passportIssueDate;
    data['father_husband_name'] = fatherHusbandName;
    data['passport_expiry_date'] = passportExpiryDate;
    return data;
  }
}

class BasicDetail {
  String? presentAddress;
  String? country;
  String? state;
  String? city;
  String? zip;
  String? residentTel;
  String? gender;
  String? maritalStatus;
  String? spouseName;
  String? motherName;
  String? fatherName;

  BasicDetail({
    this.presentAddress,
    this.country,
    this.state,
    this.city,
    this.zip,
    this.residentTel,
    this.gender,
    this.maritalStatus,
    this.spouseName,
    this.motherName,
    this.fatherName,
  });

  BasicDetail.fromJson(Map<String, dynamic> json) {
    presentAddress = json['present_address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zip = json['zip'];
    residentTel = json['resident_tel'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    spouseName = json['spouse_name'];
    motherName = json['mother_name'];
    fatherName = json['father_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['present_address'] = presentAddress;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['zip'] = zip;
    data['resident_tel'] = residentTel;
    data['gender'] = gender;
    data['marital_status'] = maritalStatus;
    data['spouse_name'] = spouseName;
    data['mother_name'] = motherName;
    data['father_name'] = fatherName;
    return data;
  }
}
