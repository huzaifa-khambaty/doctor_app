import 'dart:io';

class EditProfileRequest {
  final String? fullName;
  final String? phoneNumber;
  final String? hospitalAffiliation;
  final File? profilePicture;

  EditProfileRequest({
    this.fullName,
    this.phoneNumber,
    this.hospitalAffiliation,
    this.profilePicture,
  });

  Map<String, String> toFields() {
    return {
      'full_name': ?fullName,
      'phone_number': ?phoneNumber,
      'hospital_affiliation': ?hospitalAffiliation,
      '_method': 'PUT'
    };
  }
}
