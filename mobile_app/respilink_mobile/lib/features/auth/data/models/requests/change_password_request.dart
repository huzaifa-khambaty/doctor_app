class ChangePasswordRequest {
  final String current;
  final String password;
  final String cnfPassword;

  ChangePasswordRequest({
    required this.cnfPassword,
    required this.current,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': current,
      'password': password,
      'password_confirmation': cnfPassword,
    };
  }
}
