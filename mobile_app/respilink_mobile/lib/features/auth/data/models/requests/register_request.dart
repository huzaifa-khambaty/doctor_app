class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final List<int> specialtyIds;
  final String hospitalAffiliation;
  final String password;
  final String passwordConfirmation;
  final String fcmToken;

  RegisterRequest({
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
      'full_name': name,
      'email': email,
      'phone': phone,
      'specialties': specialtyIds,
      'hospital_affiliation': hospitalAffiliation,
      'password': password,
      'password_confirmation': passwordConfirmation,
      //'fcm_token': fcmToken,
    };
  }
}