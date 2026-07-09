class ForgetPasswordRequest {
  final String email;
  final String its;

  ForgetPasswordRequest({required this.email, required this.its});

  Map<String, dynamic> toJson() {
    return {'email': email, 'its': its};
  }
}
