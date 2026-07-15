import 'package:respilink_mobile/features/auth/data/models/requests/change_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/register_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/resent_otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/reset_password_request.dart';

abstract class AuthEvent {}

class UserAuthenticationRequested extends AuthEvent {
  UserAuthenticationRequested();
}

class LoginRequested extends AuthEvent {
  final LoginRequest request;

  LoginRequested({required this.request});
}

class RegisterRequested extends AuthEvent {
  final RegisterRequest request;

  RegisterRequested({required this.request});
}

class VerifyOtpRequested extends AuthEvent {
  final OtpRequest request;

  VerifyOtpRequested({required this.request});
}

class ResendOtpRequested extends AuthEvent {
  final ResendOtpRequest request;

  ResendOtpRequested({required this.request});
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

class ChangePasswordRequested extends AuthEvent {
  final ChangePasswordRequest request;

  ChangePasswordRequested({required this.request});
}

class SpecialitiesRequested extends AuthEvent {
  SpecialitiesRequested();
}