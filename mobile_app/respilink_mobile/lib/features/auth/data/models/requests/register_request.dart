class RegisterRequest {
  final String itsNumber;
  final String name;
  final String email;
  final String phone;
  final List<int> specialtyIds;
  final String hospitalAffiliation;
  final String password;
  final String passwordConfirmation;
  final String fcmToken;

  RegisterRequest({
    required this.itsNumber,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialtyIds,
    required this.hospitalAffiliation,
    required this.password,
    required this.passwordConfirmation,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'its_number': itsNumber,
      'name': name,
      'email': email,
      'phone': phone,
      'specialties[]': specialtyIds,
      'hospital_affiliation': hospitalAffiliation,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'fcm_token': fcmToken,
    };
  }
}