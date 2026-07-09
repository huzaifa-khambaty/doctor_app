class ResendOtpRequest {
  final String email;
  final String? purpose;

  ResendOtpRequest({required this.email, this.purpose});

  Map<String, dynamic> toJson() {
    return {'identifier': email, 'channel': "email", 'purpose': purpose};
  }
}
