class CreatePractionerRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String licenseNumber;
  final String hospitalAffiliation;
  final String yearOfRegistration;
  final List<int> specialtyIds;

  CreatePractionerRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.licenseNumber,
    required this.hospitalAffiliation,
    required this.yearOfRegistration,
    required this.specialtyIds,
  });

  Map<String, dynamic> toJson() => {
        'full_name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'license_number': licenseNumber,
        'hospital_affiliation': hospitalAffiliation,
        'year_of_registration': yearOfRegistration,
        'specialties': specialtyIds,
      };
}
