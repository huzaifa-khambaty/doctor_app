import 'package:respilink_mobile/features/auth/data/models/privacy_policy_model.dart';
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

/// Distinct from [AuthSuccess] so a still-mounted LoginView (Login -> Register
/// is a push, not a stack replace) never mistakes a registration for a login
/// and races RegisterView's own navigation to the OTP screen.
class RegisterSuccess extends AuthState {
  final Doctor? model;

  RegisterSuccess({this.model});
}

class ForgetPasswordSuccess extends AuthState {
  final String message;

  ForgetPasswordSuccess({required this.message});
}

class OptVerifiedSuccess<T> extends AuthState {
  final T? data;
  final String? message;

  OptVerifiedSuccess({this.data, this.message});
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

/// Login rejected because the account's email/phone isn't OTP-verified yet.
/// A resend (`auth/otp/send`) is already in flight to [identifier] by the
/// time this is emitted — the listener just needs to navigate to the OTP
/// screen with purpose "login" so the rest of the flow matches register/
/// reset (see [OptVerifiedSuccess]).
class LoginRequiresOtp extends AuthState {
  final String identifier;

  LoginRequiresOtp({required this.identifier});
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

/// Dedicated (not sharing AuthLoading/AuthFailed) so this fetch never gets
/// mistaken for — or drowned out by — an unrelated flow on another page that
/// still shares this same global AuthBloc.
class PrivacyPolicyLoading extends AuthState {
  PrivacyPolicyLoading();
}

class PrivacyPolicyLoaded extends AuthState {
  final PrivacyPolicyModel policy;

  PrivacyPolicyLoaded({required this.policy});
}

class PrivacyPolicyFailed extends AuthState {
  final String message;

  PrivacyPolicyFailed({required this.message});
}
