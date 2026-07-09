class LoginRequest {
  final String itsNumber;
  final String password;
  final String fcmToken;

  LoginRequest({
    required this.itsNumber,
    required this.password,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': itsNumber,
      'password': password,
      //'fcm_token': fcmToken,
    };
  }
}