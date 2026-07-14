import 'package:respilink_mobile/features/auth/data/models/requests/resent_otp_request.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import 'package:respilink_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<UserAuthenticationRequested>(_isUserLoggedIn);
    on<LoginRequested>(_login);
    on<RegisterRequested>(_register);
    on<VerifyOtpRequested>(_verifyOtp);
    on<ResendOtpRequested>(_resendOtp);
    on<LogoutRequested>(_logout);
    on<UpdateProfilePictureEvent>(_updateProfilePicture);
    on<UpdateProfileEvent>(_updateProfile);
    on<ChangePasswordRequested>(_changePassword);
    on<ForgetPasswordRequested>(_forgetPassword);
    on<ResetPasswordRequested>(_resetPassword);
    on<SpecialitiesRequested>(_specialities);
  }

  void _isUserLoggedIn(
    UserAuthenticationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _repository.isUserLoggedIn();

    if (res.data == true) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }
  
  void _login(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.login(event.request);

    if (res.success) {
      emit(AuthSuccess(model: res.data));
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _register(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.register(event.request);

    if (res.success) {
      emit(AuthSuccess(model: res.data));
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _verifyOtp(VerifyOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.verifyOtp(event.request);

    if (res.success) {

      if(event.request.purpose == "reset") {
        emit(OptVerifiedSuccess(data: "OTP verified successfully."));
      } else {
        emit(OptVerifiedSuccess<Doctor?>(data: res.data));
      }
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _resendOtp(ResendOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.resendOtp(event.request);

    if (res.success) {
      final message = res.message;
      emit(
        ResendOtpSuccess(
          message: (message != null && message.isNotEmpty)
              ? message
              : 'OTP has been resent successfully.',
        ),
      );
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _logout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.logout();

    if (res.success) {
      emit(AuthLogoutSuccess());
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _updateProfilePicture(
    UpdateProfilePictureEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthProfileImageLoading());

    final res = await _repository.updateProfilePicture(event.file);

    if (res.success) {
      emit(AuthSuccess(model: res.data));
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _updateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _repository.updateProfile(event.request);

    if (res.success) {
      emit(AuthSuccess(model: res.data));
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _changePassword(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _repository.changePassword(event.request);

    if (res.success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _forgetPassword(
    ForgetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _repository.forgetPassword(event.request);

    if (res.success) {
      add(ResendOtpRequested(request: ResendOtpRequest(email: event.request.email, purpose: "reset")));
      emit(ForgetPasswordSuccess(message: res.message ?? ""));
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _resetPassword(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _repository.resetPassword(event.request);

    if (res.success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailed(message: res.fullErrorMessage));
    }
  }

  void _specialities(
    SpecialitiesRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(SpecialitiesLoading());

    final res = await _repository.specialities();

    if (res.success) {
      emit(SpecialitiesLoaded(specialities: res.data ?? []));
    } else {
      emit(SpecialitiesFailed(message: res.fullErrorMessage));
    }
  }
}
