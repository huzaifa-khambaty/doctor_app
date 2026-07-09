import 'package:respilink_app/shared/model/admin_mode.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {
  AuthLoading();
}

class AuthProfileImageLoading extends AuthState {
  AuthProfileImageLoading();
}

class AuthSuccess extends AuthState {
  final AdminModel? model;

  AuthSuccess({this.model});
}

class AuthLogoutSuccess extends AuthState {
  AuthLogoutSuccess();
}

class ResendOtpSuccess extends AuthState {
  String message;

  ResendOtpSuccess({required this.message});
}

class ResendOtpFailure extends AuthState {
  String message;

  ResendOtpFailure({required this.message});
}

class AuthFailed extends AuthState {
  String message;

  AuthFailed({required this.message});
}