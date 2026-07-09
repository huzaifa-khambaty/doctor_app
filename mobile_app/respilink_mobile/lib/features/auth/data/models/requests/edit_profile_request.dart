class EditProfileRequest {
  final String name;
  final String phone;

  final String? passportHolder;
  final String? passportNo;
  final String? surname;
  final String? givenName;
  final String? dateOfBirth;
  final String? placeOfBirth;
  final String? nationality;
  final String? cnicNumber;
  final String? countryOfBirth;
  final String? passportIssueDate;
  final String? passportExpiryDate;
  final String? fatherHusbandName;

  final String? presentAddress;
  final String? residenceCountry;
  final String? residenceState;
  final String? residenceCity;
  final String? zipcode;
  final String? residentTel;
  final String? gender;
  final String? maritalStatus;
  final String? spouseName;
  final String? motherName;
  final String? fatherName;

  EditProfileRequest({
    required this.name,
    required this.phone,
    this.passportHolder,
    this.passportNo,
    this.surname,
    this.givenName,
    this.dateOfBirth,
    this.placeOfBirth,
    this.nationality,
    this.cnicNumber,
    this.countryOfBirth,
    this.passportIssueDate,
    this.passportExpiryDate,
    this.fatherHusbandName,

    this.presentAddress,
    this.residenceCountry,
    this.residenceState,
    this.residenceCity,
    this.zipcode,
    this.residentTel,
    this.gender,
    this.maritalStatus,
    this.spouseName,
    this.motherName,
    this.fatherName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'passport_holder': passportHolder,
      'passport_no': passportNo,
      'surname': surname,
      'given_name': givenName,
      'date_of_birth': dateOfBirth,
      'place_of_birth': placeOfBirth,
      'nationality': nationality,
      'cnic_number': cnicNumber,
      'country_of_birth': countryOfBirth,
      'passport_issue_date': passportIssueDate,
      'passport_expiry_date': passportExpiryDate,
      'father_husband_name': fatherHusbandName,

      'present_address': presentAddress,
      'residence_country': residenceCountry,
      'residence_state': residenceState,
      'residence_city': residenceCity,
      'zipcode': zipcode,
      'resident_tel': residentTel,
      'gender': gender,
      'marital_status': maritalStatus,
      'spouse_name': spouseName,
      'mother_name': motherName,
      'father_name': fatherName,
    };
  }
}
