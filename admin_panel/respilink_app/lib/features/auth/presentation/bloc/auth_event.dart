import 'package:respilink_app/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/reset_password_request.dart';

abstract class AuthEvent {}

class UserAuthenticationRequested extends AuthEvent {
  UserAuthenticationRequested();
}

class LoginRequested extends AuthEvent {
  final LoginRequest request;

  LoginRequested({required this.request});
}

class ForgetPasswordRequested extends AuthEvent {
  final ForgetPasswordRequest request;

  ForgetPasswordRequested({required this.request});
}

class ResetPasswordRequested extends AuthEvent {
  final ResetPasswordRequest request;

  ResetPasswordRequested({required this.request});
}

class LogoutRequested extends AuthEvent {
  LogoutRequested();
}


class UpdateProfileEvent extends AuthEvent {
  final EditProfileRequest request;

  UpdateProfileEvent({required this.request});
}

class AuthProfileEvent extends AuthEvent {
  AuthProfileEvent();
}

class FetchMeRequested extends AuthEvent {}

class SaveProfileRequested extends AuthEvent {
  final String name;
  final String phone;

  SaveProfileRequested({required this.name, required this.phone});
}

