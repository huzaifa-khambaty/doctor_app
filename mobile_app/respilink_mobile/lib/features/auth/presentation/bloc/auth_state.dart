import 'package:respilink_mobile/features/auth/data/models/specialities_model.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {
  AuthLoading();
}

class AuthSuccess extends AuthState {
  final Doctor? model;

  AuthSuccess({this.model});
}

class ForgetPasswordSuccess extends AuthState {
  final String message;

  ForgetPasswordSuccess({required this.message});
}

class OptVerifiedSuccess<T> extends AuthState {
  final T? data;

  OptVerifiedSuccess({this.data});
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

class SpecialitiesLoading extends AuthState {
  SpecialitiesLoading();
}

class SpecialitiesLoaded extends AuthState {
  final List<SpecialitiesModel> specialities;

  SpecialitiesLoaded({required this.specialities});
}

class SpecialitiesFailed extends AuthState {
  String message;

  SpecialitiesFailed({required this.message});
}