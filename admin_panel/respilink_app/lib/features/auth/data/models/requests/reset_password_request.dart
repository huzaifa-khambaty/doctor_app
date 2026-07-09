class ResetPasswordRequest {
  final String email, otp, password, confirmPassword;

  ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.otp,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'password_confirmation': confirmPassword,
      'password': password,
    };
  }
}
