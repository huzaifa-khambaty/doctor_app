class CreateAdminRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final List<String> roles;

  const CreateAdminRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.roles,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'roles': roles,
      };
}

class UpdateAdminRequest {
  final String? name;
  final String? email;
  final String? password;
  final String? passwordConfirmation;
  final List<String>? roles;

  const UpdateAdminRequest({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.roles,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
      data['password_confirmation'] = passwordConfirmation ?? password;
    }
    if (roles != null) data['roles'] = roles;
    return data;
  }
}
