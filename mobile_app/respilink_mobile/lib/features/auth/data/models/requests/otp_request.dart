class OtpRequest {
  final String email;
  final String otp;
  final String? purpose;

  OtpRequest({required this.email, required this.otp, this.purpose});

  Map<String, dynamic> toJson() {
    return {
      'identifier': email,
      'code': otp,
      'channel': "email",
      'purpose': purpose,
    };
  }
}
